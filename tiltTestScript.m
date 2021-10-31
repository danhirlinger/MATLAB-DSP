% tiltTestScript.m
clear; clc;
% Use this script to test your function for the Quiz

%%%% Input signals (try out both)

% Impulse response
x = [1; zeros(2047,1)];

% White noise
% Fs = 48000; 
% x = 0.2 * randn(Fs,1);

% Gain between -6 dB and +6 dB (try different values)
gain = 1;

% Write this function
y = tiltEQ(x,gain);

% For impulse response, plot frequency response
% freqz(y);

% For white noise, listen to output
% sound([x ; y],Fs);