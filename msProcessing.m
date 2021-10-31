% msProcessing.m
% Dan Hirlinger
% 1/18/2021
clear;clc;
% demonstrate mid-sides processing and stereo-image widening

[x,Fs] = audioread('stereoDrums.wav');


% separate L, R

L = x(:,1);
R = x(:,2);

N = length(L);

% Encoding process
S = zeros(N,1);
M = zeros(N,1);
for n = 1:N
    S(n,1) = L(n,1) - R(n,1);
    M(n,1) = L(n,1) + R(n,1); 
end

% add effect(s) to S, M
% S = 0 * S; % turn off sides
% Stereo Image Processing
width = 1; % [0 - 2] (narrow - wide)
S = width * S;
M = (2 - width) * M;


% Decoding process
newL = 0.5 * (M+S);
newR = 0.5 * (M-S);


% New stereo
y = [newL, newR];

% Goniometer analysis

amp = zeros(N,1);
ang  = zeros(N,1);
horz  = zeros(N,1);
vert  = zeros(N,1);

for n = 1:N
   amp(n,1) = sqrt((newL(n,1)^2) + (newR(n,1)^2));
   % ang(n,1) = atan(newL(n,1)/newR(n,1)) + pi/4; OR
   ang(n,1) = atan2(newL(n,1), newR(n,1)) + pi/4; % this will plot all the way around (0 - 2pi)
   
   % convert polar coordinates to cartesian for plot()
   
   horz(n,1) = amp(n,1) * cos(ang(n,1)); % get x coordinate
   vert(n,1) = amp(n,1) * sin(ang(n,1)); % get y coordinate
end


plot(horz,vert,'.b');
axis([-1 1 -1 1]);











