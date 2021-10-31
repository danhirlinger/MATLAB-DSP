% rcFilter_2ndOrder_DK.m

Fs = 48000; Ts = 1/Fs;

Vi = [1; zeros(2047,1)];

C1 = 100e-9;
R1 = Ts/(2*C1);
C2 = 100e-9;
R2 = Ts/(2*C2);
R3 = 1000;
R4 = 1000;

G = (1/R1) + (1/R3) + (1/R4);
M = 1 + (R4/R2) - (1/(G*R4));

b0 = 1/(G*M*R3);
b1 = 1/(G*M);
b2 = (R4/M);

x1 = 0;
x2 = 0;

N = length(Vi);
Vo = zeros(N,1);
for n = 1:N
    Vo(n,1) = b0*Vi(n,1) + b1*x1 + b2*x2;
    x1 = (2/R1)*(Vo(n,1) + (R4/R2)*Vo(n,1) - (R4*x2))  - x1;
    x2 = 2/R1 * Vo(n,1) - x2;
end

[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);

