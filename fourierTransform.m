% fourierTransform.m
% 11/4/20
clear;clc;

Fs = 4800; Ts = 1/Fs;
t = [0:Ts:1-Ts].';
f = 100;

A = 0.729;
phase = 0.444;

x = A * cos(2*pi*f*t + phase); % put in garbage values for A, phi
% in our analysis, we want to find A, phi values

Xc = zeros(2401,1); % analysis with cosine
Xs = zeros(2401,1); % " " " " " " " sine

N = length(x);

for k = 0:Fs/2
    
    f = k*Fs/N;
    
    pc = cos(2*pi*f*t);
    ps = -sin(2*pi*f*t);
    
    Xc(k+1,1) = pc.' * x;
    Xs(k+1,1) = ps.' * x;
end

plot(Xc); figure; plot(Xs);

v = (2/N) * Xs(101,1); % scale down values according to length of signal
h = (2/N) * Xc(101,1);

A = sqrt(v^2 + h^2)
phase = atan(v/h)

