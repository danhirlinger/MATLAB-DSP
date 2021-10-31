% ampModulation.m
% Dan Hirlinger
% 10/14/2020
clear; clc;

% tremolo

[x,Fs] = audioread('AcGtr.wav');
N = length(x);
Ts = 1/Fs;

% synthesize LFO
t = [0:N-1].' * Ts;
f = 10; % Hz [.1:10]

depth = 70; % pct range [0:100]
A = depth/200;
dc = 1-A;
lfo = A * sin(2*pi*f*t) + dc;

y = zeros(N,1);
for n = 1:N
    y(n,1) = x(n,1) * lfo(n,1);
end

plot(lfo);
sound(y,Fs);
