function [A_ccf, B_ccf, C_ccf, M] = to_CCF(A,B,C)
% [A_ccf, B_ccf, C_ccf, M] = to_CCF(A,B,C)
%   Converts A, B, C matrices to canonical controllable form.

%% Create P
P = to_P(A,B);

%% Get inverse of P
P_inv = inv(P);
%display(P_inv)

%% Get p
p = P_inv(end, :);
%display(p)

%% Make inverse of M
[m, n] = size(A);
M_inv = [];
for i = 0:m-1
    M_inv = [M_inv; p*(A^i)];
end
%display(M_inv)

%% Get M
M = inv(M_inv);
%display(M)

%% Convert A, B, and C to canonical controllable form
A_ccf = M_inv * A * M;
B_ccf = M_inv * B;
C_ccf = C*M;

% Done! 