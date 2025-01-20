-- title:       Doom Fire
-- description: Attempt to recreate the fire effect from Doom
-- origin:      Fabien Sanglard's blog post: https://fabiensanglard.net/doom_fire_psx/

-- Color of the fire by its TTL (the higher the TTL, the brighter the color)
fire_by_ttl = { 
    COLORS.black, 
    COLORS.dark_gray,
    COLORS.brown,
    COLORS.dark_purple,
    COLORS.red,
    COLORS.orange,
    COLORS.yellow,
    COLORS.white
}

bytes_per_row = 64
rows_to_draw = 48
fire_data_size = bytes_per_row * rows_to_draw

-- Fire TTL is stored starting at 0x2000 (map), 4 bytes per pixel,
memory_ttl_start = MEM_LAYOUT.map
memory_screen_end = MEM_LAYOUT.screen + 0x2000

-- Zero-out the TTL memory
memset(memory_ttl_start, 0, fire_data_size)
cls()

-- Stores the fire TTL similarly to how pixels are stored in the screen memory
function set_fire_ttl(at, left_px_ttl, right_px_ttl)
    local ttl = left_px_ttl | right_px_ttl << 4
    poke(memory_ttl_start + at, ttl)
end

-- Sets the fire pixels directly in screen memory
function set_fire_color(at, left_px, right_px)
    local px = left_px | right_px << 4
    poke(MEM_LAYOUT.screen + 0x1fff - at, px)
end

-- Initialize the fire TTL and the fire color to white at the lowest row
-- (the fire will start at the bottom of the screen)
for i = 0, 63, 1 do
    local max_ttl = #fire_by_ttl
    set_fire_ttl(i, max_ttl, max_ttl)

    local hottest_color = fire_by_ttl[max_ttl]
    set_fire_color(i, hottest_color, hottest_color)
end

function _update60()
    -- We move for bytes at the time for performance reasons
    for pos=fire_data_size, 0, -4 do
        -- Read the current TTL
        local ttl = peek4(memory_ttl_start + pos)
        local new_ttl = 0
        local fire_color = 0

        -- The routine below is similar to set_fire_ttl and set_fire_color
        -- except that it operates on 4 bytes at a time for efficiency

        -- Handle high nibbles
        for i = 12, 0, -4 do
            -- Extract the TTL
            local px_ttl = ttl >> i & 0xf

            -- Decrease the TTL by 1 with some chance. Cap the TTL to 1
            -- Note: the randomness is the most costly operation in this loop,
            -- perhaps it could be optimized further by pregenerating a rnd table
            px_ttl = max(1, px_ttl - flr(rnd(5)/3))

            -- Store the new TTL
            new_ttl = new_ttl | px_ttl << i

            -- Store the new color
            fire_color = fire_color | fire_by_ttl[px_ttl] << i
        end

        -- Same as above but for the low nibbles
        for i = 4, 16, 4 do
            local px = ttl << i & 0xf
            px = max(1, px - flr(rnd(5)/3))
            new_ttl = new_ttl | px >> i
            fire_color = fire_color | fire_by_ttl[px] >> i
        end

        -- Store the TTL back but shifted by a row
        poke4(memory_ttl_start + bytes_per_row + pos, new_ttl)
        -- Store the color back but shifted by a row and 4 bytes 
        -- (since we're writing 4 bytes at the time)
        poke4(memory_screen_end + - pos - 4 - bytes_per_row, fire_color)
    end
end
