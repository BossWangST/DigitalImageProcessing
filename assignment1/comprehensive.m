f = im2double(imread('hallback.bmp'));
%本题最后一个变换是缩小，但是由于matlab的subplot在一行内放了5张图
%所以最后一张缩小的效果看不出来，但实际确实缩小了，从右侧变量栏中可以看到大小确实变小了
subplot(151), imshow(f), title('原图');
[oldM, oldN, Channal] = size(f);
% rotate
theta = pi / 9;
old = [[0, 0]; [oldM - 1, 0]; [oldM - 1, oldN - 1]; [0, oldN - 1]];
rotate_xy = zeros(size(old));
for i = 1:4
    rotate_xy(i, 1) = old(i, 1) * cos(theta) + old(i, 2) * sin(theta);
    rotate_xy(i, 2) = -old(i, 1) * sin(theta) + old(i, 2) * cos(theta);
end
x_max = max(rotate_xy(:, 1));
x_min = min(rotate_xy(:, 1));
y_max = max(rotate_xy(:, 2));
y_min = min(rotate_xy(:, 2));
M = ceil(x_max-x_min+1);
N = ceil(y_max-y_min+1);
rotate_f = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            old_x = x + x_min;
            old_y = y + y_min;
            oldx = old_x * cos(theta) - old_y * sin(theta);
            oldy = old_x * sin(theta) + old_y * cos(theta);
            rotate_f(x+1, y+1, c) = my_bilinear(c, f, oldx, oldy, oldM, oldN);
        end
    end
end
subplot(152), imshow(rotate_f), title('旋转20度');
% horizontal mirror
[oldM, oldN, Channal] = size(rotate_f);
M = oldM;
N = oldN;
horizontal_mirror = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            oldx = M - 1 - x;
            oldy = y;
            %horizontal_mirror(x+1, y+1, c) = my_bilinear(c, rotate, oldx, oldy, oldM, oldN);
            horizontal_mirror(x+1, y+1, c) = rotate_f(oldx+1,oldy+1,c);
        end
    end
end
subplot(153), imshow(horizontal_mirror), title('水平镜像');
% staggered
dx=0.3;
dy=0.5;
tform=affine2d([1,dx,0;dy,1,0;0,0,1]);
stagger=imwarp(horizontal_mirror,tform);
subplot(154),imshow(stagger),title('错切');
% zoom
kx=0.6;
ky=0.6;
[oldM,oldN,Channal]=size(stagger);
M = round(kx*oldM);
N = round(ky*oldN);

zoom = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            oldx = x / kx;
            oldy = y / ky;
            zoom(x+1, y+1, c) = my_bilinear(c, stagger, oldx, oldy, oldM, oldN);
        end
    end
end
subplot(155),imshow(zoom),title('缩小');
