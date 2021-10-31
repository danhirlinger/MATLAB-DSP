% irExperiments.m
% Dan Hirlinger
% 2/8/21

% Input signal
[x,Fs] = audioread('AcGtr.wav');

% Impulse response
h = audioread('reverbIR.wav');

% Stereo convolution
hL = h(:,1);
hR = h(:,2);

% Convolution
yL = conv(x,hL);
yR = conv(x,hR);

% Use correlation w time reverse
xT = x(end:-1:1);
% yR = xcorr(xT,hR);
% yL = xcorr(xT,hL);

y = [yL, yR];

% sound(y,Fs);