% guitarPartitioned.m
% Overlap-add method

clear; clc;
[x,Fs] = audioread('Strat_JCM900.wav');
%x = [1; zeros(127,1)];
h = audioread('MarshallSM57onAxis0_5in.wav');
M = length(h);

ref = conv(x,h);

% Partition
% Smallest FFT = 32 samples (2^5)
% Split in segments based on power of 2
h1 = h(1:31,1);      M1 = 2^5 - 1;
h2 = h(32:63,1);     M2 = 2^5;  % 32
h3 = h(64:127,1);    M3 = 2^6;  % 64
h4 = h(128:255,1);   M4 = 2^7;  % 128
h5 = h(256:511,1);   M5 = 2^8;  % 256
h6 = h(512:1023,1);  M6 = 2^9;  % 512
h7 = h(1024:2047,1); M7 = 2^10; % 1024
h8 = h(2048,1);   % Tack on extra sample at end 

% Pre-calculate FFTs of h segments
H2 = fft([h2;zeros(M2,1)]); % Total length 64
H3 = fft([h3;zeros(M3,1)]); % length 128
H4 = fft([h4;zeros(M4,1)]); % length 256
H5 = fft([h5;zeros(M5,1)]); % length 512
H6 = fft([h6;zeros(M6,1)]); % length 1024
H7 = fft([h7;zeros(M7,1)]); % length 2048

% Real-time buffers
buf1 = zeros(M1,1);
buf2 = zeros(M2,1);
buf3 = zeros(M3,1);
buf4 = zeros(M4,1);
buf5 = zeros(M5,1);
buf6 = zeros(M6,1);
buf7 = zeros(M7,1);

outBuf2 = zeros(2*M2,1);
outBuf3 = zeros(2*M3,1);
outBuf4 = zeros(2*M4,1);
outBuf5 = zeros(2*M5,1);
outBuf6 = zeros(2*M6,1);
outBuf7 = zeros(2*M7,1);
outBuf8 = zeros(M,1); % For the last sample of IR

x = [x ; zeros(M-1,1)];
N = length(x);
y = zeros(N,1);
for n = 1:N
    
    % Time-reverse buffer for 
    % standard convolution
    buf1 = [x(n,1) ; buf1(1:end-1,1)];
    
    % Buffers for FFT convolutions
    buf2 = [buf2(2:end,1) ; x(n,1) ];
    buf3 = [buf3(2:end,1) ; x(n,1) ];
    buf4 = [buf4(2:end,1) ; x(n,1) ];
    buf5 = [buf5(2:end,1) ; x(n,1) ];
    buf6 = [buf6(2:end,1) ; x(n,1) ];
    buf7 = [buf7(2:end,1) ; x(n,1) ];
    
    % Buffer for last sample of IR
    outBuf8 = [outBuf8(2:end,1) ; h8*x(n,1)];
    
    % Standard conv: one sample every loop
    y1 = 0; 
    for m = 1:M1
        y1 = y1 + buf1(m,1) * h1(m,1);
    end
    
    if (mod(n,M7) == 0)
        % n = 1024, 2048, etc.
        xF = [buf7 ; zeros(M7,1)];
        X = fft(xF);
        Y = X.*H7;
        yF = real(ifft(Y));   
        outBuf7 = outBuf7 + yF;
    end
    
    if (mod(n,M6) == 0)
        % n = 512, 1024, 2048, etc.
        xF = [buf6 ; zeros(M6,1)];
        X = fft(xF);
        Y = X.*H6;
        yF = real(ifft(Y));   
        outBuf6 = outBuf6 + yF;
    end
    
    if (mod(n,M5) == 0)
        % n = 256, 512, 1024, 2048, etc.
        xF = [buf5 ; zeros(M5,1)];
        X = fft(xF);
        Y = X.*H5;
        yF = real(ifft(Y));   
        outBuf5 = outBuf5 + yF;
    end    
       
    if (mod(n,M4) == 0)
        % n = 128, 256, 512, 1024, 2048, etc.
        xF = [buf4 ; zeros(M4,1)];
        X = fft(xF);
        Y = X.*H4;
        yF = real(ifft(Y));   
        outBuf4 = outBuf4 + yF;
    end   
      
    if (mod(n,M3) == 0)
        % n = 64, 128, 256, 512, 1024, 2048, etc.
        xF = [buf3 ; zeros(M3,1)];
        X = fft(xF);
        Y = X.*H3;
        yF = real(ifft(Y));   
        outBuf3 = outBuf3 + yF;
    end
    
    if (mod(n,M2) == 0)
        % n = 32, 64, 128, 256, 512, 1024, 2048, etc.
        xF = [buf2 ; zeros(M2,1)];
        X = fft(xF);
        Y = X.*H2;
        yF = real(ifft(Y));   
        outBuf2 = outBuf2 + yF;
    end
    
    y(n,1) = y1 +  outBuf2(1,1) + outBuf3(1,1) + ...
            outBuf4(1,1) + outBuf5(1,1) + outBuf6(1,1) + ...
            outBuf7(1,1) + outBuf8(1,1);
    outBuf2 = [outBuf2(2:end,1) ; 0];
    outBuf3 = [outBuf3(2:end,1) ; 0];
    outBuf4 = [outBuf4(2:end,1) ; 0];
    outBuf5 = [outBuf5(2:end,1) ; 0];
    outBuf6 = [outBuf6(2:end,1) ; 0];
    outBuf7 = [outBuf7(2:end,1) ; 0];
    
end


plot(ref); hold on;
plot(y); hold off;
max(ref-y) % null test = 0