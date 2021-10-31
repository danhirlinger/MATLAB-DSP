%Null Test for Project
clear; clc;
% Process signal using convolution
[fVox, Fs] = audioread('femaleVocal.wav');
hEQ = audioread('EQ_IR_Good.wav');

convEQ = conv(fVox, hEQ);
audiowrite('ProtEQ_conv.wav',convEQ,Fs);

% Signal processed in ProTools
protEQ =  audioread('EQ_Vocal_Good.wav');

% Add zeros
protEQ = [protEQ; zeros(length(convEQ) - length(protEQ),1)];


nullEQ = (protEQ - convEQ);
figure; plot(nullEQ);
axis([0 1400000 -1 1]);
xlabel('Samples'); ylabel('Amplitude'); title('ProTools EQ Null Test');

hDelay = audioread('Mod Delay_IR_Good.wav');

convDelay = conv(fVox, hDelay);
audiowrite('ModDelay_conv.wav',convDelay,Fs);

% Signal processed in ProTools
protDelay =  audioread('Mod Delay_Vocal_Good.wav');

% Add zeros
protDelay = [protDelay; zeros(length(convDelay) - length(protDelay),1)];


nullDelay = (protDelay - convDelay);
figure; plot(nullDelay);
axis([0 1400000 -1 1]);
title('ProTools Delay Null Test'); xlabel('Samples'); ylabel('Amplitude'); 


[freqEQ,w1] = freqz(hEQ);
[freqDelay,w2] = freqz(hDelay);


figure; semilogx((w1/pi)*Fs,20*log10(abs(freqEQ)));
axis([0 Fs -20 5]);
xlabel('Frequency'); ylabel('Amplitude'); title('ProTools EQ Magnitude Response');


t = [0:length(hDelay)-1] * 1/Fs;
figure; plot(t,hDelay);
xlabel('Time'); ylabel('Amplitude'); title('ProTools Delay IR');

