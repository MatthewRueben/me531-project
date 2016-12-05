function animation_demonstration(export,skip, solv, timeend)
% Produces two simple movies, to demonstrate usage of the ANIMATION
% function for exporting movie frames
%
%
% ========================
% Copyright Ross L. Hatton, 2011


	% Handle default arguments -- don't export frames, and don't skip
	% unless told otherwise
	if nargin < 2
		
		skip = [0 0];
		
		if nargin < 1
			
			export = [0 0];
			
		end
		
    end

    global sol
    
    sol= solv;
    %%%%%%%
    %lenght of vid
    global tend
    tend = timeend;
    
    % Do the math needed
    
   % sol= ode45Make();
    
	%%%%%%%%
	% Create animation elements, and store them in the frame_info structure
	frame_info = animation_demo_create_elements; %setup function, defined below in file

	
	%%%%%%%%%%%%%%%%%
	% First movie: Draw the cosine function
	
	% Designate animation function
	frame_gen_function...
		= @animation_demo_draw_cosine; % frame function, defined below in file

	% Declare timing
	timing.duration = 20; % three second animation
	timing.fps = 15;     % create frames for 15 fps animation
	timing.pacing = @(y) softspace(0,1,y); % Use a soft start and end, using the included softstart function

	% Declare a directory name in which to place files
	destination = 'demonstration_movie_1';
	
	% Animate the movie
	[frame_info, endframe]...
		= animation(frame_gen_function,frame_info,timing,destination,export(1),skip(1));
	
	
end


%%%%%%%%%%%%%%%%%%
% Create animation elements, and return a vector of their handles
function h = animation_demo_create_elements

	h.f = figure(100);                            % Designate a figure for this animation
	clf(h.f)                                     % Clear this figure
	set(h.f,'color','w','InvertHardCopy','off')  % Set this figure to have a white background
												 %  and to maintain color
												 %  settings during printing

	h.ax = axes('Parent',h.f);                   % Create axes for the plot
    axis square
	set(h.ax,'Xlim',[-1, 1],'Ylim',[-1,1]);   % Set the range of the plot
	set(h.ax,'Xtick',-1:0.25:1,'YTick',-1:0.25:1);   % Set the tick locations
	set(h.ax,'FontSize',16);                       % Set the axis font size
	xlabel(h.ax, 'x')							 % Label the axes
	ylabel(h.ax, 'y')
	set(h.ax,'Box','on')						 % put box all the way around the axes


	% Line element to be used to draw the cosine function
	h.line = line(0,0,'Color',[235 140 30]/255,'linewidth',20,'Marker', 'o','Parent',h.ax);

end




%%%%%%%%%%%%%%%%%%
% Frame content specification for dynamically drawing the cosine function,
% at time tau on a range of 0 to 1
function frame_info = animation_demo_draw_cosine(frame_info,tau)
    global tend
    global sol
	% Declare a baseline set of points at which to evaluate the cosine
	% function
	%x_full = linspace(0,2*pi,300)';
    %"Position" 
    %y_t= 2*pi*tau;
    theta= deval(sol,tend*tau);
    theta1 = theta(1);
    theta2 = theta(3);
    
    
    % The end of the first 0.5 meter link 
    % tip= [(cos(theta)*0.5)+4, sin(theta)*0.5]
    tip1= [cos(theta1), sin(theta1)]*0.5;
    tip2= tip1+[cos(theta2), sin(theta2)]*0.25;	
    
      	
	% Set one line in the plot to the calculated x and y points
	set(frame_info.line,'XData',[0, tip1(1), tip2(1)],'YData',[0, tip1(2), tip2(2)])
    
    % Set two line in the plot to the calculated x and y points
	%set(frame_info.line,'XData',[tip1(1), tip2(1)],'YData',[tip1(2), tip2(2)])
	
	% Declare a print method (in this case, print 150dpi png files of
	% frame_info.f, using the Painters renderer)
	frame_info.printmethod = @(dest) print(frame_info.f,'-dpng','-r 150','-painters',dest);
	

end

	