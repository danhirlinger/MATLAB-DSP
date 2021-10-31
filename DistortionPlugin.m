classdef DistortionPlugin < audioPlugin
    properties (Access = public)
        alpha = 1;
    end
    
    properties (Constant)
        PluginInterface = audioPluginInterface(audioPluginParameter('alpha',...
            'DisplayName', 'Drive',...
            'DisplayNameLocation','Above',...
            'Label','db',...
            'Mapping', {'lin',1,10}, ...
            'Style','vslider', ...
            'Layout', [3,3]), ...
            audioPluginGridLayout(...
            'RowHeight', [20, 20, 160, 20, 100],...
            'ColumnWidth', [100, 100, 100, 100, 50, 150]));
    end
    
    methods
        function out = process(o,in)
            %             o.setAlpha(o)
            out = (2/pi) * atan(o.alpha * in);
        end
        %         function setAlpha(o)
        %             o.alpha = alpha;
        %         end
    end
    
end