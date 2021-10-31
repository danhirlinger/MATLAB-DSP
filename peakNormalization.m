% peakNormalization.m

clear;clc;

[sig,Fs] = audioread('AcGtr.wav');

N = length(sig);

dBAmp = -6;

A = 10.^(dBAmp/20);

peak = max(abs(sig));

out = zeros(N,1);

for n = 1:N
   out(n,1) = A * sig(n,1) * (1/peak); 
end

