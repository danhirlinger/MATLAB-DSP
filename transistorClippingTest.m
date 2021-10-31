% transistorClippingTest.m
% Dan Hirlinger
% 2/1/21
clear; clc;

[x,Fs] = audioread('BassDI.wav');

thresh = 0.2;

out = transistorClipping(x,thresh);

actual = audioread('LA3APrint.wav');

plot(out); 
figure; plot(actual);
