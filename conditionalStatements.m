%conditionalStatements.m
% Dan Hirlinger
% 9/28/2020

clc;clear;

a = 5;

if a > 2
    
    b = 3;
else
    
    b = 30;
    
end

c = 1;

%[x,Fs] = audioread('sw20Hz.wav');
[x,Fs] = audioread('AcGtr.wav');

% finding max amplitude value without using built-in function
Max = x(1,1);

N = length(x);
for n = 2:N
    if abs(x(n,1)) > Max
        Max = abs(x(n,1));
    end
end

Ap = max(abs(x));
Ap == Max;

% peak normalization

xNorm = x/Ap;

for n = 1:N
    
    x(n,1) = x(n,1) * xNorm;
    
end




    
