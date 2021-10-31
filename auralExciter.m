function [out] = auralExciter(in,Fs,gain);
% Dan Hirlinger
% 3/10/21

% Create HPF
Nyq = Fs/2;
fHz = 1000;
Wn = fHz/Nyq;
m = 1;

b = fir1(m,Wn,'high');

% Process signal through HPF
x = conv(in,b);


% Soft clipping: Arctangent distortion
a = 5; %alpha, [1:10]
for n = 1:N
    out(n,1) = (2/pi) * atan(a*x(n,1));
end

gainWet = gain;
gainDry = gain - 1;

out = out * gainWet + in * gainDry;