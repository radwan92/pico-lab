-- title:       Spring Damping
-- description: Moving to a target position with acceleration and then
--              spring-like damping near the target.
-- origin:      LazyDevs Pico-8 Hero - https://www.youtube.com/watch?v=M-bwX1jE-eo

dt = 0.1667

Ball = {
    position = Vec2:new(63, 63),
    target_position = Vec2:new(63, 63),
    velocity = Vec2:new(0, 0),
    acceleration = 10,
    damping = 0.2,
    max_speed = 100,
    radius = 4,
    color = COLORS.green,

    draw = function(self)
        circ(self.position.x, self.position.y, self.radius, self.color)
    end,

    -- This is the core of the spring-damp technique
    update = function(self)
        if self.velocity:magnitude() == 0 then 
            return
        end

        -- Calculat how far are we from the target
        local offset = self.target_position - self.position
        
        -- Change speed - we want to get to the target
        self.velocity = self.velocity + offset:normalized() 
            * (offset:magnitude() * self.acceleration * dt)
        
        -- Cap the speed
        local clamped_speed = mid(0, self.velocity:magnitude(), self.max_speed)
        self.velocity = self.velocity:normalized() * clamped_speed

        -- Damp
        self.velocity = self.velocity * (1 - self.damping)
        
        -- Snap to target to prevent jitter
        if offset:magnitude() < 2 and self.velocity:magnitude() < 2 then
            self.position = self.target_position:clone()
            self.velocity = Vec2:new(0, 0)
        else
            -- Move!
            self.position = self.position + self.velocity * (dt)
        end
    end,
}

Menu = SimpleMenu:new()
    :with_up_down_selection()
    :with_enabled(function()
        return btn(BUTTONS.o)
    end)
    :with_disabled_draw(function()
        print("hold o to tweak values", 1, 1, 7)
        print("press arrows to move the ball", 1, 9, 7)
    end)
Menu:add_entry("acceleration", SMEntry.Control.left_right)
    :with_field_inc_dec(Ball, 1, 1, 100)
Menu:add_entry("damping", SMEntry.Control.left_right)
    :with_field_inc_dec(Ball, 0.01, 0.01, 1)
Menu:add_entry("max_speed", SMEntry.Control.left_right)
    :with_field_inc_dec(Ball, 5, 1, 300)

function change_ball_target_position()
    if btn(BUTTONS.o) then
        return
    end

    if btnp(BUTTONS.left) then
        Ball.target_position.x = mid(20, Ball.target_position.x - 100, 107)
        Ball.velocity = Ball.target_position - Ball.position
    end
    if btnp(BUTTONS.right) then
        Ball.target_position.x = mid(20, Ball.target_position.x + 100, 107)
        Ball.velocity = Ball.target_position - Ball.position
    end
    if btnp(BUTTONS.up) then
        Ball.target_position.y = mid(20, Ball.target_position.y - 100, 107)
        Ball.velocity = Ball.target_position - Ball.position
    end
    if btnp(BUTTONS.down) then
        Ball.target_position.y = mid(20, Ball.target_position.y + 100, 107)
        Ball.velocity = Ball.target_position - Ball.position
    end
end

function _update60()
    Ball:update()
    Menu:update()
    change_ball_target_position()
end

function _draw()
    cls(1)
    Menu:draw()
    Ball:draw()
end