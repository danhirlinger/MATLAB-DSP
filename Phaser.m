classdef Phaser < handle
    % Dan Hirlinger
    properties
        width = 0; % affects the APF coefficients [0.1:0.9]
        depth = 1; % [-1.8,1.8]
        rate = 20; % [10,30]
        angle = 0;
        mix = 0.5;
        Fs = 48000; Ts;
        
        b0; b1; b2; a0; a1; a2;
        
        x1 = 0; x2 = 0;
        y1 = 0; y2 = 0;
        APF;
    end
    methods
        function o = Phaser(Fs,depth,rate,width,mix)
            % Set all params
            o.APF = APF2nd(Fs,width,rate,depth);
            setFs(o,Fs);
            setDepth(o,depth);
            setRate(o,rate);
            setWidth(o,width);
            setMix(o,mix);

        end
        function out = processSignal(o,in)
            N = length(in);
            out = zeros(N,1);
            for n = 1:N
                out(n,1) = processSample(o,in(n,1));
            end
        end
        function y = processSample(o,x)
%             % Set a1,b1 values based on LFO
%             o.a1 = -2*(o.depth/2)*cos(o.angle);
%             o.b1 = o.a1;
%             
%             % Process APF
%             apf = ((o.b0/o.a0)*x) + ((o.b1/o.a0)*o.x1) + ((o.b2/o.a0)*o.x2) + ...
%                 ((-o.a1/o.a0)*o.y1) + ((-o.a2/o.a0*o.y2));
%             y = x + apf*o.mix;
%             o.x2 = o.x1;
%             o.x1 = x;
%             o.y2 = o.y1;
%             o.y1 = apf;
%             
%             % Adjust phase increment
%             phi = o.rate * (o.Ts) * (1/(2*pi));
%             o.angle = o.angle + phi;
%             if o.angle > (2*pi)
%                 o.angle = o.angle - (2*pi);
%             end
            y = o.APF.processSample(x);
            y = x + y*o.mix;
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.APF.setFs(Fs);
        end
        function setDepth(o,depth)
            o.depth = depth;
            o.APF.setDepth(depth);
        end
        function setRate(o,rate)
            o.rate = rate;
            o.APF.setRate(rate);
        end
        function setWidth(o,width)
            o.width = width;
            o.APF.setCoeffs(width);
        end
        function setMix(o,mix)
            o.mix = mix;
        end
    end
end