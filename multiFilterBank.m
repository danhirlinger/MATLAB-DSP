% multiFilterbank.m
% Dan Hirlinger
% has not been done in class as of 3/10/21
clear; clc;

Fs = 48000;
Nyq = Fs/2;
m = 3; % Filter order


numBands = 3;

% Log-spaced cutoff frequencies
% 2*10^1 -  2*10^4 (20 - 20k) Hz
freq = 2 * logspace(1,4,numBands + 1);

for band = 1:numBands
   Wn = [freq(band) , freq(band+1)] ./  Nyq;
   [b(:,band),a(:,band)] = butter(m,Wn);
   
   [h,w] = freqz(b(:,band),a(:,band),4096,Fs);
   semilogx(w,20*log10(abs(h)));
   hold on;
end

hold off;
axis([20 20000 -24 6]);
xlabel('Freq (Hz)');
ylabel('Amp (db)');