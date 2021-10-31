classdef  GainChange < handle
    
    
    % Variables of class
    properties
        
       g = 0.5; 
        
    end
    % Functions of class
    methods
        
        function [out] = process(o,in)
            N = length(in);
            out = zeros(N,1);
            for n = 1:N
               out(n,1) = o.g * in(n,1); 
            end 
        end
        
        function setGain(o,newGain)
            % set property up above
            o.g = newGain;
        end
        
    end    
    
end