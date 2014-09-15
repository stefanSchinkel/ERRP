function varargout = findFiles(varargin)
%
%FINDFILES - find all files matching a pattern
%
% function files = findFiles(dir,pattern)
%
% use 'find' to recursively search for files 
% matching a given pattern. The function will
% return a cell array containing all files with 
% absolute paths.
%
% The optional case switch toggles case sensitivity.
% By default case insensitive find is used. Set the
% switch to 1 to be case sensitive.
%
% Input:
%	dir	= directory to search (relative/absolute)
%	pattern	= pattern to match
%	case	=  case switch (1-case-sensive, )
%
%
% Output:
% 	files	= file list (sorted)
%
% IMPORTANT NOTE
%
% The order in which find returns the results is not always 
% the same across machines. To be sure it is comparable,
% the output is sorted.
%
% requires: UNIX
%

flagDebug = false;

varargin{4} = [];
% sanity check 
if ~ischar(varargin{1}) | ~ischar(varargin{2})
	help(mfilename)
	disp('ERRP:helper:findFiles - string input required');
	return
else
	searchDir = varargin{1};
	pattern = varargin{2};
end
% case-sensistive matching ?
if varargin{3} == 1,	caseFlag = 'name';else	caseFlag = 'iname';end

%first up assemble command
currentDir = pwd;
idSlash = strfind(searchDir,'/');

%check if path is absolute
if ~isempty(idSlash) 

	if idSlash(end) == length(searchDir)
	
		workDir = searchDir(1:end-1);
		if flagDebug, disp('Removing trailing slash'); end
	end
	if idSlash(1) == 1
		
		workDir = searchDir;
		if flagDebug, disp('Assuming absolute path');end
	end

else

	workDir = fullfile(currentDir,searchDir);
	if flagDebug, disp('Assuming relative path');end
end

%check iff directory exists
if ~isdir(workDir)
	error('ERRP:helper:findFiles - search dir does not exist');
end

% assemble find commmand
cmd = sprintf('find %s -%s ''%s'' ',workDir,caseFlag,pattern);

% evaluate command
[a b] = unix(cmd);

%catch potential error
if 0 ~= a,	
	disp('Error find executing command');
	return
end

% check if b contains actual data or only '\n' 
% which means nothing was found
if sum(isstrprop(b,'wspace')) == length(b)	
	disp('ERRP:helper:findFiles - No matching files found');
	return
end

%split by newlines to assemble output
out = textscan(b,'%s','Delimiter','\n');

files = {};
cnt =1;
for iFile = 1:length(out{1})
	tmpFile = out{1}{iFile};
	
	%sometimes find will return ''
	% for various reasons
	if ~isempty(tmpFile)
		files{cnt} =  strrep(tmpFile,'./','');
		cnt = cnt+1;
	end

end

% set return values
% either a message
% or sorted(!) file list
if isempty(files)	
	disp('ERRP:helper:findFiles - No matching files found');
	return
else
	varargout{1} = sort(files);
end
