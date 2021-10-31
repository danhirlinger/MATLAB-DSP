% oversamplingTest.m
% Demonstrates up- and down-sampling in the frequency domain
clear;clc;

[in,Fs] = audioread('AcGtr.wav');

newFs = 96000;
upFactor = newFs/Fs;
downFactor = 1/upFactor;

frameSize = 2048;
overlap = 2; % [2:4]
hop = frameSize/overlap;

N = length(in);
NFrame = ceil(N/frameSize);
% zero-pad input to always have complete frame at end
if (mod(N,frameSize) > 0)
    pad = NFrame * frameSize - N; % amount of 0's we need to add
    in = [in; zeros(pad,1)];
end

% Total number of frames factoring in overlap
R = (NFrame-1)*overlap + 1;

strt = 1; % initial index
nend = frameSize;

out = zeros(length(in),1);

% Window function
w = hanningz(frameSize);

% Processing loop
% This loop has overlapping frames
for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    x1 = freqDomainUpsample(x,upFactor);
    
    % slot for distortion to which we'd like
    % to apply anti-aliasing
    
    y = freqDomainDownsample(x1,downFactor);
    
    out(strt:nend,1) = out(strt:nend,1) + y;
    
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

maxError = max(abs(out-in));
20*log10(maxError)
