--- @class Vec2
--- @field x number
--- @field y number
--- @operator add:Vec2
--- @operator sub:Vec2
Vec2 = {}
Vec2.__index = Vec2

--- Creates new Vec2
--- @param x? number
--- @param y? number
--- @return Vec2
function Vec2:new(x, y)
    o = {x = x or 0, y = y or 0}
    setmetatable(o, self)
    return o
end

--- @return Vec2
function Vec2:clone()
    return Vec2:new(self.x, self.y)
end

--- @return number
function Vec2:sqr_magnitude()
    return self.x * self.x + self.y * self.y
end

--- @return number
function Vec2:magnitude()
    -- This trick is to avoid overflow.
    -- Courtesy of: https://www.lexaloffle.com/bbs/?pid=38407
    local scale = max(abs(self.x), abs(self.y))
    local z = min(abs(self.x), abs(self.y)) / scale
    return sqrt(z*z + 1) * scale
end

--- @return Vec2
function Vec2:normalized()
    local mag = self:magnitude()
    return Vec2:new(self.x / mag, self.y / mag)
end

--- @param other Vec2
--- @return number
function Vec2:dot(other)
    return self.x * other.x + self.y * other.y
end

--- @param scalar number
--- @return Vec2
function Vec2:mul_scalar(scalar)
    return Vec2:new(self.x * scalar, self.y * scalar)
end

--- @return Vec2
--- @operator mul:Vec2
function Vec2.__mul(lhs, rhs)
    if type(lhs) == "number" then
        return Vec2:new(rhs.x * lhs, rhs.y * lhs)
    elseif type(rhs) == "number" then
        return Vec2:new(lhs.x * rhs, lhs.y * rhs)
    end

    assert(false, "Invalid multiplication")
end

--- @return Vec2
--- @operator add:Vec2
function Vec2.__add(self, other)
    return Vec2:new(self.x + other.x, self.y + other.y)
end

--- @return Vec2
--- @operator sub:Vec2
function Vec2.__sub(self, other)
    return Vec2:new(self.x - other.x, self.y - other.y)
end

--- @return string
function Vec2.__tostring(self)
    return "("..self.x..","..self.y..")"
end

--- @return string
--- @operator concat:string
function Vec2.__concat(lhs, rhs)
    return tostring(lhs)..tostring(rhs)
end
