% pvPitch.m
clear;clc;
% Perform pitch-shifting using a phase vocoder

[in,Fs] = audioread('AcGtr.wav');
%[in,Fs] = audioread('monoDrums.wav');

frameSize = 1024;
% Overlap, hop for analysis
overlapA = 4; % [2:4]
hopA = frameSize/overlapA;

% Speed ratio between in, out signals [0.75,3]
semitones = 3;
tr = 2^(semitones/12); % momentary transposition
ratio = 1/tr;
% Overlap, hop for synthesis
overlapS = overlapA * ratio;
hopS = round(frameSize/overlapS);

N = length(in);
NFrame = ceil(N/frameSize);
% zero-pad inputs to always have complete frame at end
if (mod(N,frameSize) > 0)
    pad = NFrame * frameSize - N; % amount of 0's we need to add
    in = [in; zeros(pad,1)];
end

% Total number of frames factoring in overlap
R = (NFrame-1)*overlapA + 1;

strt = 1; % initial index
nend = frameSize;

w = hanningz(frameSize);

Xamp = zeros(frameSize,R);
Xphase = zeros(frameSize,R);
% Analysis section to determine how phase angle
% changes from one frame to the next
for r = 1:R
    seg = in(strt:nend,1);
    
    x = seg .* w;
    
    X = fft(x);
    Xamp(:,r) = abs(X);
    Xphase(:,r) = angle(X);
    
    strt = strt + hopA;
    nend = strt + frameSize - 1;
end

% Synthesis prep
k = [0:frameSize-1].';
wk = k*Fs/frameSize; % center freq in Hz
pk = wk*2*pi / Fs; % radians/sample for each freq bin

Y = zeros(frameSize,R);
y = zeros((R*hopS) + frameSize,1);

Yamp = Xamp; % not changing amp
Yphase = Xphase(:,1); % start with output phase = input phase

% First spectrum of Y
Y(:,1) = Yamp(:,1) .* exp(1j * Yphase);

strt = 1;
nend = frameSize;

y(strt:nend) = real(ifft(Y(:,1)));

strt = strt + hopS;
nend = strt + frameSize - 1;

% Synthesis loop for remaining frames
for r = 2:R
    % Target phase for center frequency
    % (Expected phase change)
    Pt = Xphase(:,r-1) + hopA * pk;
    
    % Phase deviation from target
    Pd = Xphase(:,r) - Pt;
    
    % Principle Argument (wrap into range of (-pi, pi) )
    % Looking at how far into a cycle the Pd is
    prinArg = Pd - 2*pi*round(Pd/(2*pi));
    
    % Phase increment per sample
    phaseIncr = pk + prinArg/hopA;
    
    % Phase for output signal
    Yphase = Yphase + hopS * phaseIncr;
    
    Y = Yamp(:,r) .* exp(1j * Yphase);
    
    seg = real(ifft(Y));
    
    y(strt:nend) = y(strt:nend) + seg .*w;
    
    strt = strt + hopS;
    nend = strt + frameSize - 1;
end

y = y/max(abs(y));

% Interpolate/decimate samples of y
% y = resample(y,round(frameSize*ratio),frameSize);
y = resample(y,frameSize,round(frameSize/ratio));
sound(y,Fs);
plot(y);

