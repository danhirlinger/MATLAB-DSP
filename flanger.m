function [y,buffer,wI,angle] = flanger(x,Fs,mix,rate,depth,predelay,type,buffer,wI,angle,M)

buffer(wI,1) = x;
Ts = 1/Fs;
    
% lfo
if (type == 1)
    delay = (depth/2)*sin(angle) + (depth/2) + 1 + predelay;
else
    delay = (depth/2)*sawtooth(angle) + (depth/2) + 1 + predelay;
end

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

% convert frequency to phase increment
phi = rate * (Ts) * (1/(2*pi));
angle = angle + phi;

if angle > (2*pi)
   angle = angle - (2*pi); 
end

y = mix*y + x;