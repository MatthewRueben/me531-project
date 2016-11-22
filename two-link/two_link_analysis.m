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

% CCF.
[A_ccf, B_ccf, C_ccf, M] = to_CCF(A, B, C);
display(A_ccf)
display(B_ccf)
display(C_ccf)


%% Design a controller
% A_eq = A + BK
% Choose critically damped with 4 poles all at "lambda"
lambda = 1.0;
syms s
char_poly = (s+lambda)*(s+lambda)*(s+lambda)*(s+lambda);
a = coeffs(char_poly); 

A_eq = [zeros(3,1) eye(3);
        -1*fliplr(a(2:end))];
display(A_eq)

% Calculate K in CCF
dif = (A_eq - A_ccf);
K_ccf = dif(end,:)./B_ccf(end);

% Transform K back to natural coordinates
K = K_ccf * inv(M);
display(K)


%% Is it observable? How observable?
% Observable?
Q = to_Q(A, C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% COF from CCF.
A_obs = A_ccf';
B_obs = C_ccf';
C_obs = B_ccf';


