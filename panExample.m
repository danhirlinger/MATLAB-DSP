% panExample.m
% Dan Hirlinger
% 1/13/21
clear;clc;

% Input, mono signal
[in,Fs] = audioread('AcGtr.wav');

% Trivial panning
% left = in;
% right = 0*in;

pan = -45; % [-100:+100]
x = (pan/200) + 0.5; %[0:1]


% Linear panning
%aR = x;
%aL = (1-x);

% left = aL * in;
% right = aR * in;

% Square Law Panning

aR = sqrt(x);
aL = sqrt(1-x);

left = aL * in;
right = aR * in;



out = [left,right];
