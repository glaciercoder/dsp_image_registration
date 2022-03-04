peppers = imread("test_large.png");
onion = imread("test.png");
N = max_threshold_ind(peppers,onion,4);
[max_N,imax] = max(abs(N(:)));
[ypeak,xpeak] = ind2sub(size(N),imax(1));
figure
surf(N) 
shading flat 
