% Problem 2.1
% Matthew Rueben

clear all
close all

syms t 
syms x0  % initial state
syms x0_1 x0_2 x0_3  % components of initial state

%% Part a
A = [-4 0 0; 
     0 -7 1;
     0 -9 -1];
x0 = [x0_1 x0_2 x0_3]';
etotheAt = expm(A*t) * x0;
display(simplify(etotheAt))

% etotheAt = 
%                                             exp(-4*t)*conj(x0_1)
%  conj(x0_2)*(exp(-4*t) - 3*t*exp(-4*t)) + t*exp(-4*t)*conj(x0_3)
%        exp(-4*t)*conj(x0_3)*(3*t + 1) - 9*t*exp(-4*t)*conj(x0_2)
%
% All exponents are negative, so this eventually decays.


%% Part b
syms a o
A = [a o
    -o a]; % a is alpha; o is omega
x0 = [x0_1 x0_2]';
etotheAt = expm(A*t) * x0;
display(simplify(etotheAt))

% etotheAt = 
%  exp(a*t)*(cos(o*t)*conj(x0_1) + sin(o*t)*conj(x0_2))
%  exp(a*t)*(cos(o*t)*conj(x0_2) - sin(o*t)*conj(x0_1))
%
% This system will decay if alpha is negative. 
% Omega determines the frequency of oscillation.

%% Part c
A = [-8 7; 
     -4 3];
x0 = [x0_1 x0_2]';
etotheAt = expm(A*t) * x0;
display(simplify(etotheAt))

% etotheAt = 
% conj(x0_2)*((7*exp(-t))/3 - (7*exp(-4*t))/3) - conj(x0_1)*((4*exp(-t))/3 - (7*exp(-4*t))/3)
% conj(x0_2)*((7*exp(-t))/3 - (4*exp(-4*t))/3) - conj(x0_1)*((4*exp(-t))/3 - (4*exp(-4*t))/3)
%
% This system also decays, albeit with two different time constants.
