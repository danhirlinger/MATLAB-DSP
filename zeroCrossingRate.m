% zeroCrossingRate.m
% Dan Hirlinger
% 10/19/2020
clear;clc;
% Use zero-crossing rate to determine pitch

% Signal to analyze
Fs = 48000; Ts = 1/Fs;
f = 100;

lenSec = 1;
N = Fs * lenSec; % to convert seconds into # samples

t = [0:N-1].' * Ts;

x = sin(2*pi*f*t);

% Count # of zero crossings for entire signal
zeroCount = 0;
prevSample = 0;
for n = 1:N
    sample = x(n,1);
    if sample >= 0
       if prevSample <= 0
           zeroCount = zeroCount + 1;
       end
    else % if sample < 0
        if prevSample >= 0
            zeroCount = zeroCount + 1;
        end
    end
    prevSample = sample;
end

% zeroCount is total # of ZC's per N samples
% ZCR = # of ZC's/sec
zcr = zeroCount/lenSec;

pitch = zcr/2;


% Alternative approach
zeroCount = 0;
prevSample = 0;
for n = 1:N
    sample = x(n,1);
    if sample * prevSample < 0
       zeroCount = zeroCount + 1; 
    end
    prevSample = sample;
end