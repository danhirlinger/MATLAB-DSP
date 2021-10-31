% thdAnalysis.m
% Dan Hirlinger
% November 18, 2020
clear;clc;

Fs = 48000; Ts = 1/Fs;
f = 5000; % frequency (Hz)
A = 1;   % linear Amplitude
phi = 0; % phase in radians
% Time vector in seconds
lenSecs = 1;
N = Fs * lenSecs;
t = [0:N-1].' * Ts;

% Square wave synthesis
duty = 50; % duty tells wave how much to be positive (0-100)
y = A * square(2*pi*f*t + phi,duty);

X = fft(y);
% find amplitude values of X
ampVals = abs(X);
k = (f * N)/Fs; % find fundamental frequency bin number (k)
% establish number of harmonics desired
harmonics = [1 2 3 4 5 6];
% the array below will include the fundamental frequency along with the next 5
% harmonics. harmincs(1) will be the fund. freq.
harmonicAmps = zeros(length(harmonics),1);
for n = harmonics
    harmonicAmps(n,1) = ampVals((k*n)+1,1);
end

% calculate THD
THD = 100 * sqrt((sum(harmonicAmps(2:6)))/harmonicAmps(1))

% the result is displayed as a percentage, not as a decimal