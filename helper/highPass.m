function [out] = highPass(in,cutoff,sampRate,order)

%HIGHPASS high-pass filter a data vector
%
% function [out] = highPass(in,cutoff,sampRate,[order]);
%
% Lowpass filter a signal at the given cutoff frequency using 
% a Butterworth filter of a given order. The sampling rate has 
% to be given as sampRate. The order is not mandatory and 
% defaults to 4. 
%
% The function returns the filtered signal in out.
%
% requires: Signal Processing Toolbox
%
% See also: lowPass.m
%

% $Log$
%

debug=true;
if debug;warning('on','all');else warning('off','all');end

%% check number of input arguments
error(nargchk(3,4,nargin))

%% check number of out arguments
error(nargoutchk(0,1,nargout))

%% check input 
if ~isvector(in), error('lowPass requires the input to be a vector');end
if ~isnumeric(sampRate), error('Sampling rate has to be a numeric value');end

if 	nargin<4, 
	order = 2; 
elseif 	nargin == 4, 
	if ~isnumeric(order), 
		disp('No numeric value for ORDER supplied. Using default (2)');
		order = 2;
	end 
end

% construct high-pass filter
[b a]=butter(order,(cutoff/(sampRate/2)),'high');

% Use the filter
out = filtfilt(b,a,in);

% no output is specified plot the original and the filtered data
if nargout < 1,
	figure;
	subplot(2,1,1);plot(in);
	title('Original time series');
	axis tight;
	subplot(2,1,2);plot(out);
	title(sprintf('Data high-pass filtered at %3d Hz using Butterworth filter of order %2d',...
		cutoff,order));
	axis tight;
end
