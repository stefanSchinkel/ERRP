function varargout = eeg_jrpmat2(varargin)

% EEG_JRPMAT2 - JRP-based similarity matrix of an EEG set
%
% function r = eeg_jrpmat2(eeg,window [,eps,norm])
%
% The function works analagous to eeg_jprmat, but the individual
% RPs are computed only for the window of interest, and embedding 
% is not support. 
%   
% The shape of the EEG set matches those used in EEGlab. 
%
% (channel x time/frame x trial)
%
% Required inputs:
%	eeg : EEG-data (chan x frame x trial)
%
% Optional parameters: 
%	win : a time window of interest 
%	eps  : recurrence threshold (def: .1)
%	norm : recurrecen criterion (def: 'fan')
%
% Output:
%	r = (chan x chan) similarity matrix
%
% IMPORTANT NOTE: 
% For the recurrence criterion ('norm'), all methods available  in crp.m 
% can be used. The default is fixed amount of nearest neighbours.
%
% THE USE OF ANY OTHER RECURRENCE CRITERION IS  DISCOURAGED. 
%
%
% Requires: CRPtool, 
%
% See also: ERRP, CRPtool
% 
% Reference: 
%
% Schinke, Zamora-Lopez, Dimigen, Sommer and Kurths (2011), 
% "Functional network analysis reveals differences in the semantic priming task",
% Journal of Neuroscience Methods 
% doi:10.1016/j.jneumeth.2011.02.018
%

%
% Copyright (C) 2011 Stefan Schinkel, schinkel@physik.hu-berlin.de 
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


%error identifiers
errID = 'ERRP:eeg_jrpmat:missingParams';


% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,4,nargin))


varargin{5} = [];

if ~isempty(varargin{1}),eeg = varargin{1}; 	else error(errID1,'No data supplied'); end
if ~isempty(varargin{2}),win = varargin{2}; 	else win = 1:size(eeg,2);end
if ~isempty(varargin{3}),eps = varargin{3}; 	else eps =.1; end
if ~isempty(varargin{4}),norm = varargin{4}; 	else norm = 'fan';end

%parameters
nChans = size(eeg,1);
nTrials = size(eeg,3);

for ii = 1:nTrials
	
	disp(sprintf('ERRP:jprmat2: %s: Processing trial %d of %d',datestr(now),ii,nTrials))
	
	clear r RP
	% construct indiviual RPs and store in cell 
	% as they can differ in size due to indiviual embedding
	for i=1:nChans
		RP{i} = crp(double(eeg(i,win,ii)),1,1,eps,norm,'sil');
	end

	% compute joint recurrence rates of sliced out windows
	for i=1:nChans
		for j=i:nChans
			clear JRP
			JRP = RP{i}.*RP{j};
			% r has to be normalised by the maximum JRR possible, which
			% is the MINIMUM of the indiviual Recurrence Rates
			rpi=RP{i};

			r(i,j) = mean(JRP(:)) / mean(rpi(:));
			r(j,i) = r(i,j);


			end %inner chan loop
		end %out chan loop

	   varargout{1}(:,:,ii) = r;

	end %win
	
end % trial loop


