% LinearFade.m
% Creates linear fades
% "Fade-in" applied to beginning of sine wave signal
% "Fade-out" applied to the end



clc;clear;close all;
Fs = 48000;
Ts = (1/Fs);
t = 0:Ts:3;
t = t(:);
f = 100; phi = 0;
in = sin(2*pi*f.*t + phi);
figure(1);
plot(t,in);

fadeLen = 1;
numOfSamples = fadeLen*Fs;
a = linspace(0,1,numOfSamples); a = a(:);
fadeIn = a;
fadeOut = 1-a;
figure(2);
plot(a,fadeIn,a,fadeOut);legend('Fade-in','Fade-out');

temp = in;
temp(1:numOfSamples) = fadeIn .* in(1:numOfSamples);
figure(3);
plot(t,temp);