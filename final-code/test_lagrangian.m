%% Test function lagrangian.m
% With a simple spring+mass system

syms m k  % constants
syms x dx ddx  % state variables
syms F  % inputs

state = [x dx];  % UNUSED
state_deriv = [dx ddx];  % UNUSED
state_vars = [x dx ddx];

eqKE = 1/2 * m * dx^2;
eqPE = 1/2 * k * x^2; 
forces_or_torques = [F];

set_point = [0.10   0.0   0.0];  % release from 10cm

% Calculate Lagrangian
L = eqPE - eqKE; % so eqn should be dL/dx - d/dt(dL/dx_dot) = F|tau
constants = [m k];
choices = [2.0 5.0];  % for the constants
L = subs(L, constants, choices);

% Do Lagrange equation
addpath ./external-code  % so we can call Lagrange() from inside a folder
eqns = Lagrange(L, state_vars);
display(eqns)

% Solve for feed-forward force or torque
ffF = -1 * subs(eqns(1), state_vars, set_point);
display(ffF)
