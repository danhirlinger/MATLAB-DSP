% crestFactor.m
% Dan Hirlinger
% October 16, 2020
clear;clc;

[x, Fs] = audioread('HW2.wav');

% find peak amplitude
Apeak = max(abs(x));

% find RMS amplitude
Arms = sqrt((sum(x.^2)/length(x)));

% calculate crest factor
cFactor = abs(Apeak) / Arms;

% calculate linear crest factor to  the decibel value
CFdB = (20*log10(Apeak)) - (20*log10(Arms/0.7071))
