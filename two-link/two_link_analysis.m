% Matt Rueben, Wendy Xu, Duy Nguyen

clear all
close all

%% Our linearized, TWO-bar system
A = [0    1    0 0;
     5.88 0 1.98 0;
     0    0    0 1;
     3.24 0 3.24 0];
display(A)

B = [0
     0
     0
     0.5];
display(B)

C = [0 0 1 0];  % observes theta_b (encoder)
display(C)


%% Is it controllable? How controllable? 
% Controllable?
P = to_P(A, B);
display(rank(P), 'Rank of P')
display(size(A), 'Size of A')

% How controllable?
SVs_P = svd(P);  % singular values
display(SVs_P, 'Singular values of P')

% CCF.
[A_ccf, B_ccf, C_ccf, M] = to_CCF(A, B, C);
display(A_ccf)
display(B_ccf)
display(C_ccf)


%% Design a controller
% A_eq = A + BK
% Choose critically damped with 4 poles all at "lambda"
lambda = 2.0;
syms s
char_poly = (s+lambda)*(s+lambda)*(s+lambda)*(s+lambda);
a = coeffs(char_poly);  % these are in REVERSE ORDER

A_eq = [zeros(3,1) eye(3);
        -1*a(1:end-1)];
display(A_eq)

% Calculate K in CCF
dif = (A_eq - A_ccf);
K_ccf = dif(end,:)./B_ccf(end);

% Transform K back to natural coordinates
K = K_ccf * inv(M);
display(eval(K), 'K')


%% Is it observable? How observable?
% Observable?
Q = to_Q(A, C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% How observable?
SVs_Q = svd(Q);  % singular values
display(SVs_Q, 'Singular values of Q')

% COF from CCF.
A_obs = A_ccf';
B_obs = C_ccf';
C_obs = B_ccf';


