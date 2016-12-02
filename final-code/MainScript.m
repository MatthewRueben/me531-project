%%Multivariable Linear Control Systems Team Project
%
%Modeling 2 link system 
% Matt Rueben, Duy Nguyen, Wendy Xu
%This is the main script that calls all the other functions.

%% Starting with getting our Kinematics equations

%Setting symbolic and variables

syms m1 m2 L1 L2 L0 g % system consts
system_consts = [m1 m2 L1 L2];
g = 8.91; % need a double? 
syms th1 dth1 ddth1 th2 dth2 ddth2   % state variables
state = [th1 dth1 th2 dth2];
state_deriv = [dth1 ddth1 dth2 ddth2];
state_vars = [th1 dth1 ddth1 th2 dth2 ddth2];

syms T  % inputs
forces_or_torques = [T];

%Setting up the Kinematic equations
%% Finding the KE 
%Knowing that KEtranslational= 1/2*mv^2
%KE Rotational=1/2*I*w^2, and dth is velocity
%I - moment of intertia of a pivoting bar = 1/3*m*l^2
%I - moment of intertia of a piont mass= m*l^2
eqKE = (m1*L1^2*dth1^2)/6 + 0.5 *m2*...
( L1^2* dth1^2 + L2^2*(dth1+dth2)^2 + L1*L2*cos(dth2)*(dth1^2+dth1*dth2));

%% Finding PE
eqPE = m1*g*L1*sin(th1)/2 + m2*g*(L1*sin(th1) +L2*sin(th1 +th2)); 





%% Now use the kinematic equations to in the Lagrangian to find the equations of motion

%function [FTT , eqNL] = lagrangian(eqKE, eqPE) 
% For using kinematics to find equations of motion for the system. 
%INPUTS: eqKE is the Kinetic Energy equation,and eqPE is our Potential
%Energy
%OUTPUT: FFT is the Feed Forward Torque needed to keep our system in a
%balence pose. eqNL is our non linear equation.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

start_pose = [0.10   0.0   0.0];  % release from this starting pose 10cm
%%%%%%&&&&&&&Make this the same size as "Var" or the state_var

%Setting up the Kinematic equestions  
Lag = eqPE - eqKE; % so eqn should be dL/dx - d/dt(dL/dx_dot) = F|tau

%Replacing symbolic with real values
real_const_vals = [2.0 5.0 1 1];  % for the constants
Lag = subs(Lag, system_consts, real_const_vals);

% Do Lagrange equation
addpath ./external-code  % so we can call Lagrange() from inside a folder
eqns = Lagrange(Lag, state_vars);
display(eqns)

% Solve for feed-forward force or torque
ffF = -1 * subs(eqns(1), state_vars, start_pose);
display(ffF)


%settling pose to discrrize around == real values  (Pivot)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eqL = get_linearized_function(eqNL,var,pivot)
%%  function eqNL =linearize(eqNL)
%Helper function to linearize
%INPUTS eqNL is our non linear equation. fft, about a piont. stable
%OUTPUT:eqL is our linear equation. (wil retrurn symbolic equation)
% % % EquilibriumForceRequired 
% % % In symbolic 
% % % Substitute 
% % % A1= subs (A,[l,m,g],[2, 4, 9,81])
% % % A2 = Double (A1)



%get conver to canon


%% Here we are extracting our coefficients
%Set up:

%% Simulate and Animate natural system without any torque

%% function Ks =DesignController(eqL, lambdas)
% Created controller for system
%INPUTS: eqL, takes in linear equation of motion, lambdas are the poles
%OUTPUT: Ks, an matrix/ cell array of K controller values

%Simulate and Animate with controllers 

% % % id equilibrium balances, then no e torque
% % % k= place(A,B, [ 1, 2]);

%% function Ls =DesignObserver(eqL, lambdas)
% Creates observer for system
%INPUTS: eqL, takes in linear equation of motion, lambdas are the poles
%OUTPUT: Ls, an matrix/ cell array of L observer values

%look for obs

%% Simulate and Animate with observers 


%% function ODEsimani (tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL




