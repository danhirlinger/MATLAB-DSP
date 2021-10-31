% impulseResponse.m
% Dan Hirlinger
% 2/3/21

% Input signal
[x,Fs] = audioread('AcGtr.wav');

% System as an impulse response
delaySamples = Fs;
h = [1; zeros(delaySamples,1); 0.5];

% Output is calculated using convolution
y = conv(x,h);