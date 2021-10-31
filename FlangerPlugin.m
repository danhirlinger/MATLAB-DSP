classdef FlangerPlugin < audioPlugin
    properties
        depth = 1;
        rate = 1;
        preD = 0;
        mix = 0;
        
        flangerEffectL;
        flangerEffectR;
    end
    properties (Constant)
        PluginInterface = audioPluginInterface(...
            audioPluginParameter('depth',...
            'DisplayName', 'Depth',...
            'Label','Samples',...
            'Mapping', {'lin',1,12}),...
            audioPluginParameter('rate',...
            'DisplayName', 'Rate',...
            'Label','Hz',...
            'Mapping', {'lin',1,12}),...
            audioPluginParameter('preD',...
            'DisplayName', 'Predelay',...
            'Label','Samples',...
            'Mapping', {'lin',0,5}),...
            audioPluginParameter('mix',...
            'DisplayName', 'Mix',...
            'Label','Mix',...
            'Mapping', {'lin',0,1}));
    end
    methods
        function o = FlangerPlugin()
            o.flangerEffectL = FlangerEffect();
            o.flangerEffectR = FlangerEffect();
            o.flangerEffectL.setFs(getSampleRate(o));
            o.flangerEffectR.setFs(getSampleRate(o));
        end
        function out = process(o,in)
            l = o.flangerEffectL.process(in(:,1));
            r = o.flangerEffectR.process(in(:,2));
            out = [l,r];
        end
        function reset(o)
            Fs = getSampleRate(o);
            o.flangerEffectL.setFs(Fs);
            o.flangerEffectR.setFs(Fs);
        end
        function setDepth(o,depth)
            o.depth = depth;
            updateParams(o);
        end
        function setRate(o,rate)
            o.rate = rate;
            updateParams(o);
        end
        function setPreD(o,preD)
            o.preD = preD;
            updateParams(o);
        end
        function setMix(o,mix)
            o.mix = mix;
            updateParams(o);
        end
        function updateParams(o)
            o.flangerEffectL.setDepth(o.depth);
            o.flangerEffectL.setRate(o.rate);
            o.flangerEffectL.setPreD(o.preD);
            o.flangerEffectL.setMix(o.mix);
            
            o.flangerEffectR.setDepth(o.depth);
            o.flangerEffectR.setRate(o.rate);
            o.flangerEffectR.setPreD(o.preD);
            o.flangerEffectR.setMix(o.mix);
        end
    end
end