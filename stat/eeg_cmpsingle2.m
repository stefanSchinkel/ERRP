function out = eeg_cmpsingle2(x,y,varargin)

%EEG_CMPSINGLE2 compare single trial ERPS (spatial embedding)
%
% function [out] = cmpsingle2(X,Y,roi,time,samples,alpha,eps,norm)
%
% The function runs and Monte-Carlo-Simulation
% of all possible comparision between two 
% condition stored in EEGlab-like format (i.e.
% EEG = [elec x frame x trial]. The comparison
% is done by employing the rqaci.m algorithm.
%
% The phase space is constructed using time delay 
% embedding of the (averaged) vectors in the ROI. 
%
% The recurrence threshold is taken as
% fraction of the maximum PS diameter.
%
% Input:
% X 	= EEG data 
% Y 	= EEG data 
% roi	= region of interest (def: all)
% time	= time window of interest (def: total)
% nSamp	= no. of Monte-Carlo samples (def: 1000)
% alpha	= alpha level of CI for rqaci.m (def: 5)
% dim 	= embedding dimension (def: 2)
% tau 	= embedding delay (def: 1) 
% eps	= fraction of max PS diameter (def: .05)
% norm	= normod for neighbourhood selection (def: 'max')
%	  see crqa/crp.m and CRPtool for details
%
% Output:
% out	= pcolor-plotable matrix. 
% 	  For colour-codes see cicompare.m
%
% requires: rqaci.m cicompare.m (ERRP), CRPtool
%
% see also: rqaci.m eeg_cmpsingle.m
%
% References:
%
% S. Schinkel, O. Dimigen & N.Marwan: 
% "Selection of recurrence threshold for signal detection", 
% European Physical Journal -Special Topics, 164(1), 45-53 (2008)
%
% S. Schinkel, N. Marwan, O. Dimigen & J. Kurths: 
% "Confidence Bounds of recurrence-based complexity measures",
% Physics Letters A (NN)
%
% Trivia: if the waitbar gets stuck and cannot be closed run:
%	set(0,'ShowHiddenHandles','on')
%	delete(get(0,'Children'))


% Copyright (C) 2007 Stefan Schinkel, University of Potsdam
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


% $Log$

% debug settings
debug = 0;
if debug;warning('on','all');else warning('off','all');end

%just to really kill annoying warnings
warning('off','MATLAB:divideByZero')

% check number of input arguments
error(nargchk(1,10,nargin))

% check number of out arguments
error(nargoutchk(0,1,nargout))

% prevent indexation errors
varargin{9}=[];

% assign parameters
if ~isempty(varargin{1}), roi = varargin{1};else roi= [1:size(x,1)];end
if ~isempty(varargin{2}), timeWindow = varargin{2};else timeWindow=1:size(x,2);end
if ~isempty(varargin{3}), nSamples = varargin{3};else nSamples = 1000;end
if ~isempty(varargin{4}), alpha = varargin{4};else alpha = 5;end
if ~isempty(varargin{5}), dim = varargin{5};else dim = 2;end
if ~isempty(varargin{6}), tau = varargin{6};else tau =  1;end
if ~isempty(varargin{7}), epsFactor = varargin{7};else epsFactor = [];end
if ~isempty(varargin{8}), norm = varargin{8};else norm = 'max';end

% nSample MCS
allCombos = allcomb(1:size(x,3),1:size(y,3));
chosenSamples = randsample(1:size(allCombos,1),nSamples);
allCombos = allCombos(chosenSamples,:);

% a waitbar
h = waitbar(0,'Computing ...','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)

%alloc memory for valX/Y and ciX/Y
valX = zeros(size(allCombos,1),4);
valY = zeros(size(allCombos,1),4);
ciX = zeros(size(allCombos,1),4,2);
ciY = zeros(size(allCombos,1),4,2);



% estimate CIs using rqaci
for i=1:size(allCombos,1)
	
	%check for interupt
	if getappdata(h,'canceling'),delete(h),error('User requested interupt');end

	%extract the data and transpose
	% "live" assignment might also doable, but prone to errors
	dataX = mean(double(x(roi,timeWindow,allCombos(i,1))),1);
	dataY = mean(double(y(roi,timeWindow,allCombos(i,2))),1);
	
	%eps estimation and RP for X
	eps = pss(dataX,dim,tau,norm) *epsFactor;
	rpX = crp(dataX,dim,tau,eps,norm,'sil');

	%eps estimation and RP for Y
	eps = pss(dataY,dim,tau,norm) *epsFactor;
	rpY = crp(dataY,dim,tau,eps,norm,'sil');

	%estimation of CIs
	[valX(i,:) ciX(i,:,:)] = rqaci(rpX,nSamples,alpha);
	[valY(i,:) ciY(i,:,:)] = rqaci(rpY,nSamples,alpha); 

	%update waitbar
	waitbar(i/nSamples,h,sprintf('Performing comparison %d/%d',i,nSamples))
	
end	

%waitbar must be deleted, not closed
delete(h)

%RQA measures available (for plotting/summary)
measures = {'DET','L','LAM','TT'};

%alloc memory for output
out = zeros(4,size(allCombos,1));

% check using cicompare
for ii = 1:4
	out(ii,:) = cicompare( squeeze(ciX(:,ii,:))',squeeze(ciY(:,ii,:))' );
end

% if output is not assigned, we print a summary and a plot
if nargout == 0,
	
	%log params so we can replicate
	disp(sprintf('Summary statistic for parameters:\nROI: [%s]\ntime: %d-%d \t samples: %d\t alpha: %d\neps: %02.2f\t norm: %s',...
		num2str(roi),timeWindow(1),timeWindow(end),nSamples,alpha,epsFactor,norm));
	
	for ii = 1:4
		%% print a summary statistic	
		percentMinusOne =  numel(find(out(ii,:) == -1))/nSamples*100; 	% x is larger
		percentZero =  numel(find(out(ii,:) == 0))/nSamples*100;		% both are equal
		percentOne =  numel(find(out(ii,:) == 1))/nSamples*100;			% y is larger


		%summary statistic
		disp(sprintf('(%s)\txLarger: %3.2f%%\t equal: %3.2f%%\t yLarger: %3.2f%%',... 
			measures{ii},percentMinusOne,percentZero,percentOne));

		%plotting
		subplot(4,1,ii),
		pcolor([out(ii,:);out(ii,:)]);
		set(gca,'Ytick',[]);
		caxis([-1 1]); 
		shading flat;
		ylabel(measures{ii})

	end
end
