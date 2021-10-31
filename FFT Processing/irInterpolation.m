% irInterpolation.m
% Interpolation btw two impulse responses
clear;clc;
[offAxis,Fs] = audioread('MarshallSM57offAxis0_5in.wav');
[onAxis] = audioread('MarshallSM57onAxis0_5in.wav');

% Linear interpolation in time domain
mix = 0.5;
ir = (1-mix)*onAxis + mix*offAxis;

hold on; stem(offAxis);
stem(onAxis);
stem(ir); hold off;

figure;
[Hon,W] = freqz(onAxis,1,2048,Fs);
[Hoff,W] = freqz(offAxis,1,2048,Fs);
[Hir,W] = freqz(ir,1,2048,Fs);

plot(W,20*log10(abs(Hon)),W,20*log10(abs(Hoff)),W,20*log10(abs(Hir)));
axis([20 2000 -80 20]);
% semilog(W,20*log10(abs(Hon)),W,20*log10(abs(Hoff)),W,20*log10(abs(Hir)));
% axis([20 2000 -80 20]);

% Frequency Domain Interpolation

% FFT's
H1 = fft(onAxis);
H2 = fft(offAxis);

% Get polar coordinates
H1amp = abs(H1);
H2amp = abs(H2);

N = length(H1amp);
H1amp = H1amp(1:(N/2) + 1,1);
H2amp = H2amp(1:(N/2) + 1,1);
Hamp = (1-mix)*H1amp + mix*H2amp;

figure;
plot(20*log10(H1amp));hold on;
plot(20*log10(H2amp));
plot(20*log10(Hamp));hold off;

H1phase = unwrap(angle(H1));
H2phase = unwrap(angle(H2));

H1phase = H1phase(1:(N/2) + 1,1);
H2phase = H2phase(1:(N/2) + 1,1);
Hphase = (1-mix)*H1phase + mix*H2phase;

figure;
plot(H1phase); hold on;
plot(H2phase);
plot(Hphase); hold off;

H = Hamp .* exp(1j * Hphase);

H = [H ; conj(H(end-1:-1:2))];
h = real(ifft(H));

figure;
stem(onAxis); hold on;
stem(offAxis);
stem(h);

figure;
[Hon,W] = freqz(onAxis,1,2048,Fs);
[Hoff,W] = freqz(offAxis,1,2048,Fs);
[Hir,W] = freqz(h,1,2048,Fs);

plot(W,20*log10(abs(Hon)),W,20*log10(abs(Hoff)),W,20*log10(abs(Hir)));
% axis([20 2000 -80 20]);





















