% testScript.m
% Use this script to test your function for Quiz 1

clear;clc;

% Input signal
[x,Fs] = audioread('Vocal.wav');

% Effect Parameters (try different values)
delayMS = 500; % range = [100 - 500]
bits = 6;      % range = [2 - 16]
mix = 0.2;     % range = [0 - 1]

% You need to write this function
y = hDelay(x,Fs,delayMS,bits,mix);


% Listen to the sound file
% sound(y,Fs);


