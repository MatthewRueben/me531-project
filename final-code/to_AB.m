function [A, B, constants] = to_AB(linear_eqns, state_vars, input_vars)
%TO_AB Extract the elements of the A and B matrices from linear equations
%of motion. I am adapting Prof. Hatton's code from the function
%kinectic_energy_to_mass_matrix() in this file.
%   [A_matrix] = to_AB(linear-eqns-of-motion, state_variables, input_variables)
%
%  INPUT: linear-eqns-of-motion can have multiple symbolic expressions in a
%  matrix.
% 
%  OUTPUT: note that the first column of A_matrix corresponds to the first
%  element of state_variables, and so on.

%% Deal with input variables
states_and_inputs = [state_vars input_vars];
state_indices = 1 : length(state_vars);
input_indices = length(state_vars)+1 : length(states_and_inputs);


%% Remove constant terms that do not have any of the variables in "state_vars".
all_zeros = zeros(length(states_and_inputs),1);
constants = subs(linear_eqns, states_and_inputs, all_zeros);
if constants ~= 0
    display('WARNING: your equations have some constant terms! Bad.')
    linear_eqns = linear_eqns - constants;
end

n_state = length(state_indices);
n_state_deriv = length(linear_eqns);  % assumes each expression is an equation that's been solved for a state derivative variable
n_inputs = length(input_vars);

% dz = A*z + B*u
coeffs_state = sym(nan(n_state_deriv, n_state));  % sym() changes data type to symbolic
coeffs_inputs = sym(nan(n_state_deriv, n_inputs));

in = @(el, array) any(el==array);  % checks if an element is in an array

% for each state variable
for i = 1:length(states_and_inputs)
    %replace all but the current state variable with zero, and the
    %current state variable with one.
    % (this gives us the coefficients)
    var = states_and_inputs(i);
    all_zero_except_var = all_zeros;
    all_zero_except_var(i) = 1;
    coeffs = subs(linear_eqns, states_and_inputs, all_zero_except_var);
    coeffs = simplify(sym(coeffs));  % MR 03-Dec-2016: added sym() in case the coefficient is just a constant
    
    % Stick the coefficients in the right matrix
    if in(i, state_indices)
        j = find(i == state_indices);
        if length(j) ~= 1; display('PROBLEM!'); end
        coeffs_state(:,j) = coeffs;
%     elseif in(i, state_deriv_indices)
%         j = find(i == state_deriv_indices);
%         if length(j) ~= 1; display('PROBLEM!'); end
%         coeffs_state_deriv(:,j) = coeffs;
    elseif in(i, input_indices)
        j = find(i == input_indices);
        if length(j) ~= 1; display('PROBLEM!'); end
        coeffs_inputs(:,j) = coeffs;
    else
        display('WARNING: we got a rogue variable on our hands here. Come see.')
    end
end

% Calculate A and B matrices
%display(coeffs_state)
%display(coeffs_state_deriv)
A = coeffs_state;
%A = inv(coeffs_state_deriv) * -1 * coeffs_state;  % -1 is to put state variables on other side of equals sign from state_deriv variables.
B = coeffs_inputs;
%B = inv(coeffs_state_deriv) * -1 * coeffs_inputs;  % KEEP THE -1 ???

end

