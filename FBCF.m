classdef FBCF < handle
    
    properties
        delay;
        g = 0.5;
        d = 0;
    end
    
    methods
        function o = FBCF(modRate,delaySamples,Fs)
            o.delay = ModDelay;
            o.delay.setRate(modRate);
            o.delay.setDelay(delaySamples);
            o.delay.setFs(Fs);
        end
        function out = processSignal(o,in)
            N = length(in);
            out = zeros(N,1);
            for n = 1:N
                out(n,1) = processSample(o,in(n,1));
            end
        end
        function y = processSample(o,x)
            w = x + o.g*o.d;
            y = o.delay.processSample(w);
            o.d = y;
        end
        function setGain(o,g)
            o.g = g;
        end
        function setFs(o,Fs)
            o.delay.setFs(Fs);
        end
    end
end