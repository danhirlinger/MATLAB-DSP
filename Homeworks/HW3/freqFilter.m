function [y] = freqFilter(b,a,x)

X = fft(x);
N = length(x);
A = length(a);
B = length(b);
HNum = zeros(N,1);
HDen = zeros(N,1);

% e ^ j*2*pi*k*z*(1/N)
% z = number of delay samples
% k = frequency bin

Hnum = 0;
Hden = 0;

for k = 0:N-1
    for m = 1:B % for FF coefficients
        if (k-m+2 > 0)
            Hnum = Hnum + (exp(-1i*2*pi*k*m*(1/N))) * b(1,m);
        end % sum up all parts of Hnum
    end
    for m = 1:A % for FB coefficients
        if (k-m+2 > 0)
            Hden = Hden + (exp(-1i*2*pi*k*m*(1/N))) * a(1,m);
        end % sum up all parts of Hden
    end
    HNum(k+1,1) = Hnum;
    HDen(k+1,1) = Hden;
    Hnum = 0; % reset Hnum, Hden values
    Hden = 0;   
end

H = HNum ./ HDen;

Y = X .* H;

y = real(ifft(Y));

