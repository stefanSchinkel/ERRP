function out = sym2words(data,wordLength)

%SYM2WORDS - ENCODE SYMBOLS VECTOR IN WORDS
%
% function [words] = sym2words(data,wordLength)
%
% Computes the words of length wordLength in the vector data.
% The routine is suboptimal, but it does work. Matlab precision)
%
% Input:
% 	data = symbols (vector)
% 	wordLength = lenght or words
%
% Output:
% 	words = word encoded time series
%
% requires: 
%
% see also: sym2sym.m, transcode.m, opCalc.m

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
if (nargchk(2,2,nargin)), help(mfilename),return; end
if (nargchk(0,1,nargout)), help(mfilename),return; end

%shape data for routine
if  size(data,1) > size(data,2)
	data = data';
end


for i=1:length(data)-wordLength
	out(i) = str2num(num2str(data(i : i + wordLength-1), '%d'));
end

% this is actually unecessary, but its better for pcolor plots
uniqueOut = unique(out);
for i=1:length(uniqueOut)
	out(out == uniqueOut(i)) = i;
end

%transpose for return
out = out';
