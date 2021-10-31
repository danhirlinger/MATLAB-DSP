% testPitchDelay.m

[in,Fs] = audioread('AcGtr.wav');

pitch = PitchDelay;

pitch.setFs(Fs);
semitones = 12;
pitch.setPitch(semitones);

N = length(in);
out = zeros(N,1);

for n = 1:N
    out(n,1) = pitch.processSample(in(n,1),1);
end
