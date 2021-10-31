% windowFunctions.m
close all; clear; clc;

N = 1024; % FFT size
Fs = 48000; Ts = 1/Fs;
f = 300;
t = [0:N-1].'*Ts;
x = sin(2*pi*f*t);
plot(x);

% Not using a window function

X = (1/(N/2)) * fft(x);
X = X(1:N/2,1);
k = [0:(N/2) - 1];
freq = k * (Fs/N);

% Spectrum of the sine wave
semilogx(freq,20*log10(abs(X))); axis([20 20000 -50 0]);
hold on;

% Hanning window
xHann = x .* hann(N);
% figure; plot(xHann);
X = (1/(N/2)) * fft(xHann);
X = X(1:N/2,1);

semilogx(freq,20*log10(abs(X))); axis([20 20000 -100 0]);

% Hamming window
xHamm = x .* hamming(N);
% figure; plot(xHann);
X = (1/(N/2)) * fft(xHamm);
X = X(1:N/2,1);

semilogx(freq,20*log10(abs(X))); axis([20 20000 -100 0]);

% Blackman window
xB = x .* blackman(N);
% figure; plot(xHann);
X = (1/(N/2)) * fft(xB);
X = X(1:N/2,1);

semilogx(freq,20*log10(abs(X))); axis([20 20000 -100 0]);

% Kaiser window
xK = x .* kaiser(N);
% figure; plot(xHann);
X = (1/(N/2)) * fft(xK);
X = X(1:N/2,1);

semilogx(freq,20*log10(abs(X))); axis([20 20000 -100 0]);

legend('Rect','Hann','Hamming','Blackman','Kaiser');

figure;
plot(hann(N)); hold on;
plot(hamming(N));
plot(blackman(N));
plot(kaiser(N)); hold off;
legend('Hann','Hamming','Blackman','Kaiser');

