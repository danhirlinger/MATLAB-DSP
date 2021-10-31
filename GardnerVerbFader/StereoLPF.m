classdef StereoLPF < handle
    properties (Access = private)
        freq = 1000;
        Q = sqrt(2)/2;
        b0 = 1;b1 = 0;b2 = 0;
        a0 = 1;a1 = 0;a2 = 0;
        Fs = 48000;
        
        sFreq = [1000 1000];
        sQ = [sqrt(2)/2 sqrt(2)/2];
        rate = 0.9;
                
        %   L,R
        x1=[0 0];
        x2=[0 0];
        y1=[0 0];
        y2=[0 0];
        
        count = [1 1]; MAXCOUNT = 32;
    end
    methods (Access = public)
        function o = StereoLPF(f)
            o.freq = f;
            o.sFreq = [f f];
            updateCoeffs(o,1);
            updateCoeffs(o,2);
        end
        function out = process(o,in)
            % in could be mono or stereo
            % out should match input
            % N = # samples
            % C = # channels
            [N,C] = size(in);
            out = zeros(N,C);
            for c = 1:C
                for n = 1:N
                    out(n,c) = processSample(o,in(n,c),c);
                end
            end
        end
        function y = processSample(o,x,c)
            
            o.count(c) = o.count(c) + 1;
            if (o.count(c) >= o.MAXCOUNT)
                updateCoeffs(o,c);
                o.count(c) = 1;
            end
            y = o.b0*x + o.b1*o.x1(c) + o.b2*o.x2(c) + ...
                (-o.a1)*o.y1(c) + (-o.a2)*o.y2(c);
            
            o.x2(c) = o.x1(c); o.x1(c) = x;
            o.y2(c) = o.y1(c); o.y1(c) = y;
        end
        function setFreq(o,freq)
            o.freq = freq;
%             updateCoeffs(o);
        end
        function setQ(o,Q)
            o.Q = Q;
%             updateCoeffs(o);
        end
        function setFs(o,Fs)
            o.Fs = Fs;
%             updateCoeffs(o);
        end
    end
    methods (Access = private)
        function updateCoeffs(o,c)
            o.sFreq(c) = o.sFreq(c)*o.rate + o.freq*(1-o.rate);
            o.sQ(c) = o.sQ(c)*o.rate + o.Q*(1-o.rate);
            w0 = 2*pi*o.sFreq(c)/o.Fs;            % Angular Freq. (Radians/sample)
            alpha = sin(w0)/(2*o.sQ(c));        % Filter Width
            
            A0 = 1 + alpha;
            o.b0 =  ((1 - cos(w0))/2) / A0;
            o.b1 =   (1 - cos(w0)) / A0;
            o.b2 =  ((1 - cos(w0))/2) / A0;
            o.a0 =   1;
            o.a1 =  (-2*cos(w0)) / A0;
            o.a2 =   (1 - alpha) / A0;
        end
    end
end