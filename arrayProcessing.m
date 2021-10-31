% arrayProcessing.m
% Dan Hirlinger
% 10/12/2020
clear; clc;
% Digital Summing / "Mixing"

Fs = 48000;
Ts = 1/Fs;
t = [0:Ts:1].';

f1 = 300;
x1 = sin(2*pi*f1*t);

f2 = 1000;
x2 = sin(2*pi*f2*t);

y = x1 + x2;

%plot(y);


% Ring Modulation
% reuse same signals as above

N = length(x1);
y = zeros(N,1);

for n = 1:N
    y(n,1) = x1(n,1) * x2(n,1);
end

% resulting harmonics are sums/differences of signal frequencies

% simple version: y = x1 .* x2;

% using a musical signal
[x,Fs] = audioread('AcGtr.wav');
Ts = 1/Fs;
N = length(x);
t = [0:N-1].' * Ts;
m = sin(2*pi*500*t);

for n = 1:N
    y(n,1) = x(n,1) * m(n,1);
end

plottf(y,Fs);