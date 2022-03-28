%f = [1, 2, 3; 4, 5, 6; 7, 8, 9];
%书上这道题是对一个3✖3矩阵对变换，但实际是可以对图片进行变换的，这里便对图片进行变换
%the key is not to forget im2double!!!!!
f = im2double(imread('hallback.bmp'));
subplot(121), imshow(f), title('原图');
[oldM, oldN, Channal] = size(f);
kx = 2.3;
ky = 1.6;
trans = [kx, 0, 0; 0, ky, 0; 0, 0, 1];
% get new image's size
M = round(kx*oldM);
N = round(ky*oldN);

% get new image's shade
new_f = zeros(M, N, Channal);
for c = 1:Channal
    for x = 0:M - 1
        for y = 0:N - 1
            oldx = x / kx;
            oldy = y / ky;
            new_f(x+1, y+1, c) = my_bilinear(c, f, oldx, oldy, oldM, oldN);
        end
    end
end

subplot(122), imshow(new_f), title('放大后');
