function [varargout] = eeg_permtest(varargin)

% EEG_PERMTEST - run a permutation test on an EEG/RQA set
%
% function [varargout] = eeg_permtest(eeg,eeg2 [,nPerms])
%   
%
% Required inputs:
%	eeg1 :   EEG-set or RQA-set(chan x frame x trial )
%	eeg2 :   EEG-set or RQA-set(chan x frame x trial [x measure])
%
% Options:
%   nPerms: number of permutations (def: 500)
%
% Output:
%   z	= chan X x frame [x measure]array containing z values
%   p	= chan X x frame [x measure]array containing two sided p-values
%   p0	= chan X x frame [x measure]array containing p-values of permutation test
%
% Requires: permtest
%
% See also: CRPtool, ERRP

%
% Copyright (C) 2008 Stefan Schinkel, schinkel@agnld.uni-potsdam.de 
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

% $Log$


% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(2,3,nargin))

%% check number of out arguments
error(nargoutchk(0,3,nargout))

varargin{4} = [];

if ~isempty(varargin{1}),eeg1 = varargin{1}; 	else help(mfile),error(); end
if ~isempty(varargin{2}),eeg2 = varargin{2}; 	else help(mfile),error(); end
if ~isempty(varargin{3}),nPerms = varargin{3}; 	else nPerms = 500; end

% check for equal size
if ~(size(eeg1) == size(eeg2)); 
	help(mfilename),error('EEG/RQA sets must match in size')
end	

% what are we dealing with?
if ndims(eeg1) == 3 %EEG-set
	flagEEG = 1;
elseif ndims(eeg1) == 4 %RQA
	flagEEG = 0;
else
	help(mfilename),error('Data size matches neither EEG nor RQA set!')
end

% EEG-routine
if flagEEG 
	for i=1:size(eeg1,1)
		%size(squeeze(eeg1(i,:,:)))
		[z(i,:) p(i,:) p0(i,:)] = permtest2(squeeze(eeg1(i,:,:))',squeeze(eeg2(i,:,:))',nPerms);
	end
else
	for i=1:size(eeg1,1)
		for j = 1:size(eeg1,4);
		%size(squeeze(eeg1(i,:,:)))
			[z(i,:,j) p(i,:,j) p0(i,:,j)] = permtest2(squeeze(eeg1(i,:,:,j))',...
			squeeze(eeg2(i,:,:,j))',nPerms);
		end
	end
end
	
varargout{1} = z;
varargout{2} = p;
varargout{3} = p0;

