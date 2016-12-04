%% Tests to_AB.m

eom = [ 2*dx + x + 5, 
    5*dx + dy + 2*x - 2];  % some fake linear equations of motion

state_vars_and_derivs = [x y dx dy];
state_var_indices = [1 2];
state_var_deriv_indices = [3 4];
[A, B] = to_AB(...
    eom, ...
    state_vars_and_derivs, ...
    state_var_indices, ...
    state_var_deriv_indices);

% Should throw a WARNING because these equations of motions have constants
% in them. This is good behavior. The program should remove the constants.

display(A)
display(B)