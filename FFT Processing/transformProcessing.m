% transformProcessing.m
clear;clc; close all;
%% time domain signal
%[x,Fs] = audioread('AcGtr.wav');
x = randn(4,1);
t = [0:Ts:1-Ts].';

x = sin(2*pi*10*t);
w = sin(2*pi*17*t);

%% frequency domain signal
X = fft(x);
W = fft(w);

%% Separate amplitude and phase
%Xamp = abs(X);
%Xphase = angle(X);

%% put together for cartesian coordinates
%Xre = Xamp .* cos(Xphase);
%Xim = Xamp .* sin(Xphase);

%Y = Xre + Xim*1j;
%% Amp scaling: Y = g * X
%Y = 2 * X;
 % OR
%Xamp = abs(X) * 2;
%Xphase = angle(X);

%Y = Xre + Xim*1j;

%% Mixing signals: Y = X + W
Y = X+W;
%% below achieves the same Y as the above
%Y = Xamp .* e^(1j*Xphase);

%% convert back to time domain ; plot error
y = real(ifft(Y));

%plot(y-x);

%% Time domain convolution as freq-domain multiplication

x = [0:.1:.9].'; % length = 10
h = [0.4:-.1:0.1].'; % length = 4
y1 = conv(x,h); % length = 13

xpad = [x;zeros(length(h)-1,1)];
hpad = [h;zeros(length(x)-1,1)];

X = fft(xpad);
H = fft(hpad);

Y = X .* H;

y = real(ifft(Y));
