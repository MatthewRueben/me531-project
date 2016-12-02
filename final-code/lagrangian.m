 function [FFT , eqNL] = lagrangian(eqKE, eqPE, state, state_deriv, forces_or_torques, set_point) 
% For using kinematics to find equations of motion for the system.
%
% INPUTS: eqKE is the Kinetic Energy equation, eqPE is our Potential
% Energy, state is a list of our state variables (symbolic variables),
% state_deriv is a list of the *time derivatives* of our state variables,
% and forces_or_torques is a list of the corresponding force or torque (as
% a symbolic variable) for each state variable. NOTE that you can pass a
% zero as one of your forces_or_torques and we'll understand. Finally,
% set_point is a list of what to substitute in for state to put the
% system at its set point; we use this to calculate the steady-state
% force|torque for each nonzero element in forces_or_torques.
% 
% OUTPUT: FFT is the Feed Forward Torque needed to keep our system in
% a balanced pose. eqNL is our non linear equation.

%% Do Lagrangian

% Equations:
% Lagrangian L = PE - KE
% If L(x,y) then...
% dL/dx - d/dt(dL/dx_dot) = force or torque on x
% and
% dL/dy - d/dt(dL/dy_dot) = force or torque on y

% So for our state variables...
for var in state_vars and F_or_tau in forces_or_torques,
    % State Lagrangian equation
    dL/dvar - d/dt(dL/dvar_dot) = F_or_tau
    
    % Solve for var_doubledot
    
    
    % Extract coefficients for each state variable and force|torque
    eqNL =
    % (these will go into the linearized x_dot = Ax + Bu
    
    if F_or_tau is a symbol, not zero
        eqn = subs(eqn, state_vars, set_point)
        FFT(i) = solve(eqn, F_or_tau);
    end
    
end




end