-- title:       Player Movement
-- description: Very basic player movement controlled by the arrow keys.

DIRECTION = {
    LEFT = 0,
    RIGHT = 1,
    UP = 2,
    DOWN = 3,
}

Player = { 
    x = 63, 
    y = 63,
    sprite = 0,
    speed = 1,

    move = function(self, direction)
        local dx, dy = 0, 0

        if direction == DIRECTION.UP then
            dy = -self.speed
        elseif direction == DIRECTION.DOWN then
            dy = self.speed
        elseif direction == DIRECTION.LEFT then
            dx = -self.speed
        elseif direction == DIRECTION.RIGHT then
            dx = self.speed
        end

        self.x += dx
        self.y += dy
    end,

    draw = function(self)
        spr(self.sprite, self.x, self.y)
    end,

    dbg_print_position = function(self)
        print("x: "..self.x, 0, 0, 7)
        print("y: "..self.y, 0, 8, 7)
    end
}

function _update()
    for _, v in pairs(DIRECTION) do
        if btn(v) then
            Player:move(v)
        end
    end
end

function _draw()
    cls()

    Player:draw()
    Player:dbg_print_position()
end