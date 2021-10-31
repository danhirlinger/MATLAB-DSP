function [out] = freqDomainUpsample(in,factor)
% Perform interpolation/upsampling by adding
% 0's in the frequency domain

N = length(in);
X = fft(in);

% Determine number of 0's to add
numZeros = ceil(N * (factor-1));

% Index for half of spectrum
halfSpec = N/2 + 1;

Y = [X(1:halfSpec,1) ; zeros(numZeros,1) ; X(halfSpec+1:end,1)];

out = real(ifft(Y)) * factor;

end