% basicDelay.m
% Dan Hirlinger
% 6/7/21
clear;clc;

% Review of delay

[in,Fs] = audioread('AcGtr.wav');

N = length(in);

out = zeros(N,1);

% % Indexing like diff eq
% d = 1000; % samples of delay
% for n = 1:N
%     % series delay
%     if n-d > 0
%         out(n,1) = in(n-d,1);
%     end
%     % parallel delay
%     if n-d > 0
%         out(n,1) = in(n,1) + in(n-d,1);
%     else
%         out(n,1) = in(n,1);
%     end
% end


% Linear buffer (array to "save/delay" samples)

% b = 3; % length of buffer
% % length of buffer determines length of delay
% buffer = zeros(b,1);
% 
% for n = 1:N
%     x = in(n,1);
%     
%     % series delay
% %     y = buffer(end,1);
% %     buffer = [x ; buffer(1:end-1,1)];
%     % buffer(2,1) = buffer(1,1);
%     % buffer(1,1) = x;    
%     
%     % parallel delay (feed forward)
% %     y = x + buffer(end,1);
% %     buffer = [x ; buffer(1:end-1,1)];
%     
%     % parallel delay (feed back)
% %     y = x + buffer(end,1);
% %     buffer = [y ; buffer(1:end-1,1)];
% 
%     out(n,1) = y;
% end

% Circular buffer
in = [1:20]';
N = length(in);
out = zeros(N,1);
M = 6;
buffer = zeros(M,1);
i = 1; % index

for n = 1:N
    x = in(n,1);
    
    y = buffer(i,1);
    buffer(i,1) = x;
    i = i + 1;
    if (i > M)
        i = 1;
    end
    
    out(n,1) = y; 
end


% Read, write index
in = [1:20]';
N = length(in);
out = zeros(N,1);
M = 6;
buffer = zeros(M,1);

delay = 5;
wI = M; % start wI at last element to avoid rI > wI
rI = wI - delay;

for n = 1:N
    x = in(n,1);
    
    buffer(wI,1) = x;
    
    y = buffer(rI,1);
%     y = buffer(wI-delay,1);
        
    wI = wI + 1;
    if (wI > M)
        wI = 1;
    end
    rI = rI + 1;
    if (rI > M)
        rI = 1;
    end
    
    out(n,1) = y;
end



% Read relative to write index
in = [1:20]';
N = length(in);
out = zeros(N,1);
M = 6;
buffer = zeros(M,1);

delay = 5;
wI = M; % start wI at last element to avoid rI > wI
rI = wI - delay;

for n = 1:N
    x = in(n,1);
    
    buffer(wI,1) = x;
    
    rI = wI - delay;
    if (rI < 1)
        rI = rI + M;
    end
    
    y = buffer(rI,1);
        
    wI = wI + 1;
    if (wI > M)
        wI = 1;
    end

    
    out(n,1) = y;
end





