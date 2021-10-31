
% oscTest.m
clear;clc;
% This is a script to be used for testing your 
% "oscillator.m" function

freq = 10; % frequency in Hz
Fs = 48000; % Sampling rate
lenSec = 3; % Length of the signal in seconds

out = oscillator(freq,Fs,lenSec)


% plot(out);
% 
% sound(out,Fs);