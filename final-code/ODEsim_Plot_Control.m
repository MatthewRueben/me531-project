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
    f1 = matlabFunction(f(1), 'vars',state_var)%convert our function to matlab function handler
    f2 = matlabFunction(f(2), 'vars',state_var)
    [t,y] = ode45(@fu1,tspan,start_point);

    for m = [1:4]%draw the graph
        subplot(2,2,m);
        plot(t,y(:,m));
        title(char(state_var(m)));
    end
    
    function yd = fu1(t,y)
        g = num2cell(y);%convert elemets of the y array into cell array in order to put them into the function handler        
        yd = zeros(4,1);
        yd(1) = y(2);
        yd(2) = f1(g{:});
        yd(3) = y(4);
        yd(4) = f2(g{:});
        
    end
end