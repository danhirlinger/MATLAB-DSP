% peakFrames.m
% Dan Hirlinger

[x, Fs] = audioread('HW2.wav');

% Allow for variable buffer size
bufferSize = 512;

numSegs = round(length(x)/bufferSize);

% establish empty array for peak amplitudes
peakAmp = [];


for n = 1:numSegs
    % need to allow for partial segment at end of sample
    if n*bufferSize < bufferSize*(numSegs-1)
        % extract appropriate number of samples
        segment = x(((n-1)*bufferSize)+1:bufferSize*n);
    else
        % OR extract partial sample
        segment = x(((n-1)*bufferSize)+1:end);
    end
    % find amplitude peak within segment
    Ap = max(abs(segment));
    % append peak amplitude array
    peakAmp = [peakAmp ; Ap];
    
end

% Plot array of peaks
plot(peakAmp)

