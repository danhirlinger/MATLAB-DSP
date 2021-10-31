% overlapConvolution.m
clear;clc;
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1].';

test = conv(x,h); % reference convolution

M = length(h);

L = M; % Frame size for "x"

N = L+M -1; % FFT size

% Calculate spectrum of "h" before any audio processing
h = [h; zeros(N-M,1)];
H = fft(h);

%% Overlap-Add

start = 1; % starting sample of "x"
y = zeros(length(x) + M - 1,1);

while (start + L -1 <= length(x))
    xFrame = x(start:start+L-1,1);
    xFrame = [xFrame; zeros(N-L,1)];
    X = fft(xFrame);
    Y = X.*H;
    yFrame = real(ifft(Y));
    
    y(start:start+N-1,1) = y(start:start+N-1,1) + yFrame;
    start = start + L;
end

[test y]

%% Overlap-Add: Real-time processing
count = 1;
bufferIn = zeros(L,1);
bufferOut = zeros(N,1);
y = zeros(length(x) + M - 1,1);

for n = 1:length(x)
    sample = x(n,1);
    bufferIn = [bufferIn(2:end,1) ; sample]; % fills in buffer right to left
    if (count == L)
        % Do FFT stuff
        xFrame = [bufferIn; zeros(N-L,1)];
        X = fft(xFrame);
        Y = X.*H;
        yFrame = real(ifft(Y));
        bufferOut = bufferOut + yFrame; % overlap add
        out = bufferOut(1,1); % use first sample for output
        bufferOut = [bufferOut(2:end,1) ; 0]; % shift buffer
        
        count = 1;
    else % Wait to do FFT stuff
        out = bufferOut(1,1);
        bufferOut = [bufferOut(2:end,1) ; 0];
        count = count + 1;
    end
    y(n,1) = out;
end

[test y]