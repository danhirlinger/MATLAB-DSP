% pitchAutoCorr.m
% Dan Hirlinger
% 11/6/2020
clear;clc;

[x,Fs] = audioread('testSignal.wav');
bufferSize = 512;
overlapPct = .5;
overlap = bufferSize*overlapPct;
N = length(x);
% use correlation in each buffer to determine the pitch for that buffer

numSegs = floor(length(x)/overlap);

pitch = zeros(numSegs,1);

for n = 1:numSegs
    % determine segment starting and ending sample numbers
    segStart = ((n-1)*overlap)+1;
    segEnd = overlap*(n+1);
    if segEnd > N % if segEnd DNE in the signal, take partial segment
        % segStart to the end of the audio signal
        segment = x(segStart:end);
    else % for when the segment is not partial
        segment = x(segStart:segEnd);
    end
    segCorr = xcorr(segment,segment); % get autocorrelation values for segment
    [pks,locs] = findpeaks(segCorr); % find peaks of correlation values and their locations in the segment
    
    % if there are peaks / if there is a signal AND it's not a collection of junk peak values
    % I ran into junk pks,locs arrays when segment was half silence, half
    % signal (i.e. locs was 299x1). I decided that pitch could not be
    % determined for these arrays using correlation. Therefore, their pitch = 0
    if isempty(locs) == 0 && length(locs) <= 23 
        M = length(locs); % get total number of peak locations
        maxPkLoc = locs(round(M/2),1); % retrieve location of global peak
        nextPkLoc = locs(round(M/2)+1,1); % retrieve location of next peak
        numSamples = abs(nextPkLoc-maxPkLoc); % get duration in samples of distance between peaks
        segPitch = 1 / (numSamples * (1/Fs)); % multiply by Ts to get period; get inverse to determine f, pitch
        pitch(n,1) = segPitch; % append array
    elseif segStart % if no signal (silence)/pitch cannot be determined from autocorrelation, then no pitch
        pitch(n,1) = 0;
    end
end


% plot
plot(pitch);


