% phaseSynth.m

% How to synthesize a sine wave from instantaneous phase

clc;clear;

Fs = 48000;

phase = 0;

f = 1000; % Hertz

angleChange = f * (1/Fs) * 2*pi; % radians of rotation per 1 sample

lenSec = 4;

N = lenSec * Fs;

%y = zeros(1,Fs);

for n = 1:N
    
    y(n,1) = sin(phase);
    
    phase = phase + angleChange;
    
    if (phase > 2*pi)
        
        phase = phase - (2*pi);
        
    end
end

figure();
plot(y);
sound(y,Fs);


