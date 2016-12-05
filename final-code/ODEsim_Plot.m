%FUNCTION: ODEsim_Plot_Control
%
%INPUTS: take 4 inputs
% f: the functions in array form. Example: f = [x+y , 3*x] 
% tend: is how long you want to run the plot. Example: tend = 20
% state_var: the variables of the functions. Example: state_var = [x, y] 
% start_point: the starting position. Example: start_point = [0 0] 
%
%OUTPUT: L, a matrix/ cell array of L observer values
%
%NOTE: This is hard code for controller with 4 elements in the state_var

function ODEsim_Plot_Control(f,tend,state_var,start_point)
    tspan = [0 tend];
    
    [col1 row1] = size(f);
    [col2 row2] = size(state_var);
    fSize = max(col1,row1); %get the number of functions 
    varSize = max(col2,row2); %get the number of variables
    
    g = {}; %cell array for function handlers
    for n = [1:fSize]
        g{n} = matlabFunction(f(n), 'vars',state_var)%convert our function to matlab function handler
    end
    
    [t,y] = ode45(@fu1,tspan,start_point);

    for m = [1:varSize]%draw the graph
        subplot(2,2,m);
        plot(t,y(:,m));
        title(char(state_var(m)));
    end
    
    function yd = fu1(t,y)
        h = num2cell(y);%convert elemets of the y array into cell array in order to put them into the function handler        
        yd = zeros(4,1);
        i = 1;
        j = 1;
        %put the function into the right position
        %assume the data have this order [a ad b bd c cd d dd]
        while i < varSize 
            yd(i) = y(i+1);
            yd(i + 1) = g{j}(h{:});
            i = i + 2;
            j = j + 1;
        end
    end
end