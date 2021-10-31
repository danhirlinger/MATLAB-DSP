% filterBank.m
% Dan Hirlinger
clear; clc;

Fs = 48000;
Nyq = Fs/2;

n = 8; % Q value
Wn = 1000/Nyq; % where the "split" occurs

[bLow,aLow] = butter(n,Wn);
[bHi,aHi] = butter(n,Wn,'high');

[hLow,w] = freqz(bLow,aLow,4096,Fs);
[hHi] = freqz(bHi,aHi,4096,Fs);

semilogx(w,20*log10(abs(hLow)),w,20*log10(abs(hHi)));
axis([20 20000 -24 6]);
xlabel('Freq (Hz)');
ylabel('Amp (db)');
legend('LPF','HPF');