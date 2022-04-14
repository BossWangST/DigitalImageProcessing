figure(1);
Image1 = im2double(imread('peppers.JPG'));
subplot(432), imshow(Image1), title('原图');
%此时Image1已经读入MATLAB中，并且是一个三维矩阵H*W*C
Red = Image1(:, :, 1);
Green = Image1(:, :, 2);
Blue = Image1(:, :, 3);
%Task1:互换颜色通道
Image2 = zeros(size(Image1));
%Red-Green
Image2(:, :, 1) = Green;
Image2(:, :, 2) = Red;
Image2(:, :, 3) = Blue;
subplot(334), imshow(Image2), title('Red-Green通道互换');
%Red-Blue
Image2(:, :, 1) = Blue;
Image2(:, :, 2) = Green;
Image2(:, :, 3) = Red;
subplot(335), imshow(Image2), title('Red-Blue通道互换');
%Green-Blue
Image2(:, :, 1) = Red;
Image2(:, :, 2) = Blue;
Image2(:, :, 3) = Green;
subplot(336), imshow(Image2), title('Green-Blue通道互换');
%Task2:灰度化
Image2 = rgb2gray(Image1);
subplot(3, 3, 7), imshow(Image2), title('灰度化');
Image2 = .299 * Image1(:, :, 1) + .587 * Image1(:, :, 2) + .114 * Image1(:, :, 3);
subplot(3, 3, 8), imshow(Image2), title('Manual-灰度化1');
Image2 = (Image1(:, :, 1) + Image1(:, :, 2) + Image1(:, :, 3)) / 3;
subplot(3, 3, 9), imshow(Image2), title('Manual-灰度化2');
%Extra-Task:变换到YCbCr和HSV空间
figure(4);
Image2 = rgb2ycbcr(Image1);
subplot(2, 4, 1), imshow(Image2), title('RGB-to-YCbCr');
Y = Image2(:, :, 1);
subplot(2, 4, 2), imshow(Y), title('YCbCr-Y');
Cb = Image2(:, :, 2);
subplot(2, 4, 3), imshow(Cb), title('YCbCr-Cb');
Cr = Image2(:, :, 3);
subplot(2, 4, 4), imshow(Cr), title('YCbCr-Cr');
Image2 = rgb2hsv(Image1);
subplot(2, 4, 5), imshow(Image2), title('RGB-to-HSV');
H = Image2(:, :, 1);
subplot(2, 4, 6), imshow(H), title('HSV-H');
S = Image2(:, :, 2);
subplot(2, 4, 7), imshow(S), title('HSV-S');
V = Image2(:, :, 3);
subplot(2, 4, 8), imshow(V), title('HSV-V');
%Task3:图像的旋转、放大（使用不同的差值方法）
figure(2);
%rotate image
%MATLAB functions
Image2 = imrotate(Image1, 60, 'nearest', 'loose');
subplot(3, 3, 1), imshow(Image2), title('Rotate-Nearest');
Image2 = imrotate(Image1, 60, 'bilinear', 'loose');
subplot(3, 3, 2), imshow(Image2), title('Rotate-Bilinear');
Image2 = imrotate(Image1, 60, 'bicubic', 'loose');
subplot(3, 3, 3), imshow(Image2), title('Rotate-Bicubic');
Image2 = imresize(Image1, 1.6, 'nearest');
subplot(3, 3, 4), imshow(Image2), title('Zoom-Nearest');
Image2 = imresize(Image1, 1.6, 'bilinear');
subplot(3, 3, 5), imshow(Image2), title('Zoom-Bilinear');
Image2 = imresize(Image1, 1.6, 'bicubic');
subplot(3, 3, 6), imshow(Image2), title('Zoom-Bicubic');
%Manual functions
[oldM, oldN, Channal] = size(Image1);
theta = -pi / 3;
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
Image2 = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            old_x = x + x_min;
            old_y = y + y_min;
            oldx = old_x * cos(theta) - old_y * sin(theta);
            oldy = old_x * sin(theta) + old_y * cos(theta);
            Image2(x+1, y+1, c) = my_bilinear(c, Image1, oldx, oldy, oldM, oldN);
        end
    end
end
subplot(3, 3, 7), imshow(Image2), title('Rotate-My-bilinear');
M = round(oldM*1.6);
N = round(oldN*1.6);
Image2 = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            oldx = x / 1.6;
            oldy = y / 1.6;
            Image2(x+1, y+1, c) = my_bilinear(c, Image1, oldx, oldy, oldM, oldN);
        end
    end
end
subplot(3, 3, 8), imshow(Image2), title('Zoom-My-bilinear');
%Task3:图像拼接及代数运算
%图像的拼接
flip_horizontal = flip(Image1, 1);
flip_vertical = flip(Image1, 2);
flip_vertical_horizontal = flip(flip_horizontal, 2);
Image2 = [Image1, flip_vertical; flip_horizontal, flip_vertical_horizontal];
figure(3);
subplot(251), imshow(Image2), title('Joint-Flip');
%图像代数运算
Image1 = imread('peppers.JPG');
Image3 = imread('fruit.jpg');
Image3 = imresize(Image3, [oldM, oldN], 'bilinear');
Image2 = imadd(Image1, Image3);
subplot(252), imshow(Image2), title('Image-Add');
Image2 = imabsdiff(Image1, Image3);
subplot(253), imshow(Image2), title('Image-Diff');
Image2 = immultiply(Image1, Image3);
subplot(254), imshow(Image2), title('Image-Multiply');
Image2 = imdivide(Image1, Image3);
subplot(255), imshow(Image2), title('Image-Divide');
Image2 = bitand(Image1, Image3);
subplot(256), imshow(Image2), title('Image-Divide');
Image2 = bitor(Image1, Image3);
subplot(258), imshow(Image2), title('Image-Divide');
Image2 = bitxor(Image1, Image3);
subplot(2, 5, 10), imshow(Image2), title('Image-Divide');
