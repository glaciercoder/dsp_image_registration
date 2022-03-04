image_A = imread("test_1.png");
image_B = imrotate(image_A,45,'crop');
imshow(image_B)
[row_B, col_B] = size(image_B(:,:,1));
[row_A,col_A] = size(image_A(:,:,1));
center_B_ind = [round(row_B / 2),round(col_B / 2)];
center_A_ind = [round(row_A / 2),round(col_A / 2)];
r_B = round(sqrt(row_B^2+col_B^2));
r_A = round(sqrt(row_A^2+col_A^2));
r_start = 50;


FB = fft2(image_B(:,:,1));
FB = real(FB);
FB_lp = logsample(FB, r_start, r_B, center_B_ind(2), center_B_ind(1), r_B, 360);

FA = fft2(image_A(:,:,1));
FA = real(FA);
FA_lp = logsample(FA, r_start, r_A, center_A_ind(2), center_A_ind(1), r_A, 360);

c = normxcorr2(FA_lp,FB_lp);
        figure
        surf(c) 
        shading flat % draw results

[max_c,imax] = max(abs(c(:)));
[ypeak,xpeak] = ind2sub(size(c),imax(1));
corr_offset = [(xpeak-size(FA_lp,2)) 
               (ypeak-size(FA_lp,1))];
           
% A = [1,2,3, 4, 5;6, 7, 8, 9, 10;11,12, 13, 14,15];
% B  = logsample(A, 0.01, 3, 3, 2, 30,4);
