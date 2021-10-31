% pitchDetectionZCR.m
% Dan Hirlinger
% 11/6/2020
clear;clc;
% initialize variables
[x,Fs] = audioread('testSignal.wav');
Ts = 1/Fs;
bufferSize = 512;
overlapPct = 0.5; %  50%
overlap = bufferSize * overlapPct;
N = length(x);
% determine number of buffer segments based on signal length, buffer size,
% and the overlap
numSegs = floor(length(x)/overlap);

pitch = zeros(numSegs,1);
for n = 1:numSegs
    % reset counters
    zeroCount = 0;
    prevSample = 0;
    % determine segment starting and ending sample numbers
    segStart = ((n-1)*overlap)+1;
    segEnd = overlap*(n+1);
    if segEnd > N % if the ending segment number DNE in the signal
        % take partial segment, segStart to end of audio signal
        segment = x(segStart:end);
        % find length in seconds of segment to determine ZCR later
        lenSec = length(segment)/Fs;
    else % for when the segment is not partial
        segment = x(segStart:segEnd); % take segment that is the buffer len
        lenSec = length(segment)/Fs; % again, determine length in seconds
        % below is a loop for determining # of ZC's
    end
        for m = segStart:segStart+length(segment)-1
           sample = x(m,1);
            if sample >= 0
               if prevSample < 0
                   zeroCount = zeroCount + 1;
               end
            else % if sample < 0
               if prevSample > 0
                   zeroCount = zeroCount + 1; % this is not good code
               end
            end
            prevSample = sample; 
        end
    segZcr = zeroCount/lenSec; % determine segment ZCR
    segPitch = segZcr/2; % determine pitch of segment based on segZcr
    pitch(n,1) = segPitch; % insert segPitch value into array
    
end

% plot pitch to view detected fundamental frequency

plot(pitch);