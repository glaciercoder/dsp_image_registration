function [R,center_ind] = R_and_centerind(M)
% show the R and the center index of the matrix in test_scaling
[row_M, col_M] = size(M);
R=round(sqrt(row_M^2+col_M^2));
center_ind=[round(row_M / 2),round(col_M / 2)];
end