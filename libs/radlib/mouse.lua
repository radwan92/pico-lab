--- @enum MOUSE_BTN
MOUSE_BTN = {
    left    = 0x1,
    right   = 0x2,
    middle  = 0x4,
}

--- @class PMouse
PMouse = {
    pressed = {
        [MOUSE_BTN.left] = false,
        [MOUSE_BTN.right] = false,
        [MOUSE_BTN.middle] = false,
    }
}
PMouse.__index = PMouse

function PMouse:enable()
    poke(0x5f2d, 0x1)
end

--- Returns the x, y position of the mouse
--- @return number, number "x,y"
function PMouse:position()
    return stat(32), stat(33)
end

--- Returns true if the button is currently pressed
--- @param button MOUSE_BTN
--- @return boolean
function PMouse:btn(button)
    return (stat(34) & button) ~= 0
end

--- Returns true if the button was just pressed
--- @param button MOUSE_BTN
--- @return boolean
function PMouse:btnp(button)
    local was_pressed = self.pressed[button]
    local is_pressed = self:btn(button)

    if is_pressed then
        if was_pressed then
            return false
        end

        self.pressed[button] = true
        return true
    end

    if was_pressed then
        self.pressed[button] = false
    end
    
    return false
end