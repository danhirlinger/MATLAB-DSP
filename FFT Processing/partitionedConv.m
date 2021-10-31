% partitionedConv.m
clear;clc;
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1, -2].';
test = conv(x,h);

% Uniform partitions
% Split up into 2 partitions of 2

h1 = h(1:2,1); % [1, -1]
h2 = h(3:4,1); % [1, -2]

y1 = conv(x,h1);
y2 = conv(x,h2);

y2 = [zeros(2,1) ; y2]; % delay by 2 samples
y1 = [y1 ; zeros(2,1)];

y = y1 + y2;

[test,y];

% Non-uniform partitions (different sizes)

h = [1, -1, 1, -2, -1, 1].';
test =  conv(x,h);

h1 = h(1:2,1);
d = length(h1); % delay length
h2 = h(3:6,1);

y1 = conv(x,h1);
y2 = conv(x,h2);

y2 = [zeros(d,1) ; y2];
y1 = [y1 ; zeros(length(h2),1)];

y = y1 + y2;

[test,y];

% Real-time partitions
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1, -2, -1, 1].';
test = conv(x,h);

h1 = h(1:2,1); M1 = length(h1);
h2 = h(3:6,1); M2 = length(h2);

x = [x ; zeros(length(h)-1,1)];
N = length(x);

buf1 = zeros(M1,1);
buf2 = zeros(M2,1);
outBuf = zeros(M1,1);
for n = 1:N
    
    buf1 = [x(n,1) ; buf1(1:end-1,1)];
    buf2 = [x(n,1) ; buf2(1:end-1,1)];
    y1 = 0;
    for m = 1:M1
        y1 = y1 + buf1(m,1)*h1(m,1);
    end
    y2 = 0;
    for m = 1:M2
        y2 = y2 + buf2(m,1)*h2(m,1);
    end
    
    % Need to delay y2 by M1 samples
    y = y1 + outBuf(end,1);
    outBuf = [y2 ; outBuf(1:end-1,1)];    
    
    out(n,1) = y;
end

[test out];

% Move the delay block up front (see block diagram)
buf1 = zeros(M1,1);
buf2 = zeros(M2,1);
for n = 1:N
    %
    buf2 = [buf1(end,1); buf2(1:end-1,1)];
    buf1 = [x(n,1) ; buf1(1:end-1,1)];

    y1 = 0;
    for m = 1:M1
        y1 = y1 + buf1(m,1)*h1(m,1);
    end
    y2 = 0;
    for m = 1:M2
        y2 = y2 + buf2(m,1)*h2(m,1);
    end
    
    % Need to delay y2 by M1 samples
    y = y1 + y2;
    
    out(n,1) = y;
end

[test out];

%% Uniform partitioned FFT convolution
% Latency = N - 1
clear; clc;
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1, -2].';
test = conv(x,h);

M = length(h);
h1 = h(1:2,1);
h2 = h(3:4,1);
M1 = length(h1); % length of partition

H1 = fft([h1 ; zeros(M1,1)]);
H2 = fft([h2 ; zeros(M1,1)]);

buf1 = zeros(M1,1);
buf2 = zeros(M1,1);

x = [x; zeros(M,1)];
N = length(x);
outBuf = zeros(2*M1,1);
y = zeros(N,1);
for n = 1:N
    
    buf2 = [buf2(2:end,1) ; buf1(1,1)];
    buf1 = [buf1(2:end,1) ; x(n,1)];
    
    if (mod(n,M1) == 0)
        x1F = [buf1 ; zeros(M1,1)];
        X1 = fft(x1F);
        Y1 = X1.*H1;
        x2F = [buf2 ; zeros(M1,1)];
        X2 = fft(x2F);
        Y2 = X2.*H2;
        
        yF = real(ifft(Y1)) + real(ifft(Y2));
        outBuf = outBuf + yF;
    end
    y(n,1) = outBuf(1,1);
    outBuf = [outBuf(2:end,1) ; 0];
end

test
y

%% Hybrid Time+Freq Domain Partitioned Convolution
clear; clc;
x = [3, -1, 0, 3, 2, 0, 1, 2, 1].';
h = [1, -1, 1, -2, -1].';
test = conv(x,h);
M = length(h);

% Time-domain section of IR
h1 = h(1:2,1);
M1 = length(h1); % Length of time-domain IR
h2 = h(3:5,1);
M2 = length(h2); % Length of freq-domain IR
H2 = fft([h2; zeros(M2-1,1)]);

x = [x ; zeros(M-1,1)];
N = length(x);

buf1 = zeros(M1,1);
buf2 = zeros(M2,1);
outBuf = zeros(M1+M2,1);
y = zeros(N,1);

for n = 1:N
    
    buf1 = [x(n,1) ; buf1(1:end-1,1)];
    buf2 = [buf2(2:end,1) ; x(n,1)];
    y1 = 0;
    for m1 = 1:M1
       y1 = y1 + buf1(m1,1) * h1(m1,1);
    end
    
    if (mod(n,M2) == 0)
        xF = [buf2  ; zeros(M2-1,1)];
        X = fft(xF);
        Y = X.*H2;
        yF = real(ifft(Y));
        outBuf = outBuf + yF;
    end
    y2 = outBuf(1,1);
    y(n,1) = y1 + y2;
    outBuf = [outBuf(2:end,1);0];
end

[test, y]




