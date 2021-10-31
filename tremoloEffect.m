function [y] = tremoloEffect(x,Fs,depth,rate)
% x: input signal
% y: output signal

N = length(x);
Ts = 1/Fs;

% synthesize LFO
t = (0:N-1).' * Ts;
f = rate; % Hz [.1:10]

A = depth/200;
dc = 1-A;
lfo = A * sin(2*pi*f*t) + dc;

y = zeros(N,1);
for n = 1:N
    y(n,1) = x(n,1) * lfo(n,1);
end



