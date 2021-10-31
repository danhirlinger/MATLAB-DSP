% potentiometerExamples.m

% Dan Hirlinger
% 9/15/21

clc;clear;

% Circuit component values
R1 = 1000;
Rp = 5000;

alpha = 0.5; % [0,1] ; for a plug-in, this would be the knob
R2 = (1-alpha) * Rp;
R3 = alpha * Rp;

gain = R3/(R1+R2+R3);

% Input signal

Fs = 48000; Ts = 1/Fs;
t = [0:Ts:1].';
f = 5;
x = sin(2*pi*f*t);

N = length(x);
y = zeros(N,1);

for n = 1:N
    y(n,1) = gain * x(n,1);
end

plot(t,x,t,y);

