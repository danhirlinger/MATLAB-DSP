% discreteFourierTransform.m
% Dan Hirlinger
% November 18, 2020
clear; clc;
% read in file
[x,Fs] = audioread('sawtoothwave.wav');
Ts = 1/Fs;
% determine length of input signal
N = length(x);

% create time vector used for creating the periodic signals equal to the
% length of the input signal (in seconds)
t = (0:N-1) * Ts; 

% using a loop, create a matrix to contain the set of analyzing periodic
% functions
p = zeros(N,N);

for k = 0:N-1
   w = k * ((2*pi)/N) * Fs;
   pSignal = cos(w*t) - 1i*sin(w*t);
   p(k+1,1:N) = pSignal;
end

% Calculate DFT
X = p * x;
% compare result to builtin fuction fft
%plot(X); figure;
plot(fft(x));