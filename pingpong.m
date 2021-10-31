function [out] = pingpong(x,Fs,BPM,note,feedback,wet)

% Convert BPM to samps/sec
BPS = BPM/60; % Beats per second
SecPB = 1/BPS; % Seconds per beat
delaySec = note * SecPB; % delay time in seconds
delaySamps = fix(delaySec * Fs); % # of samples in the delay


d1 = delaySamps; % delay for L
d2 = d1; % delay for C
d3 = d1; % delay for R

% Convert feedback pct to a feedback gain amt
fGain = feedback / 100;

% Create output signal based on audio effect

N = length(x); % Length of original signal
y = zeros(N*2,2);

% Add "tail" to the audio array
x = [x ; zeros(N,1)];
    
% Delay buffers
buffer1 = zeros(d1,1); % memory buffer for L
buffer2 = zeros(d2,1); %  "" "" for C
buffer3 = zeros(d3,1); %  "" "" for R


for n = 1:N*2
    L = 0.707 * x(n,1) + buffer1(end,1);
    C = x(n,1) + buffer2(end,1);
    R = 0.707 * x(n,1) + buffer3(end,1);
    
    buffer1 = [x(n,1) + fGain*buffer3(end,1); buffer1(1:end-1,1)];
    buffer2 = [buffer1(end,1); buffer2(1:end-1,1)];
    buffer3 = [buffer2(end,1); buffer3(1:end-1,1)];
    
    y(n,:) = [L,R] + C;
end


dry = 100-wet;
out = ((dry/100) * x) + ((wet/100) * y);