function [y] = sbc(x,Fs,bQ,freq,T,R,attack,release,wet)
% single-band compressor
% Dan Hirlinger
% compress low/mid/hi depending on user input
% y = output signal
% x = input signal
% bQ = type of filtering
%     1 = LPF
%     2 = BPF
%     3 = HPF
%     4 = APF
% T = threshold in dB  -60:0 dB
% R = ratio  1 - 100
% attack = attack time in seconds
% release = release time in seconds
% wet = ratio of processed to unprocessed signal (wet = 1 > all processed)

if bQ == 1
    xProcess = biquadFilter(x,Fs,freq,1,3,'lpf',1);
elseif bQ == 2
    xProcess = biquadFilter(x,Fs,freq,1,3,'bp1',1);
elseif bQ == 3
    xProcess = biquadFilter(x,Fs,freq,1,3,'hpf',1);
elseif bQ == 4
    xProcess = biquadFilter(x,Fs,freq,1,3,'apf',1);
else
    msg = "Error occurred. Invalid input argument.";
    error(msg)
end

N = length(xProcess);
x_final = zeros(N,1);
x_smooth = 0;
alphaA = exp(-log(9)/(Fs*attack));
alphaR = exp(-log(9)/(Fs*release));

for n = 1:N
    x_abs = abs(xProcess(n,1));
    
    x_dB = 20*log10(x_abs);
    if x_dB < -144
        x_dB = -144;
    end
    if x_dB < T
        x_sc = x_dB; % no compression
    else
        x_sc = T + (x_dB - T) / R; % compression
    end
    x_delta = x_sc - x_dB;
    
    % smoothing filter
    if (x_smooth > x_delta)
        % attack mode!
        x_smooth = ((1-alphaA) * x_delta) + (alphaA * x_smooth);
    else
        % release mode
        x_smooth = ((1-alphaR) * x_delta) + (alphaR * x_smooth);
    end    
    
    g_linear = 10^(x_smooth/20);
    
    x_final(n,1) = g_linear * xProcess(n,1);
end

y = (xProcess*wet) + (x*(1-wet));