classdef GardnerSmallRoomPlugIn < audioPlugin
    properties
        mix = 0;
        gain = 0.5;
        Fs = 48000;
        gardner;
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('mix',...
            'DisplayName', 'Mix',...
            'Label','Mix',...
            'Mapping', {'lin',0,1}));
    end
    methods
        function o = GardnerSmallRoomPlugIn()
            o.gardner = GardnerSmallRoom(o.Fs);
            o.gardner.setFs(getSampleRate(o));
        end
        function reset(o)
            FS = getSampleRate(o);
            o.gardner.setFs(FS);
        end
        function out = process(o,in)
            out = o.gardner.process(in);
        end
        
        function set.gain(o,gain)
            o.gain = gain;
            o.gardner.setGain(gain);
        end
        function set.mix(o,mix)
            o.mix = mix;
            o.gardner.setMix(mix);
        end
    end
end