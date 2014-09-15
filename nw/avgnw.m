function r = avgnw(x)

% AVGNW - compute an average adjacency matrix
%	
%	This function takes a set of adjacency matrices
%	and computes their average (ie. commonly found links)
%	If mulitple realisations of a process are present this
%	may work better than averaging data first. 
%
%	The input set can have multiple realisations and 
%	the matrix at consecutive time steps. 
%
% Required inputs:
%	x = a set of adjacency matrices in either 3D or 4D
%		3D: [ i x j x realisation] or 
%		4D: [ i x j x time x realisation]
%
% Output:
%	r = average network
%		3D input: [ i x i ]
%		4D input: [ i x j x time]
%
% Requires:  
%
% See also:
%
if ndims(x) == 3,
	flag3D = true;
elseif ndims(x) == 4
	flag3D = false;
else 
	error('Input has to be 3D or 4D')
end

% for 3D we just average
if flag3D
	r = mean(x,3);
else
	r = mean(x,4);
end

%convert to single to save memory (also rounds properly
r = uint8(r);
