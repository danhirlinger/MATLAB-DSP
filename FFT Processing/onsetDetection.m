% onsetDetection.m
clear;clc;

%[in,Fs] = audioread('AcGtr.wav');
[in,Fs] = audioread('monoDrums.wav');

frameSize = 1024;
% Overlap, hop for analysis
overlap = 4; % [2:4]
hop = frameSize/overlap;

N = length(in);
NFrame = ceil(N/frameSize);
% zero-pad input to always have complete frame at end
if (mod(N,frameSize) > 0)
    pad = NFrame * frameSize - N; % amount of 0's we need to add
    in = [in; zeros(pad,1)];
end
N = length(in);

% Total number of frames factoring in overlap
R = (NFrame-1)*overlap + 1;

strt = 1; % initial index
nend = frameSize;

w = hanningz(frameSize);

X = zeros(frameSize,R);
Xamp = zeros(frameSize,R);
Xphase = zeros(frameSize,R);
% Analysis section to determine how phase angle
% changes from one frame to the next
for r = 1:R
    seg = in(strt:nend,1);
    
    x = seg .* w;
    
    X(:,r) = fft(x);
    Xamp(:,r) = abs(X(:,r));
    Xphase(:,r) = angle(X(:,r));
    
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

% --Spectral flux--
SF = zeros(1,R-1);

% --Phase deviation--
firstDif = zeros(frameSize,R-1);
secondDif = zeros(frameSize,R-1);
phaseDif = zeros(1,R-1);

% --Complex domain--
CD = zeros(1,R-1);

for r = 2:R
    
    % --Spectral flux--
    Xdif = Xamp(:,r) - Xamp(:,r-1);
    XH = (Xdif + abs(Xdif)) / 2;
    SF(1,r) = sum(XH);
    
    
    % --Phase deviation--
    % Instantaneous freq given by the firstDif
    firstDif(:,r) = Xphase(:,r) - Xphase(:,r-1);
     % Principle argument wrap to [-pi,pi)
    firstDif(:,r) = firstDif(:,r) - (2*pi*round(firstDif(:,r)/2*pi));
    % Change in instantaneous freq given by secondDif
    secondDif(:,r) = firstDif(:,r) - firstDif(:,r-1);
    secondDif(:,r) = secondDif(:,r) - (2*pi*round(secondDif(:,r)/2*pi));
    
    phaseDif(1,r) = (1/frameSize) * sum(abs(secondDif(:,r)));
    
    
    % --Complex domain--
    XT = Xamp(:,r-1) .* exp(Xphase(:,r-1) + firstDif(:,r-1));
    CD(1,r) = sum(abs(X(:,r) - XT));
    
end

SFnorm = SF/max(abs(SF));
% plot for comparison
t = [0:N-1].' * (1/Fs);
plot(t,in); hold on;

tSF = ([0:length(SF)-1].' * hop) * (1/Fs);
plot(tSF,SFnorm); hold off;



