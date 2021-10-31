% rcFilter_DK.m

Fs = 48000; Ts = 1/Fs;

Vi = [1; zeros(2047,1)];

R2 = 1000;
C = 100e-9;
R1 = Ts/(2*C);

x1 = 0;

N = length(Vi);
Vo = zeros(N,1);
for n = 1:N
    Vo(n,1) = Vi(n,1) * R1/(R1+R2) + x1*(R1*R2)/(R1+R2);
    x1 = 2/R1 * Vo(n,1) - x1;
end

[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);

%%%% High-pass filter %%%%

x1 = 0;

G = ((1/R1) + (1/R2));

N = length(Vi);
Vo = zeros(N,1);

for n = 1:N
    Vo(n,1) = Vi(n,1) * (1/(R1*G)) - x1*(1/G);
    x1 = 2/R1 * (Vi(n,1) - Vo(n,1)) - x1;
end

[H,W] = freqz(Vo,1,2048,Fs);
semilogx(W,20*log10(abs(H)));
axis([20 20000 -30 5]);
