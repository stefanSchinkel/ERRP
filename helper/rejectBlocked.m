
function [varargout]= rejectBlocked(varargin)

%EEG_rejectDiff - reject abnormal trials by no change in slope
%
% function [eeg rejects] = rejectBlocked(eeg)
%
% Reject measurements from an eeg set if the
% value of a channel does not change for 
% longer a pre-determined number of sample point.
% 
% Input:
%	eeg = eeg-set (channel x time x trial)
%	critDur = critical duration (def: 100 samples)
%
% Output:
%	eeg = eeg-set without rejected trials
%	rejects = number of trials discarded
%
% requires: 
%
% see also:ERRP
%





% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,3,nargin))

%% check number of out arguments
error(nargoutchk(0,3,nargout))

varargin{4} = [];
if ndims(varargin{1}) ~= 3; 
	error('Need eegset of shape [channel x time x trial]');
else 
	eeg = varargin{1};
end
if isempty(varargin{2}); 
	warning('Using default duration. 100 samples');
	critDur = 1000;
else 
	critDur = varargin{2};
end

if ~isempty(varargin{3}), 
	flagOverride = 1; 
else 	
	flagOverride = 0;
end

nChan = size(eeg,1);
nFrame = size(eeg,3);

%% loop trialwise
rej = [];

for iFrame=1:size(eeg,3)

	for iChan = 1:nChan		
		try
			d(iChan) = maxConsElements( diff(eeg(iChan,:,iFrame)) ,0);
		catch 
			d(iChan) = 1;
		end
	end  %iChan

	if any(d > critDur)
		rej = [rej iFrame];
	end
end
%if to many rejections
if size(rej,2) > size(eeg,3)/2 & ~flagOverride
	reply = input('Discarding more than half the trials. Proceed anyways? Y/N [Y]: ', 's');
	if isempty(reply)
    	reply = 'Y';
	end
	if reply ~= 'Y';
		error('Rejection procedure cancelled.');
	else
		disp(sprintf('\nNOTE:\tMore than half the trials were discarded.'));
	end
end
	
eeg(:,:,rej) = [];

varargout{1} = eeg;
varargout{2} = rej;

end % main
