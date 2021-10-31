% sincFilter.m

% consider comparing: rectangular, triangle, cosine, sinc

clc; close all;clear;
N = 10;
n = -N:N-1;
f = 10;
h = sin(2*pi*n)./(2*pi*n);
h(isnan(h)) = 1;
h2 = sinc(n);   % This sinc creates a dirac function
plot(n,h); hold on;
plot(n,h2); % These functions are equal
hold off;
N = 50;
n = -N:N-1;
for f = 0.1:0.1:pi   % This "f" is a normalized cut-off freq
    f/pi % normalized cut-off freq
    h = sinc((f/pi)*n);
    h = h/sum(h); % unity gain
    %plot(h);
    %figure;
    freqz(h);
    pause;
end