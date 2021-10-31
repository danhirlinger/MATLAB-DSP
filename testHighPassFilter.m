% testHighPassFilter.m
clear;clc;close all;
hpf = HighPassFilter;

[in,Fs] = audioread('AcGtr.wav');

hpf.setAmount(0.2);
y = hpf.process(in);

N = length(in);
out = zeros(N,1);
for n = 1:N
   out(n,1) = hpf.processSample(in(n,1)); 
end