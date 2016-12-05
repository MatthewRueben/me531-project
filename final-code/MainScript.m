%%Multivariable Linear Control Systems Team Project
%
%Modeling 2 link system 
% Matt Rueben, Duy Nguyen, Wendy Xu
%This is the main script that calls all the other functions.

%% Starting with getting our Kinematics equations

%Clearing workspace
clear all
close all

%Setting symbolic and variables

syms m1 m2 L1 L2 L0 g % system consts
system_consts = [m1 m2 L1 L2 g];
constant_choices = [1 1 1 1 9.81];
%g = 9.81; % need a double? 
syms th1 dth1 ddth1 th2 dth2 ddth2   % state variables
state = [th1 dth1 th2 dth2];
state_deriv = [dth1 ddth1 dth2 ddth2];
state_vars = [th1 dth1 ddth1 th2 dth2 ddth2];
%Pose where system is balanced and linerized around. 
th1_eqm = 60.0;
th2_eqm = acosd(-3/2 * cosd(th1_eqm)) - th1_eqm;  % calculated exactly so our feed-forward torques have 3/4 in them instead of ugly fractions. 
equilibrium_pose = [deg2rad(th1_eqm) 0.0 0.0 ...
                    deg2rad(th2_eqm) 0.0 0.0];  
%equilibrium_pose = [pi/2 0 0 0 0 0];


syms T  % inputs
torques = [0, T];

%% Setting up the Kinematic equations
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

%Setting up the Kinematic equations  
Lag = eqPE - eqKE; % so eqn should be dL/dx - d/dt(dL/dx_dot) = F|tau

%Replacing symbolic with real values
% real_const_vals = [2.0 5.0 1 1];  % for the constants
% Lag = subs(Lag, system_consts, real_const_vals);

% Do Lagrange equation
addpath ./external-code  % so we can call Lagrange() from inside a folder
%eqNLSystem = Lagrange(Lag, state_vars);
unusable_eqNLSystem = Lagrange(Lag, state_vars);  % First eqn will be for theta1, second eqn for theta2.
%eqNLSystem = un_uglifier(unusable_eqNLSystem)
disp('Unsuable Nonlinear system equation:')
disp(transpose(unusable_eqNLSystem))


%% Solve for feed-forward torque at equilibrium_pose
equilibrium_forces = -1 * subs(unusable_eqNLSystem, state_vars, equilibrium_pose);
%my_pose = [pi 0 0 pi/2 0 0];
%equilibrium_forces = -1 * subs(unusable_eqNLSystem, state_vars, my_pose);
disp('The torques needed to keep system stable at the equilibrium_pose:')
disp(transpose(equilibrium_forces))
T_equilibrium = equilibrium_forces(2);
disp('For our system, these torques are (should be zero and something negative):')
disp(subs(equilibrium_forces, system_consts, constant_choices))


%% Turns unusable_eqNLSystem equations to usable eqNLSystem
%The elements need to be set properly to equal ddth1 and ddth2
%End result is a usable eqNLSystem

try
    %solve_sol = solve(unusable_eqNLSystem == torques, [ddth1, ddth2]);
    [eqNLSystem(1), eqNLSystem(2)] = solve(unusable_eqNLSystem == -torques, [ddth1, ddth2]);
catch e
    display('WARNING: solve() didn''t work. Loading default NL equations.')
    load('solved_for_ddTheta.mat')
end

% eqNLSystem(1) = simplify(solve_sol.ddth1);
% eqNLSystem(2) = simplify(solve_sol.ddth2);
disp('Now with torques and solved for ddTheta1 and ddTheta2')
disp('ddTheta1:')
disp(simplify(eqNLSystem(1)))
disp('ddTheta2:')
disp(simplify(eqNLSystem(2)))


%% Now linerize the system_equations of motion around the equilibrium_pose

% % % EquilibriumForceRequired not req for linerizing

%eqLSystem = linearize(eqNLSystem,state_vars,equilibrium_pose);  % BAD; gives different answer
eqLSystem(1) = linearize(eqNLSystem(1),state_vars,equilibrium_pose);  % one equation at a time...
eqLSystem(2) = linearize(eqNLSystem(2),state_vars,equilibrium_pose);
disp('Now linearized around equilibrium_pose')
disp('ddTheta1:')
disp(simplify(eqLSystem(1)))
disp('ddTheta2:')
disp(simplify(eqLSystem(2)))

%get conver to canon


%% Now switch to "tilda'd" coordinates. 
%So th1 starts at 60deg, th2 starts at 78.6deg, and T starts at the
%feed-forward torque of -7.5 N-m. 

% "err" is for "error", i.e., how far from equilibrium the system is.
syms th1_err dth1_err ddth1_err th2_err dth2_err ddth2_err
syms T_err

state_vars_err = [th1_err+equilibrium_pose(1) dth1_err ddth1_err...
                  th2_err+equilibrium_pose(4) dth2_err ddth2_err];

eqLSystem = subs(eqLSystem, state_vars, state_vars_err);
eqLSystem = subs(eqLSystem, T, T_err + T_equilibrium);
eqLSystem = simplify(eqLSystem);

disp('Now state variables and torques are about linearization point (simpler)')
disp('ddTheta1:')
disp(simplify(eqLSystem(1)))
disp('ddTheta2:')
disp(simplify(eqLSystem(2)))

%% Here we are extracting our coefficients
state_vars = [th1_err dth1_err...
              th2_err dth2_err];  
input_vars = T_err;                        
                        
[A, B, constants] = to_AB(eqLSystem, state_vars, input_vars);
A = [0 1 0 0;
     A(1,:);
     0 0 0 1;
     A(2,:)    ];
B = [0;
     B(1);
     0;
     B(2)  ];
 
display(A)
display(B)
display(constants)

%% Set up with real values to create specific system
% Real values will allow us to simulate and make contgollers, observers.
%eqLSystem = subs(eqLSystem, [m1 m2 L1 L2 g], [1 1 1 1 10]); 

A_real = subs(A, system_consts, constant_choices);                       
B_real = subs(B, system_consts, constant_choices);                       
constants_real = subs(constants, system_consts, constant_choices);                       
disp('For our particular system, the linearized version')
display(A_real)
display(B_real)
display(constants_real)
                        

% Add the T to the eqSystems as a symbol. 
% Controller (K *state_variables)=Torque
% Use Mat lab solve to reaarange eqNLSystem into equations of motion
% % % In symbolic 
% % % Substitute 
% % % A1= subs (A,[l,m,g],[2, 4, 9,81])
% % % A2 = Double (A1)

%% Simulate and Animate natural system without any torque

eqNLSystem_real = subs(eqNLSystem, system_consts, constant_choices);
eqNLSystem_real_limp = subs(eqNLSystem_real, T, 0);

tend = 1;  % seconds
state_var = [th1 dth1 th2 dth2];
start_point = equilibrium_pose([1,2,4,5]);
%start_point(3) = start_point(3) - deg2rad(.1);

ODEsim_Plot(eqNLSystem_real_limp,tend,state_var,start_point)

%call an ODE function that plots and animates it
% function ODEsim_PlotAni(tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL

% function ODEsimani (tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL


%% Design controller

C_real = [0 0 1 0];  % just observe Theta2
lambdas = [1.0, 1.0, 1.0, 1.0] * 2.0;

K = DesignController(A_real, B_real, C_real, lambdas);  

% % % id equilibrium balances, then no e torque
% % % k= place(A,B, [ 1, 2]);

%% Simulate and Animate with contollers 

% Add controller to NL equations of motion.
th1_error = th1 - equilibrium_pose(1);
dth1_error = dth1 - equilibrium_pose(2);
th2_error = th2 - equilibrium_pose(4);
dth2_error = dth2 - equilibrium_pose(5);
T_control = -K(1)*th1_error + ...
            -K(2)*dth1_error + ...
            -K(3)*th2_error + ...
            -K(4)*dth2_error;
T_equilibrium_real = subs(T_equilibrium, system_consts, constant_choices);            

eqNLSystem_real_control = subs(eqNLSystem_real, T, T_equilibrium_real + T_control);

tend = 5;  % seconds
state_var = [th1 dth1 th2 dth2];
start_point = equilibrium_pose([1,2,4,5]);
start_point(1) = start_point(1) - deg2rad(10);

figure;
ODEsim_Plot(eqNLSystem_real_control,tend,state_var,start_point)

% function ODEsimani (tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL

%% function Ls =DesignObserver(eqL, lambdas)
% Creates observer for system
%INPUTS: eqL, takes in linear equation of motion, lambdas are the poles
%OUTPUT: Ls, an matrix/ cell array of L observer values

%look for obs

%% Simulate and Animate with observers 

% might have to do some differrnt plotting to show this. 

% function ODEsimani (tend, eqNL)
% Uses ODE45 to plot and to animate system
% Takes in tend, time variable and eqNL




