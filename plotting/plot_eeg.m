function plot_eeg(varargin)

%plot_eeg - scrollplot of EEG
%
% function plot_eeg(eeg,scale,timeScale,labels)
%
% Show a scrollplot (i.e. paper representation)
% of an EEG set. The data is adjusted to a certain
% SCALE and plotted versus the TIMESCALE provided.
% If electrode LABELS are provided those are shown.
%
% If the EEG data is a set of epochs, the figure 
% allows the change from one epoch to the next. 
%
% Use for artifact rejection:
% If a scale is given, any trials lying outside that
% scale is plotted in red.
%
% Input:
%	EEG = EEG data (continous or epoched)
%
% Optional Inputs:
%	scale = scale to which data is fitted (def: 50)
%	timeScale = timeScale against which to plot 
%	labels = electrode labels 
%
% requires: ERRP:helper:scaleData
%
% see also: ERRP

% debug settings

	debug = 1;
	if debug;warning('on','all');else warning('off','all');end
	%% check number of input arguments
	error(nargchk(1,4,nargin))
	%% check number of out arguments
	error(nargoutchk(0,0,nargout))

	varargin{5} = [];
	if ndims(varargin{1}) > 3; error('Need eegset of shape [channel x time( x trial)]');else eeg = varargin{1};end
	if isempty(varargin{2}), scale = 50 ;else scale = varargin{2};end
	if isempty(varargin{3}), timeScale = 1:size(eeg,2); else timeScale = varargin{3};end
	if isempty(varargin{4}), labels = 1:size(eeg,1); else labels = varargin{4};end

	% prepare figure
 	screenSize = get(0,'Screensize');

	hFig = figure(	'Position',[50 50 screenSize(3) *.75,screenSize(4) *.8],...
					'Tag','mainFigure',...
					'Menubar','none');% choose 'Menubar','figure' to run into trouble

	hAxes = axes('Parent',hFig,...
				'Position',[0.05 0.05 0.9 0.9]);
			
	set(hFig,'visible','off');
	hold(hAxes,'on')

	textScale = uicontrol('Parent',hFig, ...
		'Units', 'normalized', ...
		'Position', [.05 .96 .3 .03],...
		'Style','Text',... 
		'String',sprintf('Voltage Range : +/-%3d mV',scale),...
		'HorizontalAlignment','center',...
		'Visible','on',...
		'BackgroundColor',[.8 .8 .8], ...
		'Tag','textCurrent');
			
	buttonPrevious = uicontrol('Parent',hFig, ...
		'Units', 'normalized', ...
		'Position', [.4 .96 .05 .03],...
		'Style','pushbutton',... 
		'String','PREV.',...
		'HorizontalAlignment','center',...
		'Visible','on',...
		'Tooltip','Show previous epoch',...
		'Enable','on',...
		'Tag','prevButton');

	textCurrent = uicontrol('Parent',hFig, ...
		'Units', 'normalized', ...
		'Position', [.475 .96 .075 .03],...
		'Style','Text',... 
		'String','Epoch',...
		'HorizontalAlignment','center',...
		'Visible','on',...
		'BackgroundColor',[.8 .8 .8], ...
		'Tag','textCurrent');

	valCurrent = uicontrol('Parent',hFig, ...
		'Units', 'normalized', ...
		'Position', [.55 .96 .025 .03],...
		'Style','Text',... 
		'String',num2str(1),...
		'HorizontalAlignment','center',...
		'Visible','on',...
		'BackgroundColor',[.8 .8 .8], ...
		'Tag','valCurrent');

	buttonNext = uicontrol('Parent',hFig, ...
		'Units', 'normalized', ...
		'Position', [.6 .96 .05 .03],...
		'Style','pushbutton',... 
		'String','NEXT',...
		'HorizontalAlignment','center',...
		'Visible','on',...
		'Tooltip','Show next epoch',...
		'Tag','nextButton');

	%get params & store in userdata
	data.eeg = eeg;
	data.scale = scale;
	data.timeScale = timeScale;
	data.labels = labels;
	data.currentTrial = 1;	
	nChan = size(eeg,1); 	data.nChan = nChan;
	nTrial = size(eeg,3);	data.nTrial = nTrial;
	patchColour = [.7 .7 .7];




	%make alternating patches from [-1 1]
	upperBound =  repmat(1,1,length(timeScale));
	lowerBound =  repmat(-1,1,length(timeScale));
	hPatches = [];
	for i=1:2:nChan

		hPatches(end+1) = fill(	[timeScale fliplr(timeScale)],...
	 							[( upperBound + i*2 )  ( lowerBound + i*2 )],...
								[.7 .7 .7],...
								'edgecolor','white');  
	end			

	%fancy up stuff
	set(hAxes,'Ylim',[1 2*nChan+1])
	set(hAxes,'Ticklength',[0 0])
	set(hAxes,'YTick',[2:2: 2*nChan])
	set(hAxes,'YTickl',labels)
	set(hAxes,'YDir','Reverse') % 


	%store in data in GUI
	set(hFig,'UserData',data);
	
	
	%scale data to initial scale
	rescale(hFig);
	
	%plot initial trial
	plotEpoch(hFig,1);


	set(buttonNext,'Callback',{@changeTrial,1})
	set(buttonPrevious,'Callback',{@changeTrial,-1})
	
	set(hFig,'visible','on');

		
end % main function

%%% GUI CALLBACKS

function changeTrial(source,eventdata,step)
	
	hFig = get(source,'Parent');
	
	data = get(hFig,'Userdata');
	theTrial = data.currentTrial + step;
	
	if 0 < theTrial & theTrial <= data.nTrial
		plotEpoch(hFig,theTrial);
		data.currentTrial = theTrial;
		set(findobj(hFig,'Tag','valCurrent'),'String',num2str(theTrial));
		set(hFig,'UserData',data);
	else
		disp('Already at end/beginning of trials');
		return
	end
	
end % change trial


function rescale(hFig)

	data = get(hFig,'UserData');
	data.eeg = scaleData(data.eeg,data.scale);
	set(hFig,'UserData',data);

end

function plotEpoch(hFig,trial)
	%acquire userdata
	data = get(hFig,'UserData');
	
	eeg = data.eeg;
	timeScale = data.timeScale;
	labels = data.labels;
	nChan = data.nChan;

	if isfield(data,'hEEG')
		for i=1:nChan
			set(data.hEEG(i),'YData',eeg(i,:,trial) + i*2,...
				'Color','b')
		end
	else
		for i=1:nChan
			data.hEEG(i) = plot(timeScale,eeg(i,:,trial) + i*2);
		end
	end
	%check if a trial is outside limits
	idx = any(abs(eeg(:,:,trial)') > 1);
	
	if ~isempty(idx)
		set(data.hEEG(find(idx)),'Color','r')
	end
	
	set(gca,'XLim',[data.timeScale(1) data.timeScale(end)] );
	
	set(gcf,'UserData',data);


end %plotEpoch


