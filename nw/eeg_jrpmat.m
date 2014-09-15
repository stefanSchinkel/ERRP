function varargout = eeg_jrpmat(varargin)

% EEG_JRPMAT - JRP-based similarity matrix of an EEG set
%
% function r = eeg_jrpmat(eeg,dim,tau,window [,eps,norm])
%
% It is advisable to estimate embedding delays and dimension
% for each channel and trial individually. Note though that
% the final size of the RPs should match, otherwise the 
% smallest individual plot determines the final size.
%   
% The shape of the EEG set matches those used in EEGlab. 
% (channel x time/frame x trial)
%
% Required inputs:
%	eeg : EEG-data (chan x frame x trial)
%	dim : embedding dimension (1/1 per channel/1 per channel & trial)
%	tau : embedding delay (1/1 per channel/1 per channel & trial)
%
% Optional parameters: 
%	win : a time window of interest 
%	eps  : recurrence threshold (def: .1)
%	norm : recurrence criterion (def: 'fan')
%
% Output:
%	r = (chan x chan) similarity matrix
%
% IMPORTANT NOTE: 
% For the recurrence criterion ('norm'), all methods available  in crp.m 
% can be used. The default is fixed amount of nearest neighbours.
%
% THE USE OF ANY OTHER RECURRENCE CRITERION IS STRONLGY DISCOURAGED. 
%
%
% Requires: CRPtool, 
%
% See also: ERRP (eeg_delay,eeg_dim), CRPtool
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
error(nargchk(3,6,nargin))


varargin{7} = [];

if ~isempty(varargin{1}),eeg = varargin{1}; 	else error(errID1,'No data supplied'); end
if ~isempty(varargin{2}),dim = varargin{2}; 	else error(errID1,'No dimension supplied'); end
if ~isempty(varargin{3}),tau = varargin{3}; 	else error(errID1,'No delay supplied'); end
if ~isempty(varargin{4}),win = varargin{4}; 	else win = {1:size(eeg,2)};end
if ~isempty(varargin{5}),eps = varargin{5}; 	else eps =.1; end
if ~isempty(varargin{6}),norm = varargin{6}; 	else norm = 'fan';end

if ~iscell(win), win = {win};end
%parameters
nChans = size(eeg,1);
nTrials = size(eeg,3);

if length(dim) == 1
	dim = ones(nTrials,nChans)*dim;
elseif length(dim) == nChans
	dim = repmat(dim(:)',nTrials,1);
end

if length(tau) == 1
	tau = ones(nTrials,nChans)*tau;
elseif length(tau) == nChans
	tau = repmat(tau(:)',nTrials,1); 
end




for ii = 1:nTrials
	
	disp(sprintf('%s: Processing trial %d of %d',datestr(now),ii,nTrials))
	
	clear r RP
	% construct indiviual RPs and store in cell 
	% as they can differ in size due to indiviual embedding
	for i=1:nChans
		RP{i} = crp(double(eeg(i,:,ii)),dim(ii,i),tau(ii,i),eps,norm,'sil');
	end

	for k =1:length(win)	

		% compute joint recurrence rates of sliced out windows
		for i=1:nChans
			for j=i:nChans
				clear JRP
					rpi = RP{i}(win{k},win{k});
					rpj = RP{j}(win{k},win{k});
					JRP = rpi.*rpj;
					% r has to be normalised by the maximum JRR possible, which
					% is the MINIMUM of the indiviual Recurrence Rates
					warning off MATLAB:divideByZero	

					r(i,j) = mean(JRP(:)) / (min(mean(rpi(:)),mean(rpj(:))));
					r(j,i) = r(i,j);


			end %inner chan loop
		end %out chan loop

	   out{k}(:,:,ii) = r;

	end %win
	
end % trial loop


varargout{1}= out;
