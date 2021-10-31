%amplitudeMeasurements.m
%9/23/2020
%Dan Hirlinger

clear;
clc;

% Measuring overall signal amplitudes

[x,Fs] = audioread('sw20Hz.wav');
%[x,Fs] = audioread('AcGtr.wav');

Ap = max(abs(x));

App = max(x) - min(x);

E = sum(x.^2);

P = E/length(x);

Arms = sqrt(P);

% all arithmetic in one line 
Arms = sqrt((sum(x.^2)/length(x)));

% trying to sum up all samples in signal using loop

xsum = 0; 

for n = 1:N
    
    xsum = xsum(n,1);
    
end

