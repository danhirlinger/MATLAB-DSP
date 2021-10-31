% filterImplementations.m
% Dan Hirlinger
% 2/22/21


% Several ways to apply a filter to an audio signal

% Input
% [x,Fs] = audioread('AcGtr.wav');
Fs = 48000;
x = randn(Fs,1) * 0.2; % white noise

% Filter

N = length(x);
y = zeros(N,1);


% Using difference equation
% for n = 1:N
%     if n > 1
%         % y(n,1) = 0.5*x(n,1) + 0.5*x(n-1,1); % LPF
%         y(n,1) = 0.5*x(n,1) - 0.5*x(n-1,1); % HPF
%     else
%         y(n,1) = x(n,1);
%     end
% end


% Using IR, convolution
% b0 = 0.5; % want b0 + b1 = 1
% b1 = -0.5; % use 0.5 for LPF; use -0.5 for HPF
% b = [b0, b1];
% m = 20;
% b = (1/m) * ones(m,1);

% m = 1; % # of delay samples to use; AKA the filter order

% Nyq = Fs/2;
% fHz = 12000;
% Wn = fHz/Nyq;
% Wn = 0.5; % cut-off frequency relative to Nyquist; AKA "Normalized" cutt-off frequency [0-1]
% 
% b = fir1(m,Wn);


% y = conv(x,b);

% freqz(b);
m = 4;
% freqz( (1/m) * ones(m,1) );
% Output
% sound([x;y]Fs);


% DAY 2: 2/24/21
% Fs = 48000;
Nyq = Fs/2;
fHz = 12000;
Wn = fHz/Nyq; % cut-off frequency relative to Nyquist; AKA "Normalized" cutt-off frequency [0-1]

b = fir1(m,Wn);
% m = filter order: # of delays we're gonna use
% higher order > steeper slope/sharper roll-off of filter
% drawback: more roll-off is more mathmatically complex

% Wn = cut-off frequency of the filter

% fir1() is automatically a LPF
% make it HPF filer with fir1(m,Wn,'high');
% HPF's prefer an even filter order
freqz(b);

% Band-pass and band-stop

fL = 3000;
fU = 12000;

wL = fL / Nyq;
wU = fU / Nyq;

W = [wL, wU]; 

h = fir1(m,W);

% by default, with W being an array of 2 values, it will be a band pass
% change to band-stop with 'stop' > fir1(m,W,'stop');

freqz(h);

% using fir2(), plot an arbitrary frequency response

% in F, must begin with 0, end with 1; normalized scale of frequencies
F = [0 , 3000/Nyq , 8000/Nyq , 12000/Nyq, 15000/Nyq , 1];
A = [1 ,  0.5     ,    1     ,    1     ,    2     , 2]; % +/-1 = +/- 6dB 
h = fir2(m,F,A);
freqz(h);










