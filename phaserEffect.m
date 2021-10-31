% phaserEffect.m
% Dan Hirlinger
% 6/17/21
clear; clc;
% read in signal
% [in,Fs] = audioread('AcGtr.wav');

Fs = 48000;
lenSec = 5;
in = 2*rand(lenSec*Fs,1) - 1;

Ts = 1/Fs;
% declare variables
depth = 3; % [-1.8:1.8]
rate = 40;
width = 0.5; % affects the APF coefficients [0.1:0.9]
angle = 0;
mix = 1;

N = length(in);
out = zeros(N,1);

a0 = 1 + width; % a0 = b2
b0 = width; % b0 = a2
a2 = width;
b2 = 1 + width;

x1 = 0;
x2 = 0;

y1 = 0;
y2 = 0;

for n = 1:N
    
    % a1, b1 modulate based on lfo
    % this affects the frequency of the phaser
    % set LFO
    a1 = ((depth/2)*cos(angle)) + (depth/2) - 1;
    b1 = a1;
    A1(n,1) = a1;
    
    x = in(n,1);

    apf = ((b0/a0)*x) + ((b1/a0)*x1) + ((b2/a0)*x2) + ((-a1/a0)*y1) + ((-a2/a0*y2));
    
    y = x + apf*mix;
    
    x2 = x1;
    x1 = x;
    y2 = y1;
    y1 = apf;
   
    % convert frequency to phase increment
    phi = rate * (Ts) * (1/(2*pi));
    angle = angle + phi;
    
    if angle > (2*pi)
        angle = angle - (2*pi);
    end
    
    out(n,1) = y;
end

% final signal = dry + APF

% sound(out,Fs);
plot(A1);