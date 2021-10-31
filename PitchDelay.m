classdef PitchDelay < handle
    properties
        Fs = 48000;
        delta = 0; % rate of change for delay
        
        M = 96000; % # samples in buffer
        buffer = zeros(96000,2); % stereo delay buffer
        wI = [96000 96000];
        delay = [2 2];
        
        MAX_SEC = 0.03; % 30 ms, maximum delay
        MAX_SAMPLES = 0.03/48000;
        MIN_SAMPLES = 2;
        
        blockNum = 1;
    end
    methods
        function o = PitchDelay(blockNum)
            o.blockNum = blockNum;
            if (blockNum == 1)
                o.delay = [2 2];
            elseif (blockNum == 2)
                o.delay = [o.MAX_SAMPLES/3 o.MAX_SAMPLES/3];
            else % blockNum == 3
                o.delay = [2*o.MAX_SAMPLES/3 2*o.MAX_SAMPLES/3];
            end
        end
        function [y,angle] = processSample(o,x,c,angle)
            % Store current sample in delay buffer
            o.buffer(o.wI(c),c) = x;
            
            o.delay(c) = o.delay(c) + o.delta;
            % Make sure delay is still in bounds
            if (o.delta <= 0 && o.delay(c) < o.MIN_SAMPLES)
                o.delay(c) = o.MAX_SAMPLES;
                angle = 1.5*pi;
            end
            if (o.delta > 0 && o.delay(c) > o.MAX_SAMPLES)
                o.delay(c) = o.MIN_SAMPLES;
                angle = 1.5*pi;
            end
            r1 = o.wI(c) - floor(o.delay(c));
            if (r1 < 1)
                r1 = r1 + o.M;
            end
            r2 = r1 - 1;
            if (r2 < 1)
                r2 = r2 + o.M;
            end
            
            g2 = o.delay(c) - floor(o.delay(c));
            g1 = 1-g2;
            
            y = g1*o.buffer(r1,c) + g2*o.buffer(r2,c);
            
            o.wI = o.wI + 1;
            if (o.wI > o.M)
                o.wI = 1;
            end
        end
        function setFs(o,Fs)
            o.Fs = Fs;
            o.MAX_SAMPLES = o.MAX_SEC * Fs;
            if (o.blockNum == 1)
                o.delay = [2 2];
            elseif (o.blockNum == 2)
                o.delay = [o.MAX_SAMPLES/3 o.MAX_SAMPLES/3];
            else % blockNum == 3
                o.delay = [2*o.MAX_SAMPLES/3 2*o.MAX_SAMPLES/3];
            end
        end
        function setPitch(o,semitone)
            % tr = 2^(semitone/12);
            o.delta = 1 - (2^(semitone/12));
        end
    end
end