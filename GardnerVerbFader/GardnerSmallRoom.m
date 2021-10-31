% Gardner Small Room Reverb
classdef GardnerSmallRoom < handle
    properties
        %         Delay1;
        M1 = 24*48;
        D1 = zeros(24*48,2); %initial delay of 24 samples
        wI = [24*48 24*48];
        nest1;
        nest2;
        lpf;
        Fs = 48000;
        fb = [0 0];
        gain = 0;
        mix = 0.5;
    end
    methods
        function o = GardnerSmallRoom(Fs)
            % o.Delay1 = ModDelay(24,0.7);
            o.nest1 = NestedAPF2(Fs, 22*48, 0.4, 8.3*48, 0.6, 35*48, 0.3);
            o.nest2 = NestedAPF(Fs,30*48,0.4,66*48,0.1);
            o.lpf = StereoLPF(4200);
            setFs(o,Fs);
        end
        function out = process(o,in)
            [N,C] = size(in);
            out = zeros(N,C);
            for c = 1:C
                for n = 1:N
                    out(n,c) = processSample(o,in(n,c),c);
                end
            end
            out = out*o.mix + in*(1-o.mix);
        end
        function y = processSample(o,x,c)
            % inital 24-delay
            v = x - o.gain * o.fb(c);
            v = (v + o.D1(o.wI(c),c))/2;
            o.D1(o.wI(c),c) = x;
            % v = o.Delay1.processSample(v,c);
            % nested APFs:
            % outer: 35(0.3)
            % inner: 22(0.4) ; 8.3(0.6)
            v = o.nest1.processSample(v,c);
            % send to out, g = 0.5
            y = v*0.5;
            % nested APF
            % outer: 66(0.1)
            % inner: 30(0.4)
            v = o.nest2.processSample(x,c);
            
            % send to out, g = 0.5
            y = y + (v*0.5);
            % add final out to reverb
            y = (y + v)/4;
            % feedback, LPF 4.2kHz
            o.fb(c) = o.lpf.processSample(v,c);
            o.wI(c) = o.wI(c) + 1;
            if (o.wI(c) > o.M1)
                o.wI(c) = 1;
            end
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            % o.Delay1.setFs(Fs);
            o.nest1.setFs(Fs);
            o.nest2.setFs(Fs);
            o.lpf.setFs(Fs);
        end
        function setGain(o,gain)
            o.gain = gain;
        end
        function setMix(o,mix)
            o.mix = mix;
        end
    end
end