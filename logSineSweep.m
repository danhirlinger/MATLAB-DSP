% logSineSweep.m
% Dan Hirlinger
% 10/16/2020
clear;clc;

% declare variables
Fs = 48000; Ts = (1/Fs);

f1 = 500; % frequency at start of sweep
f2 = 3000; % frequency at end  of sweep

dBAmp = 20; %amplitude in decibels
A = 10.^(dBAmp/20); % converted from dB to amplitude

%%%% LINEAR SS %%%%
lenSec = 1; % length of signal
N = lenSec * Fs; % number of samples in signal
% factor to determine the increment to rise between each sample
fValsFactor = (f2-f1)/(N-1);
% create array with f values for given f1, f2, lenSec
fVals = (f1:fValsFactor:f2).';
phase = 0;

y = zeros(N,1);

for n = 1:N
    angleChange = fVals(n) * (1/Fs) * 2*pi; % find sngle of given fVal
    y(n,1) = sin(phase) * A; % get sample value for current frequency
    phase = phase + angleChange; % change angle based on current fVal
    if (phase > 2*pi)
        phase = phase - (2*pi); % here to reset angle after 2pi is exceeded
    end
end
% plot
subplot(2,1,1);
plot(y);

%%%% LOGARITHMIC SS %%%%

% convert f1, f2 to normalized frequency scale
normF1 = (log10(f1/20))/3;
normF2 = (log10(f2/20))/3;

% create array of norm-spaced vals between normF1, normF2
% use same idea with fValsFactor
lenSec = 1; % length of signal
N = lenSec * Fs;% number of samples in signal
% factor to determine the increment to rise between each sample
normArrayFactor = (normF2 - normF1)/(N-1);
% create array with f values for given normF1, normF2, lenSec
normArray = (normF1:normArrayFactor:normF2).';

% convert entire array to frequency scale
freqArray = 20 * (10.^(3*normArray));

phase = 0; % reset the phase

for n = 1:N  
    angleChange = freqArray(n) * (1/Fs) * 2*pi;
    y(n,1) = sin(phase) * A;    
    phase = phase + angleChange;    
    if (phase > 2*pi)        
        phase = phase - (2*pi);
    end    
end
% plot
subplot(2,1,2);
plot(y);
