function [y] = hDelay(x,Fs,delayMS,bits,mix)
% hDelay.m 
% Dan Hirlinger
% 2/3/21

xEffect = x;
N = length(x);
% Bit crushing

% alter scale from [-1:1] to [0:1]
xEffect = (0.5*xEffect) + 0.5;

ampLevels = 2^bits;
% multiply by number of desired A levels
xEffect = xEffect*ampLevels;

% round off values
xEffect = round(xEffect);

% divide by number of A levels to return to range [0:1]
xEffect = xEffect * (1/ampLevels);

% return back to scale [-1:1]
xEffect = (xEffect * 2) - 1;

% Echo
delaySamples = (delayMS/1000) * Fs;
xEffectFinal = zeros(N,1);
for n = 1:N
    if (n-delaySamples < 1)
        xEffectFinal(n,1) = xEffect(n,1);
    else
        xEffectFinal(n,1) =  + xEffect(n-delaySamples,1);   
    end
end


% 0 = dry ; 1 = wet
g1 = (1-mix); % for signal without effects / dry
g2 = mix; % for signal with effects / wet

y = (g1 * x) + (g2 * xEffectFinal);
 
