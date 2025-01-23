-- title:       Smoke Puff
-- description: Creates a puff of smoke effect using a simple particle system
-- origin:      LazyDevs Pico-8 Hero - https://www.youtube.com/watch?v=LwvXRZO0IaQ

Particles = {
    list = {},

    new = function (self, position, ttl, colors)
        local p = {
            position = position,
            speed = Vec2:new(0, 0),
            start_ttl = ttl,
            ttl = ttl,
            colors = colors,
            radius = 1,
            speed_coeff = 1,
            radius_coeff = 1,
        }
        setmetatable(p, self)
        p.__index = self
        add(self.list, p)
        return p
    end,

    update_one = function (self)
        self.speed = self.speed * self.speed_coeff
        self.radius = self.radius * self.radius_coeff
        self.position = self.position + self.speed
        
        self.ttl = self.ttl - 1
        if self.ttl <= 0 then
            del(self.list, self)
        end
    end,

    draw_one = function (self)
        local ttl_percent = 1 - self.ttl / self.start_ttl
        local color = self.colors[1 + flr(ttl_percent * #self.colors)]

        circfill(self.position.x, self.position.y, self.radius, color)
    end,

    update = function ()
        for i = #Particles.list, 1, -1 do
            Particles.list[i]:update_one()
        end
    end,

    draw = function ()
        for i = #Particles.list, 1, -1 do
            Particles.list[i]:draw_one()
        end
    end,
}
Particles.__index = Particles

Smoke = {
    speed = 1,
    num_particles = 7,
    radius_min = 1,
    radius_max = 2,
    ttl_min = 30,
    ttl_max = 60,
    radius_coeff = 0.98,
    speed_coeff = 0.93,

    create_puff = function (self, position)
        for i = 0, self.num_particles do
            -- Make sure min is smaller than max
            if self.ttl_min > self.ttl_max then
                self.ttl_min, self.ttl_max = self.ttl_max, self.ttl_min
            end

            -- Smoke dies out quickly, so we want to randomize it a bit
            local ttl = self.ttl_min + rnd(self.ttl_max - self.ttl_min)

            -- Smoke starts white and fades to dark gray as it dies out
            local colors = { COLORS.white, COLORS.light_gray, COLORS.dark_gray }
            
            local particle = Particles:new(position, ttl, colors)

            -- Random direction center-out from the spawn point
            local rng = rnd()
            local speed = Vec2:new(sin(rng), cos(rng)) * self.speed

            particle.speed = speed
            particle.radius = self.radius_min + rnd(self.radius_max - self.radius_min)

            -- Radius changes over time - originally smoke particles get smaller
            particle.radius_coeff = self.radius_coeff

            -- Speed changes over time - originally smoke particles quickly slow down
            particle.speed_coeff = self.speed_coeff
        end
    end
}

Mouse = {
    x = 0,
    y = 0,

    update = function(self)
        self.x, self.y = PMouse:position()

        if PMouse:btnp(MOUSE_BTN.left) then
            local click_position = Vec2:new(self.x, self.y)
            Smoke:create_puff(click_position)
        end
    end,

    draw = function (self)
        pset(self.x, self.y, COLORS.orange)
    end
}

menu_enabled = false
Menu = SimpleMenu:new()
    :with_up_down_selection()
    :with_enabled(function()
        if btnp(BUTTONS.o) then
            menu_enabled = not menu_enabled
        end
        return menu_enabled
    end)
    :with_disabled_draw(function()
        print("press o to open tweak menu", 1, 1, COLORS.white)
    end)
Menu:add_entry("speed", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 0.1, 0, 10)
Menu:add_entry("num_particles", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 1, 1, 50)
Menu:add_entry("radius_min", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 1, 1, 10)
Menu:add_entry("radius_max", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 1, 1, 10)
Menu:add_entry("ttl_min", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 3, 1, 300)
Menu:add_entry("ttl_max", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 3, 1, 300)
Menu:add_entry("radius_coeff", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 0.005, 0.5, 1.5)
Menu:add_entry("speed_coeff", SMEntry.Control.left_right)
    :with_field_inc_dec(Smoke, 0.005, 0.5, 1.5)

function _init()
    PMouse:enable()
end

function _update60()
    Particles:update()
    Mouse:update()
    Menu:update()
end

function _draw()
    cls(1)
    Particles:draw()
    Mouse:draw()
    Menu:draw()
    print("click to create smoke puffs", 1, 122, COLORS.white)
end