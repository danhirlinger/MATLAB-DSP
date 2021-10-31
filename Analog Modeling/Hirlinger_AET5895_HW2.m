% Hirlinger_AET5895_HW2.m
clear;clc;

R1 = 100000;
R2 = 10000;
C1 = 800 * 10^-12;
C2 = 800 * 10^-12;

% Angular frequency
w = 2 * pi * [20:20000];
s = 1j * w;

% Transfer function
A = 1 + R2*C2.*s;
B = ((1/R1) + C1.*s);
H = (1/R1) ./ (A.*B + C2.*s);

% Magnitude and phase response from transfer function
subplot(2,1,1);
semilogx(w/(2*pi) , 20*log10(abs(H)));
axis([20 24000 -200 50]);
xlabel('Freq (Hz)'); ylabel('Amp (dB)');

subplot(2,1,2);
semilogx(w/(2*pi), angle(H) * (180/pi));
axis([20 24000 -90 0]);
xlabel('Freq (Hz)'); ylabel('Phase (deg)');





% Using bilinear() function
num = 1;
den = [R1*R2*C1*C2 , (C1*R1 + C2*R2 + C2*R1) , 1];
[Hbi,Wbi] = freqs(num,den);

Fs = 48000;
[b,a] = bilinear(num,den,Fs);
[Hd,Wd] = freqz(b,a,4096,Fs);

% Magnitude and phase response from bilinear() results
figure(); subplot(2,1,1);
semilogx(Wd , 20*log10(abs(Hd)));
axis([20 24000 -200 50]);
xlabel('Freq (Hz)'); ylabel('Amp (dB)');

subplot(2,1,2);
semilogx(Wd, angle(Hd) * (180/pi));
axis([20 24000 -90 0]);
xlabel('Freq (Hz)'); ylabel('Phase (deg)');



