% specCentroid.m
clear;clc;

% [in,Fs] = audioread('AcGtr.wav');
% [in,Fs] = audioread('soundFile1.wav');
% [in,Fs] = audioread('woman.m4a');
% [in,Fs] = audioread('the_nights.m4a');
% [in,Fs] = audioread('walking_on_a_dream.m4a');

% Below analysis is for mono, so convert any stereo > mono
% [m,n] = size(in);
% if n == 2
%     y = in(:,1) + in(:,2);
%     peakA = max(abs(y));
%     y = y/peakA;
%     
%     peakL = max(abs(in(:,1)));
%     peakR = max(abs(in(:,2)));
%     maxPeak = max([peakL peakR]);
%     
%     y = y*maxPeak;
%     in = y;
% end

Fs = 48000; Ts = 1/Fs;
lenSec = 5;
f1 = 1000;
f2 = 3000;
t = [0:Ts:lenSec].';
in = sin(2*pi*f1*t);
% in = (sin(2*pi*f1*t) + sin(2*pi*f2*t))/2;

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

% Frequency bin numbers
k = [0:frameSize-1].';
% Need freq (Hz) corresponding to bins
kP = k(1:(frameSize/2)+1,1).*(Fs/frameSize);

% Window function
w = hann(frameSize);

SC = zeros(R,1);
testSC = zeros(R,1);
% Processing loop
% This loop has overlapping frames
for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    % analysis
    X = fft(x);
    % Magnitude spectrum
    Xamp = abs(X);
    Xamp = Xamp(1:(frameSize/2)+1,1);
    
    % Direct method
    testSC(r,1) = sum(kP.*Xamp)/sum(Xamp);
    
    % Proposed method
    % Find FT coefficients above STH
    MAX = max(Xamp);
    % Spectral threshold (STH)
    STH = MAX*.02;
    for k = 1:length(Xamp)
        if (Xamp(k,1) < STH)
            % If below STH, coef = 0
            Xamp(k,1) = 0;
        end
    end
    SC(r,1) = sum(kP.*Xamp)/sum(Xamp);
    strt = strt + hop;
    nend = strt + frameSize - 1;
end
% plot(SC);
% testSC = spectralCentroid(in,Fs);
error = SC - testSC;
plot(error); figure;
plot(SC);
hold on;
plot(testSC);
hold off;

mean(SC)

% Using a sine wave of one frequency, it's noticed that 
% the proposed method gives a more consistent SC value over time
% Although original method proves to be more accurate at
% higher frequencies

% Adding two sine waves together, the proposed method reports a value
% closer and more accurate to the expected SC, compared to the direct
% method

% When calculating the SC for an aperiodic signal (i.e. not a simple sine
% wave), the direct method reports generally higher values of SC, as frequency bins 
% with small amounts of information (i.e. below the STH), which could be classified
% as noise are included in the calculation. It could be assumed that these values
% are more inaccurate than the SC values obtained from the proposed method, as the
% insignificant amplitude values are likely noise. Conversely, it could be theorized that 
% the proposed method delivers more accurate SC values, as it focuses on
% the larger magnitudes and ignores small magnitudes that are likely
% insignificant






