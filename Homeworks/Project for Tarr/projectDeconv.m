% projectDeconv.m
% Aaron Amitrano, Dan Hirlinger, Steve Key
% 3/15/21
clear; clc;
close all;

%%%%% Deconvolution with sine sweep in CSA track room

% Import original sine sweep (x) and room measurement (y)
[x,xFs] = audioread('projectSineSweep.wav');
% [y,yFs] = audioread('Miktek MK300_sineSweep1.wav');
% [y,yFs] = audioread('Miktek MK300_sineSweep2.wav');
% [y,yFs] = audioread('Miktek MK300_sineSweep3.wav');
[y] = audioread('csaSineSweep.wav');
Ts = 1/xFs;


% (0-pad 'x' to make same length as 'y')
xN = length(x);
yN = length(y);
x = [x; zeros(yN-xN,1)];
    

% Convert both signals to frequency domain (fft)
X = fft(x);
Y = fft(y);
XN = length(X);
lam = 0.5; % Regulization factor


for k = 0:XN-1 % Calculate H[k] for each bin, k
   HIR(k+1,1) = (conj(X(k+1,1))*Y(k+1,1))/(Ts*(conj(X(k+1,1))*X(k+1,1)+lam));
end

% convert to time domain > perform IFFT
hIR = real(ifft(HIR));

% normalize IR amplitude
hIR = hIR * (1/max(hIR));
hIRN = length(hIR);
[hIRH,hIRW] = freqz(hIR);

% Plot magnitude Response
ampHIR = abs(hIRH);
ampHIR = 20*log10(ampHIR);
figure; semilogx((hIRW/pi)*xFs, ampHIR);
xlabel('Frequency (Hz)'); ylabel('Amplitude (dB)'); title('CSA Magnitude Response');

% Reverb effect analysis
t = [0:Ts:10]; % 10-s sweep
tN = length(t);
t = [t,zeros(1,hIRN-tN)];
figure; plot(t,20*log10(abs(hIR)));
axis([0 1 -70 0]);
xlabel('Time (s)'); ylabel('Amplitude (dB)'); title('Room Reverb Analysis');

%%%%%%%%%%

%%%%%%% Deconvolution with sine sweep through hardware EQ

% Import original sine sweep (x) and room measurement (y)
[x,xFs] = audioread('projectSineSweep.wav');
[y,yFs] = audioread('api550aSineSweep.wav');
Ts = 1/xFs;


% % (0-pad 'x' to make same length as 'y')
% xN = length(x);
% yN = length(y);
% x = [x; zeros(yN-xN,1)];
    

% Convert both signals to frequency domain (fft)
X = fft(x);
Y = fft(y);
XN = length(X);
lam = 0.5; % Regulization factor


for k = 0:XN-1 % Calculate H[k] for each bin, k
   HEQ(k+1,1) = (conj(X(k+1,1))*Y(k+1,1))/(Ts*(conj(X(k+1,1))*X(k+1,1)+lam));
end

% convert to time domain > perform IFFT
hEQ = real(ifft(HEQ));

% normalize IR amplitude
hEQ = hEQ * (1/max(hEQ));
hEQN = length(hEQ);
[hEQH,hEQW] = freqz(hEQ);

% Magnitude response of analog EQ
ampEq = abs(hEQH); % dB scale for vertical axis
ampEq = 20*log10(ampEq);
figure; semilogx((hEQW/pi)*xFs,ampEq); % log scale (semilogx) for horizontal axis
xlabel('Frequency (Hz)'); ylabel('Amplitude (dB)'); title('Analog EQ Magnitude Response');

% EQ IR analysis
t = [0:Ts:10]; % 10-s sweep
tN = length(t);
t = [t,zeros(1,hEQN-tN)];
figure; plot(t,20*log10(abs(hEQ)));
axis([0 10 -70 0]);
xlabel('Time (s)'); ylabel('Amplitude (dB)'); title('EQ IR Analysis');


% convolve vocal.wav with CSA IR and EQ IR
[vox,Fs] = audioread("Vocal.wav");

% conv with CSA IR
outIR = conv(vox,hIR);
% normalized outIR to [-1 1]; initial outIR has max values above 2
outIR = outIR * (1/max(outIR));
audiowrite('csa_IR_conv.wav',outIR,Fs);

% conv with EQ IR
outEQ = conv(vox,hEQ);
audiowrite('eq_IR_conv.wav',outEQ,Fs);

% null test for CSA room
csaVox = audioread('csaVocal.wav');
% (0-pad 'x' to make same length as 'y')
csaVoxN = length(csaVox);
outIRN = length(outIR);
csaVox = [csaVox; zeros(outIRN-csaVoxN,1)];
nullIR = (outIR - csaVox);
figure; plot(nullIR);
axis([0 outIRN -1 1]);
xlabel('Time (s)'); ylabel('Amplitude (dB)'); title('CSA Null Test');


% null test for analogue EQ
eqVox = audioread('api550aVocal.wav');
% (0-pad 'x' to make same length as 'y')
eqVoxN = length(eqVox);
outEQN = length(outEQ);
outEQ = [outEQ; zeros(eqVoxN-outEQN,1)];
nullEQ = (outEQ - eqVox);
figure; plot(nullEQ);
axis([0 eqVoxN -1 1]);
xlabel('Samples'); ylabel('Amplitude (dB)'); title('EQ Null Test');

% audiowrite()



