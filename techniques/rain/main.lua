-- title:       Rain
-- description: Line-based rain effect with ground-hit effect
-- origin:      Rhythm Frog by giacomopc - https://www.lexaloffle.com/bbs/?tid=44923

Rain = {
    -- Number of raindrops
    amount = 50,
    last_amount = 0,

    -- The angle at which rain falls, in pico-8 system, x inverted
    -- 0 = horizontally to the left
    -- 0.25 = vertical top to bottom
    -- 0.5 = horizontally to the right
    slope = 0.2,

    -- How long is the raindrop
    length = 15,

    -- Speed factor applied on top of randomized raindrop speed
    speed_factor = 8,

    -- Raindrop target position; where it will hit the ground
    x = {},
    y = {},

    -- Time-point of the raindrop.
    -- 0 = raindrop just started falling
    -- 1 = raindrop fully hit the ground
    t = {},

    -- How fast the raindrop is falling
    speed = {},

    init = function(self)
        for i = 1, self.amount do
            -- From -0.25 to 1.25 of the screen width
            self.x[i] = rnd(SCREEN.width * 1.5) - SCREEN.width * 0.25
            -- From -0.25 to 1.25 of the screen height
            self.y[i] = rnd(SCREEN.height * 1.5) - SCREEN.height * 0.25
            -- Randomize the starting time-point of the raindrop
            self.t[i] = rnd()
            self.speed[i] = 15 + rnd(30)
        end
    end,

    update = function(self)
        if self.amount ~= self.last_amount then
            self.last_amount = self.amount
            self:init()
        end

        for i = 1, self.amount do
            self.t[i] = (self.t[i] + 1 / 60) % 1
        end
    end,

    draw = function(self)
        for i = 1, self.amount do
            local length = self.length

            -- Calculate vertical and horizontal speed
            local speed = self.speed[i]
            local dx = cos(self.slope) * speed * self.speed_factor
            local dy = sin(self.slope) * speed * self.speed_factor

            -- Where the raindrop should be given its speed and the
            -- current time-point `t`
            local t = self.t[i]
            local x = lerp(self.x[i] + dx, self.x[i], t)
            local y = lerp(self.y[i] + dy, self.y[i], t)

            -- Clip to the hit point so we don't draw the raindrop
            -- below the ground
            clip(0, 0, SCREEN.width, self.y[i])

            -- Calculate the raindrop vector
            local lx = cos(self.slope) * length
            local ly = sin(self.slope) * length

            -- Draw the raindrop line
            line(x, y, x - lx, y - ly, 7)

            clip()

            local hit = y > self.y[i] + ly
            if hit then
                spr(0, self.x[i] - 1, self.y[i] - 1)
            end
        end
        clip()
    end
}

Menu = SimpleMenu:new()
    :with_up_down_selection()
Menu:add_entry("amount", SMEntry.Control.left_right)
    :with_field_inc_dec(Rain, 5, 5, 200)
Menu:add_entry("slope", SMEntry.Control.left_right)
    :with_field_inc_dec(Rain, 0.02, 0, 0.5)
Menu:add_entry("length", SMEntry.Control.left_right)
    :with_field_inc_dec(Rain, 2, 1, 30)
Menu:add_entry("speed_factor", SMEntry.Control.left_right)
    :with_field_inc_dec(Rain, 0.5, 1, 30)

function _update60()
    Menu:update()
    Rain:update()
end

function _draw()
    cls(1)
    Menu:draw()
    Rain:draw()
end
