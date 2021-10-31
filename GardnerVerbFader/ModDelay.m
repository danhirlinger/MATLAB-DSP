classdef ModDelay < handle
    
    properties
        
        M = 10000;
        buffer = zeros(10000,1);
        wI = [10000 10000]; % write index
        angle = [0 0];
        depth = 1; % [1,20] "samples"
        preD = 0; % [0,20] "samples"
        rate = 5; % [0.1,10] "Hz"
        Fs = 48000;
        Ts = 1/48000;
    end
    
    methods
        
        function o = ModDelay(delay,rate)
            o.preD = delay;
            o.rate = rate;
        end
        function y = processSample(o,x,c)
            o.buffer(o.wI(c),1) = x;
            d = (o.depth/2)*sin(o.angle(c)) + (o.depth/2) + 1 + o.preD;
            r1 = o.wI(c) - floor(d);
            if (r1 < 1)
                r1 = r1 + o.M;
            end
            r2 = r1 - 1;
            if (r2 < 1)
                r2 = r2 + o.M;
            end
            
            
            g2 = d - floor(d);
            g1 = 1 - g2;
            
            y = 0.5 * o.buffer(r1,1) + 0.5 * o.buffer(r2,1);
            
            o.wI(c) = o.wI(c) + 1;
            if (o.wI(c) > o.M)
                o.wI(c) = 1;
            end
            
            % convert frequency to phase increment
            phi = o.rate * (o.Ts) * (2*pi);
            o.angle(c) = o.angle(c) + phi;
            if o.angle(c) > (2*pi)
                o.angle(c) = o.angle(c) - (2*pi);
            end
        end
        function setRate(o,rate)
            o.rate = rate;
        end
        function setDepth(o,depth)
            o.depth = depth;
        end
        function setDelay(o,preD)
            o.preD = preD;
        end
       function setFs(o,Fs)
           o.Fs = Fs;
           o.Ts = 1/Fs;
       end
    end
end