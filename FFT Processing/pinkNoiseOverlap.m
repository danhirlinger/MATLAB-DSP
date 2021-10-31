% pinkNoiseOverlap.m

clear;clc;
% Created by filtering white noise
Fs = 48000;
lenSec = 5;

in = randn(Fs*lenSec,1);
in = in/max(abs(in));

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

% Frequency bin numbers
k = [0:frameSize-1].';
f = k*Fs/frameSize;

A = 1./sqrt(f); % Amplitude scaling values
A(1,1) = A(2,1); % use to avoid Inf at 0Hz

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
    Xamp = abs(X);
    Xphase = angle(X);
    
    % processing
    Xamp = Xamp(1:(frameSize/2)+1,1);
    Xphase = Xphase(1:(frameSize/2)+1,1);
    
    Yamp = A(1:(frameSize/2)+1,1) .* Xamp;
    % Yphase = Xphase;
    Y = Yamp .* exp(1j*Xphase); % half spectrum
    Y = [Y ; conj(Y(end-1:-1:2,1))];
    
    % synthesis
    y = real(ifft(Y));
    out(strt:nend,1) = out(strt:nend,1) + y;
    
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

out = out/max(abs(out));

audiowrite('pinkNoise.wav',out,Fs);