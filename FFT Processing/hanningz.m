function [w] = hanningz(N)
% This function calculates a modified hanning windowing function
% such that hanningz(N) = [k_0 = 0, k_1, k_2, ..., k_n-1 = k1]
% 
% The first sample must be zero, and must end with a non-zero value
% that matches the second sample.
%
% See Bernardini Paper: "Traditional Implementations of a phase-vocoder"

w = .5*(1 - cos(2*pi*(0:N-1)'/(N)));