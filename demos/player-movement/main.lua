-- title:       Player Movement
-- description: Very basic player movement controlled by the arrow keys.

Player = { 
    x = 63, 
    y = 63,
    sprite = 0,
    speed = 1,

    move = function(self, direction)
        local dx, dy = 0, 0

        if      direction == BUTTONS.up     then dy = -self.speed
        elseif  direction == BUTTONS.down   then dy = self.speed
        elseif  direction == BUTTONS.left   then dx = -self.speed
        elseif  direction == BUTTONS.right  then dx = self.speed
        end

        self.x = self.x + dx
        self.y = self.y + dy
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
    for _, v in pairs(BUTTONS) do
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