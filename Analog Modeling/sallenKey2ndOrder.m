% sallenKey2ndOrder.m

C1 = .5e-6;
C2 = .5e-6;
R1 = 10e3;
R2 = 10e3;

num = R2;
den = [C1*C2*R1*R2^2 , (C1*R1*R2 + C2*R1*R2 + C2*R2^2 - C1*R1), R1+R2];

[H,W] = freqs(num,den);

% Finding H,W, using bilinear() function
Fs = 48000;
[b,a] = bilinear(num,den,Fs);
[Hd,Wd] = freqz(b,a,4096,Fs);

semilogx(W/(2*pi), 20*log10(abs(H)),Wd,20*log10(abs(Hd)));
xlabel('Freq (Hz)'); ylabel('Amp (dB)');

