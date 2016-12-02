%%Multivariable Linear Control Systems Team Project
%
%Modeling 2 link system 
% Matt Rueben, Duy Nguyen, Wendy Xu
%This is the main script that calls all the other functions.

%% Starting with getting our Kinematics equations

%Setting up equations

%testing git MERGE

%Getting KE

%Getting PE

%% function [FTT , eqNL] = lagrangian(eqKE, eqPE) 
% For using kinematics to find equations of motion for the system. 
%INPUTS: eqKE is the Kinetic Energy equation,and eqPE is our Potential
%Energy
%OUTPUT: FFT is the Feed Forward Torque needed to keep our system in a
%balence pose. eqNL is our non linear equation.
 syms w r g real
 w = r^2

%%  function eqNL =linearize(eqNL)
%Helper function to linearize
%INPUTS eqNL is our non linear equation. fft, about a piont. stable
%OUTPUT:eqL is our linear equation.
EquilibriumForceRequired 
In symbolic 
Substitute 
A1= subs (A,[l,m,g],[2, 4, 9,81])
A2 = Double (A1)

%testing git merge 

%get conver to canon


%% Here we are extracting our coefficients
%Set up:

%% Simulate and Animate natural system without any torque

%% function Ks =DesignController(eqL, lambdas)
% Created controller for system
%INPUTS: eqL, takes in linear equation of motion, lambdas are the poles
%OUTPUT: Ks, an matrix/ cell array of K controller values

%Simulate and Animate with controllers 

id equilibrium balances, then no e torque
k= place(A,B, [ 1, 2]);

%% function Ls =DesignObserver(eqL, lambdas)
% Creates observer for system
%INPUTS: eqL, takes in linear equation of motion, lambdas are the poles
%OUTPUT: Ls, an matrix/ cell array of L observer values

look for obs

%% Simulate and Animate with observers 


%% function ODEsimani (tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL




