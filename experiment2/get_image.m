%图片的滤波函数
function Image = get_image(noiseI, H)
Image = noiseI;
%下面计算step
[M, N, Channal] = size(Image);
s = size(H);
len = s(1, 1);
step_x = M - len + 1;
step_y = N - len + 1;
for c = 1:Channal
    for y = 1:step_y
        for x = 1:step_x
            %逐个求出卷积值
            current_gray = 0;
            for y_r = y:y + len - 1
                for x_r = x:x + len - 1
                    current_gray = current_gray + Image(x_r, y_r, c) * H(x_r-x+1, y_r-y+1,c);
                end
            end
            Image(x+(len - 1)/2, y+(len - 1)/2, c) = current_gray;
        end
    end
end

end
