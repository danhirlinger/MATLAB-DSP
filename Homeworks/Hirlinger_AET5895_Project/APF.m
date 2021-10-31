classdef APF < handle
    
    properties (Access = private)
        delay;
        gain = 0.5;
        fb = [0 0];
        Fs = 48000;
        
        count = [1 1]; MAXCOUNT = 32;
    end
    
    methods
        function o = APF(delaySamples,rate,Fs)
            o.delay = ModDelay(delaySamples,rate);
            o.delay.setFs(Fs);
        end
        function out = process(o,in)
            [N,C] = size(in);
            out = zeros(N,C);
            for c = 1:C
                for n = 1:N
                    out(n,c) = processSample(o,in(n,c),c);
                end
            end
        end
        function y = processSample(o,x,c)            
            w = x - o.gain * o.fb(c);
            v = o.delay.processSample(w,c);
            y = v + o.gain * x;
            o.fb(c) = y;
        end
        function setGain(o,g)
            o.gain = g;
        end
        function setDepth(o,depth)
            o.delay.setDepth(depth);
        end
        function setFs(o,Fs)
            o.delay.setFs(Fs);
        end
    end
end