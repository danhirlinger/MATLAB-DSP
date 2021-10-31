% frequencyResponse.m
% Dan Hirlinger
% 3/8/21
clear; clc; 

b = [1 3 3 1];
G = 1/8;

h = G * [1 3 3 1];

Fs = 48000;

% freqz(b); % not unity gain
[H,F] = freqz(h,1,2048,Fs); % unity gain

% Plot w log-weighting
% dBA with log frequency
semilogx(F,20*log10(abs(H)));
axis([20 20000 -60 10]);