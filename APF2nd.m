classdef APF2nd < handle
    % 2nd-order APF for phaser
    % Phase is changing with LFO, a0 fixed at 1
    properties
        b0; b1=1; b2=1; a0=1; a1=1; a2;
        x1 = 0; x2 = 0;
        y1 = 0; y2 = 0;
        rate; depth;
        angle = 0;
        Fs = 48000; Ts;
    end
    methods
        function o = APF2nd(Fs,w,r,d)
            setFs(o,Fs);
            setCoeffs(o,w);
            setRate(o,r);
            setDepth(o,d);
        end
        function out = processSignal(o,in)
            N = length(in);
            out = zeros(N,1);
            for n = 1:N
                out(n,1) = processSample(o,in(n,1));
            end
        end
        function y = processSample(o,x)
            o.a1 = ((o.depth/2)*cos(o.angle)) + (o.depth/2) - 1;
            o.b1 = o.a1;
            y = ((o.b0)*x) + ((o.b1)*o.x1) + ...
                ((o.b2)*o.x2) + ((-o.a1)*o.y1) + ...
                ((-o.a2)*o.y2);
            o.x2 = o.x1; o.x1 = x;
            o.y2 = o.y1; o.y1 = y;
            % Adjust phase increment, if needed
            phi = o.rate * (o.Ts) * (2*pi);
            o.angle = o.angle + phi;
            if o.angle > (2*pi)
                o.angle = o.angle - (2*pi);
            end
        end
        function setCoeffs(o,w)
            % static coefficients
            o.b0 =   w;
            o.a2 =   w;
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.Ts = 1/Fs;
        end
        function setRate(o,rate)
            o.rate = rate;
        end
        function setDepth(o,depth)
            o.depth = depth;
        end
    end
end