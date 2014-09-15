function [varargout]= eeg_rejectAbs(varargin)

%EEG_rejectAbs - reject abnormal trials by baseline divergence
%
% function [eeg rejects] = eeg_rejectAbs(eeg,critVolt,timeRange)
%
% Reject measurements from an eeg set if the
% absolute value of the measurement in in any
% channel in the trial exceeds the given value.
% The whole trial is discarded then. 
% 
% Input:
%	eeg = eeg-set (trial x time x channel)
%	critVolt = critical Volage
%
% Optional Inputs:
%	timeRange = range of data that is checked
%
% Output:
%	eeg = eeg-set without rejected trials
%	rejects = number of trials discarded
%
% requires: 
%
% see also:ERRP
%

% Copyright (C) 2010 Stefan Schinkel, University of Potsdam
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

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,4,nargin))

%% check number of out arguments
error(nargoutchk(0,3,nargout))

varargin{5} = [];
if ndims(varargin{1}) ~= 3; error('Need eegset of shape [channel x time x trial]');else eeg = varargin{1};end
if isempty(varargin{2}), critVolt = helper_dialog;else critVolt = varargin{2};end
if ~isempty(varargin{3}), tRange = varargin{3}; else tRange = 1:size(eeg,2);end

if ~isempty(varargin{4}), override = 1; else override = 0;end

%% check params
if isnan(critVolt);	error('Cannot proceed without voltage range.');end

%% loop trialwise
rej = [];id = [];
for i=1:size(eeg,3)

	[r id] = max(max(abs(eeg(:,tRange,i)')));

	if r >= critVolt
		rej = [rej i];
	end

end

%if too many rejections
if size(rej,2) > size(eeg,3)/2 & ~override
	reply = input('Discarding more than half the trials. Proceed anyways? Y/N [Y]: ', 's');
	if isempty(reply)
    	reply = 'Y';
	end
	if reply ~= 'Y';
		error('Rejection procedure cancelled.');
	else
		disp(sprintf('\nNOTE:\tMore than half the trials were discarded.'));
		disp(sprintf('\tMake sure you ran eeg_baseline() on the set.'));
	end
end
	
eeg(:,:,rej) = [];

varargout{1} = eeg;
varargout{2} = rej;
varargout{3} = id;
end % main

function params = helper_dialog()
	dlg_returns = inputdlg({'Provide the critial voltage value (in mV):'},'Input voltage range',1);
	if isempty(dlg_returns);params(1) = NaN;else params(1) = str2double(dlg_returns(1));end
end

%function [varargout]= eeg_rejectRange(varargin)
%
%%EEG_REJECTRANGE - reject abnormal trials by voltage range
%%
%% function [eeg rejects] = eeg_rejectRange(eeg,range)
%%
%% Reject measurements from an eeg set if the
%% difference between any two points in any
%% channel in the trial exceeds the given range.
%% The whole trial is discarded then. 
%% 
%% Input:
%%	eeg = eeg-set (chan x time x trial)
%%	range = range in mV
%%
%% Output:
%%	eeg = eeg-set without rejected trials
%%	rejects = number of trials discarded
%%
%% requires: 
%%
%% see also: opTool/eegfun
%%
%
%% Copyright (C) 2008 Stefan Schinkel, University of Potsdam
%% http://www.agnld.uni-potsdam.de 
%%
%% This program is free software; you can redistribute it and/or modify
%% it under the terms of the GNU General Public License as published by
%% the Free Software Foundation; either version 3 of the License, or
%% (at your option) any later version.
%%
%% This program is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU General Public License for more details.
%%
%% You should have received a copy of the GNU General Public License
%% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%% $Log: eeg_rejectRange.m,v $
%% Revision 1.1  2008/03/05 13:03:48  schinkel
%% Initial Import
%%
%
%% debug settings
%debug = 0;
%if debug;warning('on','all');else warning('off','all');end
%
%%% check number of input arguments
%error(nargchk(1,3,nargin))
%
%%% check number of out arguments
%error(nargoutchk(1,2,nargout))
%
%varargin{4} = [];
%if ndims(varargin{1}) ~= 3; error('Need eegset of shape [trial x time x channel]');else eeg = varargin{1};end
%if isempty(varargin{2}), rangeCrit = helper_dialog;else rangeCrit = varargin{2};end
%if ~isempty(varargin{3}), override = 1; else override = 0;end
%
%
%%% loop trialwise
%rej = [];
%for i=1:size(eeg,3)
%	r = range(eeg(:,:,i),2);
%	if sum(r >= rangeCrit) > 1,rej = [rej i];end
%end
%
%%if to many rejections
%if size(rej,2) > size(eeg,3)/2 & ~override
%	reply = input('Discarding more than half the trials. Proceed anyways? Y/N [Y]: ', 's');
%	if isempty(reply)
%    	reply = 'Y';
%	end
%	if ~strcmpi(reply,'y')
%		error('Rejection procedure cancelled.');
%	else
%		disp(sprintf('\nNOTE:\tMore than half the trials were discarded.'));
%		disp(sprintf('\tCheck voltage range'));
%	end
%end
%
%eeg(:,:,rej) = [];
%
%varargout{1} = eeg;
%varargout{2} = rej;
%
%	
%
%end % main
%
%function params = helper_dialog()
%	dlg_returns = inputdlg({'Provide the critial voltage range (in mV):'},'Input voltage range',1);
%	if isempty(dlg_returns);params(1) = NaN;else params(1) = str2double(dlg_returns(1));end
%end
%

