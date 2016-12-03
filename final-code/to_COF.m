function [A_cof, B_cof, C_cof, M] = to_COF(A,B,C)
% [A_cof, B_cof, C_cof, M] = to_COF(A,B,C)
%   Converts A, B, C matrices to canonical observable form.


%% Create Q
Q = to_Q(A,C);

%% Get inverse of Q
Q_inv = inv(Q);
%display(Q_inv)

%% Get q
q = Q_inv(:,end);
%display(q)

%% Make inverse of M
[m, n] = size(A);
M_inv = [];
for i = 0:m-1
    M_inv = [M_inv, (A^i)*q];
end
%display(M_inv)

%% Get M
M = inv(M_inv);
%display(M)

%% Convert A, B, and C to canonical observable form
A_cof = M * A * M_inv;  % Note that these are *backwards* transforms
B_cof = M * B;
C_cof = C * M_inv;

% Done! 