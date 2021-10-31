% irMeasurement.m
% Dan Hirlinger
% 2/8/21

% Measuring the impulse response of a delay effect

Fs = 48000;
% Input measurement signal
x = [1 ; zeros(Fs,1)];

% stem(x);

% Process impulse signal with arbitrary effect
d = 0.1*Fs;
N = length(x);
h = zeros(N,1); % IR
for n = 1:N
   
    if (n-d) < 1
        h(n,1) = x(n,1);
    else
        h(n,1) = x(n,1) + 0.5 * x(n-d,1); % feed forward
        % h(n,1) = x(n,1) + 0.5 * h(n-d,1); % feed back
    end
end

stem(h);

% Save IR for Pro Tools
% audiowrite('myImpulseResponse.wav',h,Fs);