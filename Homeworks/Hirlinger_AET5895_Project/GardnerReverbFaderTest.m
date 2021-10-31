% GardnerReverbFaderTest.m

% clear;clc;

[in,Fs] = audioread('AcGtr.wav');

verb = GardnerReverbFader();

size = 1;
gain = 1;
mix = 0.8;

verb.setFs(Fs);
verb.setSize(size);
verb.setGain(gain);
verb.setMix(mix);

out = verb.process(in);
plot(out);


