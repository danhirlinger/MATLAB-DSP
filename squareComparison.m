% squareComparison.m
% Dan Hirlinger
% 11/2/20
clear;clc;

Fs = 48000; Ts = 1/Fs;
t = [0:Ts:1-Ts].';
f = 200;

x = square(2*pi*f*t);

harmonic = 3;
p = sin(2*pi*f*t*harmonic);

% plot(t,x); hold on;
% plot(t,p); hold off;
% axis([0 1 -1.1 1.1]);

% multiplying by odd harmonic will result in positive innerProduct results
% multiplying by even harmonic will give basically 0
innerProduct = p.' * x;

innerProduct = zeros(500,1);
for m = f:10000
    p = sin(2*pi*f*t*m); %m = harmonic
    innerProduct(m,1) = p.' * x;
end
plot(innerProduct);