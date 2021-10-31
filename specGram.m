% specGram.m
% Dan Hirlinger
% November 18, 2020
clear; clc;

% declare variables
[x,Fs] = audioread('testSignal.wav'); Ts = 1/Fs;
bufferSize = 512;
overlapPct = .5;
overlap = bufferSize * overlapPct;
N = length(x);
t = [0:N-1] * Ts;
plot(t,x); axis([0 t(end) -1 1]);
figure;

% Establish time array; times of the segment ends
T = (overlap:overlap:N-1) * Ts;
% Establish frequency array
F = (0:Fs/bufferSize:(Fs/2)).'; 

% establish S array for fft values
S = zeros(bufferSize,length(T));

% set up loop to attain fft values
for n = 1:length(T)
    segStart = ((n-1)*overlap)+1;
    segEnd = overlap*(n+1);
    if segEnd > N % if ending segment number DNE in the signal
        segment = x(segStart:end);
        window = hann(length(segment)); % window for length of the partial segment
        frame = window .* segment; % weight the fft
        S(1:length(segment),n) = fft(frame); % attain fft
    else % for when the segment is not partial
        segment = x(segStart:segEnd);
        window = hann(bufferSize); % window for length of bufferSize
        frame = window .* segment; % weight the fft
        S(:,n) = fft(frame); % attain fft
    end
end

% restructure S to fix dimensions
S = [S(1:overlap+1,:)];
% not sure if this is the best way to have this done. The initial S array
% contained bufferSize amount of rows. The plot requires half of that

%[S] = spectrogram(x,hann(bufferSize),overlap,bufferSize,Fs);

% 3-D plot
surf(T,F,20*log10(abs(S)),'EdgeColor','none');
axis xy; axis tight; view(0,90);
xlabel('Time (sec)'); ylabel('Freq (Hz)');