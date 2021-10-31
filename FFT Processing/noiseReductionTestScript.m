% noiseReductionTestScript.m

[in,Fs] = audioread('soundFile1.wav');
plot(in);

% White noise
% n = 0.2*randn(length(in),1);

% Pink noise
n = audioread('pinkNoise.wav');

% Scale amp of noise to test SNR
n = 0.1 * n;

frameSize = 2048;
overlap = 2;
bias = 1; % standard devs above/below the average [-2:2]

% Average amp per frequency
[avgApF,sDApF] = spectralAnalysis(n,frameSize,overlap);

% Blend signal and noise
sigNoise = in + n(1:length(in),1);
plot(sigNoise);
[out] = spectralSubtraction(sigNoise,frameSize,overlap,avgApF,sDApF,bias);
figure; plot(out);
