%% Test function lagrangian.m
% With a simple spring+mass system

syms m k  % constants
syms x dx ddx  % state variables
syms F  % inputs
state = [x dx]';
state_deriv = [dx ddx]';
eqKE = 1/2 * m * dx^2;
eqPE = 1/2 * k * x^2; 
forces_or_torques = [F];
set_point = [0.10   0.0];  % release from 10cm
[FFT , eqNL] = lagrangian(eqKE, eqPE, state, state_deriv, forces_or_torques, set_point); 
display(FFT)
display(eqNL)