function [out] = flangerSignal(in,Fs,mix,rate,depth,predelay,type,M)

Ts = 1/Fs;
N = length(in);


buffer = zeros(M,1);

wI = M; % write index

t = [0:N-1].' * Ts;
if (type == 1)
    lfo = (depth/2)*sin(2*pi*rate*t) + (depth/2) + 1 + predelay;
elseif (type == 0)                  % |_____________| this ensures a minimum at 1 sample delay
    lfo = (depth/2)*sawtooth(2*pi*rate*t) + (depth/2) + 1 + predelay;
end

out = zeros(N,1);
for n = 1:N
    x = in(n,1);
    
    buffer(wI,1) = x;
    
    delay = lfo(n,1);
    
    r1 = wI - floor(delay); % 3 samples of delay
    if (r1 < 1)
        r1 = r1 + M;
    end
    r2 = r1 - 1;
    if (r2 < 1)
       r2 = r2 + M; 
    end
    
    g2 = delay - floor(delay);
    g1 = 1 - g2;
    
    y = g1 * buffer(r1,1) + g2 * buffer(r2,1);
    
    wI = wI + 1;
    if (wI > M)
        wI = 1;
    end    
    
    out(n,1) = x + mix*y;
end