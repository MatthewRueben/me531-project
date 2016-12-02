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

function eqL = get_linearized_function(eqNL,var,pivot)
    jab = jacobian(eqNL,var);
    f0 = subs(eqNL,var,pivot); 
    for i = 1:6
        f0 = f0 + subs(jab(i),var,pivot)*(var(i) - pivot(i));
    end

    eqL = f0;
end

%function eqL =linearized(eqNL)
%Helper function to linearize
%INPUTS eqNL is our non linear equation.
%OUTPUT:eqL is our linear equation. 

%end
    