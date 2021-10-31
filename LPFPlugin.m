classdef LPFPlugin < audioPlugin
    properties
        freq = 1000;
        Q = sqrt(2)/2;
        
        lpf;
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('freq',...
            'DisplayName', 'Frequency',...
            'Label','Hz',...
            'Mapping', {'log',100,20000}),...
            audioPluginParameter('Q',...
            'DisplayName', 'Q',...
            'Label','Resonance',...
            'Mapping', {'lin',0,5}));
    end
    
    methods
        function o = LPFPlugin()
            o.lpf = StereoLPF;
        end
        function reset(o)
            Fs = getSampleRate(o);
            o.lpf.setFs(Fs);
        end
        function out = process(o,in)
            out = o.lpf.process(in);
        end
        function set.freq(o,freq)
            o.freq = freq;
            o.lpf.setFreq(freq);
        end
        function set.Q(o,Q)
            o.Q = Q;
            o.lpf.setQ(Q);
        end
    end
end