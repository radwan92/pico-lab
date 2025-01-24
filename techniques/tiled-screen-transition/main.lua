-- title:       Tiled Screen Transition
-- description: Diagonal, tile-flipping-like screen transition, using sprites
-- origin:      Driftmania source code: https://github.com/maxbize/PICO-8/blob/9f79b9defff0d524654fe140c7745ecf0cc234a7/Driftmania/driftmania.lua#L408

animation_frame = 0

function restart_animation()
    animation_frame = 45
end

function animate_screen()
    if animation_frame <= 0 then
        -- Do nothing if animation has finished
        return
    end

    -- Set colors to be transparent. See the sprite sheet to understand why.
    -- Alternatively, you can use palt(1), which would set all colors except
    -- peach to be transparent.
    palt(COLORS.peach, true)
    palt(COLORS.black, false)

    for x = 0, SCREEN.width, 8 do
        for y = 0, SCREEN.height, 8 do
        -- Calculate sprite index based on animation frame and position
        -- Using both x and y to creates a pattern that moves diagonally
        local sprite_index = mid(0, 31, -15 + animation_frame + x / 16 + y / 16)
        spr(sprite_index, x, y)
        end
    end
    palt()
    animation_frame = animation_frame - 1
end

function _update()
    if btnp(BUTTONS.x) or btnp(BUTTONS.o) then
        restart_animation()
    end
end

function _draw()
    cls(1)
    print("press x or o", 0, 0, COLORS.white)
    animate_screen()
end