% synthesis.m
% Dan Hirlinger
% 9/30/2020

%synthesizing signals; creating them from computer code, digitally
clear;clc;

% Common parameters for ALL signals:
Fs = 48000; Ts = 1/Fs;
f = 10; % frequency (Hz)
A = 1;   % linear Amplitude
phi = 0; % phase in radians

% Time vector in seconds
lenSecs = 1;
t = [0:Ts:lenSecs].';

% sine wave
%y = A * sin(2*pi*f*t + phi);

% Square wave
duty = 50; % duty tells wave how much to be positive (0-100)
% y = A * square(2*pi*f*t + phi,duty);

% Sawtooth wave
% y = A * sawtooth(2*pi*f*t + phi); % phi notates beginning phase


% Triangle wave
width = 1;
y = A * sawtooth(2*pi*f*t + phi, width);
% width determines where Apos peaks
plot(y);
% Impulse train
Fs = 48000; % samples per second
lenSec = 1;
sig = zeros(lenSec * Fs,1); % make column vector of 0's
f = 100;
tau = round(Fs/f); % tau = # samples/sec * sec/cycles = samples/cycle
% round to ensure tau is an integer # of samples
% cannot index a fraction of a sample

%set some of the samples = 1
sig(1:tau:end,1) = 1;
%stem(sig); % simpler plot, doesn't connect the samples together w a line
%plottf(sig,Fs);

% White noise
% aperiodic - does not repeat a pattern; use RNG
Fs = 48000;
lenSec = 1;

%x = 0.2*randn(lenSec*Fs,1); %normal distribution RNG
%OR use unifromally distributed RNG
x = 2*rand(lenSec*Fs,1) - 1;
%plottf(x,Fs);



%plot(t,y)
%plottf(y,Fs);





