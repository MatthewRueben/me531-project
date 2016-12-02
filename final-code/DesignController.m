function [ K ] = DesignController(A,B,C, lambdas )
%DESIGNCONTROLLER Designs a controller.
%
%INPUTS: takes in linear equations of motion via A-, B-, and C-matrices;
%lambdas are the eigenvalues for pole placement
%
%OUTPUT: K, an matrix/ cell array of K controller values
 

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
syms s
char_poly = 1;  % "empty" expression
for lambda = [lambdas]
    char_poly = char_poly*(s+lambda);  % add one root per eigenvalue
end
a = coeffs(char_poly);  % these are in REVERSE ORDER

n = length(lambdas);
A_eq = [zeros(n-1,1) eye(n-1);
        -1*a(1:end-1)];
display(A_eq)

% Calculate K in CCF
dif = (A_eq - A_ccf);
K_ccf = dif(end,:)./B_ccf(end);

% Transform K back to natural coordinates
K = K_ccf * inv(M);
display(eval(K), 'K')


end

