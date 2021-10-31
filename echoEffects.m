% echoEffects.m
% Dan Hirlinger
% 2/1/2021
clc; clear;

% input signal
[x,Fs] = audioread('AcGtr.wav');

% Delay
% 
% delayMS = 150;
% delaySec = delayMS / 1000;

% BPM
BPM = 90;
BPS = BPM / 60;
delaySec = 1 / BPS;

d = round(Fs * delaySec);

% Delay using zero-padding
w = [zeros(d,1) ; x];

% Make "x" same length as "w"
x = [x ; zeros(d,1)];

% Add together for "y"
y = x + w;

% plot(x); hold on;

% sound(y,Fs);

%%%% Difference equation (Multi-tap example)
% y[n] = x[n] + g1*x[n-1000] + g2*x[n-2000]

d1 = 1000;
d2 = 2000;
g1 = 0.4;
g2 = 0.2;
N = length(x);

for n = 1:N
    if (n-d1 < 1)
        y(n,1) = x(n,1);
    elseif (n-d2 < 1)
        y(n,1) = x(n,1) + g1*x(n-d1,1);
    else
        y(n,1) =  x(n,1) + g2*x(n-d2,1);   
    end
end

%%%%% Feedback example
% y[10] = x[10] + g*y[4]

d1 = 10000;

N = length(x);

for n = 1:N
    
    if(n-d1 < 1)
        y(n,1) = x(n,1);
    else
        y(n,1) = x(n,1) + g1*y(n-d1,1);
    end   
end
