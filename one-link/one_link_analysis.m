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
my_m = 1.0;  % kg
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

% How controllable?
SVs_P = svd(P);  % singular values
display(SVs_P, 'Singular values of P')

% CCF.
[A_ccf, B_ccf, C_ccf, M_for_P] = to_CCF(my_A, my_B, my_C);
display(A_ccf)
display(B_ccf)
display(C_ccf)


%% Design a controller
% A_eq = A + BK
% Choose critically damped with 2 poles
lambda = 2.0;
syms s
char_poly = (s+lambda)*(s+lambda);
a = coeffs(char_poly);  % these are in REVERSE ORDER
A_eq_ctl = [0          1;
        -1*a(1:end-1)];
display(A_eq_ctl)

% Calculate K in CCF
dif = (A_eq_ctl - A_ccf);
K_ccf = dif(end,:)./B_ccf(end);

% Transform K back to natural coordinates
K = K_ccf * inv(M_for_P);
display(eval(K), 'K')


%% Is it observable? How observable?
% Observable?
Q = to_Q(my_A, my_C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% How observable?
SVs_Q = svd(Q);  % singular values
display(SVs_Q, 'Singular values of Q')

% Don't do it this way anymore, says Dr. Hatton! 
% % COF from CCF.
% A_obs = A_ccf';
% B_obs = C_ccf';
% C_obs = B_ccf';

% COF from Q.
Q_inv = inv(Q);
q = Q_inv(:,end);
M_inv = [q, my_A*q];
M_for_Q = inv(M_inv);
A_cof = M_for_Q * my_A * M_inv;  % Note that these are *backwards* transforms
B_cof = M_for_Q * my_B;
C_cof = my_C * M_inv;
display(A_cof)
display(B_cof)
display(C_cof)


%% Design an observer
% A_eq = A - LC
% Choose critically damped with 2 poles
lambda = 2.0 * 10;  % 10x faster than controller
syms s
char_poly = (s+lambda)*(s+lambda);
a = coeffs(char_poly);  % these are in REVERSE ORDER
A_eq_obs = [0          1;
            -1*a(1:end-1)]';  % note transpose relative to CCF
display(A_eq_obs)

% Calculate L in COF
dif = (A_cof - A_eq_obs);
L_cof = dif(:,end)./C_cof(end);

% Transform L back to natural coordinates
L = M_for_Q * L_cof;
display(eval(L), 'L')


