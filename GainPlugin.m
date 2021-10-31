classdef GainPlugin < audioPlugin
    
    properties (Access = public)
        gain = 1;
    end
    properties (Access = private)
        dBGain = 0;
        smoothGain = [0 0];
        alpha = 0.99;
    end
    
    properties (Constant)
        %        PluginInterface = audioPluginInterface(audioPluginParameter('gain',...
        %            'DisplayName', 'Gain',...
        %            'Label','linear',...
        %            'Mapping', {'lin',0,20}));
        
        PluginInterface = audioPluginInterface(audioPluginParameter('gain',...
            'DisplayName', 'Gain',...
            'DisplayNameLocation','Above',...
            'Label','db',...
            'Mapping', {'pow',1/3,-140,12}, ...
            'Style','rotaryknob', ...
            'Layout', [3,1]), ...
            audioPluginGridLayout(...
            'RowHeight', [20, 20, 160, 20, 100],...
            'ColumnWidth', [100, 100, 100, 100, 50, 150]));
    end
    
    methods
        function out = process(o,in)
            setGain(o);
            %    out = in * o.dBGain;
            [N,C] = size(in);
            out = zeros(N,C);
            for c = 1:C
                for n = 1:N
                    out(n,c) = processSample(o,in(n,c),c);
                end
            end
        end
        function y = processSample(o,x,c)
            o.smoothGain(c) = o.dBGain*(1-o.alpha) + o.alpha*o.smoothGain(c);
            y = o.smoothGain(c)*x;
        end
        function setGain(o)
            o.dBGain = 10^(o.gain/20);
        end
        function set.gain(o,gain)
            o.gain = gain;
            o.dBGain = 10^(o.gain/20);
        end
    end
end