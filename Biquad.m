classdef Biquad < handle
   
    properties
        
        x1 = 0; x2 = 0;
        
        y1 = 0; y2 = 0;
        
        b0 = 0; b1 = 0; b2 = 0;
        
        a0 = 1; a1 = 0; a2 = 0;
        
        Fs = 48000;
        f = 1000;
        Q = 1;
        dBGain = 0;
        
        w0 = 0;
        alpha = 0;
        A = 0;
        
    end
    
    methods
        function o = Biquad(Fs,f,Q,dBGain)
            o.Fs = Fs;
            o.w0 = 2*pi*f/Fs;            % Angular Freq. (Radians/sample) 
            o.alpha = sin(o.w0)/(2*Q);      % Filter Width
            o.A  = sqrt(10^(dBGain/20));  % Amplitude
        end

        function out = processSignal(o,in,type)
            N = length(in);
            out = zeros(N,1);
            if strcmp(type,'lpf')
                setLPF(o);
            elseif strcmp(type,'hpf')
                setHPF(o);
            elseif strcmp(type,'apf')
                setAPF(o);
            end
            for n = 1:N
                out(n,1) = processSample(o,in(n,1));
            end            
        end
        function setLPF(o)
            o.b0 =  (1 - cos(o.w0))/2;
            o.b1 =   1 - cos(o.w0);
            o.b2 =  (1 - cos(o.w0))/2;
            o.a0 =   1 + o.alpha;
            o.a1 =  -2*cos(o.w0);
            o.a2 =   1 - o.alpha;
                
        end
        function setHPF(o)
            o.b0 =  (1 + cos(o.w0))/2;
            o.b1 = -(1 + cos(o.w0));
            o.b2 =  (1 + cos(o.w0))/2;
            o.a0 =   1 + o.alpha;
            o.a1 =  -2*cos(o.w0);
            o.a2 =   1 - o.alpha;
        end
        function setAPF(o)
            o.b0 =   1 - o.alpha;
            o.b1 =  -2*cos(o.w0);
            o.b2 =   1 + o.alpha;
            o.a0 =   1 + o.alpha;
            o.a1 =  -2*cos(o.w0);
            o.a2 =   1 - o.alpha;
        end
        function [y] = processSample(o,x)
            y = (o.b0/o.a0)*x + (o.b1/o.a0)*o.x1 + (o.b2/o.a0)*o.x2 ...
            + (-o.a1/o.a0)*o.y1 + (-o.a2/o.a0)*o.y2;
            o.x2 = o.x1;
            o.x1 = x;
            o.y2 = o.y1;
            o.y1 = y;
        end
        function setAlpha(o,alpha)
            o.alpha = alpha;
        end
        
    end
    
end