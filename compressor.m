% compressor.m
% Dan Hirlinger
% 4/5/21

[in,Fs] = audioread('AcGtr.wav');

N = length(in);
out = zeros(N,1);
T = -20; % threshold
R = 4/1; % 3:1 ratio

attack = 0.1; % 100 ms
release = 0.5; % 500 ms
alphaA = exp(-log(9)/(Fs*attack));
alphaR = exp(-log(9)/(Fs*release));

% want to 

x_smooth = 0;
gr = zeros(N,1);
for n = 1:N
   
    x = in(n,1);
    
    x_abs = abs(x);
    
    x_dB = 20*log10(x_abs);
    if x_dB < -144
        x_dB = -144;
    end
    
    if x_dB < T
        % no compression
        x_sc = x_dB;
    else
        % compression
        x_sc = T + (x_dB - T) / R;
    end
    x_delta = x_sc - x_dB;
    
    % smoothing filter
    if (x_smooth > x_delta)
        % attack mode
        x_smooth = ((1-alphaA) * x_delta) + (alphaA * x_smooth);
    else
        % release mode
        x_smooth = ((1-alphaR) * x_delta) + (alphaR * x_smooth);
    end
    
    
    g_linear = 10^(x_smooth/20);
    
    gr(n,1) = g_linear;
    
    out(n,1) = g_linear * x;
end


plot(out); hold on;
plot(gr); hold off;
