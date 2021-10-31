%examTestScript.m
close all; clear sound;
clear; clc;

%%
% Test signal used for each problem
[x,Fs] = audioread('AcGtr.wav');



%% auralExciter.m Test
gain = .4; % Experiment with different values

% Use function
[ out ] = auralExciter( x, Fs, gain );

% Playback sound of processed output signal
sound(out,Fs);