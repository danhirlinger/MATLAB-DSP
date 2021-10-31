classdef HighPassFilter < handle
    % Basic 1st-order HPF
    properties (Access = private)
        x1 = 0;
        
        b0 = 1;
        b1 = 0;
    end
    
    methods (Access = private)
        function [y] = processSample(o,x)
            y = o.b0*x + o.b1*o.x1;
            o.x1 = x;
        end
    end
    
    methods (Access = public)
        function o = HighPassFilter(amount)
%             o.b0 = 1 - 0.5*amount;
%             o.b1 = -0.5 * amount;
              o.setAmount(amount);
        end
        
        function [out] = process(o,in)
            N = length(in);
            out = zeros(N,1);
            for n = 1:N
                out(n,1) = processSample(o,in(n,1));
            end
        end
        function setAmount(o,amount)
            % amount goes from 0-1
            if (amount >= 0 && amount <= 1)
                o.b0 = 1 - 0.5*amount;
                o.b1 = -0.5 * amount;
            else
                disp('Invalid amount.');
            end
        end
    end
       
end