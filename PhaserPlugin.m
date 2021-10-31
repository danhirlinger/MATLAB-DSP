classdef PhaserPlugin < audioPlugin
    properties
        depth = 1;
        rate = 5;
        width = 0;
        mix = 0.5;
        Fs = 48000;
        phaserL;
        phaserR;
    end
        properties (Constant)
            PluginInterface = audioPluginInterface(...
                audioPluginParameter('depth',...
                'DisplayName', 'Depth',...
                'Label','Samples',...
                'Mapping', {'lin',0,2}),...
                audioPluginParameter('rate',...
                'DisplayName', 'Rate',...
                'Label','Hz',...
                'Mapping', {'lin',1,5}),...
                audioPluginParameter('width',...
                'DisplayName', 'Width',...
                'Label','Resonance',...
                'Mapping', {'lin',0,1}),...
                audioPluginParameter('mix',...
                'DisplayName', 'Mix',...
                'Label','Mix',...
                'Mapping', {'lin',0,1}));
        end
    methods
        function o = PhaserPlugin()
            o.phaserL = Phaser(o.Fs,o.depth,o.rate,o.width,o.mix);
            o.phaserR = Phaser(o.Fs,o.depth,o.rate,o.width,o.mix);
            o.phaserL.setFs(getSampleRate(o));
            o.phaserR.setFs(getSampleRate(o));
        end
        function reset(o)
            FS = getSampleRate(o);
            o.phaserL.setFs(FS);
            o.phaserR.setFs(FS);
        end
        function out = process(o,in)
            l = o.phaserL.processSignal(in(:,1));
            r = o.phaserR.processSignal(in(:,2));
            out = [l,r];
        end
        function set.depth(o,depth)
            o.depth = depth;
            o.phaserL.setDepth(depth);
            o.phaserR.setDepth(depth);
        end
        function set.rate(o,rate)
            o.rate = rate;
            o.phaserL.setRate(rate);
            o.phaserR.setRate(rate);
%             updateParams(o);
        end
        function set.width(o,width)
            o.width = width;
            o.phaserL.setWidth(width);
            o.phaserR.setWidth(width);
        end
        function set.mix(o,mix)
            o.mix = mix;
            o.phaserL.setMix(mix);
            o.phaserR.setMix(mix);
        end
        function updateParams(o)
            o.phaserL.set.depth(o.depth);
            o.phaserL.set.rate(o.rate);
            o.phaserL.set.width(o.width);
            o.phaserL.setMix(o.mix);
            
            o.phaserR.set.depth(o.depth);
            o.phaserR.set.rate(o.rate);
            o.phaserR.set.width(o.width);
            o.phaserR.setMix(o.mix);
        end
    end
end