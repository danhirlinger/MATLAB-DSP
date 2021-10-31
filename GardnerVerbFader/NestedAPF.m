% Nested APF
classdef NestedAPF < handle
    properties (Access = private)
        delay;
        gain = 0.5;
        fb = [0 0];
        apf;
        Fs = 48000;
    end
    
    methods
        function o = NestedAPF(Fs,d1,r1,d2,r2)
            % d1 = 20; r1 = 0.7; d2 = 50; r2 = 0.8
            o.apf = APF(d1,r1,Fs); % inner APF
            o.apf.setGain(0.3);
            o.delay = ModDelay(d2,r2); % outer APF
            o.delay.setFs(Fs);
        end
        function out = process(o,in)
            [N.C] = size(in);
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
            v = o.apf.processSample(v,c);
            y = v + o.gain * x;
            o.fb(c) = y;
        end
        function setGain(o,g)
            o.gain = g;
        end
        function setDepth(o,depth)
            o.delay.setDepth(depth)
            o.apf.setDepth(depth);
        end
        function setFs(o,Fs)
            o.delay.setFs(Fs);
            o.apf.setFs(Fs);
        end
    end
end