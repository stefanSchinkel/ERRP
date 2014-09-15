function errp()

% ERRP- visualise, compare, analyse EEG/RQA data
%
%
% Input:
%	none = taken from GUI
%
% Output:
%
%
% requires: ERRP
%
% see also: opTool, ERRP
%

% Copyright (C) 2008 Stefan Schinkel, University of Potsdam
% http://www.agnld.uni-potsdam.de/~schinkel/ 

% $Log$

global debug 
debug = 1;
if debug;warning('on','all');else warning('off','all');end

screenSize = get(0,'Screensize');
vars = evalin('base','who');
wsVars = {vars{1:length(vars)}};

figHandle = figure('Name','ERRP',... 
		'Position',[0,0,300,500],... 
		'Color',[.801 .75 .688],... 
		'NumberTitle','off',...
		'Tag','mainFigure',... 
		'Visible','off',...
		'Menubar','none');

% figure props
errpLayout

end %main

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%		FILE MENU								%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function loadData(source,eventdata)
	
	figHandle = get(get(source,'Parent'),'Parent');
	
	setState('BUSY ... ');	
	
	[file,path] = uigetfile('*.mat','Select the Matlab-file');
	
	if file
		evalin('base',sprintf('load %s%s',path,file));
	else 
		setState('ready');	
		return;
	end
	
	vars = evalin('base','who');
	wsVars = {vars{1:length(vars)}};
	set(findobj(figHandle,'Tag','vars'),'String',wsVars)
	set(findobj(figHandle,'Tag','chanList'),'Value',1);	

	% update vars
	refreshData([],[],figHandle);
	
	% reset state text	
	setState('ready');	

end %loadData	

function clearData(source,eventdata)

	figHandle = get(get(source,'Parent'),'Parent');
	setState('BUSY ... ');	
	
	vars = evalin('base','who');
	[s] = listdlg('PromptString','Select a variable to be cleared',...
		'Name','Select Variable',...
		'InitialValue',[],...
		'ListString',vars);
	for i=1:length(s);
		evalin('base',sprintf('clear %s',vars{s(i)}));
	end

	% update vars
	refreshData([],[],figHandle);
	
	% reset state text	
	setState('ready');	
	
end %clearData	

function refreshData(source,eventdata,varargin)
	
	if isempty(varargin)
		figHandle = get(get(source,'Parent'),'Parent')
	else
		figHandle = varargin{1};
	end
	figHandle
	setState('BUSY ... ');	
	
	vars = evalin('base','who');
	wsVars = {vars{1:length(vars)}};
	set(findobj(figHandle,'Tag','vars'),'String',wsVars)
	set(findobj(figHandle,'Tag','chanList'),'Value',[]);	
	
	setState('ready');	
	refresh(figHandle);
	
end %refreshData


function closeFig(source,eventdata)
	figHandle = get(get(source,'Parent'),'Parent');
	close(figHandle);
end %end closeFig



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%		PLOT MENU								%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plotAvg(source,eventdata,varargin)

	%% aquire fig handle and update text
	figHandle = get(get(source,'Parent'),'Parent');
	setState('BUSY ...');


	%% refresh data source 
	if ~getData(figHandle);
		setState('ready');
		return
	end
	
	%% get GUI data
	data = guidata(figHandle);
	
	if ~isfield(data,'elecs') || isempty(data.elecs)
		errordlg('No electrodes chosen.','Missing Electrode Error');
		return
	end
	
	%% make ERP 
	nCond = data.nCond;
	for iCond = 1:nCond
		erp{iCond} = mean(mean(data.eeg{iCond}(data.elecs,:,data.e0:data.e1),1),3);
	end

	% get timescale
	if isfield(data,'timeScale')
		ts = data.timeScale;
	else
		ts = 1:length(erp{1});
	end
	
	%% plot
	figure;
	hold all
	for iCond = 1:nCond
		if isempty(varargin)
			plot(ts,erp{iCond});
		else
			disp('Plotting smoothed data');
			plot(ts,movavg(erp{iCond}));
		end
	end
	
	axes2origin	
	legend(data.vars)
	ylabel('\muVolt');
	xlabel('time');

	% assemble title string
	str = ' ';
	for i=1:numel(data.elecs)
		if isfield(data,'label')
			str = sprintf('%s %s',str, data.label{data.elecs(i)});
		else
			str = sprintf('%s %d',str,data.elecs(i));
		end
	end
	
	title(sprintf('Average at%s',str));
	
	% update busytext
	setState('ready');

end %% end plotAvg


function plotDifference(source,eventdata)

	%% aquire fig handle and update text
	figHandle = get(get(source,'Parent'),'Parent');
	setState('BUSY ...');


	%% refresh data source 
	if ~getData(figHandle);
		setState('ready');
		return
	end
	
	%% get GUI data
	data = guidata(figHandle);
	
	if ~isfield(data,'elecs') || isempty(data.elecs)
		errordlg('No electrodes chosen.','Missing Electrode Error');
		return
	end
	
	
	% construct difference iff possible
	if data.nCond ~= 2
		errordlg('Too many datasets','This only makes sense for 2 sets');
		
		% update busytext
		setState('ready');
		return
	end
		
	% no. of sets ok, continue
	for iCond = 1:2
		erp{iCond} = mean(mean(data.eeg{iCond}(data.elecs,:,data.e0:data.e1),1),3);
	end

	% get timescale
	if isfield(data,'timeScale')
		ts = data.timeScale;
	else
		ts = 1:length(erp{1});
	end
	
	% plot difference curves
	figure;
	plot(ts,erp{1}-erp{2});

	%select figure and fancy plot
	axes2origin	
	ylabel('\muVolt');
	xlabel('time');

	% assemble title string
	str = ' ';
	for i=1:numel(data.elecs)
		if isfield(data,'label')
			str = sprintf('%s %s',str, data.label{data.elecs(i)});
		else
			str = sprintf('%s %d',str,data.elecs(i));
		end
	end
	
	% add title
	title(sprintf('Difference %s-%s at%s',data.vars{1},data.vars{2},str));

	% update busytext
	setState('ready');

end %% end plotAvg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	generic helper functions - used by callbacks	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setState(state)
	set(findobj('Tag','busytext'),'String',sprintf('State: %s',state));
end %set state

%% update the epochs of the selected set
function selectionCallback(source,eventdata)
	

	% aquire fig handle and set busytext
	figHandle = get(source,'Parent');
	setState('BUSY ... ');	

	% get guidata
	data = guidata(figHandle);
	
	selectedValues = get(source,'Value');
	options = get(source,'String');

	%lets assume every vars in one condition
	nCond = numel(selectedValues);
	
	% get all variable names in cell
	for iCond = 1:nCond
		vars{iCond} = options{selectedValues(iCond)};
	end

	[nChans nFrames nEpochs] = evalin('base',['size(' vars{1} ')']);

	for iCond = 2:nCond
		if 	~isequal(nChans,evalin('base',['size(' vars{iCond} ',1)'])) || ...
		 	~isequal(nFrames,evalin('base',['size(' vars{iCond} ',2)']))
			
			% on mismatch present error and clear data.vars
			errordlg('Size of varibles not equal','Size Mismatch Error');
			setState('ready');
			data.vars = [];
			guidata(figHandle,data);
			
			return

		end
	end
	
	%% prep epochs	
	set(findobj(figHandle,'Tag','epoch0'),'String',1);
	set(findobj(figHandle,'Tag','epoch1'),'String',nEpochs);	

	%% prep chans
	set(findobj(figHandle,'Tag','chanList'),'Value',1);
	if isfield(data,'label')
		set(findobj(figHandle,'Tag','chanList'),'String',data.label);
	else
		set(findobj(figHandle,'Tag','chanList'),'String',{1:nChans});
	end
	setState('ready');
	
	% store data in GUI
	data.vars = vars;
	guidata(figHandle,data);

	
	
end %selectionCallback

%%% update the epochs of the selected set
function loadMeta(source,eventdata,varargin)
	
	% aquire fig handle and set busytext
	figHandle = get(source,'Parent');
	setState('BUSY ... ');	

	% get guidata
	data = guidata(figHandle)

	% get varible
	theVar = selectVariable();
	if isempty(theVar),	
		setState('ready');
	 	return
	end
	
	% once we have sth, process by input
	switch varargin{1}
		case 1

			disp('loading time scale')

			% store in guidata
			data.timeScale = evalin('base',sprintf('%s',theVar{1}));
			set(findobj(figHandle,'Tag','timescale'),'String',...
				sprintf('%d ...%d',data.timeScale(1),data.timeScale(end)));
	
		case 2

			disp('Loading labels')

			% store in guidata
			data.label = evalin('base',sprintf('%s',theVar{1}));
			set(findobj(figHandle,'Tag','labels'),'String',...
				sprintf('%s ...%s',data.label{1},data.label{end}));
	
			% label the channels  accorgingly, iff given
			chanList = get(findobj(figHandle,'Tag','chanList'),'String');

			if ~isempty(chanList)
				disp('Relabeling')
				set(findobj(figHandle,'Tag','chanList'),'String',data.label);
			end
			data
		case 3
			disp('not yet implemented')
		otherwise
			disp('This should not have happened ...')
	end

	% store data, update busytext
	guidata(figHandle,data);
	setState('ready');
	
end %loadMeta

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% retrieve selected vars for processing	%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function status = getData(figHandle)
	
	setState('BUSY ... ');

	% get guidata
	data = guidata(figHandle);

	if ~isfield(data,'vars') || isempty(data.vars)
		errordlg('Select data first','Data Error');
		status = boolean(0);
		return
	else
		nCond = numel(data.vars);
		disp(sprintf('Loading %d datasets',nCond));

		% load data 	
		for iCond = 1:nCond
			data.eeg{iCond} = evalin('base',data.vars{iCond});
		end
	end

	% insert params
	data.elecs = get(findobj(figHandle,'Tag','chanList'),'Value');
	data.e0 = str2num( get(findobj(figHandle,'Tag','epoch0'),'String') );
	data.e1 = str2num( get(findobj(figHandle,'Tag','epoch1'),'String') );
	data.nCond = numel(data.vars);
	
	% update guidata
	guidata(figHandle,data);
	
	% update busytext
	status = boolean(1);
	setState('ready');

end %getData

function aboutDialog(source,eventdata)

	message = sprintf(['ERRP\n\n a simple GUI to fiddle with EEG data.\n\n' ...
		'This is probably not helpful for you, is it?\n\n\n\n\n' ...
		'Copyright 2010 to 20%s, Stefan Schinkel,\nHU Berlin'],datestr(now,'yy') );
	
	msgbox(message,'About ERRP','help') 

end % aboutDialog

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%																	%%%
%%%			MOVED TO BACK WORK HERE LATER							%%%
%%%																	%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% run RQA on single channel or ROI%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function runRQA(source,eventdata,varargin)

	
	% get the parent
	figHandle = get(get(get(source,'Parent'),'Parent'),'Parent');
	
	% ROI ? 
	if ~isempty(varargin)
		FlagComputeRoi = 1
	else
		FlagComputeRoi = 0
	end
	
	% write busy text
	set(findobj(figHandle,'Tag','busytext'),'String','State: BUSY ... ');
	
	%% fetch data
	[c1 c2] = getData(figHandle);

	%% ask for rqa params
	dlgPrompt ={'Embedding dimension','Time delay','RQA window size','Step Size'};
	dlgTitle = 'RQA parameters';
	dlgReturns = inputdlg(dlgPrompt,dlgTitle,1);
	
	if isempty(dlgReturns);
		set(findobj(figHandle,'Tag','busytext'),'String','State: ready');
		disp('Computation aborted')	
		return
	else 
		params = str2double(dlgReturns);
	end

	dim=params(1);tau=params(2);ws=params(3);ss=params(4);
		
	%name of variables in workspace
	valVar1 = get(findobj(figHandle,'Tag','var1'),'Value');
	optVar1 = get(findobj(figHandle,'Tag','var1'),'String');
	valVar2 = get(findobj(figHandle,'Tag','var2'),'Value');
	optVar2 = get(findobj(figHandle,'Tag','var2'),'String');

	if FlagComputeRoi
		% concat varname 
		varNameC1 = sprintf('%srqa%d%d%d%dROI',optVar1{valVar1},dim,tau,ws,ss);
		varNameC2 = sprintf('%srqa%d%d%d%dROI',optVar1{valVar2},dim,tau,ws,ss);
		c1 = mean(c1,3);
		c2 = mean(c2,3);
	else
		varNameC1 = sprintf('%srqa%d%d%d%d',optVar1{valVar1},dim,tau,ws,ss);
		varNameC2 = sprintf('%srqa%d%d%d%d',optVar1{valVar2},dim,tau,ws,ss);
	end
			
	% run rqa on set1
	rqaC1 = eeg_opcrqa(c1,dim,tau,ws,ss);
	assignin('base',varNameC1,rqaC1);

	% run rqa on set2
	rqaC2 = eeg_opcrqa(c2,dim,tau,ws,ss);
	assignin('base',varNameC2,rqaC2);
	
	% update vars
	refreshData([],[],figHandle);
	
	% reset state text
	set(findobj(figHandle,'Tag','busytext'),'String','State: ready');

end %% end runRQA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compare %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function permtest(source,eventdata)

	figHandle = get(get(source,'Parent'),'Parent');
	set(findobj(figHandle,'Tag','busytext'),'String','State: BUSY ... ');drawnow;

	%% fetch data
	[c1 c2] = getData(figHandle);
	c1 = mean(c1,3);c2 = mean(c2,3);
	
	% no. of permuations
	nPerms = str2double(get(findobj(figHandle,'Tag','perms'),'String'));
	
	% test 
	[z p] = permtest2(c1,c2,nPerms);
	
	%plot 
	figure;
%	subplot(3,1,1);plot(z);
%		axis tight;
%		ylabel('z-value');
%		xlabel('Frames');
	subplot(2,1,1);
		plot(p);
		hold on;
		plot(1:length(p),.05,':k')
		plot(1:length(p),.01,'-.k')
		set(gca,'YDir','reverse');
		set(gca,'YScale','log');ylabel('p-value');
		axis tight;
		xlabel('Frames');

	subplot(2,1,2);
		plot(mean(c1));
		hold on;
		plot(mean(c2),'r');
		axis tight;ylabel('means');
		xlabel('Frames');
		legend('set 1','set 2');
	
	%%reset state
	set(findobj(figHandle,'Tag','busytext'),'String','State: ready');

	%force write out
	drawnow

end 
