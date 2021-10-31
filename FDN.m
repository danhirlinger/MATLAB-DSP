classdef FDN < handle
    properties
        % 4 separate mod delays
        M = 4; % # of delay blocks
        delay = cell(4,1);
        % d = [521; 607; 738; 869]
        fb = cell(4,1);
        gain = 0.5;
        
        %D = [0 1 1 0;
        %    -1 0 0 -1;
        %    1 0 0 -1;
        %    0 1 -1 0];
        D = zeros(4,4);
    end
    methods
        function o = FDN()
            for m = 1:o.M
                rate = rand(1) + 0.5;
                d = (randn(1) * 150) + 600;
                o.delay{m,1} = ModDelay(d,rate);
                o.fb{m,1} = 0;
                for r = 1:o.M
                    o.D(r,m) = sign(randn(1));
                end
            end
        end
        
        function y = processSample(o,x)
            
            in = zeros(o.M,1); out = zeros(o.M,1);
            for m = 1:o.M
                in(m,1) = x + o.fb{m,1};
                out(m,1) = o.delay{m,1}.processSample(in(m,1));
            end
            
            % Feedback matrix
            for c = 1:o.M
                a = 0;
                for r = 1:o.M
                    a = a + o.D(r,c) * out(r,1);
                end
                o.fb{c,1} = a * o.gain;
            end
            
            y = sum(out) * (1/o.M);
        end
        
        function setModulation(modAmt)
            for m = 1:o.M
                o.delay{m,1}.setDepth(modAmt);
            end
        end
        function setTime(o,time)
            o.gain = time;
        end
    end
end