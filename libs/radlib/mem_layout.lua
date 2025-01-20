--- @enum MEM_LAYOUT
MEM_LAYOUT = {
    gfx                 = 0x0000,
    gfx2_map2           = 0x1000,
    map                 = 0x2000,
    gfx_flags           = 0x3000,
    song                = 0x3100,
    sfx                 = 0x3200,
    user_data           = 0x4300,
    custom_font         = 0x5600,
    persistent_data     = 0x5E00,
    draw_state          = 0x5F00,
    hardware_state      = 0x5F40,
    gpio_pins           = 0x5F80,
    screen              = 0x6000,
    user_data2          = 0x8000,
}
