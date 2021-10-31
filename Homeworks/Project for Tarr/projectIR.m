%projectIR.m

Fs = 48000;
Ts = 1/Fs;
t = [0:Ts:1].';
h = [1 ; zeros(length(t),1)];



audiowrite('projectIR.wav',h,Fs);