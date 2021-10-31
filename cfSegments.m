% cfSegments.m
% Dan Hirlinger
% 10/16/2020
clear;clc;

[x,Fs] = audioread('HW2.wav'); Ts = 1/Fs;

% establish buffer size
bufferSize = 512;
% find number of segments for given buffer size
% needs to be rounded to avoid errors
numSegs = round(length(x)/bufferSize);
% establish empty arrays
peakAmp = zeros(numSegs,1);
rmsAmp = zeros(numSegs,1);
DRdB = zeros(numSegs,1); % crest factor values on decibel scale
% determine time in seconds at beginning of each buffer for plot scale
buffStartTime = zeros(numSegs,1);
for n = 1:numSegs
    % need to allow for partial segment at end of sample
    if n*bufferSize < bufferSize*(numSegs-1)
        % extract appropriate number of samples
        segment = x(((n-1)*bufferSize)+1:bufferSize*n);
    else
        % OR extract partial sample
        segment = x(((n-1)*bufferSize)+1:end);
    end
    % find peakAmp for segment
    Ap = max(abs(segment));
    % append peakAmp array
    peakAmp(n,1) = Ap;
    % find rmsAmp for segment
    Arms = sqrt((sum(segment.^2)/length(segment)));
    % append rmsAmp
    rmsAmp(n,1) = Arms;
    % find DRdB for segment
    DRdB_segment = (20*log10(Ap)) - (20*log10(Arms/0.7071));
    % append DRdB
    DRdB(n,1) = DRdB_segment;
    % create array for x axis points for latter 3 graphs represented later
    buffStartTime(n,1) = Ts * bufferSize * (n-1);
    
end

% plot everything
subplot(4,1,1);
plot(x);
numberTicks = numSegs;
% ticks = (1:512:x);          << attempted to change x axis for sound file
% xticks(ticks);                 to match the other plots
%set(gca,'xtick',1:512:x);       could not figure out how to do it
subplot(4,1,2);
plot(buffStartTime,peakAmp);
subplot(4,1,3);
plot(buffStartTime,rmsAmp);
subplot(4,1,4);
plot(buffStartTime,DRdB);
