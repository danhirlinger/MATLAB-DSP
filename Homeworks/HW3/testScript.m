% filterTest.m
clear;clc;
% This is a script to be used for testing your 
% filter functions

% Experiment with different length signals
x = [1;zeros(1023,1)]; % frequency in Hz

% Experiment with different coefficients
b = [0.2929, -.5858, .2929];
a = [1, 0, 0.1716];

% Compare the results
y1 = filter(b,a,x);
y2 = timeFilter(b,a,x);
y3 = freqFilter(b,a,x);



 
