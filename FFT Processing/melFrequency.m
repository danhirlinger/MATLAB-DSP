% melFrequency.m

clear;clc;
% Calculate MFCC's, based on Joshi and Ceeran (2014)

[in,Fs] = audioread('AcGtr.wav');

frameSize = 256;
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

% Frequency bin numbers
k = [0:frameSize-1].';
f = k*Fs/frameSize;

% Convert Hz > Mel
% melFreq = 2595*log10(1 + (f/700))
minF = 100;   minMel = 2595*log10(1 + (minF/700));
maxF = 4000;  maxMel = 2595*log10(1 + (maxF/700));

numFilters = 20;

% Linearly-spaced frequencies on Mel scale
melFreqs = linspace(minMel,maxMel,numFilters+2);
% Convert Mel > Hz
fHz = 700 * (10.^(melFreqs/2595) - 1); % array of frequency bins

% Window function
w = hann(frameSize);

for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    % analysis
    X = fft(x);
    Xamp = abs(X);
    Xpsd = (1/frameSize) * Xamp.^2; % Power Spectral Density
    
    for m = 2:numFilters + 1
        fm1 = fHz(m-1);
        f  =  fHz(m);
        fp1 = fHz(m+1);
        Hm = zeros(frameSize,1);
        for k = 1:frameSize
            freq = k*Fs/frameSize;
            if (freq >= fm1 && freq <= f)
                Hm(k,1) = (freq - fm1) / (f - fm1);
            elseif (freq > f && freq <= fp1)
                Hm(k,1) = (fp1-freq) / (fp1 - f);
            end
        end
        %plot(Hm);
        S(m,1) = log10(sum(Xpsd .* Hm));
    end
    CC(:,r) = abs(fft(S));
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

surf(CC,'EdgeColor','none');
axis xy; axis tight; view(0,90);