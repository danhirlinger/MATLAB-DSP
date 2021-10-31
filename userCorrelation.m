% userCorrelation.m
% Dan Hirlinger
% 11/6/2020
clear;clc;

% This is a script you should use for Problem 2 in order to verify the performance
% of your solution. Make sure your code can automatically adjust to signals of different lengths. 
% Your code should create two array variables:

% Example vectors from test
%x = [2 ; -1 ; 1 ; -2 ; 4];
%y = [1 ; 3 ; -2 ; -1 ; 1.5];
% Alternative input signals
x = randn(10,1);
y = randn(10,1);
% get length of signal
N = length(x);
% l = lag values, should be -N+1:N-1
l = (-N+1:N-1).';
M = 2*N-1; % output length, # of correlation values
% could also use M = length(l)

% r = correlation function
r = zeros(M,1);

% ADD YOUR CODE HERE:
for m = 1:M 
    lag = l(m,1);
    if lag < 0 % when lag is negative
        a = x(1:N-abs(lag),1);
        b = y(1+abs(lag):end,1);
    elseif lag > 0 % when lag is positive
        a = x(1+abs(lag):end,1);
        b = y(1:N-abs(lag),1);
    else % when lag = 0
        a = x;
        b = y;
    end
    % get correlation value
    r(m,1) = sum(a.*b);
end

r,l

% Make sure your result matches the built-in function
[R,L] = xcorr(x,y)

