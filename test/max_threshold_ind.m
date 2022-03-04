% Input: searchin_area and window(pictures)
%        Threshold: T
% Reture: N is a matrix, its (i,j) element is the index that exceeds T
% Pay attention to x,y here, x,y point have index(y,x)

function N = max_threshold_ind(searching_area,window,T)

% Convert the image to double
searching_area = im2double(searching_area(:,:,1));
window = im2double(window(:,:,1));

% Get the size
[row_w, col_w] = size(window);
[row_s,col_s] = size(searching_area);

% Calculate the normalization constant
W_n = sum(window,'all') / (row_w * col_w);

% The range of the reference point
x_max = col_s - col_w + 1;
y_max = row_s - row_w + 1;
N = zeros(y_max,x_max);

% Calculate the index
for j = 1:x_max
    for i = 1:y_max
        n = 0;
        l = 1;
        m = 1;
        distance = 0;
        while((distance < T) && (max(l,m) < min(row_w,col_w)))
%             S_n = sum(searching_area(i:i+row_w-1,j:j+col_w-1),'all') / (row_w * col_w);
%             distance = distance + abs(searching_area(i+l-1,j+m-1)-window(l,m)+S_n-W_n); % Normalized distance
             distance = distance + abs(searching_area(i+l-1,j+m-1)-window(l,m)); % Unnormalized distance
            n = n + 1;
            l = l + 1;
            m = m + 1;
        end
        N(i,j) = n;
    end
end

            
            
            
            