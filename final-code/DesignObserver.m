function [ L ] = DesignObserver(A,B,C, lambdas )
%DESIGNOBSERVER Designs an observer.
%
%INPUTS: takes in linear equations of motion via A-, B-, and C-matrices;
%lambdas are the eigenvalues for pole placement
%
%OUTPUT: L, a matrix/ cell array of L observer values
 

%% Is it observable? How observable?
% Observable?
Q = to_Q(A, C);
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

% COF.
[A_cof, B_cof, C_cof, M_for_Q] = to_COF(A,B,C);
display(A_cof)
display(B_cof)
display(C_cof)

%% Design an observer
% A_eq = A - LC
syms s
char_poly = 1;  % "empty" expression
for lambda = [lambdas]
    char_poly = char_poly*(s+lambda);  % add one root per eigenvalue
end
a = coeffs(char_poly);  % these are in REVERSE ORDER

A_eq_cof = [0          1;
            -1*a(1:end-1)]';  % note transpose relative to CCF
display(A_eq_cof)

% Calculate L in COF
dif = (A_cof - A_eq_cof);
L_cof = dif(:,end)./C_cof(end);

% Transform L back to natural coordinates
L = M_for_Q * L_cof;
display(eval(L), 'L')


end

