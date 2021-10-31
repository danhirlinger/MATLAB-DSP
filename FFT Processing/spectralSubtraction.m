function [out] = spectralSubtraction(in,frameSize,overlap,avgApF,sDApF,bias)

hop = frameSize/overlap;

N = length(in);
NFrame = ceil(N/frameSize);
% zero-pad input to always have complete frame at end
if (mod(N,frameSize) > 0)
    
    pad = NFrame * frameSize - N; % amount of 0's we need to add
    in = [in; zeros(pad,1)];
end

% Total number of frames factoring in overlap
R = (NFrame-1)*overlap + 1;

strt = 1; % initial index
nend = frameSize;

% Window function
w = hann(frameSize);

S = zeros(frameSize,1);
out = zeros(length(in),1);
for r = 1:R
    seg = in(strt:nend,1);
    x = seg .* w; % apply window to segment
    
    % analysis
    X = fft(x);
    Xamp = abs(X);
    Xphase = angle(X);
    
    for k = 1:frameSize
        S(k,1) = Xamp(k,1) - (avgApF(k,1) + sDApF(k,1)*bias);
        if S(k,1) < 0
            S(k,1) = 0;
        end
    end
    
    Y = S .* exp(1j * Xphase);
    
    y = real(ifft(Y));
    
    out(strt:nend) = out(strt:nend) + y;
    strt = strt + hop;
    nend = strt + frameSize - 1;
end

end

