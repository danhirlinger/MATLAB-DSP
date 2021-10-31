% sallenKey_2ndOrder_DK.m

Fs = 48000; Ts = 1/Fs;

Vi = [1; zeros(2047,1)];

C1 = .1e-6;
R1 = Ts/(2*C1);
C2 = .1e-6;
R2 = Ts/(2*C2);
R3 = 10e3;
R4 = 10e3;
R5 = 10e3;
R6 = 5.55e3;

G1 = (1/R1)+(1/R4);
G2 = R6/(R5+R6);
G3 = (1/R2)+(1/R3)+(1/R4);
G4 = (G1*G2*R4)-(1/(G3*R2))-(G2/(G3*R4));

b0 = 1/(G3*G4*R3);
b1 = R4/G4;
b2 = (1/(G3*G4));

x1 = 0;
x2 = 0;

N = length(Vi);
Vo = zeros(N,1);
for n = 1:N
    Vo(n,1) = b0*Vi(n,1) + b1*x1 + b2*x2;
    x2 = (2/R2)*((G1*G2*R4*Vo(n,1))-(x1*R4) - Vo(n,1)) - x2;
    x1 = (2/R1)*((Vo(n,1)*G2)) - x1;
end

[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);

