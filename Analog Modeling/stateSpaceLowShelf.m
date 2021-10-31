% stateSpaceLowShelf.m
clear;clc;close all;

RA = 1000;
RB = 9100;
C1 = 110e-9;

A = 1/(RA*C1);
B = -1/(RB*C1);
D = 1;
E = 1;


[bc,ac] = ss2tf(A,B,D,E);
[H,W] = freqs(bc,ac);
semilogx(W/(2*pi),20*log10(abs(H)));
axis([20 20000 -30 5]); 
xlabel('Freq (Hz)');
ylabel('Magnitude (dB)');
hold on; 

% Digitize state-space form
Fs = 48000;
[Ad,Bd,Dd,Ed] = bilinear(A,B,D,E,Fs);
[b,a] = ss2tf(Ad,Bd,Dd,Ed);
[H,F] = freqz(b,a,2048,Fs);
semilogx(F,20*log10(abs(H)));


u = [1; zeros(63,1)]; % state "vector"
x = [0];
N = length(u);
y = zeros(N,1);

for n = 1:N   
    y(n,1) = Dd * x + Ed * u(n,1);
    x = Ad * x + Bd * u(n,1);
end

[H,F] = freqz(y,1,2048,Fs);
semilogx(F,20*log10(abs(H)));
hold off;