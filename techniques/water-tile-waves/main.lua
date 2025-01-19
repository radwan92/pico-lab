-- title:       Water Tile Waves
-- description: Waving water effect on selected tiles
-- origin:      pico-8 zine #2, page 32. Modified.

frame = 0

Cam = { 
    x = 8,
    y = -24, 
    speed = 0.4,

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
}

function warp_water_tiles()
    local tiles_per_screen = 16
    local wave_speed = 0.1667
    local displacement = 1

    -- Calculate the tile range to draw
    for tile_y = max(0, flr(Cam.y / 8)), flr(Cam.y / 8) + tiles_per_screen do
    for tile_x = max(0, flr(Cam.x / 8)), flr(Cam.x / 8) + tiles_per_screen do

        local tile = mget(tile_x, tile_y)
        local has_wave_flag = fget(tile, 4)

        if has_wave_flag then
            -- Go through each row
            for y = 0, 7 do
                -- Calculate the offset which creates the wave effect
                -- Note: +0.5 to make the offset [-0.5, 1.5] (given displacement of 1) 
                -- instead of [-0.5, 0.5] which would never shift right (as pset rounds down)
                local offset = sin((frame * wave_speed + y) / 12) * displacement + 0.5
                if offset > 0 then
                    -- Shift the pixels to the right
                    for x = 7, 0, -1 do
                        local color = pget(tile_x * 8 + x, tile_y * 8 + y)
                        pset(tile_x * 8 + x + offset, tile_y * 8 + y, color)
                    end
                else
                    -- Shift the pixels to the left
                    for x = 0, 7 do
                        local color = pget(tile_x * 8 + x, tile_y * 8 + y)
                        pset(tile_x * 8 + x + offset, tile_y * 8 + y, color)
                    end
                end
            end
        end
    end
    end
end

function _update60()
    frame = frame + 1

    for _, button in pairs(BUTTONS) do
        if btn(button) then
            Cam:move(button)
        end
    end
end

function _draw()
    cls()

    -- Set camera position
    camera(Cam.x, Cam.y)
        -- Draw the map
        map()
        -- Apply the warp effect
        warp_water_tiles()
    camera(0, 0)

    -- Draw the camera position (in tiles)
    print("tile: "..flr(Cam.x / 8).."/"..flr(Cam.y / 8), 0, 0, 7)
end
