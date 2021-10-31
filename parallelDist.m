% parallelDist.m
% Dan Hirlinger
% 2/1/21

clear; clc;

% [x,Fs] = audioread('AcGtr.wav');
Fs = 48000; Ts = 1/Fs;
f = 500;
t = [0:Ts:1]';
x = sin(2*pi*f*t);

g1 = 0.4; % Unprocessed signal
g1x = x; % Weight for unprocessed signal
g2 = .3; % Even distortion: FW rectification
g2x = x; % Weight for FW rectification signal
g3 = 0.3; % Odd distortion: arctan distortion
g3x = x; % Weight for arctan distortion signal

N = length(x);
a = 3; % alpha value
for n = 1:N
    g2x(n,1) = abs(g2x(n,1));
    
    g3x(n,1) = (2/pi) * atan(a*g3x(n,1));
end
out = g1*g1x + g2*g2x + g3*g3x;

plot(x,out); % Characteristic curve

figure; thd(out,Fs); % THD analysis
