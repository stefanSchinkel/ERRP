function theVar = selectVariable()

% get all variables in WS
vars = evalin('base','who');

% dialog for selection
[s] = listdlg('PromptString','Select a variable',...
	'Name','Select Variable',...
	'InitialValue',[],...
	'ListString',vars)

% proceed only on selection
if isempty(s),	theVar = [];return;end

% loop over possible multiselection
for i=1:numel(s)
	if evalin('base',['isstruct(' vars{s(i)} ')'])

		% if we encounter a struct, we open it
		fields = evalin('base',['fieldnames( ' vars{s(i)} ')' ]);   
		[ss] = listdlg('PromptString','Select field',...
		'Name','Select Field','InitialValue',[],'ListString',fields);
		
		if ~isempty(ss)
			theVar{i} = [ vars{s(i)} '.' fields{ss} ]
		else
			return
		end
	else
		theVar{i} = vars{s(i)};
	end
end
