% test
% Run this to visualize the distorted DI signal compared to original
% distorted signal
clear; clc;

[in,Fs1] = audioread('BassDI.wav');
thresh = 0.2;
[out] = transistorClipping(in,thresh);
[ref,Fs2] = audioread('LA3APrint.wav');


plot(out); % Distortion from function
hold on;
plot(ref);      % Origical distorted
hold off;