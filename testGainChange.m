% testGainChange.m
clear;clc;close all;
% Test script for the GainChange class

% Create an instance of class
gain = GainChange;

[x,Fs] = audioread('AcGtr.wav');

y = gain.process(x);

gain.setGain(0.25);

w = gain.process(x);

plot(x); hold on;
plot(y);
plot(w); hold off;