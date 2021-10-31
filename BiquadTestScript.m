% BiquadTestScript.m
% Dan Hirlinger
% 6/15/21

bq = Biquad;

[x,Fs] = audioread('AcGtr.wav');
Q = 3; % filter bandwidth
f = 1000; % filter frequency
dBGain = 0; % gain value on decibel scale
type = 'lpf';
%   type : 'lpf','hpf','pkf','bp1','bp2','apf','lsf','hsf'

bq.setBQParams(Fs,f,Q,dBGain);

bq.processSignal(x,type);