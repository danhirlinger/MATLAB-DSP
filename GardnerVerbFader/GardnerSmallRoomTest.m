% GardnerSmallRoomTest.m
clear;clc;

[x,Fs] = audioread('AcGtr.wav');

reverb = GardnerSmallRoom(Fs);
% reverb = GardnerMediumRoom(Fs);

reverb.setFs(Fs);
gain = 0.9;
mix = 0.9;
reverb.setGain(gain);
reverb.setMix(mix);

out = reverb.process(x);
sound([out],Fs);

