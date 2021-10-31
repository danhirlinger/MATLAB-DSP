% testFBCF.m
% Dan Hirlinger
% 6/17/21
clear;clc;close all;

[in,Fs]= audioread('AcGtr.wav');

rate = 3;
depth = 4;
g = 0.3;


fbcf = FBCF(rate,depth,Fs);

fbcf.setGain(g);
fbcf.setFs(Fs);

out = fbcf.processSignal(in);

sound(out,Fs); 