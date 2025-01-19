-- title:       camera shake
-- description: a simple example of how to implement camera shake in pico-8
-- origin:      lazydevs pico-8 hero - https://www.youtube.com/watch?v=GhIpA03VD-c 

Cam = {
    x = 0,
    y = 0,
    shake = 0,

    update_shake = function(self)
        -- Config
        local magnitude = 16
        local damping = 0.95
        local min_shake = 0.05

        -- Offset the camera randomly
        local x = (magnitude - rnd(2 * magnitude)) * self.shake
        local y = (magnitude - rnd(2 * magnitude)) * self.shake

        -- Apply the offset
        camera(x + self.x, y + self.y)

        -- Reduce the shake amount
        self.shake = self.shake * damping

        -- Clamp the shake amount
        if self.shake < min_shake then
            self.shake = 0
        end
    end
}

function _update60()
    if btn(5) then 
        Cam.shake = 1
    end
end

function _draw()
    cls()
    
    Cam:update_shake()
    rectfill(0, 0, 127, 127, 1)
    print("press x to shake the camera", 0, 0, 7)
    rect(60, 60, 67, 67, 2)
end