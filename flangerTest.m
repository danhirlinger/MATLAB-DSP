% flangerTest.m
% Dan Hirlinger
% 6/10/21
clear;clc;close all;

[in,Fs] = audioread('AcGtr.wav');

mix = 1;    % [0,1]
rate = 2;   % [0.1,10] "Hz"
% depth: the range of the LFO
depth = 3;  % [1,20]   "samples"
predelay = 0; % [0,20] "samples"
type = 1; % 1 = sin ; 0 = triangle
M = 20;

% out = flangerSignal(in,Fs,mix,rate,depth,predelay,type,M);

N = length(in);
out = zeros(N,1);

buffer = zeros(M,1);
wI = M;
angle = 0;
for n = 1:N
    x = in(n,1);
    
    [y,buffer,wI,angle] = flanger(x,Fs,mix,rate,depth,predelay,type,buffer,wI,angle,M);
    out(n,1) = y;
end

flangerEffect = FlangerEffect;
flangerEffect.setDepth(depth);
flangerEffect.setRate(rate);
flangerEffect.setPredelay(predelay);
flangerEffect.setFs(Fs);
flangerEffect.setMix(mix);

out = flangerEffect.process(in);
