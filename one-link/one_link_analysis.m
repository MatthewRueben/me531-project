% Matt Rueben, Wendy Xu, Duy Nguyen

clear all
close all

%% Our linearized, one-bar system
g = 9.81;  % gravity (m/s^2)
syms l m  % leave link length and mass as variables for now
A = [0               1
     3*sqrt(2)*g/4/l 0];
display(A)
%display(subs(A,l,1))  % JUST FOR FUN

B = [0
     3/m/l^2];
display(B)
%subs(B,[l m],[2 2])

C = [1 0];  % TESTING

%% Choose parameters
my_l = 1.0;  % m
my_m = 2.0;  % kg
my_A = subs(A,[l m],[my_l my_m]);
my_B = subs(B,[l m],[my_l my_m]);
my_C = C;  % for completeness
display(my_A)
display(my_B)
display(my_C)

%% Is it controllable? How controllable? 
% Controllable?
P = to_P(my_A,my_B);
display(rank(P), 'Rank of P')
display(size(my_A), 'Size of A')

% CCF.
[A_ccf, B_ccf, C_ccf, M] = to_CCF(my_A, my_B, my_C);
display(A_ccf)
display(B_ccf)
display(C_ccf)


%% Design a controller
% A_eq = A + BK
% Choose critically damped with 2 poles
lambda = 1.0;
A_eq = [0          1;
        -lambda^2 -2*lambda];
display(A_eq)

% Calculate K in CCF
dif = (A_eq - A_ccf);
K_ccf = dif(end,:)./B_ccf(end);

% Transform K back to natural coordinates
K = K_ccf * inv(M);
display(K)


%% Is it observable? How observable?
% Observable?
Q = to_Q(my_A, my_C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% COF from CCF.
A_obs = A_ccf';
B_obs = C_ccf';
C_obs = B_ccf';


