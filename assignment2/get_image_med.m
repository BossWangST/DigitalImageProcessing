%图片的中值滤波函数
function Image = get_image_med(noiseI, r)
Image = noiseI;
[M, N, Channal] = size(Image);
len = 2 * r + 1;
%下面计算step
step_x = M - len + 1;
step_y = N - len + 1;
for c = 1:Channal
    for y = 1:step_y
        for x = 1:step_x
            template = Image(x:x+len-1, y:y+len-1, c);
            line = [template(1, :), template(2, :), template(3, :)];
            sort(line);
            mid_num = line((len * len + 1)/2);
            Image(x+(len - 1)/2, y+(len - 1)/2, c) = mid_num;
        end
    end
end

end
