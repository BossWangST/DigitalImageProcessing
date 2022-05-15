Image = im2double(imread('Letters-a.jpg'));
%add noise
noiseI = imnoise(Image, 'gaussian');
subplot(221), imshow(Image), title('原图');
subplot(222), imshow(noiseI), title('添加高斯噪声');
Image_3 = noiseI;
Image_5 = noiseI;
[M, N, Channal] = size(Image);
%Note: Calculate the step!
step_x = M - 3 + 1;
step_y = N - 3 + 1;
for c = 1:Channal
    for y = 1:step_y
        for x = 1:step_x
            current_mat = Image_3(x:x+3-1, y:y+3-1, c); %3*3均值模版
            Image_3(x+(3 - 1)/2, y+(3 - 1)/2, c) = sum(current_mat, 'all') / 9;
        end
    end
end
subplot(223), imshow(Image_3), title('3*3模版均值滤波');
%以下为题目拓展，模版大小采用5*5
step_x = M - 5 + 1;
step_y = N - 5 + 1;
for c = 1:Channal
    for y = 1:step_y
        for x = 1:step_x
            current_mat = Image_5(x:x+5-1, y:y+5-1, c); %5*5均值模版
            Image_5(x+(5 - 1)/2, y+(5 - 1)/2, c) = sum(current_mat, 'all') / 25;
        end
    end
end
subplot(224), imshow(Image_5), title('5*5模版均值滤波');
