% periodicity.m
% Dan Hirlinger
% November 11, 2020
clear; clc;
% ZCR will be low for periodic
% autocorr will have not many max values for aperiodic

% read in audio file and define variables
[x,Fs] = audioread('quiz3.wav'); Ts = 1/Fs;
N = length(x);

bufferSize = 512;
numSegs = floor(length(x)/bufferSize);
pdctyArray = zeros(numSegs,1);

for n = 1:numSegs
   zeroCount = 0;
   prevSample = 0;
   % determine segment starting and ending sample numbers
   segStart = (bufferSize * (n-1)) + 1;
   segEnd = (bufferSize * n) + 1;
   if segEnd > N % if the end of the segment DNE in the signal
       % take partial signal
       segment = x(segStart:end);
       lenSec = length(segment)/Fs;
   else % for when the segment is not partial
       segment = x(segStart:segEnd);
       lenSec = length(segment)/Fs;
   end
   % determine number of ZC's in the segment
   for m = segStart:segStart+length(segment)-1
       sample = x(m,1);
       if sample >= 0
           if prevSample < 0
               zeroCount = zeroCount + 1;
           end
       else % if sample < 0
           if prevSample > 0
               zeroCount = zeroCount + 1;
           end
       end
       prevSample = sample;
   end
   segZcr = zeroCount/lenSec;
   if segZcr > 15000 % likely aperiodic signal
       pdctyArray(n,1) = 0;
   else
       pdctyArray(n,1) = 1;
   end
end

plot(pdctyArray);





