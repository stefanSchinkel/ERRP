function y = movavg(x,win)

%MOVAVG - simple 1D/2D moving average
%
% function [y] = movavg(x[,win])
%
% Compute moving average of the vector or matrix x
% with a given window size (def: 10). Border effects
% are not compensated for.
%
% Input:
%	x = vector or 2D matrix
%
% Parameter:
%	win = size of window (def: 10)
%
% Output:
%	y = smoothed data
%
%
% requires: 
%
% see also:ERRP/helper
%

% Copyright (C) 2012 Stefan Schinkel, HU Berlin
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


% I/O check

if nargin < 1
	help(mfilename)
	error('Input required')
elseif nargin < 2
	win = 10;
end


% homemade isvector
if min(size(x)) == 1
	flagVector = 1;
elseif ndims(x) == 2
	flagVector = 0;
else
	help(mfilename)
	error('Vector or 2D Matrix required')
end


if flagVector	% 1D case

	%filter coefficient
	b=ones(1,win)/win;

	% filter and return
	y = filter(b,1,x);

else
	
	%filter coeffs
	h=ones(win,win)/win^2;

	%filter and return
	y = filter2(h,x);
end

