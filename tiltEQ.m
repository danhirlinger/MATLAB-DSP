function [out] = tiltEQ(in,tilt)
% Dan Hirlinger
% 3/3/21

limAmp = 10^(tilt/20);

F = [0 1];
A = [1/limAmp,linAmp]; % linear scale

m = 10; % order
h = fir2(m,F,A);

out = conv(in,h);

% Fs = 48000;
% Nyq = Fs / 2;
% N = length(input);
% % tilt has raneg -6:6dB
% % when tilt is negative, lows are boosted
% % when tilt is positive, highs are boosted
% % tilt dB amount is the max change in A between 0Hz - Nyquist
% % between 0 and Nyquist, tilt has constant slope
% 
% 
% % currently only works with 3 cases: -6, 0, and +6 dB
% % run into error when changing below values of the extremes, as 
% % the specified step size alters the number of items in the array
% 
% % I believe that I have approached the problem wrong with this method
% 
% 
% % at highest difference, minimum A will be 0; max will be 1
% 
% if tilt > 0 % highs boosted, lows subdued
%     A = linspace(-(tilt/2),(tilt/2),Nyq+1);
%     A = 10.^(A/20);
% elseif tilt < 0 % lows boosted, highs subdued
%     A = linspace((abs(tilt)/2),-(abs(tilt)/2),Nyq+1);
%     A = 10.^(A/20);
% else % flat Eq; no filtering effect
%     A = [ones(1,Nyq+1)];
% end
% order = 100; % m
% 
% F = [0 : 1/Nyq : 1];
% % A = [0 : 1/Nyq : 1]; % +/-1 = +/- 6dB 
% h = fir2(order,F,A);
% freqz(h);
% 
% out = conv(in,h);
