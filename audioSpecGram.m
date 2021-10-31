% audioSpecGram.m
clear; clc;
[x,Fs] = audioread('AcGtr.wav');
Ts = 1/Fs;
N = length(x);
t = [0:N-1] * Ts;

% plot waveform
plot(t,x); 
axis([0 7 -1 1]);
figure;

% Length FFT
nfft = 4096;

% window "cross-fade" function
win = hann(nfft);

% overlap amount
overlap = nfft/2;

% use internal spectrogram function
[S,F,T] = spectrogram(x,win,overlap,nfft,Fs);

% 3-D plot
surf(T,F,20*log10(abs(S)),'EdgeColor','none');
axis xy; axis tight; view(0,90);
xlabel('Time (sec)'); ylabel('Freq (Hz)');


