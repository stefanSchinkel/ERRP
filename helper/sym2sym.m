function sym = sym2sym(sym)

%SYM2WORDS - REMAP SYMBOLS TO "LINEAR" ALPHABET
%
% function [symbols] = sym2sym(symbols)
%
% The function maps the symbols in the input vector to 
% a "linear" alphabet. Every symbol is assigned to an
% increasing integer, based on first occurence. 
%
% Input:
% 	data = symbols (vector)
%
% Output:
% 	out = word encoded time series
%
% requires: 
%
% see also: sym2words.m, transcode.m, opCalc.m

% Copyright (C) 2009 Stefan Schinkel, University of Potsdam
% http://www.agnld.uni-potsdam.de 
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
%
% $Log$


%% I/O check
if (nargchk(1,1,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end


% this is actually unecessary, but its better for pcolor plots
uniqueSym = unique(sym);
for i=1:length(uniqueSym)
	sym(sym == uniqueSym(i)) = i;
end
