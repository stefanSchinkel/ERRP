function axes2origin(varargin)	

% AXES2ORGIN - relocate plot axis to 0
%
% function axes2origin([theZero,hideLabel])
%
% AXES2ORGIN relocates axes of the current 2D plot
% through the origin preserving ticks, labels etc.
% Primary purpose is the plotting of EEG data. The
% zero line can be adjusted by THEZERO. Furthermore
% the plotting of ticks and tickmarks can be surpressed
% by using a nonempty value for HIDELABEL
% 
% The properties 'FontSize' and 'FontWeight' will be 
% maintained in the reset plot. 
% 
% Input: 
%	zero = zero line (def: 0)
%	hideLabel = hide ticks etc (def: no hiding)
%
% Output: 
%	none
% 
% Borrowed form plotAtOrigin (FEX File ID: #10473)
%
% function axes2origin(hAx,theZero,hideLabel)
% The same as above but uses the axes provided in 
% HAX handle instead of gca().
%
% Requires: axescheck.m (MATLABROOT/toolbox/matlab/graphics)
%
% See also: plot_erpconf.m 

% check number of input arguments
error(nargchk(0,3,nargin))

% check number of out arguments
error(nargoutchk(0,0,nargout))

% prevent indexation errors
varargin{4}=[];

% check if axes handle in input 
% if so extract and keep remaining 
% in new cell
args = varargin;
if axescheck(varargin{1}), 
	hAX = varargin{1};
	varargin = {args{2:end}};
else
	hAX = gca;
	varargin = args;
end

% look at remaining varargin 
% to set an artifical zero for the zeroline
if isempty(varargin{1}),	theZero = 0;		else	theZero = varargin{1};	end
% check if we need to plot lables
if isempty(varargin{2})	hideLabel = false;	else	hideLabel = true;		end


% first up hold the plot
hold(hAX,'on');

%% acquire some params to comp
LineWidth = get(hAX,'LineWidth');
FontSize = get(hAX,'FontSize');
FontWeight = get(hAX,'FontWeight');


% GET TICKS
X=get(hAX,'Xtick');Y=get(hAX,'Ytick');

% GET LABELS
XL=get(hAX,'XtickLabel');YL=get(hAX,'YtickLabel');

% GET OFFSETS
Xoff=diff(get(hAX,'XLim'))./60;
Yoff=diff(get(hAX,'YLim'))./40;

% DRAW AXIS LINEs
plot(get(hAX,'XLim'),[theZero theZero],'k','LineWidth',LineWidth);
plot([0 0],get(hAX,'YLim'),'k','LineWidth',LineWidth);

% Plot new ticks  
for i=1:length(X)
    plot([X(i) X(i)],[theZero-Yoff theZero+Yoff],'-k','LineWidth',LineWidth);
end;
for i=1:length(Y)
   plot([Xoff, -Xoff],[Y(i) Y(i)],'-k','LineWidth',LineWidth);
end;



%ADD LABELS
if ~hideLabel
	hXtick = text(X-Xoff,theZero*ones(size(X))-2.*Yoff,XL,'FontSize',FontSize,'FontWeight',FontWeight);
	hYtick = text(zeros(size(Y))-4.*Xoff,Y,YL,'FontSize',FontSize,'FontWeight',FontWeight);

	% remove the 0 on the y-axis
	for i = 1:length(hYtick);
		if str2num(get(hYtick(i),'String')) == 0
			set(hYtick(i),'visible','off')
		end
	end	%length(hYtick)
	
	% remove the 0 on the x-axis
	for i = 1:length(hXtick);
		if str2num(get(hXtick(i),'String')) == 0
			set(hXtick(i),'visible','off')
		end
	end	 % length(hXtick)
end % if ~hideLabel

box(hAX,'off')
% axis square;
axis off;
set(gcf,'color','w');
