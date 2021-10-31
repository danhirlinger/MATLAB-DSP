function [out] = oscillator(freq,Fs,lenSec)
% Dan Hirlinger

Nyq = Fs/2;
radius = 1;

% convert frequency to an angle relative to Nyquist = pi
angle = (freq/Nyq) * pi;

% convert radius and angle from polar > cartesian
% getting (x,y) from (radius, angle)
% need (x,y) / (adjacent, opposite)
x = radius * cos(angle);
y = radius * sin(angle);

% found the roots because adjacent is the real part,
% opposite is the imaginary
% need two points that reflect across x axis
roots = [x + y*1j, x - y*1j];

% expand roots to a polynomial
a = poly(roots);
b = [1];
% fvtool(b,a);

% take IR of system for the input length of time
out = [1;zeros(lenSec*Fs,1) - 1];
N = length(out);
y2 = 0;
y1 = 0;
for n = 1:N
    out(n,1) = (b/a(1,1))*out(n,1) + (-a(1,2)/a(1,1))*y1 + (-a(1,3)/a(1,1))*y2;
    y2 = y1;
    y1 = out(n,1);
end


% normalize the amplitude
m = min(out);
M = max(out);
for n = 1:N
    out(n,1) = 2*((out(n,1)-m)/(M-m)) - 1;
end
