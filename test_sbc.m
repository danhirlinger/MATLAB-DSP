% test_sbc.m
% Dan Hirlinger
% Test script for the single-band compressor (sbc.m)
clear; clc;

[x,Fs] = audioread('AcGtr.wav');

% y = output signal
% x = input signal
% bQ = type of filtering
%     1 = LPF
%     2 = BPF
%     3 = HPF
%     4 = APF
% T = threshold in dB  -60:0 dB
% R = ratio  1 - 100
% attack = attack time in seconds
% release = release time in seconds
% wet = ratio of processed to unprocessed signal (wet = 1 > all processed)

%y= sbc(x,Fs,bQ,freq,T,R,attack,release,wet)
 y = sbc(x,Fs,3,2500,-10,3,0.5,0.5,0.5);

sound([x;y],Fs);

