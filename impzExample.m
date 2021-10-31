% impzExample.m
% Dan Hirlinger
clear; clc; 
[x,Fs] = audioread('AcGtr.wav');
Nyq = Fs/2;

m = 2; % Filter order / cutoff(?)

freqLowHz = 1000; % Frequency in Hz
WnLow = freqLowHz/Nyq;

freqHiHz = 4000;
WnHi = freqHiHz/Nyq;

[b,a] = butter(m,WnLow);
[d,c] = butter(m,WnHi,'high');

h = impz(b,a); % Approximate system
h1 = impz(d,c);

y1 = conv(x,h);
y = conv(y1,h1);
% y = conv(x,h);

sound(y,Fs);

% stem(h); hold on;
% stem(h1); hold off;
