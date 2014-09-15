function varargout=permtest2(varargin)

% function permtest2.m
%
% Usage:
%
% [z p P] = permtest2(x,y,n)
% 
% Input:
%	x = Trails X Epoch
%	y = Trails X Epoch
%	n = number of permutations 
%
% Output:
%	z = z-value as derived from erfinv (follows normcdf)
%	p = p-value of two-sided test
% 	P = p-value of permutation test
%
%
% Requires: quantileNormal.m 
% 
% See also: permtest.m airtight.m bulletproof.m 
% 

% $Log: permtest2.m,v $
% Revision 1.7  2007/05/24 09:18:16  schinkel
% Initial Import
%
% Revision 1.6  2006/07/18 15:55:11  schinkel
% Added Funtionality for Matlab 6. Automatic switching included
%
% Revision 1.4  2006/05/30 08:31:47  schinkel
% Added proper p calculation. See normcdf,quantileNormal.m
%
% Revision 1.3  2006/05/11 15:05:05  schinkel
% Fixed Bug in real Pvalue calculation and increased computing speed
%
% Revision 1.2  2006/05/10 10:21:04  schinkel
% Added P-Value calculation.
%
% Revision 1.1.1.1  2006/03/31 12:50:36  schinkel
% Initial Import
%

debug=false;

V=version;
MR=str2num(V(1)); %% major Release Number

%% check input

if nargin <2 || nargin >4, error('Bad Input. Usage:[z p P] = permtest2(x,y,n)');end

%% avoid indexation error
varargin{4}= []; 

if ~isempty(varargin{1}), x=varargin{1}; else error('Usage:[z p P] = permtest2(x,y,n)');end
if ~isempty(varargin{2}), y=varargin{2}; else error('Usage:[z p P] = permtest2(x,y,n)');end
if ~isempty(varargin{3}), nPerms=varargin{3}; else nPerms=1000; end

if ndims(varargin{1}) ~= ndims(varargin{2}),
	error('Dimension mismatch. Exiting');
end

%% reset RNG - needed for repetitions
%rand('state',0);

%% det. necc. values

nT1=numel(x(:,1));
nT2=numel(y(:,1));
nTotal=nT1+nT2;

%% join matrices
tXY=[x',y']';

ostat=nanmean(x)-nanmean(y);
stats=[];

[ignore k]=sort(rand(nTotal,nPerms)); %% i == [200x1500]

if MR >= 7%%%% when running on Mlab 7.0 ++ only use
	for i=1:nPerms
		stats(:,i)=nanmean(tXY(k(1:nT1,i),:))-nanmean(tXY(k(1+nT1:nTotal,i),:));
	end
else
	for i=1:nPerms
		stats(i,:)=nanmean(tXY(k(1:nT1,i),:))-nanmean(tXY(k(1+nT1:nTotal,i),:));
	end
	stats=stats';
end


%% compute temporary P - values
P = mean((stats <= ostat' * ones(size(ostat, 1), nPerms))'); % besser machen;

%% look up z-value
z = quantileNormal(P);

%% convert temporary p-value to twosided p-value
p=min(2*P,2*(1-P));


varargout{1} = z;
varargout{2} = p;
varargout{3} = P;


%%%
%%% that does work, but it only for large values of df ( pbly. df > 20++)
%%%
%%% convert z value to real p value
%%% compute degrees of freedom, excluding NaNs cf. ttest2.m
%
%xnans=isnan(x);
%if any(xnans(:))
%	nx=sum(~xnans,1);
%else
%	nx=size(x,1);
%end
%
%ynans=isnan(y);
%if any(ynans(:))
%	ny=sum(~ynans,1);
%else
%	ny=size(y,1);
%end
%
%% degrees of freedom, without nans
%df=nx+ny-2;

