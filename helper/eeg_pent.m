function [h h0] = eeg_pent(eeg,dim,tau,varargin)

%EEG_PENT permutation entropy of an EEG-set
% function [h h2] = eeg_pent(eeg,dim,tau[,,ws,ss])
%
% Input: 
%	eeg = eeg set
%	dim = order/dimension used
%	tau = delay used
%
% Parameters
%	ws = window size (def: no windowing)
%	ss = step size (def: no windowing)
%
% Output:
% 	h = normalised permutation entropy
%	h0 = permutation entropy
%
%


% check input 
if nargin < 2
	help(mfilename)
	error('EEG_PENT:not enough input');
end

varargin{3} = [];
if ~isempty(varargin{1}), ws = varargin{1}; else ws = []; end
if ~isempty(varargin{2}), ss = varargin{2}; else ss = 1; end

% size for set

nChan = size(eeg,1);
nTrials = size(eeg,3);


for iChan = 1:nChan
	for iTrial = 1:nTrials
		[h0(iChan,:,iTrial) h(iChan,:,iTrial)]  =  pent(eeg(iChan,:,iTrial),dim,tau,ws,ss );	
	end %iTrial
end %iCahn

