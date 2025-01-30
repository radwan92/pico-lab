--- @param a number
--- @param b number
--- @param t number
--- @return number
function lerp(a, b, t)
    return a + (b - a) * t
end

--- @param val number
--- @param sign number
--- @return number
function set_sign(val, sign)
    if (sign >= 0 and val < 0) or (sign < 0 and val > 0) then
        return -val
    end

    return val
end
