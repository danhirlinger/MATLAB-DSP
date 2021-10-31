%  Hirlinger_AE5410_HW1.m
%  Dan Hirlinger
% 9/23/2020

clear; clc;

% read in audio file
[signal, Fs] = audioread('alphabet.m4a');

% extract initials from audio file
initialD = signal(176400:208100,1);
initialT = signal(946400:971800,1);
initialH = signal(359600:408300,1);

% concatenate signals together to form initials
initials = [initialD ; initialT ; initialH];

% create loop to concatenate initials together
% establish # of loops and variable to store concatenated samples
loopFactor = 5;
initialsConcat = [];

% create loop 
for x = 1:loopFactor
    initialsConcat = [initialsConcat ; initials];
end

% reverse audio of initials
initialsReverse = initials(end:-1:1,1);

% combine all audio signals
initialsFinal = [initials; initialsConcat; initialsReverse];

% execute sound function to listen to signal.
% initials are spoken 7 times sequentially, with variable 'initials'
% being the first iteration, variable 'initialsConcat' for the next five
% iterations, and 'initialsReverse' for the final iteration
sound(initialsFinal, Fs);

% export and save to 'audioEdits.wav'
audiowrite('audioEdits.wav',initialsFinal,Fs);

% plot waveform
plot(initialsFinal)
