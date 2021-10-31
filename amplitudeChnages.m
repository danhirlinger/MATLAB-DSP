% amplitudeChanges.m
% Dan Hirlinger
%9/21,9/23

clear; clc;

% for loops!

a = 1

m = [10;11;12;13;14;15];

for c = 1:6
    
    b = m(c,1)  %indexing values from array m
    
    
   
end

d = 10


%%%% AUDIO SINGALS w loop

[x,Fs] = audioread('AcGtr.wav');

% x = input signal

N = length(x)
% allow for loop to have any given length
for n = 1:length(x)
   
    y(n,1) = x(n,1);
    
end    

%amplitude change using gain change

g = 0.5

Ts = 1/Fs;

for n = 1:N
   
    y(n,1) = g * x(n,1); % multiply by the gain change
    
    t(n,1) = (n-1) * Ts;
    
end   

% """ using DC Offset 

for n = 1:N
   
    y(n,1) = g + x(n,1); % add the DC offset
    
    
end  

% Array for time in seconds
% Determine the length of the audio in seconds
t = [0:N-1] * Ts;

% Graph waveform (amp vs time)
plot(x);
hold on;
plot(y);
hold off;

% Plotting characteristic curves
figure;
plot(x,x);
hold on;
plot(x,y);
hold off;

