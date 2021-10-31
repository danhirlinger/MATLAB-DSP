% correlation.m
% Dan Hirlinger
% 10/28/2020

% correlation using zeros()
x = [0.5; -0.2; 0.4; 0.9; -0.1; 0.6];

N = length(x);

% Lag = -2
a = x;
b = [0;0;x(2,1)];
%r(1,1) = sum(a.*b);

% Lag = -1
a = x;
b = [0;x(1,1);x(2,1)];
%r(2,1) = sum(a*b);

% Lag = 0
a = x;
b = [x(1,1);x(2,1);x(3,1)];
%r(3,1) = sum(a*b);

% Lag = +1
a = x;
b = [x(2,1);x(3,1);0];
%r(4,1) = sum(a*b);

% Lag = +2
a = x;
b = [x(3,1);0;0];
%r(5,1) = sum(a*b);

% Loop
x = [-0.5; -0.2; 0.4; 0.9; -0.1; -0.6];
N = length(x);
M = 2*N - 1;
a = x;
lag = zeros(M,1);
for m = 1:M
   lag(m,1) = m - N;
   
   numZeros = abs(lag(m,1));
   
   if (lag(m,1) < 0)
       b = [zeros(numZeros,1); x(1:m,1)];
   elseif (lag(m,1) == 0)
       b = x;
   else % lag(m,1) > 0
       b = [ x(1 + lag(m,1) : end,1) ; zeros(numZeros,1)];
   end
   r(m,1) = sum(a.*b);
end
r, lag
[rx,lx] = xcorr(x,x)



