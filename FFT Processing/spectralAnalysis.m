function [avgAmpPerFreq,stdDevAmpPerFreq] = spectralAnalysis(in,frameSize,overlap)

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

% Window function
w = hann(frameSize);

AmpMatrix = zeros(frameSize,R);

% Create a "spectrogram" of the input signal
for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    % analysis
    X = fft(x);
    Xamp = abs(X);
    
    AmpMatrix(:,r) = Xamp;
    
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

avgAmpPerFreq = zeros(frameSize,1);
for k = 1:frameSize
    avgAmpPerFreq(k,1) = mean(AmpMatrix(k,:));
    stdDevAmpPerFreq(k,1) = std(AmpMatrix(k,:));
end
end