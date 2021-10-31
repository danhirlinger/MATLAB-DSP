% basicFlanger.m
% Dan Hirlinger
% 6/9/21
clear;clc;

% Effect Parameters %

mix = 1;    % [0,1]
rate = 2;   % [0.1,10] "Hz"
% depth: the range of the LFO
depth = 3;  % [1,20]   "samples"
predelay = 0; % [0,20] "samples"
type = 1; % 1 = sin ; 0 = triangle

% in = [1; zeros(10,1)];
[in,Fs] = audioread('AcGtr.wav');
Ts = 1/Fs;
N = length(in);

M = 20; % want a circular buffer w length that is longer than the max delay
buffer = zeros(M,1);


wI = M; % write index

% delay = 3.2; % samples
% LFO gives us a modulated delay time

% cool potential feature: smooth transition btwn sin, triangle options

t = [0:N-1].' * Ts;
if (type == 1)
    lfo = (depth/2)*sin(2*pi*rate*t) + (depth/2) + 1 + predelay;
elseif (type == 0)                  % |_____________| this ensures a minimum at 1 sample delay
    lfo = (depth/2)*sawtooth(2*pi*rate*t) + (depth/2) + 1 + predelay;
end


for n = 1:N
    x = in(n,1);
    
    buffer(wI,1) = x;
    
    delay = lfo(n,1);
    
    r1 = wI - floor(delay); % 3 samples of delay
    if (r1 < 1)
        r1 = r1 + M;
    end
    r2 = r1 - 1;
    if (r2 < 1)
       r2 = r2 + M; 
    end
    
    g2 = delay - floor(delay);
    g1 = 1 - g2;
    
    y = g1 * buffer(r1,1) + g2 * buffer(r2,1);
    
    wI = wI + 1;
    if (wI > M)
        wI = 1;
    end    
    
    out(n,1) = x + mix*y;
end


stem(out);