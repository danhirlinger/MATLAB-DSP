% ampFades.m
% Dan Hirlinger
% 10/14/2020

% input signal
[x,Fs] = audioread('sw440Hz.wav');

% Fade-in
N = length(x);
a = linspace(0,1,N).';

y = zeros(N,1);
for n = 1:N
    y(n,1) = x(n,1) * a(n,1);
end

% fade-out
N = length(x);
a = linspace(1,0,N).'; %% only change is the linear vector

y = zeros(N,1);
for n = 1:N
    y(n,1) = x(n,1) * a(n,1);
end

plot(y);

lenSec = .5;
lenSamples = round(lenSec*Fs);
a = linspace(1,0,lenSamples).';

%%lenUG = 
%%% FIND NOTES FROM CLASS TO FILL IN HERE %%

% y = zeros(N,1);
% for n = 1:N
%     y(n,1) = x(n,1) * a(n,1);
% end


% cross-fades
% equal gain (equal-amp)
fadeIn = linspace(0,1,100);
fadeOut = linspace(1,0,100);

% equal power
fadeIn = sqrt(linspace(0,1,100));
fadeOut = sqrt(linspace(1,0,100));
plot(fadeIn); hold on;
plot(fadeOut); 

%combinedGain = fadeIn + fadeOut
combinedPower = (fadeIn.^2) + (fadeOut.^2);
plot(combinedPower);
hold off;