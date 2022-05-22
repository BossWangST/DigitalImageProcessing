Image = im2double(imread("lotus.bmp"));
%首先将图像灰度化处理
Image_gray = .299 * Image(:, :, 1) + .587 * Image(:, :, 2) + .114 * Image(:, :, 3);
%Task1:统计灰度直方图
[M, N] = size(Image_gray);
histgram = zeros(256);
for y = 1:N
    for x = 1:M
        %注意这里的+1，需要把灰度值的范围改到[1,256]以便在图中表示
        histgram(round(Image_gray(x, y)*255)+1) = histgram(round(Image_gray(x, y)*255)+1) + 1;
    end
end
figure(1)
subplot(2, 2, 1), imshow(Image), title('原图');
subplot(2, 2, 2), imshow(Image_gray), title('灰度化');
subplot(2, 2, [3, 4]), stem(histgram(), '.'), title('灰度直方图');
%Task2:对灰度图像进行分段线性变换
a = 30 / 255;
b = 100 / 255;
c = 75 / 255;
d = 200 / 255;
Image2 = Image_gray;
for y = 1:N
    for x = 1:M
        if Image2(x, y) < a
            Image2(x, y) = Image2(x, y) * c / a;
        elseif Image2(x, y) < b
            Image2(x, y) = (Image2(x, y) - a) * (d - c) / (b - a) + c;
        else
            %注意这里因为使用了im2double所以所有的灰度值都在0-1之间，所以L-1=1
            Image2(x, y) = (Image2(x, y) - b) * (1 - d) / (1 - b) + d;
        end
    end
end
figure(2);
subplot(2, 2, 1), imshow(Image_gray), title('灰度化原图');
subplot(2, 2, 2), imshow(Image2), title('分段线性变换');
%Task3:对灰度图像直方图均衡化
Image3 = histeq(Image_gray);
subplot(2, 2, 3), imshow(Image3), title('直方图均衡化');
%Task4:伪彩色增强
Image4 = zeros(M, N, 3);
for y = 1:N
    for x = 1:M
        %Red
        if (Image_gray(x, y) * 255 < 128)
            Image4(x, y, 1) = 0;
        elseif (Image_gray(x, y) * 255 < 192)
            Image4(x, y, 1) = 4 * Image_gray(x, y) - 2;
        else
            Image4(x, y, 1) = 1;
        end
        %Green
        if (Image_gray(x, y) * 255 < 64)
            Image4(x, y, 2) = 4 * Image_gray(x, y);
        elseif (Image_gray(x, y) * 255 < 192)
            Image4(x, y, 2) = 1;
        else
            Image4(x, y, 2) = 4 - 4 * Image_gray(x, y);
        end
        %Blue
        if (Image_gray(x, y) * 255 < 64)
            Image4(x, y, 3) = 1;
        elseif (Image_gray(x, y) * 255 < 128)
            Image4(x, y, 3) = 2 - 4 * Image_gray(x, y);
        else
            Image4(x, y, 3) = 0;
        end
    end
end
subplot(2, 2, 4), imshow(Image4), title('伪彩色增强');
%Task5:对数字图像平滑噪声
noiseI = imnoise(Image_gray, 'gaussian');
figure(3);
subplot(3, 4, 1), imshow(Image_gray), title('灰度化原图');
subplot(3, 4, 2), imshow(noiseI), title('添加高斯噪声');
Image5_1 = noiseI;
Image5_2 = noiseI;
%Note: Calculate the step!
step_x = M - 3 + 1;
step_y = N - 3 + 1;
for y = 1:step_y
    for x = 1:step_x
        current_mat = Image5_1(x:x+3-1, y:y+3-1); %3*3均值模版
        Image5_1(x+(3 - 1)/2, y+(3 - 1)/2) = sum(current_mat, 'all') / 9;
    end
end
subplot(3, 4, 3), imshow(Image5_1), title('3*3模版均值滤波');
%以下为题目拓展，模版大小采用5*5
step_x = M - 5 + 1;
step_y = N - 5 + 1;
for y = 1:step_y
    for x = 1:step_x
        current_mat = Image5_2(x:x+5-1, y:y+5-1); %5*5均值模版
        Image5_2(x+(5 - 1)/2, y+(5 - 1)/2) = sum(current_mat, 'all') / 25;
    end
end
subplot(344), imshow(Image5_2), title('5*5模版均值滤波');
%下面进行高斯模版的计算
sigma1 = 0.8;
sigma2 = 1;
%3*3高斯模版
H_3_1=get_gaussian(1,sigma1);%注意，这里给的是模版半径而非大小
H_3_2=get_gaussian(1,sigma2);
Image_3_1=get_image(noiseI,H_3_1);
Image_3_2=get_image(noiseI,H_3_2);
subplot(345),imshow(Image_3_1),title('3*3高斯模版(sigma=0.8)滤波');
subplot(346),imshow(Image_3_2),title('3*3高斯模版(sigma=1)滤波');

%拓展到5*5高斯模版
H_5_1=get_gaussian(2,sigma1);
H_5_2=get_gaussian(2,sigma2);
Image_5_3=get_image(noiseI,H_5_1);
Image_5_4=get_image(noiseI,H_5_2);
subplot(347),imshow(Image_5_3),title('5*5高斯模版(sigma=0.8)滤波');
subplot(348),imshow(Image_5_4),title('5*5高斯模版(sigma=1)滤波');

Image_3_gaus=get_image_med(noiseI,1);%半径为1
Image_5_gaus=get_image_med(noiseI,2);%半径为2
subplot(3,4,9),imshow(Image_3_gaus),title('3*3中值滤波高斯噪声');
subplot(3,4,10),imshow(Image_5_gaus),title('5*5中值滤波高斯噪声');
%Task6:Sobel算子锐化
H1=[-1,-2,-1;0,0,0;1,2,1];
H2=[-1,0,1;-2,0,2;-1,0,1];
R1=imfilter(Image_gray,H1);
R2=imfilter(Image_gray,H2);
edgeI=abs(R1)+abs(R2);
figure(4);
subplot(1,2,1),imshow(edgeI),title('Sobel梯度图像');
sharpI=Image_gray+edgeI;
subplot(1,2,2),imshow(sharpI),title('Sobel锐化图像');
