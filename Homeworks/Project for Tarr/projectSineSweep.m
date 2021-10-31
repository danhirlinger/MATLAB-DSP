%project sine sweep

Fs = 48000;
Ts = 1/Fs;
t = [0:Ts:10];
x = chirp(t,0,10,Fs/2).';
N = length(x);
%fade in formula
fadeIn = linspace(0,1,Fs/4).';
unityGain = ones(N-Fs/2,1);
fadeOut = linspace(1,0,Fs/4).';
a = [fadeIn; unityGain; fadeOut];

y = zeros(N,1);

for n = 1:N
    
    y(n,1) = x(n,1)* a(n,1);
end

audiowrite('projectSineSweep.wav',y,Fs);
