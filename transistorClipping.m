function [out] = transistorClipping(in,thresh)
% transistorClipping.m
% Dan Hirlinger
% 2/1/21
% Emulates analog clipping


% in = input signal
% thresh = clipping amplitude
% out = processed signal
N = length(in);

% create variable to control the slope of the threshold
slope = .000075;

out = zeros(N,1);
drive = 1;
in = drive*in;
funcThresh = thresh;
for n =  1:N
    if in(n,1) > thresh
        out(n,1) = funcThresh;
        funcThresh = funcThresh - slope;    
    elseif in(n,1) < (-thresh) 
        out(n,1) = -funcThresh;
        funcThresh = funcThresh - slope;
    else
        out(n,1) = in(n,1);
        funcThresh = thresh;
    end
end