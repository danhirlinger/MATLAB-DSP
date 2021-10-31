% mdctDemo.m
clear;clc;
[in,Fs] = audioread('AcGtr.wav');

win = kbdwin(1024);

coef = mdct(in,win);

surf(20*log10(coef.^2),'EdgeColor','none');
view([0 90])
xlabel('Frame')
ylabel('Frequency')
axis([0 size(coef,2) 0 size(coef,1)])
colorbar

out = imdct(coef,win);

max(abs(in-out(1:length(in))))

