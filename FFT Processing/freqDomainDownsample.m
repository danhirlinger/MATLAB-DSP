function [out] = freqDomainDownsample(in,factor)
% Perform decimation/downsampling by removing
% bins in the frequency domain

N = length(in);
X = fft(in);

newN = floor(N*factor);
removalNum = N - newN;

% Index for half of spectrum
halfSpec = floor(N/2) + 1;

Y = [X(1:halfSpec - ceil(removalNum/2),1) ;
    X(halfSpec+1 + floor(removalNum/2):end,1)];

out = real(ifft(Y)) * factor;

end