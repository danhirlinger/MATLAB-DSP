% additiveSquare.m
% Dan Hirlinger
% 10/21/2020

% Declare variables
Fs = 48000; Ts = 1/Fs;
f = 100;
lenSec = 5;
t = [0:Ts:lenSec].';
N = Fs*lenSec;
% number of harmonics, M
M = floor((Fs)/(2*f));

% make empty array, will be filled by all required sine waves to synthesize
% the square wave
sqArray = zeros(N,M);

% gather all of the fundamental freq. sine waves for the square wave
for n = 1:M
    sine = (sin(((2*n)-1)*2*pi*f*t) * 1/((2*(n-1))+1));
    sqArray(:,n) = sine(1:N);
end

% add samples of all sine waves together
signal = zeros(N,1);
for n = 1:M
   signal = signal + sqArray(:,n);
end

% multiply summation by 4/pi
signal = signal * (4/pi);
% plot
plottf(signal,Fs);

