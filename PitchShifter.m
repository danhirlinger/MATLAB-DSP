classdef PitchShifter < handle
    properties
        PD1; PD2; PD3;
        Fs = 48000;
        
        delta = 1;
        angleChange = 0;
        
        a1 = [3*pi/2 3*pi/2];
        a2 = [(3*pi/2)+2*pi/3 (3*pi/2)+2*pi/3];
        a3 = [(3*pi/2)+4*pi/3 (3*pi/2)+4*pi/3];
        
        PI_2 = 2*pi;
        MAX_SEC = 0.03;
        MAX_SAMPLES = 0.03/48000;
    end
    methods
        function o = PitchShifter()
            o.PD1 = PitchDelay(1);
            o.PD2 = PitchDelay(2);
            o.PD3 = PitchDelay(3);
        end
        function y = processSample(o,x,c)
            [x1, o.a1(c)] = o.PD1.processSample(x,c,o.a1(c));
            [x2, o.a2(c)] = o.PD2.processSample(x,c,o.a2(c));
            [x3, o.a3(c)] = o.PD3.processSample(x,c,o.a3(c));
            
            g1 = 0.5*sin(o.a1(c)) + 0.5;
            o.a1(c) = o.a1(c) + o.angleChange;
            if (o.a1(c) > o.PI_2)
                o.a1(c) = o.a1(c) - o.PI_2;
            end
            if (o.a1(c) < 0)
                o.a1(c) = o.a1(c) + o.PI_2;
            end
            g2 = 0.5*sin(o.a2(c)) + 0.5;
            o.a2(c) = o.a2(c) + o.angleChange;
            if (o.a2(c) > o.PI_2)
                o.a2(c) = o.a2(c) - o.PI_2;
            end
            if (o.a2(c) < 0)
                o.a2(c) = o.a2(c) + o.PI_2;
            end
            g3 = 0.5*sin(o.a3(c)) + 0.5;
            o.a3(c) = o.a3(c) + o.angleChange;
            if (o.a3(c) > o.PI_2)
                o.a3(c) = o.a3(c) - o.PI_2;
            end
            if (o.a3(c) < 0)
                o.a3(c) = o.a3(c) + o.PI_2;
            end
            
            y = (g1*x1 + g2*x2 + g3*x3) * (2/3);
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.PD1.setFs(Fs);
            o.PD2.setFs(Fs);
            o.PD3.setFs(Fs);
            
            o.MAX_SAMPLES = o.MAX_SEC * Fs;
            o.period = (o.MAX_SAMPLES-1) / (o.delta*o.Fs);
            freq = 1/period;
            o.angleChange = freq * 2*pi / o.Fs;
        end
        function setPitch(o,semitone)
            % tr = 2^(semitone/12);
            o.delta = 1 - (2^(semitone/12));
            
            o.PD1.setPitch(semitone);
            o.PD2.setPitch(semitone);
            o.PD3.setPitch(semitone);
            
            o.MAX_SAMPLES = o.MAX_SEC * o.Fs;
            o.period = (o.MAX_SAMPLES-1) / (o.delta*o.Fs);
            freq = 1/period;
            o.angleChange = freq * 2*pi / o.Fs;
        end
    end
end