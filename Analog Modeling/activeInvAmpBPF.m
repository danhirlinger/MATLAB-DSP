% activeInvAmpBPF.m
clear;clc;close all;

R1 = 10e3;
R2 = 10e3;
C1 = 150e-9;
C2 = 5.6e-9;

a11 = (-1)/(C1*R1);
a12 = 0;
a21 = 1/(C2*R1);
a22 = 1/(C2*R2);

A = [a11 a12 ; a21 a22];
B = [(1/(C1*R1)) ; ((-1)/(C2*R1))];
D = [0 1];
E = [0];

% Digitize state-space form
Fs = 48000;
[Ad,Bd,Dd,Ed] = bilinear(A,B,D,E,Fs); % convert from s domain > z domain
[b,a] = ss2tf(Ad,Bd,Dd,Ed); % state space > transfer function
[H,F] = freqz(b,a,2048,Fs);
semilogx(F,20*log10(abs(H)));
axis([20 20000 -30 5]); 
xlabel('Freq (Hz)');
ylabel('Magnitude (dB)');
