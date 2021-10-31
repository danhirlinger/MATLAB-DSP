% overlapSave.m

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

%% Overlap-Save

% Had to add one extra 0 to y to make processing work
start = 1; % starting sample of "x"
y = zeros(length(x) + M,1);
xFrame = zeros(N,1);
x = [x; zeros(M,1)];

while (start + L -1 <= length(x))
    xFrame = [xFrame(L+1:end,1); x(start:start+L-1,1)];
    X = fft(xFrame);
    Y = X.*H;
    yFrame = real(ifft(Y));
    yFrame = yFrame(L:end,1);
    y(start:start+M-1,1) = yFrame;
    
    start = start + L;
end

test
y

%% Overlap-Save: Real-time processing
% clear;clc;
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1].';

test = conv(x,h); % reference convolution
M = length(h);
L = M; % Frame size for "x"
N = L+M -1; % FFT size
% Calculate spectrum of "h" before any audio processing
h = [h; zeros(N-M,1)];
H = fft(h);

count = 1;
bufferIn = zeros(N,1);
bufferOut = zeros(L,1);
y = zeros(length(x) + M - 1,1);
x = [x; zeros(M+1,1)]; % Added 0's to end of x to output all FFT values
% x = [x; zeros(M-1,1)]; % to match length of y
NN = length(x);

for n = 1:NN
    sample = x(n,1);
    bufferIn = [bufferIn(2:end,1) ; sample]; % fills in buffer right to left
    if (count == L)
        % Do FFT stuff
        xFrame = bufferIn;
        X = fft(xFrame);
        Y = X.*H;
        yFrame = real(ifft(Y));
        bufferOut = yFrame(L:end,1);
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

% [test y]
test
y