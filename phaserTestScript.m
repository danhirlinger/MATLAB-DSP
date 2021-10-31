% phaserTestScript.m
% Dan Hirlinger
% 6/21/21
clear;clc;close all;

[in,Fs] = audioread('AcGtr.wav');
% 
% Fs = 48000;
% lenSec = 5;
% in = 2*rand(lenSec*Fs,1) - 1;

depth = 1.8; % [-1.8,1.8]
rate = 50; % [10,50]
width = 0.5; % affects the APF coefficients [0.1:0.9]
mix = 1; % [0:1]

phaser = Phaser(Fs,depth,rate,width,mix);

out = phaser.processSignal(in);

% sound(out,Fs);