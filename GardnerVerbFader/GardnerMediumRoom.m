% GardnerMediumRoom.m
classdef GardnerMediumRoom < handle
    properties
        M = [5*48 67*48 15*48 108*48];
        D = cell(4,2); % delay buffers
        wI = cell(4,2); % write indices
        fb = [0 0];
        gain = 0;
        mix = 0.5;
        Fs = 48000;
        
        nest1;
        apf1;
        nest2;
        lpf;
    end
    methods
        function o = GardnerMediumRoom(Fs)
            o.nest1 = NestedAPF2(Fs,8.3*48,0.7,22*48,0.5,35*48,0.3);
            for m = 1:length(o.M)
                for c = 1:2
                    o.D{m,c} = zeros(o.M(m),1);
                    o.wI{m,c} = o.M(m);
                end
            end
            o.apf1 = APF(30*48,0.5,Fs);
            
            o.nest2 = NestedAPF(Fs,9.8*48,0.6,39*48,0.3);
            
            o.lpf = StereoLPF(2500);
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
            % add fb
            v = x - o.gain*o.fb(c);
            % double nested APF
            v = o.nest1.processSample(v,c);
            % send to output, g = 0.5
            y = v * 0.5;
            % 5 samples of delay
            v = (v + o.D{1,c}(o.wI{1,c},c))/2;
            o.D{1,c}(o.wI{1,c},c) = v;
            % APF
            v = o.apf1.processSample(v,c);
            % 67 samples of delay
            v = (v + o.D{2,c}(o.wI{2,c},c))/2;
            o.D{2,c}(o.wI{2,c},c) = v;
            % send to output, g = 0.5
            y = (y + (v*0.5))/2;
            % 15 samples of delay
            v = (v + o.D{3,c}(o.wI{3,c},c))/2;
            o.D{3,c}(o.wI{3,c},c) = v;
            % multiply by gain, add input
            v = ((v * o.gain) + x)/2;
            % nested APF
            v = o.nest2.processSample(v,c);
            % send to output, g = 0.5
            y = (y + (v*0.5))/2;
            % 108 samples of delay
            v = (v + o.D{4,c}(o.wI{4,c},c))/2;
            o.D{4,c}(o.wI{4,c},c) = v;
            % add to output
            y = (y + v)/2;
            % lpf
            o.fb(c) = o.lpf.processSample(v,c);
            % wrap write indices back around
            for m = 1:length(o.M)
                o.wI{m,c} = o.wI{m,c} + 1;
                if (o.wI{m,c} > o.M(m))
                    o.wI{m,c} = 1;
                end
            end
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.apf1.setFs(Fs);
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