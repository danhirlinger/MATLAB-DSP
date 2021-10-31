% distortionExamples.m
% Dan Hirlinger
% 1/20/21
clear; clc;

% Synthesize signal
Fs = 48000; Ts = 1/Fs;
f = 5;
t = [0:Ts:1]';
x = sin(2*pi*f*t);
N = length(x);
y = zeros(N,1);

% ========= Distortion effects ============

% Infinite clipping
% for n = 1:N
%    if x(n,1) > 0
%        y(n,1) = 1;
%    else
%        y(n,1) = -1;
%    end
% end


% Full-wave rectification

% for n = 1:N
%     y(n,1) = abs(x(n,1));
% end


% Half-wave rectification
% for n = 1:N
%    if x(n,1) > 0
%        y(n,1) = x(n,1);
%    else
%        y(n,1) = 0;
%    end
% end

% Hard clipping
% thresh = 0.7;
% drive = 2;
% x = drive*x;
% for n =  1:N
%     if x(n,1) > thresh
%         y(n,1) = thresh;
%     elseif x(n,1) < (-thresh) 
%         y(n,1) = -thresh;
%     else
%         y(n,1) = x(n,1);
%     end
% end

% Soft clipping: Cubic distortion
% thresh = 0.8;
% drive = 1;
% x = drive*x;
% for n = 1:N
%     y(n,1) = x(n,1) - (1/3)*(x(n,1)^3);
% end

% Soft clipping: Arctangent distortion
a = 5; %alpha, [1:10]
for n = 1:N
    y(n,1) = (2/pi) * atan(a*x(n,1));
end


% ==========================================

% Waveform
figure; plot(t,x,t,y);

% Characteristic curve
figure; plot(x,y);

% Visualize the harmonics / plot THD (total harmonic distortion)
% figure; thd(y,Fs);
