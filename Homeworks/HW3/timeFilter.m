function [y] = timeFilter(b,a,x)
% Dan Hirlinger
% 3/18/21

% b = array of FF coefficients
% a = array of FB coefficients
% x = input signal
% y = output signal

N = length(x);
A = length(a);
B = length(b);

% create arrays of zeros for length of b,a
% this accounts for the # of FF/FB delay samplesa 
bZ = zeros(B,1);
aZ = zeros(A,1);
ffSum = 0;
fbSum = 0;
y = zeros(N,1);

% n = input signal counter
% m = FF/FB array counter
for n = 1:N
    for m = 1:B % for each FF coefficient
        if (n-m+1) > 0
            ffSum = ffSum + x(n-m+1,1) * b(1,m); 
        end
    end
    for m = 2:A % for each FB coefficient
        % ignore first coefficient of a 
        if (n-m+1 > 0)
            fbSum = fbSum + y(n-m+1,1) * (-1*(a(1,m)));
        end
    end
    y(n,1) = ffSum + fbSum;
    ffSum = 0;
    fbSum = 0;
end
