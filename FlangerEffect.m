classdef FlangerEffect < handle
    
   properties
       delay;
       mix = 1; % [0:1]
       d = 0;
   end
   
   methods
       % Constructor
       function o = FlangerEffect()
           o.delay = ModDelay(0,5);
           % o.delayL = ModDelay;
           % o.delayR = ModDelay;
       end
       
       function out = process(o,in)
           N = length(in);
           out = zeros(N,1);
           for n = 1:N
               out(n,1) = processSample(o,in(n,1));
           end
           
       end
       
       function y = processSample(o,x)
           
%            Feed-forward
           y = ((x + o.mix*o.delay.processSample(x)) * (1-(o.mix*0.5)));
           % Feed-back
%            y = x + o.mix * o.d; % make sure mix < 1
%            o.d = o.delay.processSample(y);
    
       end
       
       function setDepth(o,depth)
           o.delay.setDepth(depth);
       end
       function setRate(o,rate)
           o.delay.setRate(rate);
       end
       function setPredelay(o,preD)
           o.delay.setPreDelay(preD);
       end
       function setFs(o,Fs)
           o.delay.setFs(Fs);
       end
       function setMix(o,mix)
           o.mix = mix;
       end
       
   end   
end