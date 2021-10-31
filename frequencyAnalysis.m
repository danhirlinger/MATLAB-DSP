% frequencyAnalysis.m

clc; clear;

% Use inner product to analyze which f's are contained in a signal

% Simple example
Fs = 64; Ts = 1/Fs;
f = 4;
t = [0:Ts:1-Ts].';
x = square(2*pi*f*t);
% harmonics at 4, 12, 20, 28

% use periodic signal w/ single freq to analyze square

% p = sin(2*pi*20*t);

% Inner product
% sum(x.*p);
% p' * x

% Use loop to analyze many different frequencies

for k = 0:Fs/2 % start with 0 > is there DC?
    % different f used each loop
    p = sin(2*pi*k*t); 
    
    % inner product to compare "periodic" signal w square wave
    X(k+1,1) = p.' * x;
    
end
k = 0:32; % use this array for plot    
% plot(k,20*log10(X)); % plot on decibel scale

% audio example
Fs = 48000; Ts = 1/Fs;
f = 1000;
t = [0:Ts:1-Ts].';
x = square(2*pi*f*t);

X = zeros(24001,1);

for k = 0:Fs/2
   p = sin(2*pi*k*t);
   X(k+1,1) = p.' * x;
end

k = 0:24000;
plot(k,X); % linear frequency, linear amplitude

% linear frequency, dB amplitude
figure; plot(k,20*log10(abs(X)));

% log freq, dB amplitude
figure; semilogx(k,20*log10(abs(X)));


