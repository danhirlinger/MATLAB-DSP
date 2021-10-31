classdef GardnerReverbFaderPlugin < audioPlugin
    properties
        size = 0.5;
        gain = 1;
        mix = 0.5;
        Fs = 48000;
        verb;
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('size',...
            'DisplayName', 'Size',...
            'Label','Size',...
            'Mapping', {'lin',0,1}),...
            audioPluginParameter('gain',...
            'DisplayName', 'Gain',...
            'Label','A',...
            'Mapping', {'lin',0,1}),...
            audioPluginParameter('mix',...
            'DisplayName', 'Mix',...
            'Label','Mix',...
            'Mapping', {'lin',0,1}));
    end
    methods
        function o = GardnerReverbFaderPlugin()
            o.verb = GardnerReverbFader();
            o.verb.setFs(getSampleRate(o));
        end
        function reset(o)
            FS = getSampleRate(o);
            o.verb.setFs(FS);
        end
        function out = process(o,in)
           out = o.verb.process(in);
        end
        function setFs(o,Fs)
            o.verb.setFs(Fs);
        end
        function set.size(o,size)
            o.size = size;
            o.verb.setSize(size);
        end
        function set.gain(o,gain)
            o.gain = gain;
            o.verb.setGain(gain)
        end
        function set.mix(o,mix)
            o.mix = mix;
            o.verb.setMix(mix);
        end
    end
end








