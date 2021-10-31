% msDistortion.m
% Dan Hirlinger
% 2/1/21
clear; clc;

% Import audio file
[x,Fs] = audioread('stereoDrums.wav');
Ts = 1/Fs;

% Separate in L,R
L = x(:,1);
R = x(:,2);

N = length(L);
t = [1:N]';
% Perform mid-side encoding
S = zeros(N,1);
M = zeros(N,1);
for n = 1:N
    S(n,1) = L(n,1) - R(n,1);
    M(n,1) = L(n,1) + R(n,1); 
end

% Perform hard clipping on the sides
newS = zeros(N,1);
thresh = 0.5;
drive = 1;
x = drive*x;
for n = 1:N
    if S(n,1) > thresh
        newS(n,1) = thresh;
    elseif S(n,1) < (-thresh)
        newS(n,1) = -thresh;
    else
        newS(n,1) = S(n,1);      
    end
end

% Perform soft clipping on the mid
newM = zeros(N,1);
thresh = 0.8;
drive = 1;
x = drive*x;
for n = 1:N
    newM(n,1) = M(n,1) - (1/3)*(M(n,1)^3);
end

% Mid-side decoding
newL = 0.5 * (newM+newS);
newR = 0.5 * (newM-newS);

% Create variable with the stereo signal
y = [newL, newR];

% Write to new file (distDrums.wav)
audiowrite('distDrums.wav',y,Fs);

