function Q = to_Q(A,C)
% Q = to_Q(A,C)
%   Converts A, C matrices to Q matrix.

%% Create Q
[m, n] = size(A);
Q = [];
for i = 0:m-1
    %display(i)
    Q = [Q; C*(A^i)];
    %display(Q)
end
%display(Q)

%Done!