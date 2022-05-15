Image = im2double(imread('Letters-a.jpg'));
%add noise
noiseI = imnoise(Image, 'gaussian');
subplot(321), imshow(Image), title('原图');
subplot(322), imshow(noiseI), title('添加高斯噪声');
%下面进行高斯模版的计算
sigma1 = 0.8;
sigma2 = 1;
%3*3高斯模版
H_3_1=get_gaussian(1,sigma1);%注意，这里给的是模版半径而非大小
H_3_2=get_gaussian(1,sigma2);
Image_3_1=get_image(noiseI,H_3_1);
Image_3_2=get_image(noiseI,H_3_2);
subplot(323),imshow(Image_3_1),title('3*3高斯模版(sigma=0.8)滤波');
subplot(324),imshow(Image_3_2),title('3*3高斯模版(sigma=1)滤波');

%拓展到5*5高斯模版
H_5_1=get_gaussian(2,sigma1);
H_5_2=get_gaussian(2,sigma2);
Image_5_1=get_image(noiseI,H_5_1);
Image_5_2=get_image(noiseI,H_5_2);
subplot(325),imshow(Image_5_1),title('5*5高斯模版(sigma=0.8)滤波');
subplot(326),imshow(Image_5_2),title('5*5高斯模版(sigma=1)滤波');


