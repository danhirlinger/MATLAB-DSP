% nonUniformPartitionedConv.m
clear;clc;
N = 31;
x = [1 ; zeros(N-1,1)];
h = [1:31].';
M = length(h);

test = conv(x,h);

h1 = h(1:7,1); M1 = length(h1); % TD
h2 = h(8:15,1); M2 = length(h2); % FFT
h3 = h(16:31,1); M3 = length(h3); % FFT

% Pre-calculate FFTs
H2 = fft([h2; zeros(M2,1)]); % size 16 FFT
H3 = fft([h3; zeros(M3,1)]); % size 32 FFT

% Buffer for real-time processing
buf1 = zeros(M1,1);
buf2 = zeros(M2,1);
buf3 = zeros(M3,1);

x = [x ; zeros(M-1,1)];
N = length(x);

outBuf2 = zeros(2*M2,1); % double size to match FFT length
outBuf3 = zeros(2*M3,1);

y = zeros(N,1);

for n = 1:N
    % Time-reverse for time-domain
    buf1 = [x(n,1) ; buf1(1:end-1,1)];
    
    % Preserve time order for FFTs
    buf2 = [buf2(2:end,1) ; x(n,1)];
    buf3 = [buf3(2:end,1) ; x(n,1)];
    
    % standard conv
    y1 = 0;
    for m1 = 1:M1
        y1 = y1 + buf1(m1,1)*h1(m1,1);
    end
    
    if (mod(n,M3) == 0) % n = 16,32,...
        xF = [buf3  ; zeros(M3,1)];
        X = fft(xF);
        Y = X.*H3;
        yF = real(ifft(Y));
        outBuf3 = outBuf3 + yF;
    end
    
    if (mod(n,M2) == 0) % n = 8,16,24,32,...
        xF = [buf2  ; zeros(M2,1)];
        X = fft(xF);
        Y = X.*H2;
        yF = real(ifft(Y));
        outBuf2 = outBuf2 + yF;
    end
    
    y2 = outBuf2(1,1);
    y3 = outBuf3(1,1);
    
    y(n,1) = y1+y2+y3;
    
    outBuf2 = [outBuf2(2:end,1) ; 0];
    outBuf3 = [outBuf3(2:end,1) ; 0];
    
end

[test y]