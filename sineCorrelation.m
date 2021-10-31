clear;clc;

Fs = 48000; Ts = 1/Fs;
t = [0:Ts:1];
f = 4;
x = sin(2*pi*f*t);

[r,l] = xcorr(x,x);


plot(x);
figure; plot(l,r);

[pks,locs] = findpeaks(r)