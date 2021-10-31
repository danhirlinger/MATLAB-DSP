% delayBuffer.m
% Dan Hirlinger
% 2/10/21

% Input
x = [1; zeros(9,1)];

h = zeros(3,1);

N = length(x);

h = zeros(4,1);
g = 0.5;
for n = 1:N
    
%    % Series delay
%    y(n,1) = h(end,1);
%    
%    h = [x(n,1) ; h(1:end-1,1)];
%    
%    % Feed-forward delay
%    y(n,1) = x(n,1) + (g * h(end,1));
%    
%    h = [x(n,1) ; h(1:end-1,1)];
   
   % Feed-back delay
   y(n,1) = x(n,1) + (g * h(end,1));
   
   h = [y(n,1) ; h(1:end-1,1)];
    
end

y