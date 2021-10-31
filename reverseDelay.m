% reverseDelay.m
% Dan Hirlinger
% 6/9/21
clear; clc;

[in,Fs] = audioread('AcGtr.wav');
N = length(in);
out = zeros(N,1);
rev = in(end:-1:1,1);

% sound(rev,Fs);

index = 1;
increment = 1;

M = Fs/2;
buffer = zeros(M,1);

for n = 1:N
    x = in(n,1);
    
    y = buffer(index,1); % read
%     y = buffer(index,1); % read, FF
%     buffer(index,1) = x; % write
    buffer(index,1) = x + y * 0.7; % write, FB
    
    index = index + increment;
    
    if (index == M)
        increment = -1;

    elseif (index == 1)
        increment = 1;
        
    end
%     out(n,1) = y;
    out(n,1) = y + x;
end

% sound(out,Fs);


