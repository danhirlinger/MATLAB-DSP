function [out] = auralExciter(in,Fs,gain);
% Dan Hirlinger
% 3/10/21

% Create HPF
Nyq = Fs/2;
fHz = 1000;
Wn = fHz/Nyq;
m = 5;

b = fir1(m,Wn,'high');
% freqz(b);

% Process signal through HPF
x = conv(in,b);


% Soft clipping: Arctangent distortion
a = 5; % alpha, [1:10]
N = length(x);
for n = 1:N
    out(n,1) = (2/pi) * atan(a*x(n,1));
end
in = [in ; zeros(length(out)-length(in),1)];
gainWet = gain;
gainDry = 1 - gain;

out = out * gainWet + in * gainDry;