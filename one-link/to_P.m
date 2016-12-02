function P = to_P(A,B)
% P = to_P(A,B)
%   Converts A, B matrices to P matrix.

%% Create P
[m, n] = size(A);
P = [];
for i = 0:m-1
    %display(i)
    P = [P, (A^i)*B];
    %display(P)
end
%display(P)

%Done!