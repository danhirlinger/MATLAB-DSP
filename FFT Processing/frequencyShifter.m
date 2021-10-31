% frequencyShifter.m
clear;clc;

[in,Fs] = audioread('soundFile1.wav');

shift = 5; % +/- (frameSize/2)

frameSize = 2048;
overlap = 2; % [2:4]
hop = frameSize/overlap;

N = length(in);
NFrame = ceil(N/frameSize);
% zero-pad input to always have complete frame at end
if (mod(N,frameSize) > 0)
    pad = NFrame * frameSize - N; % amount of 0's we need to add
    in = [in; zeros(pad,1)];
end

% Total number of frames factoring in overlap
R = (NFrame-1)*overlap + 1;

strt = 1; % initial index
nend = frameSize;

out = zeros(length(in),1);

% Window function
w = hann(frameSize);

% Processing loop
% This loop has overlapping frames
for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    % analysis
    X = fft(x);
    
    X = X(1:(frameSize/2) + 1,1);
     
    if (shift >= 0)
        % Shift up, add 0's near DC, discard bins near Nyq
        Y = [X(1) ; zeros(shift,1) ; X(2:end-shift,1)];
    else
        % Shift down, discard bins near DC, add 0's near Nyq
        posShift = abs(shift);
        Y = [X(1) ; X(posShift+1:end,1) ; zeros(posShift-1,1)];
    end
    Y = [Y ; conj(Y(end-1:-1:2,1))];
    
    % synthesis
    y = real(ifft(Y));
    out(strt:nend,1) = out(strt:nend,1) + y;
    
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

out = out/max(abs(out));
sound(out,Fs);
