function [y] = convFreq(x,h)
% convFreq.m

% Loops to go through signal

% Add zeros to input so length = N+M-1 / length of output

% signal should have same length (N+M-1) in frequency domain

% Element-wise multiplication  >   X[k] .* H[k]
% Result should give output spectrum, Y[k]
% SO: all arrays have to be the same size.....
% Y, H, and X should all have length = N+M-1
% X has length N >> zero-pad it to get length(N+M-1)
% H also should be zero-padded\

N = length(x);
M = length(h);
y = zeros(N+M-1,1);

% zero-pad x and h arrays
x = [x;zeros(M-1,1)];
h = [h;zeros(N-1,1)];

% Perform FFT of input signal, IR
X = fft(x);
H = fft(h);

Y = X .* H;

y = ifft(Y);

% for k = 1:N+M-1
%     Y(k,1) = X(k,1) .* H(k,1);
% end

% for n = 1:N+M-1 % for the length of the output, y
%     for m = 1:M
%         if (n > N) && (N-m+1 > 0)
%             % if n position is past its length, N
%             % and index for x > 0
%             y(n,1) = y(n,1) + (x(N-m+1,1) * h(m+n-N,1));
%         elseif (n <= N) && (n-m+1 > 0)
%             % when n position is 1 - N
%             y(n,1) = y(n,1) + (x(n-m+1,1) * h(m,1));
%         end
%     end
% end