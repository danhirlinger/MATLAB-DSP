% GardnerReverbFader.m

classdef GardnerReverbFader < handle
    properties
        Fs = 48000;
        small; medium;
        size = 0.5; % [small:medium] / [0:1]
        gain = 0;
        mix = 0.5;
    end
    methods
        function o = GardnerReverbFader()
            o.small = GardnerSmallRoom(o.Fs);
            o.medium = GardnerMediumRoom(o.Fs);
        end
        function out = process(o,in)
            sVerb = o.small.process(in);
            mVerb = o.medium.process(in);
            [N,C] = size(mVerb);
            out = zeros(N,C);
            for c = 1:C
                for n = 1:N
                    out(n,c) = (sVerb(n,c)*(1-o.size) + mVerb(n,c)*o.size)/2;
                end
            end
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.small.setFs(Fs);
            o.medium.setFs(Fs);
        end
        function setSize(o,size)
            o.size = size;
        end
        function setGain(o,gain)
            o.gain = gain;
            o.small.setGain(gain);
            o.medium.setGain(gain);
        end
        function setMix(o,mix)
            o.mix = mix;
            o.small.setMix(mix);
            o.medium.setMix(mix);
        end
    end
end