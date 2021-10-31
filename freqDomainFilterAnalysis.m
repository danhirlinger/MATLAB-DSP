% freqDomainFilterAnalysis.m
% 3/1/21
% Dan Hirlinger

clear; clc;

N = 512;

k = 128;

e = exp((-1j*2*pi*k)/N);

% Amplutide
abs(e)

% Angle
angle(e)

for k = 0:(N/2)-1
    H(k+1,1) = 1 + exp((-1j*2*pi*k)/N);
end

% Amplutide
ampH = abs(H);

% Angle
angleH = angle(H);

normF = [0:(N/2)-1] / ((N/2)-1);
subplot(2,1,1);
plot(normF,20*log10(ampH)); % magnitude / amplitude plot
subplot(2,1,2);
plot(normF,angleH*(180/pi));

figure;
freqz([1 1]);

