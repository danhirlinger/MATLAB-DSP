% guitarConv.m

% Standard Convolution
clear;
[x,Fs] = audioread('Strat_JCM900.wav');
x = [1; zeros(43099,1)];
h = audioread('MarshallSM57onAxis0_5in.wav');
M = length(h);

buf = zeros(M,1);
x = [x ; zeros(M-1,1)];
N = length(x);
y = zeros(N,1);
for n = 1:N
    buf = [x(n,1);buf(1:end-1,1)];
    for m = 1:M
        y(n,1) = y(n,1) + buf(m,1) * h(m,1);
    end
end
plot(y)
sound(y,Fs);
y1 = y;
clear y;

%%%% Overlap Add
%clear;
%[x,Fs] = audioread('Strat_JCM900.wav');
x = [1; zeros(43099,1)];
h = audioread('MarshallSM57onAxis0_5in.wav');
% "h" is 2048 samples long

% Frame size for segmenting "x"
L = 2048;

% It is preferrable to FFTs with length 2^P
% Since there is a one sample overlap that 
% changes the size of N, zero-pad "h"
h = [h;0];
M = length(h); % 2049

% Length of frame after convolution (x * h)
N = L+M - 1; % N = 4096

h = [h ; zeros(N-M,1)]; 
H = fft(h); % length = 4096

buf = zeros(L,1);
yB = zeros(N,1);
for n = 1:length(x)
   buf = [buf(2:end,1) ; x(n,1)];
   
   % Cannot perform FFT until buffer is filled
   if (mod(n,L) == 0)
      xF = [buf ; zeros(N-L,1)];
      X = fft(xF);
      Y = X.*H;
      yF = real(ifft(Y));   
      yB = yB + yF;
   end
   y(n,1) = yB(1,1);
   yB = [yB(2:end,1) ; 0];
    
end
y = [y ; yB(1:end-1,1)];
plot(y1);hold on;
plot(y); hold off;
legend('Standard','OLA');

figure;% Null test
plot(y1 - y(L:end-1,1)); 
% This shows there is exactly L-1 samples of delay for frame of L
% Note: y is 1 sample longer because h was zero padded by 1 zero
% Extra 0 doesn't make any difference to output signal otherwise
