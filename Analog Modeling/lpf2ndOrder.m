% LPF2ndOrder.m

R1 = 10e3;
R2 = 10e3;
R3 = 10e3;
R4 = 5.55e3;
C1 = 0.1e-6;
C2 = C1;

a11 = 0;
a12 = 1/(C1*R2);
a21 = 1/(C2*R3);
a22 = (1/C2)*(((-1)/R2)+((-1)/R3)+((-1)/R4));

A = [a11 a12 ; a21 a22];
B = [(-1/(C1*R2)) ; (1/(C2*R3))];
D = [1 0];
E = [1];

[bc,ac] = ss2tf(A,B,D,E);
[H,W] = freqs(bc,ac);
semilogx(W/(2*pi),20*log10(abs(H)));
axis([20 20000 -25 5]); 
xlabel('Freq (Hz)');
ylabel('Magnitude (dB)');
hold on; 

% % Digitize state-space form
% Fs = 48000;
% [Ad,Bd,Dd,Ed] = bilinear(A,B,D,E,Fs);
% [b,a] = ss2tf(Ad,Bd,Dd,Ed);
% [H,F] = freqz(b,a,2048,Fs);
% semilogx(F,20*log10(abs(H)));
% 
% u = [1; zeros(63,1)];
% 
% % state "vector"
% x = [0,0];
% N = length(u);
% y = zeros(N,1);
% 
% for n = 1:N   
%     y(n,1) = Dd * x + Ed * u(n,1);
%     x = Ad * x + Bd * u(n,1);
% end
% % 
% % [H,F] = freqz(y,1,2048,Fs);
% % semilogx(F,20*log10(abs(H)));
% hold off;