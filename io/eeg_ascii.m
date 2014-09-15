function eeg_ascii(eeg,varargin) 

%EEG_ASCII save EEG set as multiple ASCII files
%
% function eeg_ascii(eeg,targetDir,prefix)
%
% The function store an epoched EEG set to disk
% in multiple ASCII files, one for each trial.
% The target directory has to exist. The prefix
% is prepended to a "_trial%03d.dat".
%
% The function uses dlmwrite to handle single 
% precision values. 
%
% Input:
% 	eeg = EEG-set (chan x time x epoch)
%
% Parameters:
%	targetDir = directory to store in (def: cwd)
%	prefix = string to prepend (def: eeg_trial%d)
%
% Output:
%	as many file as trials in the format: chan x time
%
% requires:  
% 
% see also: ERRP
%

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


% set debug
debug=true;
if debug;warning('on','all');else warning('off','all');end

% I/O check and assingment
error(nargchk(1,3,nargin))
error(nargoutchk(0,0,nargout))

%% prevent indexation errors
varargin{3} = [];
if ~isempty(varargin{1}), targetDir = varargin{1};else targetDir = pwd;end
if ~isempty(varargin{2}), prefix = varargin{2};else prefix = 'eeg';end

% note that storage dirs have to exist and that any previous data 
% will be overwritten

%change to target directory
theDir = pwd;
try
	cd(targetDir)
catch
	disp('Target directory does not exist. Creating it')
	mkdir(targetDir)
end
cd(theDir);


nTrials = size(eeg,3);
%loop over subjects

if nTrials == 1

	if strcmp(prefix,'eeg')
		fileName  = fullfile(targetDir,sprintf('%s_average.dat',prefix))
	else
		fileName  = fullfile(targetDir,sprintf('%s.dat',prefix))
	end
	
	dlmwrite(fileName,eeg(:,:,1),'delimiter','\t','newline','unix');
		
	% just some into
	if debug,	disp(sprintf('Average written to %s',fileName));end

else	

	for i = 1:nTrials

		fileName  =  fullfile(targetDir,sprintf('%s_trial%03d.dat',prefix,i));

		%we have to use dlmwrite cause otherwise we'd have to
		%convert to doubles, but the data is single precision only
		dlmwrite(fileName,eeg(:,:,i),'delimiter','\t','newline','unix');

		% just some into
		if debug,
			disp(sprintf('Trial %d of %d written to %s', i,nTrials,fileName));
		end

	end %trial loop
	
end % nTrials switch

