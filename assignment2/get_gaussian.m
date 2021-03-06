%由于模版的计算都是重复性工作，所以将其写为函数为佳
function H = get_gaussian(r, sigma)
%注意，r是模版半径，模版本身大小为(r*2+1,r*2+1)
H = zeros(r*2+1, r*2+1, 3);
for c = 1:3
    for x = -r:r
        for y = -r:r
            %这里由于我们计算时，中心点是(size+1,size+1)，所以坐标需要进行偏移
            H(x+r+1, y+r+1, c) = (1 / (2 * pi * sigma^2)) * exp((x^2 + y^2)/(-(2 * sigma^2)));
        end
    end
    %注意，此时计算的模版矩阵，其总和不一定是1了，所以需要归一化使之总和加起来为1
    %还要注意，这里必须使用./点除，代表每个值除以同一个值，同时别忘了sum要加参数all！！！
    H(:, :, c) = H(:, :, c) ./ sum(H(:, :, c), 'all');
end

end
