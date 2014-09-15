function [varargout] = eeg_crqa(varargin)

%
% TODO : accept eps as array, indiviually for each chan/trial pair
%		store params
%
%
% EEG_CRQA() - run RQA on a whole EEGlab-like,epochised EEG data array.
%
% function [varargout] = eeg_crqa(eeg,dim,tau,eps,ws,ss [,method,norm,lMin,vMin,theiler])
%   
%
% Required inputs:
%   eeg :   EEG-data (chan x frame x trial)
%   dim	:	embedding dimesion 
%   tau	:	embedding delay
%   eps	:	recurrence threshold
%   ws	:	window size
%   ss	:	step size
%
% Optional parameters:
%
%   method	: method for neighbour detection (def: 'max')
%	maxnorm     - Maximum norm.
%	euclidean   - Euclidean norm.
%	minnorm     - Minimum norm.
%	nrmnorm     - Euclidean norm between normalized vectors
%	maxnorm     - Maximum norm, fixed recurrence rate.
%	fan         - Fixed amount of nearest neighbours.
%	inter       - Interdependent neighbours.
%	opattern    - Order patterns recurrence plot.
%
%   norm	: [0|1] normalise data (def: 1)
%   lMin	: minimal diagonal line length (def: 2)
%   vMin	: minimal vertical line length (def: 2)
%   theiler	: theiler window (def: 1)
%
% Output:
%   rqa	= eeg-like structure (chan X frame X epoch X measure)
%   params = struct containing RQA parameters
%
% Requires: CRPtool, 
%
% See also: crqa(), crp(), CRPtool, ERRP, 

%
% Copyright (C) 2009 Stefan Schinkel, schinkel@agnld.uni-potsdam.de 
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

%error identifiers
errID1 = 'ERRP:eeg_crqa:missingParams';


% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(1,11,nargin))

%% check number of out arguments
error(nargoutchk(0,2,nargout))

varargin{12} = [];

if ~isempty(varargin{1}),eeg = varargin{1}; 	else error(errID1,'No data supplied'); end
if ~isempty(varargin{2}),dim = varargin{2}; 	else error(errID1,'No dimension supplied'); end
if ~isempty(varargin{3}),tau = varargin{3}; 	else error(errID1,'No delay supplied'); end
if ~isempty(varargin{4}),eps = varargin{4}; 	else eps = []; end
if ~isempty(varargin{5}),ws = varargin{5}; 		else ws = size(eeg,2);end
if ~isempty(varargin{6}),ss = varargin{6}; 		else ss = size(eeg,2);end
if ~isempty(varargin{7}),meth = varargin{7}; 	else meth = 'max'; end
if ~isempty(varargin{8}),norm = varargin{8}; 	else norm = 'norm';end
if ~isempty(varargin{9}),lMin = varargin{9}; 	else lMin = 2;end
if ~isempty(varargin{10}),vMin = varargin{10}; 	else vMin = 2;end
if ~isempty(varargin{11}),theiler=varargin{11};	else theiler = 1;end

% get some params
nChans = size(eeg,1);
nX = size(eeg,2);
nTrials = size(eeg,3);

%we want to allow a fixed value for dim tau,eps or and 
%individual on - PER CHANNEL
if length(dim) == 1, dim = ones(1,nChans)*dim;end
if length(tau) == 1, tau = ones(1,nChans)*tau;end
if length(eps) == 1, eps = ones(1,nChans)*eps;end

%alloc enough memory for data

%size of all RPs
dataLength = (dim-1).*tau;

%estimate outLength per channel
for i=1:nChans
	outLength(i) = length(1:ss:nX-dataLength(i)-ws);
end 

% allocate memory 
rqa = zeros(nChans,nTrials,max(outLength),8);

%loop over the data, by trial
for i = 1:nTrials
	for j = 1:nChans % and elecs

			% extract data as double
			data = double(eeg(j,:,i));
			%make the RP
			if strcmp(meth,'op')
				RP = opcrp(data,dim(j),tau(j));
			else
				RP = crp(data,dim(j),tau(j),eps(j),norm,meth,'sil');
			end
			%we loop over the plot, NOT the data
			%out(k,:)  = crqa(data,dim(j),tau(j),eps(j),[],[],lMin,vMin,theiler,norm,meth,'sil');

			for k = 1:ss:length(RP)-ws
				out(k,:)  = opQualify(RP(k:k+ws,k:k+ws),theiler,lMin,vMin);
			end 

			nPoints = size(out(1:ss:end,1));
			
			% store in 'squeeze' mode
			rqa(j,i,1:nPoints,:) = out(1:ss:end,:);
	end
end 
% if params are required
if nargout == 2
	params = struct();
	params.dim = dim;
	params.tau = tau;
	params.eps = eps;
	params.ws = ws;	
	params.ss = ss;	
	params.meth = meth;
	params.norm = norm;
	params.lMin = lMin;
	params.vMin = vMin;
	params.theiler = theiler;	
	params.timeIds = ws/2:ss:nX-min(dataLength)-ws/2;
	
	varargout{2} = params;

end

varargout{1} = permute(rqa,[1 3 2 4]);
