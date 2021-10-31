% schroederVerb.m
clear;clc;close all;

[in,Fs] = audioread('AcGtr.wav');

fbcf1 = FBCF(0.773,1687,Fs);
fbcf2 = FBCF(0.801,1601,Fs);
fbcf3 = FBCF(0.753,2053,Fs);
fbcf4 = FBCF(0.733,2251,Fs);

fbcf1.setGain(0.7); fbcf2.setGain(0.7);
fbcf3.setGain(0.7); fbcf4.setGain(0.7);

apf1 = APF(347,0.9125,Fs);
apf2 = APF(113,1.129,Fs);
apf3 = APF(37,1.03,Fs);

apf1.setGain(0.7); apf2.setGain(0.7); apf3.setGain(0.7);

N = length(in);
out = zeros(N,1);

for n = 1:N
    x = in(n,1);
    
    % 4 parallel FBCF's
    w1 = fbcf1.processSample(x);
    w2 = fbcf1.processSample(x);
    w3 = fbcf1.processSample(x);
    w4 = fbcf1.processSample(x);
    w = (w1+w2+w3+w4) * 0.25;
    
    % 3 series APF's
    w = apf1.processSample(w);
    w = apf2.processSample(w);
    y = apf3.processSample(w);
    
    out(n,1) = y;
end