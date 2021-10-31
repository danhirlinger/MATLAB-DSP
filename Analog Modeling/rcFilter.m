    % rcFilter.m
% 9/27/21
clear;clc;
C = 800 * 10^-12; % nanoFarads
R = 20000; 

% Angular frequency
w = 2 * pi * [20:20000]; % 2pi * Hz

s = 1j * w;

% Transfer function
H = 1 ./ ((s*C*R) + 1);

% cut-off frequency
fc = 1/(2*pi*R*C);

% Digital filter
Fs = 48000;
% k = 2*Fs;
k = 2*pi*fc / (tan((pi*fc)/Fs));
b0 = 1 / (k*R*C + 1);
b1 = b0;
a0 = 1;
a1 = (1 - k*R*C) / (1 + k*R*C);

b = [b0,b1]; a = [a0,a1];

[Hd,Wd] = freqz(b,a,2048,Fs);


% Magnitude response
subplot(2,1,1);
semilogx(w/(2*pi) , 20*log10(abs(H)) , Wd , 20*log10(abs(Hd)));
axis([20 24000 -10 5]);
xlabel('Freq (Hz)'); ylabel('Amp (dB)');

% Phase response
subplot(2,1,2);
semilogx(w/(2*pi) , angle(H) * (180/pi) , Wd , angle(Hd) * (180/pi));
axis([20 24000 -90 0]);
xlabel('Freq (Hz)'); ylabel('Phase (deg)');



