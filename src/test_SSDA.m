peppers = imread("test_large.png");
onion = imread("test.png");
N = max_threshold_ind(peppers,onion,4);
[max_N,imax] = max(abs(N(:)));
[ypeak,xpeak] = ind2sub(size(N),imax(1));
figure
surf(N) %平面
shading flat %平面着色
colorbar
% figure 11
% N=[1 2 3
%    4 5 6
%    1 2 4];
% surf(N)
% shading flat
