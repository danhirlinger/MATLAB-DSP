% active1stOrderButter.m
clear;clc;

R1 = 10e3;
R2 = 9.1e3;
R3 = 1e3;
C1 = 100e-9;

num = R2 + R3;
den = [C1*R1*R3, R3];

[H,W] = freqs(num,den);

% Finding H,W, using bilinear() function
Fs = 48000;
[b,a] = bilinear(num,den,Fs);
[Hd,Wd] = freqz(b,a,4096,Fs);

semilogx(W/(2*pi), 20*log10(abs(H)));%,Wd,20*log10(abs(Hd)));
xlabel('Freq (Hz)'); ylabel('Amp (dB)');


