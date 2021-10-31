% iirFilters.m
% Dan Hirlinger
% 3/17/2021
clear; clc; close all;

x = [1; zeros(1023,1)];

b = [1];
a = [1 0 0.9];

% freqz(b,a);
fvtool(b,a);

y = filter(b,a,x);
figure;
stem(y);


% Filter implementation

% y(n,1) = b0 * x(n,1) + b1 * x(n,1,1) + a1 * y(n-1,1)
N = length(x);
b0 = 1;
b1 = 1;
a1 = 1;
x1 = 0; % one sample of FF delay
y1 = 0; % one sample of FB delay
for n = 1:N
    y(n,1) = b0 * x(n,1) + b1 * x1 + a1 * y1;
%     x2 = x1;
    x1 = x(n,1);
%     y2 = y1;
    y1 = y(n,1);
end


% Butterworth Filter
% [b,a] = butter(m,Wn);
m = 1; % filter order
Fs = 48000;
Nyq = Fs/2;
f = 4000;
% f = [6000 12000];
Wn = f/Nyq; % normalized cut-off frequency

[b,a] = butter(m,Wn);
% [b,a] = butter(m,Wn,'high');


y = filter(b,a,x);

% Biquad filter
fC = 6000;
Q = 3;
dBGain = 12;
type = 'pkf';
form = 1;
% y = biquadFilter(x,Fs,fC,Q,dBGain,type,form);










