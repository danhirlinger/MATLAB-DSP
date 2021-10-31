% pingpongTest.m
clear; clc;
% This is a test script to use for Homework 2. You can use it 
% to test the function you create. You should experiment with 
% several values of the input variables.

% Import a test file
[in,Fs] = audioread('click60.wav'); % Also try: 'click89.wav'

% sound(in,Fs); % If you want to listen to the input signal

% Input Variables
BPM = 89; % This should match the name of the sound file
note = 4; % 4 = whole, 2 = half, 1 = quarter, 0.5 = 8th, 0.25 = 16th
feedback = 50; % Percentage [0,100]
wet = 50; % wet/dry

% Call the Function
[out] = pingpong(in,Fs,BPM,note,feedback,wet);

% Listen to the output to see if it worked
sound(out,Fs);