f = im2double(imread('hallback.bmp'));
subplot(121), imshow(f), title('原图');
[oldM, oldN, Channal] = size(f);
theta = pi / 9;
x1 = 0;
y1 = 0;
x2 = oldM - 1;
y2 = 0;
x3 = oldM - 1;
y3 = oldN - 1;
x4 = 0;
y4 = oldN - 1;
x1_ = x1 * cos(theta) + y1 * sin(theta);
y1_ = -x1 * sin(theta) + y1 * cos(theta);
x2_ = x2 * cos(theta) + y2 * sin(theta);
y2_ = -x2 * sin(theta) + y2 * cos(theta);
x3_ = x3 * cos(theta) + y3 * sin(theta);
y3_ = -x3 * sin(theta) + y3 * cos(theta);
x4_ = x4 * cos(theta) + y4 * sin(theta);
y4_ = -x4 * sin(theta) + y4 * cos(theta);
max_x = max(max(x1_, x2_), max(x3_, x4_));
min_x = min(min(x1_, x2_), min(x3_, x4_));
max_y = max(max(y1_, y2_), max(y3_, y4_));
min_y = min(min(y1_, y2_), min(y3_, y4_));
M = ceil(max_x-min_x+1);
N = ceil(max_y-min_y+1);
% now we get the new resolution
new_f = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            % here is the original coordinary
            old_x = x + min_x;
            old_y = y + min_y;
            % here is the original coordinate!
            oldx = old_x * cos(theta) - old_y * sin(theta);
            oldy = old_x * sin(theta) + old_y * cos(theta);
            new_f(x+1, y+1, c) = my_bilinear(c, f, oldx, oldy, oldM, oldN);
        end
    end
end

subplot(122), imshow(new_f), title('旋转后');
