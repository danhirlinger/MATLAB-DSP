function [y] = userConv(x,h)


N = length(x);
M = length(h);
y = zeros(N+M-1,1);

% zero-pad x and h arrays
x = [x;zeros(M-1,1)];
h = [h;zeros(N-1,1)];

for n = 1:N+M-1 % for the length of the output, y
    for m = 1:M
        if (n > N) && (N-m+1 > 0)
            % if n position is past its length, N
            % and index for x > 0
            y(n,1) = y(n,1) + (x(N-m+1,1) * h(m+n-N,1));
        elseif (n <= N) && (n-m+1 > 0)
            % when n position is 1 - N
            y(n,1) = y(n,1) + (x(n-m+1,1) * h(m,1));
        end
    end
end




% Add zeros to input so length = N+M-1 / length of output