% function: PhDiff = phdiffmeasure(x, y)
%
% Input:
% x - first signal in the time domain
% y - second signal in the time domain
% 
% Output:
% PhDiff - phase difference Y -> X, rad

function PhDiff = func_phdiffmeasure(x, y)

% represent the signals as column-vectors
x = x(:);
y = y(:);

% remove the DC component of the signals
x = x - mean(x);
y = y - mean(y);

% perform fft on the signals
px = nextpow2(length(x));
py = nextpow2(length(y));
nfftx = 2^px;
nffty = 2^py;
X = fft(x, nfftx);
Y = fft(y, nffty);

% phase difference estimation
[~, indx] = max(abs(X));
[~, indy] = max(abs(Y));
angle_y = angle(Y(indy));%atan
angle_x = angle(X(indx));
PhDiff = angle_y - angle_x;

end
