Image = im2double(imread('Letters-a.jpg'));
%add noise
%本题由于需要选出中值滤波的最好噪声对象，故加入多种噪声进行测试
noiseI_gaus = imnoise(Image, 'gaussian');
noiseI_salt=imnoise(Image,'salt & pepper');
noiseI_poisson=imnoise(Image,'poisson');
subplot(432), imshow(Image), title('原图');
subplot(434), imshow(noiseI_gaus), title('添加高斯噪声');
subplot(435),imshow(noiseI_salt),title('添加椒盐噪声');
subplot(436),imshow(noiseI_poisson),title('添加泊松噪声');

%先使用3*3大小的中值滤波器尝试进行滤波，再使用5*5大小的
Image_3_gaus=get_image_med(noiseI_gaus,1);%半径为1
Image_3_salt=get_image_med(noiseI_salt,1);
Image_3_poisson=get_image_med(noiseI_poisson,1);
subplot(437),imshow(Image_3_gaus),title('3*3中值滤波高斯噪声');
subplot(438),imshow(Image_3_salt),title('3*3中值滤波椒盐噪声');
subplot(439),imshow(Image_3_poisson),title('3*3中值滤波泊松噪声');
%5*5
Image_5_gaus=get_image_med(noiseI_gaus,2);%半径为2
Image_5_salt=get_image_med(noiseI_salt,2);
Image_5_poisson=get_image_med(noiseI_poisson,2);
subplot(4,3,10),imshow(Image_5_gaus),title('5*5中值滤波高斯噪声');
subplot(4,3,11),imshow(Image_5_salt),title('5*5中值滤波椒盐噪声');
subplot(4,3,12),imshow(Image_5_poisson),title('5*5中值滤波泊松噪声');
