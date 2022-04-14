% manual bilinear
function res = my_bilinear(c, f, oldx, oldy, oldM, oldN)
if oldx < 0 || oldy < 0 || oldx > oldM - 1 || oldy > oldN - 1
    res = 255;
else
    base_x = floor(oldx) + 1;
    base_y = floor(oldy) + 1;
    a = oldx + 1 - base_x;
    b = oldy + 1 - base_y;
    if base_x == oldM || base_y == oldN
        res = f(base_x, base_y, c);
    else
        f1 = f(base_x, base_y, c) + b * (f(base_x, base_y+1, c) - f(base_x, base_y, c));
        f2 = f(base_x+1, base_y, c) + b * (f(base_x+1, base_y+1, c) - f(base_x+1, base_y, c));
        f3 = f1 + a * (f2 - f1);
        res = f3;
    end

end
end
