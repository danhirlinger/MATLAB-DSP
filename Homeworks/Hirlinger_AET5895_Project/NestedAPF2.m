% Nested APF with 2 inner APF's
classdef NestedAPF2 < handle
    properties (Access = private)
        delay;
        gain = 0.5;
        fb = [0 0];
        apf; apf2;
        Fs = 48000;
    end
    
    methods
        function o = NestedAPF2(Fs, d1, r1, d2, r2, D1, R1)
            % d1 = 20; r1 = 0.7; d2 = 50; r2 = 0.8
            o.apf = APF(d1,r1,Fs); % inner APF
            o.apf.setGain(0.3); % is the (##) rate or gain??
            o.apf2 = APF(d2,r2,Fs);
            o.apf.setGain(0.3);
            o.delay = ModDelay(D1,R1); % outer APF
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
            v = o.apf.processSample(v,c);
            v = o.apf2.processSample(v,c);
            y = v + o.gain * x;
            o.fb(c) = y;
        end
        function setGain(o,g)
            o.gain = g;
        end
        function setDepth(o,depth)
            o.delay.setDepth(depth)
            o.apf.setDepth(depth);
            o.apf2.setDepth(depth);
        end
        function setFs(o,Fs)
            o.delay.setFs(Fs);
            o.apf.setFs(Fs);
            o.apf2.setFs(Fs);
        end
    end
end