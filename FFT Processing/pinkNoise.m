% pinkNoise.m
clear;clc;
% Created by filtering white noise
Fs = 48000;
lenSec = 5;

in = randn(Fs*lenSec,1);
in = in/max(abs(in));

frameSize = 2048;

strt = 1; % initial index
nend = frameSize;

% Frequency bin numbers
k = [0:frameSize-1].';
f = k*Fs/frameSize;

A = 1./sqrt(f); % Amplitude scaling values
A(1,1) = A(2,1); % use to avoid Inf at 0Hz

% Processing loop
% This loop has contiguous frames (no overlapping)
while (nend < length(in))
    x = in(strt:nend,1);
    
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
    out(strt:nend,1) = y;
    
    strt = strt + frameSize;
    nend = strt + frameSize - 1;
end
