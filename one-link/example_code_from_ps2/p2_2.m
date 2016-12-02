% Problem 2.2
% Matthew Rueben

clear all
close all

%% Part a
A = [1 0;
    -0.5 0.5];
B = [1; -1];
C = [1 1];

% Controllable?
P = to_P(A,B);
display(rank(P), 'Rank')

% Observable?
Q = to_Q(A,C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% Neither controllable nor observable.

%% Part b
A = [-7 -2 6;
    2 -3 -2;
    -2 -2 1];
B = [1 1;
    1 -1;
    1 0];
C = [-1 -1 2;
    1 1 -1];

% Controllable?
P = to_P(A,B);
display(rank(P), 'Rank of P')

% Observable?
Q = to_Q(A,C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% Neither controllable nor observable! 

%% Part c
A = [2 -5;
    -4 0];
B = [1; -1];
C = [1 1];

% Controllable?
P = to_P(A,B);
display(rank(P), 'Rank')

% Observable?
Q = to_Q(A,C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% CCF.
[A_ccf, B_ccf, C_ccf] = to_CCF(A,B,C);
display(A_ccf)
display(B_ccf)
display(C_ccf)

% COF from CCF.
A_obs = A_ccf';
B_obs = C_ccf';
C_obs = B_ccf';

% COF from Q.
Q_inv = inv(Q);
q = Q_inv(:,end);
M_inv = [q, A*q];
M = inv(M_inv);
A_cof = M * A * M_inv;  % Note that these are *backwards* transforms
B_cof = M * B;
C_cof = C * M_inv;

% Yes! I checked that A,B,C_obs == A,B,C_cof ... and they do!

% Both controllable and observable.
% A_ccf =
%          0    1.0000
%    20.0000    2.0000
% 
% B_ccf =
%          0
%     1.0000
% 
% C_ccf =
%     3.0000    0.0000
%
%-------------------------
%A_cof =
%    -0.0000   20.0000
%     1.0000    2.0000
% 
% B_cof =
%     3.0000
%     0.0000
% 
% C_cof =
%    -0.0000    1.0000


%% Part d
A = [0 1;
    -4 -4];
B = [0; 1];
C = [1 1];

% Controllable?
P = to_P(A,B);
display(rank(P), 'Rank of P')
%display(size(A), 'Size of A')

% Observable?
Q = to_Q(A,C);
display(rank(Q), 'Rank of Q')
display(size(A), 'Size of A')

% CCF.
[A_ccf, B_ccf, C_ccf] = to_CCF(A,B,C);
display(A_ccf)
display(B_ccf)
display(C_ccf)

% COF from CCF.
A_obs = A_ccf';
B_obs = C_ccf';
C_obs = B_ccf';

% COF from Q.
Q_inv = inv(Q);
q = Q_inv(:,end);
M_inv = [q, A*q];
M = inv(M_inv);
A_cof = M * A * M_inv;  % Note that these are *backwards* transforms
B_cof = M * B;
C_cof = C * M_inv;

% Yes! I checked that A,B,C_obs == A,B,C_cof ... and they do!

% Both controllable and observable.
% A_ccf =
%      0     1
%     -4    -4
% 
% B_ccf =
%      0
%      1
% 
% C_ccf =
%      1     1
%
%
%--------------------------
% A_cof =
% 
%      0    -4
%      1    -4
% 
% B_cof =
%      1
%      1
% 
% C_cof =
%      0     1