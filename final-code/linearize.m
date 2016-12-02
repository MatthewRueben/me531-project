%function eqL = get_linearized_function(eqNL,var,pivot)
%Helper function to linearize
%INPUTS eqNL is our non linear equation, 
%       var is the variable vector,
%       pivot is the settling points
%OUTPUT:eqL is our linear equation. 
%------------------------------------------------------%
%Example of input:

%syms m2 g d2 d2d d2dd v1 v1d v1dd ;
%f = m2 * d2dd - m2*d2*(v1d)^2 + m2*g*sin(v1);
%var = [d2, d2d, d2dd, v1, v1d, v1dd];
%pivot = [3, 0, 0, 0, 0, 0];
%lin = get_linearized_function(f,var,pivot)

function eqL = get_linearized_function(eqNL,var,pivot)
    jab = jacobian(eqNL,var); %get the partial direvative 
    f0 = subs(eqNL,var,pivot); %the first part of the Taylor series 
    [col,row] = size (var); %get the number of variable in the function
    for i = 1:row
        f0 = f0 + subs(jab(i),var,pivot)*(var(i) - pivot(i)); %add the partial direvative
    end
    eqL = f0;
end


    