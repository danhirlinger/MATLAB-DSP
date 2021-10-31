% bitReduction.m
% Dan Hirlinger
% 1/27/21

% synthesize signal
Fs = 48000; Ts = 1/Fs;
f = 2500;
t = [0:Ts:1]';
x = sin(2*pi*f*t);
N = length(x);
y = zeros(N,1);

% make noise to be added to signal
% for dithering
% brings down all the harmonics in THD
dither = 0.001*randn(N,1);

x = x + dither;

% alter scale from [-1:1] to [0:1]
x1 = (0.5*x) + 0.5;

M = 6; % number of bits
ampLevels = 2^M;
% multiply by number of desired A levels
x2 = x1*ampLevels;

% round off values
x3 = round(x2);

% divide by number of A levels to return to range [0:1]
x4 = x3 * (1/ampLevels);

% return back to scale [-1:1]
out = (x4 * 2) - 1;

% waveform
% plot(out);
% 
% figure; % CC
% plot(x,out);
% 
% figure; % THD
thd(out,Fs);

