-- =========================================================================
-- 6.1 SYSTEM (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#System)
-- =========================================================================

-- ASSERT(CONDITION, [MESSAGE])
--
-- If CONDITION is false, stop the program and print MESSAGE if it is given. This can be useful for debugging cartridges, by ASSERT()'ing that things that you expect to be true are indeed true.
-- ```
-- ASSERT(ADDR >= 0 AND ADDR <= 0x7FFF, "OUT OF RANGE")
-- POKE(ADDR, 42) -- THE MEMORY ADDRESS IS OK, FOR SURE!
-- ```
---@param CONDITION boolean
---@param MESSAGE? string
function assert(CONDITION, MESSAGE) end

-- FLIP()
--
-- Flip the back buffer to screen and wait for next frame. This call is not needed when there is a _DRAW() or _UPDATE() callback defined, as the flip is performed automatically. But when using a custom main loop, a call to FLIP is normally needed:
-- ```
-- ::_::
-- CLS()
-- FOR I=1,100 DO
--   A=I/50 - T()
--   X=64+COS(A)*I
--   Y=64+SIN(A)*I
--   CIRCFILL(X,Y,1,8+(I/4)%8)
-- END
-- FLIP()GOTO _
-- ```
--
-- If your program does not call FLIP before a frame is up, and a _DRAW() callback is not in progress, the current contents of the back buffer are copied to screen.
function flip() end

-- PRINTH(STR, [FILENAME], [OVERWRITE], [SAVE_TO_DESKTOP])
--
-- Print a string to the host operating system's console for debugging.
--
-- If filename is set, append the string to a file on the host operating system (in the current directory by default -- use FOLDER to view).
--
-- Setting OVERWRITE to true causes that file to be overwritten rather than appended.
--
-- Setting SAVE_TO_DESKTOP to true saves to the desktop instead of the current path.
--
-- Use a filename of "@clip" to write to the host's clipboard.
---@param STR string
---@param FILENAME? string
---@param OVERWRITE? boolean
---@param SAVE_TO_DESKTOP? boolean
function printh(STR, FILENAME, OVERWRITE, SAVE_TO_DESKTOP) end

-- TIME()
--
-- Returns the number of seconds elapsed since the cartridge was run.
--
-- This is not the real-world time, but is calculated by counting the number of times
--
-- _UPDATE or @_UPDATE60 is called. Multiple calls of TIME() from the same frame return
-- the same result.
function time() return 0 end

-- STAT(X)
--
-- Get system status where X is:
-- ```
-- 0  Memory usage (0..2048)
-- 1  CPU used since last flip (1.0 == 100% CPU)
-- 4  Clipboard contents (after user has pressed CTRL-V)
-- 6  Parameter string
-- 7  Current framerate
--
-- 46..49  Index of currently playing SFX on channels 0..3
-- 50..53  Note number (0..31) on channel 0..3
-- 54      Currently playing pattern index
-- 55      Total patterns played
-- 56      Ticks played on current pattern
-- 57      (Boolean) TRUE when music is playing
--
-- 80..85  UTC time: year, month, day, hour, minute, second
-- 90..95  Local time
--
-- 100     Current breadcrumb label, or nil
-- 110     Returns true when in frame-by-frame mode
-- ```
-- ```
-- ⓘ
-- Audio values 16..26 are the legacy version of audio state queries 46..56. They only report on the current state of the audio mixer, which changes only ~20 times a second (depending on the host sound driver and other factors). 46..56 instead stores a history of mixer state at each tick to give a higher resolution estimate of the currently audible state.
-- ```
---@param X number
---@return number
function stat(X) return 0 end


-- =============================================================================
-- 6.2 GRAPHICS (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Graphics)
-- =============================================================================


-- CLIP(X, Y, W, H, [CLIP_PREVIOUS])
--
-- Sets the clipping rectangle in pixels. All drawing operations will be clipped to the rectangle at x, y with a width and height of w,h.
--
-- CLIP() to reset.
--
-- When CLIP_PREVIOUS is true, clip the new clipping region by the old one.
---@param X number
---@param Y number
---@param W number
---@param H number
---@param CLIP_PREVIOUS? boolean
---@overload fun()
function clip(X, Y, W, H, CLIP_PREVIOUS) end

-- PSET(X, Y, [COL])
--
-- Sets the pixel at x, y to colour index COL (0..15).
--
-- When COL is not specified, the current draw colour is used.
-- ```
-- FOR Y=0,127 DO
--   FOR X=0,127 DO
--     PSET(X, Y, X*Y/8)
--   END
-- END
-- ```
---@param X number
---@param Y number
---@param COL? number
function pset(X, Y, COL) end

-- PGET(X, Y)
--
-- Returns the colour of a pixel on the screen at (X, Y).
-- ```
-- WHILE (TRUE) DO
--   X, Y = RND(128), RND(128)
--   DX, DY = RND(4)-2, RND(4)-2
--   PSET(X, Y, PGET(DX+X, DY+Y))
-- END
-- ```
-- When X and Y are out of bounds, PGET returns 0. A custom return value can be specified with:
--
-- ```
-- POKE(0x5f36, 0x10)
-- POKE(0x5f5B, NEWVAL)
-- ```
-- 
---@param X number
---@param Y number
---@return number
function pget(X, Y) return 0 end

-- SGET(X, Y)
--
-- Get the colour (COL) of a sprite sheet pixel.
--
-- When X and Y are out of bounds, SGET returns 0. A custom value can be specified with:
-- ```
-- POKE(0x5f36, 0x10)
-- POKE(0x5f59, NEWVAL)
-- ```
---@param X number
---@param Y number
---@return number
function sget(X, Y) return 0 end

-- SSET(X, Y, [COL])
--
-- Set the colour (COL) of a sprite sheet pixel.
---@param X number
---@param Y number
---@param COL? number
function sset(X, Y, COL) end

-- FGET(N, [F])
--
-- Get the value (VAL) of sprite N's flag F.
--
-- F is the flag index 0..7.
--
-- The initial state of flags 0..7 are settable in the sprite editor, so can be used to create custom sprite attributes. It is also possible to draw only a subset of map tiles by providing a mask in MAP().
--
-- When F is omitted, all flags are retrieved as a single bitfield.
-- ```
-- FSET(2, 1 | 2 | 8)   -- SETS BITS 0,1 AND 3
-- FSET(2, 4, TRUE)     -- SETS BIT 4
-- PRINT(FGET(2))       -- 27 (1 | 2 | 8 | 16)
-- ```
---@param N number
---@param F? number
---@return number
function fget(N, F) return 0 end

-- FSET(N, [F], VAL)
--
-- Set the value (VAL) of sprite N's flag F.
--
-- F is the flag index 0..7.
--
-- VAL is TRUE or FALSE.
--
-- The initial state of flags 0..7 are settable in the sprite editor, so can be used to create custom sprite attributes. It is also possible to draw only a subset of map tiles by providing a mask in MAP().
--
-- When F is omitted, all flags are set as a single bitfield.
-- ```
-- FSET(2, 1 | 2 | 8)   -- SETS BITS 0,1 AND 3
-- FSET(2, 4, TRUE)     -- SETS BIT 4
-- PRINT(FGET(2))       -- 27 (1 | 2 | 8 | 16)
-- ```
---@param N number
---@param F? number
---@param VAL boolean
function fset(N, F, VAL) end

-- PRINT(STR, [COL])
--
-- PRINT(STR, X, Y, [COL])
--
-- Print a string STR and optionally set the draw colour to COL.
--
-- Shortcut: written on a single line, ? can be used to call print without brackets:
-- ```
-- ?"HI"
-- ```
-- When X, Y are not specified, a newline is automatically appended. This can be omitted by ending the string with an explicit termination control character:
-- ```
-- ?"THE QUICK BROWN FOX\0"
-- ```
-- Additionally, when X, Y are not specified, printing text below 122 causes the console to scroll. This can be disabled during runtime with POKE(0x5f36,0x40).
--
-- PRINT returns the right-most x position that occurred while printing. This can be used to find out the width of some text by printing it off-screen:
-- ```
-- W = PRINT("HOGE", 0, -20) -- returns 16
-- ```
-- See Appendix A (P8SCII) for information about control codes and custom fonts.
--- @param STR string
--- @param X number
--- @param Y number
--- @param COL? number
--- @return number
--- @overload fun(STR: string, COL?: number)
function print(STR, X, Y, COL) return 0 end

-- CURSOR(X, Y, [COL])
--
-- Set the cursor position.
--
-- If COL is specified, also set the current colour.
---@param X number
---@param Y number
---@param COL? number
function cursor(X, Y, COL) end

-- COLOR([COL])
--
-- Set the current colour to be used by drawing functions.
--
-- If COL is not specified, the current colour is set to 6
---@param COL? number
function color(COL) end

-- CLS([COL])
--
-- Clear the screen and reset the clipping rectangle.
--
-- COL defaults to 0 (black)
---@param COL? number
function cls(COL) end

-- CAMERA([X, Y])
--
-- Set a screen offset of -x, -y for all drawing operations
--
-- CAMERA() to reset
---@param X? number
---@param Y? number
function camera(X, Y) end

-- CIRC(X, Y, R, [COL])
--
-- Draw a circle at x,y with radius r
--
-- If r is negative, the circle is not drawn.
--
-- When bits 0x1800.0000 are set in COL, and 0x5F34 & 2 == 2, the circle is drawn inverted.
--- @param X number
--- @param Y number
--- @param R number
--- @param COL? number
function circ(X, Y, R, COL) end

-- CIRCFILL(X, Y, R, [COL])
--
-- Draw a filled circle at x,y with radius r
--
-- If r is negative, the circle is not drawn.
--
-- When bits 0x1800.0000 are set in COL, and 0x5F34 & 2 == 2, the circle is drawn inverted.
--- @param X number
--- @param Y number
--- @param R number
--- @param COL? number
function circfill(X, Y, R, COL) end

-- OVAL(X0, Y0, X1, Y1, [COL])
--
-- Draw an oval that is symmetrical in x and y (an ellipse), with the given bounding rectangle.
--- @param X0 number
--- @param Y0 number
--- @param X1 number
--- @param Y1 number
--- @param COL? number
function oval(X0, Y0, X1, Y1, COL) end

-- OVALFILL(X0, Y0, X1, Y1, [COL])
--
-- Draw an oval that is symmetrical in x and y (an ellipse), with the given bounding rectangle.
--- @param X0 number
--- @param Y0 number
--- @param X1 number
--- @param Y1 number
--- @param COL? number
function ovalfill(X0, Y0, X1, Y1, COL) end

-- LINE(X0, Y0, [X1, Y1, [COL]])
--
-- Draw a line from (X0, Y0) to (X1, Y1)
--
-- If (X1, Y1) are not given, the end of the last drawn line is used.
--
-- LINE() with no parameters means that the next call to LINE(X1, Y1) will only set the end points without drawing.
-- ```
-- CLS()
-- LINE()
-- FOR I=0,6 DO
--   LINE(64+COS(I/6)*20, 64+SIN(I/6)*20, 8+I)
-- END
-- ```
---@param X0 number
---@param Y0 number
---@param X1? number
---@param Y1? number
---@param COL? number
function line(X0, Y0, X1, Y1, COL) end

-- RECT(X0, Y0, X1, Y1, [COL])
--
-- Draw a rectangle with corners at (X0, Y0), (X1, Y1).
--- @param X0 number
--- @param Y0 number
--- @param X1 number
--- @param Y1 number
--- @param COL? number
function rect(X0, Y0, X1, Y1, COL) end

-- RECTFILL(X0, Y0, X1, Y1, [COL])
--
-- Draw a filled rectangle with corners at (X0, Y0), (X1, Y1).
--- @param X0 number
--- @param Y0 number
--- @param X1 number
--- @param Y1 number
--- @param COL? number
function rectfill(X0, Y0, X1, Y1, COL) end

-- PAL(C0, C1, [P])
--
-- PAL() swaps colour c0 for c1 for one of three palette re-mappings (p defaults to 0):
--
-- 0: Draw Palette
--
-- The draw palette re-maps colours when they are drawn. For example, an orange flower sprite can be drawn as a red flower by setting the 9th palette value to 8:
-- ```
-- PAL(9,8)     -- draw subsequent orange (colour 9) pixels as red (colour 8)
-- SPR(1,70,60) -- any orange pixels in the sprite will be drawn with red instead
-- ```
-- Changing the draw palette does not affect anything that was already drawn to the screen.
--
-- 1: Display Palette
--
-- The display palette re-maps the whole screen when it is displayed at the end of a frame. For example, if you boot PICO-8 and then type PAL(6,14,1), you can see all of the gray (colour 6) text immediate change to pink (colour 14) even though it has already been drawn. This is useful for screen-wide effects such as fading in/out.
--
-- 2: Secondary Palette
--
-- Used by FILLP() for drawing sprites. This provides a mapping from a single 4-bit colour index to two 4-bit colour indexes.
--
-- PAL()  resets all palettes to system defaults (including transparency values)
--
-- PAL(P) resets a particular palette (0..2) to system defaults
---@param C0 number
---@param C1 number
---@param P? number
---@overload fun()
---@overload fun(P: number)
function pal(C0, C1, P) end

-- PAL(TBL, [P])
--
-- When the first parameter of pal is a table, colours are assigned for each entry. For example, to re-map colour 12 and 14 to red:
-- ```
-- PAL({[12]=9, [14]=8})
-- ```
-- Or to re-colour the whole screen shades of gray (including everything that is already drawn):
-- ```
-- PAL({1,1,5,5,5,6,7,13,6,7,7,6,13,6,7,1}, 1)
-- ```
-- Because table indexes start at 1, colour 0 is given at the end in this case.
---@param TBL table
---@param P? number
function pal(TBL, P) end

-- PALT(C, [T])
--
-- Set transparency for colour index to T (boolean) Transparency is observed by SPR(), SSPR(), MAP() AND TLINE()
-- ```
-- PALT(8, TRUE) -- RED PIXELS NOT DRAWN IN SUBSEQUENT SPRITE/TLINE DRAW CALLS
-- ```
-- PALT() resets to default: all colours opaque except colour 0
-- 
-- When C is the only parameter, it is treated as a bitfield used to set all 16 values. For example: to set colours 0 and 1 as transparent:
-- ```
-- PALT(0B1100000000000000)
-- ```
---@param C number
---@param T? boolean
---@overload fun()
function palt(C, T) end

-- SPR(N, X, Y, [W, H], [FLIP_X], [FLIP_Y])
--
-- Draw sprite N (0..255) at position X,Y
--
-- W (width) and H (height) are 1, 1 by default and specify how many sprites wide to blit.
--
-- Colour 0 drawn as transparent by default (see PALT())
--
-- When FLIP_X is TRUE, flip horizontally.
--
-- When FLIP_Y is TRUE, flip vertically.
--- @param N number
--- @param X number
--- @param Y number
--- @param W? number
--- @param H? number
--- @param FLIP_X? boolean
--- @param FLIP_Y? boolean
function spr(N, X, Y, W, H, FLIP_X, FLIP_Y) end

-- SSPR(SX, SY, SW, SH, DX, DY, [DW, DH], [FLIP_X], [FLIP_Y]]
--
-- Stretch a rectangle of the sprite sheet (sx, sy, sw, sh) to a destination rectangle on the screen (dx, dy, dw, dh). In both cases, the x and y values are coordinates (in pixels) of the rectangle's top left corner, with a width of w, h.
--
-- Colour 0 drawn as transparent by default (see PALT())
--
-- dw, dh defaults to sw, sh
--
-- When FLIP_X is TRUE, flip horizontally.
--
-- When FLIP_Y is TRUE, flip vertically.
--- @param SX number
--- @param SY number
--- @param SW number
--- @param SH number
--- @param DX number
--- @param DY number
--- @param DW? number
--- @param DH? number
--- @param FLIP_X? boolean
--- @param FLIP_Y? boolean
function sspr(SX, SY, SW, SH, DX, DY, DW, DH, FLIP_X, FLIP_Y) end

-- FILLP(P)
--
-- The PICO-8 fill pattern is a 4x4 2-colour tiled pattern observed by: CIRC() CIRCFILL() RECT() RECTFILL() OVAL() OVALFILL() PSET() LINE()
--
-- P is a bitfield in reading order starting from the highest bit. To calculate the value of P for a desired pattern, add the bit values together:
-- ```
--   .-----------------------.
--   |32768|16384| 8192| 4096|
--   |-----|-----|-----|-----|
--   | 2048| 1024| 512 | 256 |
--   |-----|-----|-----|-----|
--   | 128 |  64 |  32 |  16 |
--   |-----|-----|-----|-----|
--   |  8  |  4  |  2  |  1  |
--   '-----------------------'
-- ```
-- For example, FILLP(4+8+64+128+ 256+512+4096+8192) would create a checkerboard pattern.
--
-- This can be more neatly expressed in binary: FILLP(0b0011001111001100).
--
-- The default fill pattern is 0, which means a single solid colour is drawn.
--
-- To specify a second colour for the pattern, use the high bits of any colour parameter:
-- ```
-- FILLP(0b0011010101101000)
-- CIRCFILL(64,64,20, 0x4E) -- brown and pink
-- ```
-- Additional settings are given in bits 0b0.111:
-- 
-- 0b0.100 Transparency
--
-- When this bit is set, the second colour is not drawn
-- ```
-- -- checkboard with transparent squares
-- FILLP(0b0011001111001100.1)
-- ```
-- 0b0.010 Apply to Sprites
--
-- When set, the fill pattern is applied to sprites (spr, sspr, map, tline), using a colour mapping provided by the secondary palette.
--
-- Each pixel value in the sprite (after applying the draw palette as usual) is taken to be an index into the secondary palette. Each entry in the secondary palette contains the two colours used to render the fill pattern. For example, to draw a white and red (7 and 8) checkerboard pattern for only blue pixels (colour 12) in a sprite:
-- ```
-- FOR I=0,15 DO PAL(I, I+I*16, 2) END  --  all other colours map to themselves
-- PAL(12, 0x87, 2)                     --  remap colour 12 in the secondary palette
-- 
-- FILLP(0b0011001111001100.01)         --  checkerboard palette, applied to sprites
-- SPR(1, 64,64)                        --  draw the sprite
-- ```
-- 0b0.001 Apply Secondary Palette Globally
--
-- When set, the secondary palette mapping is also applied by all draw functions that respect fill patterns (circfill, line etc). This can be useful when used in conjunction with sprite drawing functions, so that the colour index of each sprite pixel means the same thing as the colour index supplied to the drawing functions.
-- ```
-- FILLP(0b0011001111001100.001)
-- PAL(12, 0x87, 2)
-- CIRCFILL(64,64,20,12)                -- red and white checkerboard circle
-- ```
-- The secondary palette mapping is applied after the regular draw palette mapping. So the following would also draw a red and white checkered circle:
-- ```
-- PAL(3,12)
-- CIRCFILL(64,64,20,3)
-- ```
-- The fill pattern can also be set by setting bits in any colour parameter (for example, the parameter to COLOR(), or the last parameter to LINE(), RECT() etc.
-- ```
-- POKE(0x5F34, 0x3) -- 0x1 enable fillpattern in high bits  0x2 enable inversion mode
-- CIRCFILL(64,64,20, 0x114E.ABCD) -- sets fill pattern to ABCD
-- ```
-- When using the colour parameter to set the fill pattern, the following bits are used:
-- ```
-- bit  0x1000.0000 this needs to be set: it means "observe bits 0xf00.ffff"
-- bit  0x0100.0000 transparency
-- bit  0x0200.0000 apply to sprites
-- bit  0x0400.0000 apply secondary palette globally
-- bit  0x0800.0000 invert the drawing operation (circfill/ovalfill/rectfill)
-- bits 0x00FF.0000 are the usual colour bits
-- bits 0x0000.FFFF are interpreted as the fill pattern
-- ```
---@param P number
function fillp(P) end


-- ===========================================================================================
-- 6.3 TABLE FUNCTIONS (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Table_Functions)
-- ===========================================================================================


-- ADD(TBL, VAL, [INDEX])
--
-- Add value VAL to the end of table TBL. Equivalent to:
-- ```
-- TBL[#TBL + 1] = VAL
-- ```
-- If index is given then the element is inserted at that position:
-- ```
-- FOO={}        -- CREATE EMPTY TABLE
-- ADD(FOO, 11)
-- ADD(FOO, 22)
-- PRINT(FOO[2]) -- 22
-- ```
---@param TBL table
---@param VAL any
---@param INDEX? number
function add(TBL, VAL, INDEX) end

-- DEL(TBL, VAL)
--
-- Delete the first instance of value VAL in table TBL. The remaining entries are shifted left one index to avoid holes.
--
-- Note that VAL is the value of the item to be deleted, not the index into the table. (To remove an item at a particular index, use DELI instead). DEL returns the deleted item, or returns no value when nothing was deleted.
-- ```
-- A={1,10,2,11,3,12}
-- FOR ITEM IN ALL(A) DO
--   IF (ITEM < 10) THEN DEL(A, ITEM) END
-- END
-- FOREACH(A, PRINT) -- 10,11,12
-- PRINT(A[3])       -- 12
-- ```
---@param TBL table
---@param VAL any
---@return any
function del(TBL, VAL) return nil end

-- DELI(TBL, [I])
--
-- Like DEL(), but remove the item from table TBL at index I When I is not given, the last element of the table is removed and returned.
---@param TBL table
---@param I? number
---@return any
function deli(TBL, I) return nil end

-- COUNT(TBL, [VAL])
--
-- Returns the length of table t (same as #TBL) When VAL is given, returns the number of instances of VAL in that table.
---@param TBL table
---@param VAL? any
---@return number
function count(TBL, VAL) return 0 end

-- ALL(TBL)
--
-- Used in FOR loops to iterate over all items in a table (that have a 1-based integer index), in the order they were added.
-- ```
-- T = {11,12,13}
-- ADD(T,14)
-- ADD(T,"HI")
-- FOR V IN ALL(T) DO PRINT(V) END -- 11 12 13 14 HI
-- PRINT(#T) -- 5
-- ```
---@param TBL table
---@return any
function all(TBL) return nil end

-- FOREACH(TBL, FUNC)
--
-- For each item in table TBL, call function FUNC with the item as a single parameter.
-- ```
-- FOREACH({1,2,3}, PRINT)
-- ```
---@param TBL table
---@param FUNC function
function foreach(TBL, FUNC) end

-- PAIRS(TBL)
--
-- Used in FOR loops to iterate over table TBL, providing both the key and value for each item. Unlike ALL(), PAIRS() iterates over every item regardless of indexing scheme. Order is not guaranteed.
-- ```
-- T = {["HELLO"]=3, [10]="BLAH"}
-- T.BLUE = 5;
-- FOR K,V IN PAIRS(T) DO
--   PRINT("K: "..K.."  V:"..V)
-- END
-- ```
-- Output:
-- ```
-- K: 10  v:BLAH
-- K: HELLO  v:3
-- K: BLUE  v:5
-- ```
---@param TBL table
---@return any
function pairs(TBL) return nil end


-- =======================================================================
-- 6.4 INPUT (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Input)
-- =======================================================================


-- BTN([B], [PL])
--
-- Get button B state for player PL (default 0)
--
-- B: 0..5: left right up down button_o button_x
--
-- PL: player index 0..7
--
-- Instead of using a number for B, it is also possible to use a button glyph. (In the coded editor, use Shift-L R U D O X)
--
-- If no parameters supplied, returns a bitfield of all 12 button states for player 0 & 1 // P0: bits 0..5 P1: bits 8..13
--
-- Default keyboard mappings to player buttons:
-- ```
--   player 0: [DPAD]: cursors, [O]: Z C N   [X]: X V M
--   player 1: [DPAD]: SFED,    [O]: LSHIFT  [X]: TAB W  Q A
-- ```
--- @param B? number
--- @param PL? number
function btn(B, PL) return 0 end

-- BTNP(B, [PL])
--
-- BTNP is short for "Button Pressed"; Instead of being true when a button is held down, BTNP returns true when a button is down AND it was not down the last frame. It also repeats after 15 frames, returning true every 4 frames after that (at 30fps -- double that at 60fps). This can be used for things like menu navigation or grid-wise player movement.
--
-- The state that BTNP reads is reset at the start of each call to _UPDATE or _UPDATE60, so it is preferable to use BTNP from inside one of those functions.
--
-- Custom delays (in frames 30fps) can be set by poking the following memory addresses:
-- ```
-- POKE(0X5F5C, DELAY) -- SET THE INITIAL DELAY BEFORE REPEATING. 255 MEANS NEVER REPEAT.
-- POKE(0X5F5D, DELAY) -- SET THE REPEATING DELAY.
-- ```
-- In both cases, 0 can be used for the default behaviour (delays 15 and 4)
---@param B number
---@param PL? number
---@return boolean
function btnp(B, PL) return false end


-- =======================================================================
-- 6.5 AUDIO (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Audio)
-- =======================================================================


-- SFX(N, [CHANNEL], [OFFSET], [LENGTH])
--
-- Play sfx N (0..63) on CHANNEL (0..3) from note OFFSET (0..31 in notes) for LENGTH notes.
--
-- Using negative CHANNEL values have special meanings:
-- ```
-- CHANNEL -1: (default) to automatically choose a channel that is not being used
-- CHANNEL -2: to stop the given sound from playing on any channel
-- ```
-- N can be a command for the given CHANNEL (or all channels when CHANNEL < 0):
-- ```
-- N -1: to stop sound on that channel
-- N -2: to release sound on that channel from looping
-- ```
-- ```
-- SFX(3)    --  PLAY SFX 3
-- SFX(3,2)  --  PLAY SFX 3 ON CHANNEL 2
-- SFX(3,-2) --  STOP SFX 3 FROM PLAYING ON ANY CHANNEL
-- SFX(-1,2) --  STOP WHATEVER IS PLAYING ON CHANNEL 2
-- SFX(-2,2) --  RELEASE LOOPING ON CHANNEL 2
-- SFX(-1)   --  STOP ALL SOUNDS ON ALL CHANNELS
-- SFX(-2)   --  RELEASE LOOPING ON ALL CHANNELS
-- ```
---@param N number
---@param CHANNEL? number
---@param OFFSET? number
---@param LENGTH? number
function sfx(N, CHANNEL, OFFSET, LENGTH) end

-- MUSIC(N, [FADE_LEN], [CHANNEL_MASK])
--
-- Play music starting from pattern N (0..63)
--
-- N -1 to stop music
--
-- FADE_LEN is in ms (default: 0). So to fade pattern 0 in over 1 second:
-- ```
-- MUSIC(0, 1000)
-- ```
-- CHANNEL_MASK specifies which channels to reserve for music only. For example, to play only on channels 0..2:
--
-- MUSIC(0, NIL, 7) -- 1 | 2 | 4
--
-- Reserved channels can still be used to play sound effects on, but only when that channel index is explicitly requested by SFX().
---@param N number
---@param FADE_LEN? number
---@param CHANNEL_MASK? number
function music(N, FADE_LEN, CHANNEL_MASK) end


-- ===================================================================
-- 6.6 MAP (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Map)
-- 
-- The PICO-8 map is a 128x32 grid of 8-bit values, or 128x64 when using the shared memory. 
-- When using the map editor, the meaning of each value is taken to be an index into the sprite sheet (0..255). 
-- However, it can instead be used as a general block of data.
-- ===================================================================

-- MGET(X, Y)
--
-- Get map value (VAL) at X,Y
--
-- When X and Y are out of bounds, MGET returns 0, or a custom return value that can be specified with:
-- ```
-- POKE(0x5f36, 0x10)
-- POKE(0x5f5a, NEWVAL)
-- ```
---@param X number
---@param Y number
---@return number
function mget(X, Y) return 0 end

-- MSET(X, Y, VAL)
--
-- Set map value (VAL) at X,Y
---@param X number
---@param Y number
---@param VAL number
function mset(X, Y, VAL) end

-- MAP(TILE_X, TILE_Y, [SX, SY], [TILE_W, TILE_H], [LAYERS])
--
-- Draw section of map (starting from TILE_X, TILE_Y) at screen position SX, SY (pixels).
--
-- To draw a 4x2 blocks of tiles starting from 0,0 in the map, to the screen at 20,20:
-- ```
-- MAP(0, 0, 20, 20, 4, 2)
-- ```
-- TILE_W and TILE_H default to the entire map (including shared space when applicable).
--
-- MAP() is often used in conjunction with CAMERA(). To draw the map so that a player object (at PL.X in PL.Y in pixels) is centered:
-- ```
-- CAMERA(PL.X - 64, PL.Y - 64)
-- MAP()
-- ```
-- LAYERS is a bitfield. When given, only sprites with matching sprite flags are drawn. For example, when LAYERS is 0x5, only sprites with flag 0 and 2 are drawn.
--
-- Sprite 0 is taken to mean "empty" and is not drawn. To disable this behaviour, use: POKE(0x5F36, 0x8)
---@param TILE_X number
---@param TILE_Y number
---@param SX? number
---@param SY? number
---@param TILE_W? number
---@param TILE_H? number
---@param LAYERS? number
---@overload fun()
function map(TILE_X, TILE_Y, SX, SY, TILE_W, TILE_H, LAYERS) end

-- TLINE(X0, Y0, X1, Y1, MX, MY, [MDX, MDY], [LAYERS])
--
-- Draw a textured line from (X0,Y0) to (X1,Y1), sampling colour values from the map. When LAYERS is specified, only sprites with matching flags are drawn (similar to MAP())
--
-- MX, MY are map coordinates to sample from, given in tiles. Colour values are sampled from the 8x8 sprite present at each map tile. For example:
--
-- 2.0, 1.0  means the top left corner of the sprite at position 2,1 on the map
--
-- 2.5, 1.5  means pixel (4,4) of the same sprite
--
-- MDX, MDY are deltas added to mx, my after each pixel is drawn. (Defaults to 0.125, 0)
--
-- The map coordinates (MX, MY) are masked by values calculated by subtracting 0x0.0001 from the values at address 0x5F38 and 0x5F39. In simpler terms, this means you can loop a section of the map by poking the width and height you want to loop within, as long as they are powers of 2 (2,4,8,16..)
--
-- For example, to loop every 8 tiles horizontally, and every 4 tiles vertically:
-- ```
-- POKE(0x5F38, 8)
-- POKE(0x5F39, 4)
-- TLINE(...)
-- ```
-- The default values (0,0) gives a masks of 0xff.ffff, which means that the samples will loop every 256 tiles.
--
-- An offset to sample from (also in tiles) can also be specified at addresses 0x5f3a, 0x5f3b:
-- ```
-- POKE(0x5F3A, OFFSET_X)
-- POKE(0x5F3B, OFFSET_Y)
-- ```
-- Sprite 0 is taken to mean "empty" and not drawn. To disable this behaviour, use: POKE(0x5F36, 0x8)
--
-- ■ Setting TLINE Precision
--
-- By default, tline coordinates (mx,my,mdx,mdy) are expressed in tiles. This means that 1 pixel is 0.125, and only 13 bits are used for the fractional part. If more precision is needed, the coordinate space can be adjusted to allow more bits for the fractional part. This can be useful for things like textured walls, where the accumulated error from mdx,mdy rounding maybe become visible when viewed up close.
--
-- The number of bits used for the fractional part of each pixel is stored in a special register that can be adjusted by calling TLINE once with a single argument:
--
-- TLINE(16) -- MX,MY,MDX,MDY expressed in pixels
---@param X0 number
---@param Y0 number
---@param X1 number
---@param Y1 number
---@param MX number
---@param MY number
---@param MDX? number
---@param MDY? number
---@param LAYERS? number
function tline(X0, Y0, X1, Y1, MX, MY, MDX, MDY, LAYERS) end


-- =========================================================================
-- 6.7 MEMORY (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Memory)
--
-- PICO-8 has 3 types of memory:
--
-- 1. Base RAM (64k): see layout below. Access with PEEK() POKE() MEMCPY() MEMSET()
-- 2. Cart ROM (32k): same layout as base ram until 0x4300
-- 3. Lua RAM (2MB): compiled program + variables
--
-- ⓘ
-- ```
-- Technical note: While using the editor, the data being modified is in cart rom, but api functions such as SPR() and SFX() only operate on base ram. PICO-8 automatically copies cart rom to base ram (i.e. calls RELOAD()) in 3 cases:
-- 1. When a cartridge is loaded
-- 2. When a cartridge is run
-- 3. When exiting any of the editor modes // can turn off with: poke(0x5f37,1)
-- ```
--
-- ```
-- ■ Base RAM Memory Layout
-- 0X0    GFX
-- 0X1000 GFX2/MAP2 (SHARED)
-- 0X2000 MAP
-- 0X3000 GFX FLAGS
-- 0X3100 SONG
-- 0X3200 SFX
-- 0X4300 USER DATA
-- 0X5600 CUSTOM FONT (IF ONE IS DEFINED)
-- 0X5E00 PERSISTENT CART DATA (256 BYTES)
-- 0X5F00 DRAW STATE
-- 0X5F40 HARDWARE STATE
-- 0X5F80 GPIO PINS (128 BYTES)
-- 0X6000 SCREEN (8K)
-- 0x8000 USER DATA
-- ```
--
-- User data has no particular meaning and can be used for anything via MEMCPY(), PEEK() & POKE(). Persistent cart data is mapped to 0x5e00..0x5eff but only stored if CARTDATA() has been called. Colour format (gfx/screen) is 2 pixels per byte: low bits encode the left pixel of each pair. Map format is one byte per tile, where each byte normally encodes a sprite index.
--
-- ■ Remapping Graphics and Map Data
-- The GFX, MAP and SCREEN memory areas can be reassigned by setting values at the following addresses:
--
-- ```
-- 0X5F54 GFX:    can be 0x00 (default) or 0x60 (use the screen memory as the spritesheet)
-- 0X5F55 SCREEN: can be 0x60 (default) or 0x00 (use the spritesheet as screen memory)
-- 0X5F56 MAP:    can be 0x20 (default) or 0x10..0x2f, or 0x80 and above.
-- 0X5F57 MAP SIZE: map width. 0 means 256. Defaults to 128.
-- ```
--
-- Addresses can be expressed in 256 byte increments. So 0x20 means 0x2000, 0x21 means 0x2100 etc. Map addresses 0x30..0x3f are taken to mean 0x10..0x1f (shared memory area). Map data can only be contained inside the memory regions 0x1000..0x2fff, 0x8000..0xffff, and the map height is determined to be the largest possible size that fits in the given region.
--
-- GFX and SCREEN addresses can additionally be mapped to upper memory locations 0x80, 0xA0, 0xC0, 0xE0, with the constraint that MAP can not overlap with that address (in this case, the conflicting GFX and/or SCREEN mappings are kicked back to their default mapping).
--
-- ⓘ
-- ```
-- GFX and SCREEN memory mapping happens at a low level which also affects memory access functions (peek, poke, memcpy). The 8k memory blocks starting at 0x0 and 0x6000 can be thought of as pointers to a separate video ram, and setting the values at 0X5F54 and 0X5F56 alters those pointers.
-- ```
-- =========================================================================


-- PEEK(ADDR, [N])
--
-- Read a byte from an address in base ram. If N is specified, PEEK() returns that number of results (max: 8192). For example, to read the first 2 bytes of video memory:
-- ```
-- A, B = PEEK(0x6000, 2)
-- ```
-- Alternatively, the following operator can be used:
-- ```
-- @ADDR  -- PEEK(ADDR)
-- ```
---@param ADDR number
---@param N? number
---@return number
function peek(ADDR, N) return 0 end

-- POKE(ADDR, VAL1, VAL2, ...)
--
-- Write one or more bytes to an address in base ram. If more than one parameter is provided, they are written sequentially (max: 8192).
---@param ADDR number
---@vararg number
function poke(ADDR, ...) end

-- PEEK2(ADDR)
--
-- 16-bit version of PEEK. Read one number (VAL) in little-endian format:
--
--   16 bit: 0xffff.0000
--
-- Alternatively the following operator can be used:
-- ```
-- %ADDR  -- PEEK2(ADDR)
-- ```
---@param ADDR number
---@return number
function peek2(ADDR) return 0 end

-- POKE2(ADDR, VAL)
--
-- 16-bit version of POKE. Write one number (VAL) in little-endian format:
--
--   16 bit: 0xffff.0000
---@param ADDR number
---@param VAL number
function poke2(ADDR, VAL) end

-- POKE4(ADDR, VAL)
--
-- 32-bit version of POKE. Write one number (VAL) in little-endian format:
--
--   32 bit: 0xffff.ffff
---@param ADDR number
---@param VAL number
function poke4(ADDR, VAL) end

-- PEEK4(ADDR)
--
-- 32-bit version of PEEK. Read one number (VAL) in little-endian format:
--
--   32 bit: 0xffff.ffff
--
-- Alternatively the following operator can be used:
-- ```
-- $ADDR  -- PEEK4(ADDR)
-- ```
---@param ADDR number
---@return number
function peek4(ADDR) return 0 end

-- MEMCPY(DEST_ADDR, SOURCE_ADDR, LEN)
--
-- Copy LEN bytes of base ram from source to dest. Sections can be overlapping
---@param DEST_ADDR number
---@param SOURCE_ADDR number
---@param LEN number
function memcpy(DEST_ADDR, SOURCE_ADDR, LEN) end

-- RELOAD(DEST_ADDR, SOURCE_ADDR LEN, [FILENAME])
--
-- Same as MEMCPY, but copies from cart rom.
--
-- The code section ( >= 0x4300) is protected and can not be read.
--
-- If filename specified, load data from a separate cartridge. In this case, the cartridge must be local (BBS carts can not be read in this way).
---@param DEST_ADDR number
---@param SOURCE_ADDR number
---@param LEN number
---@param FILENAME? string
function reload(DEST_ADDR, SOURCE_ADDR, LEN, FILENAME) end

-- CSTORE(DEST_ADDR, SOURCE_ADDR, LEN, [FILENAME])
--
-- Same as memcpy, but copies from base ram to cart rom.
--
-- CSTORE() is equivalent to CSTORE(0, 0, 0x4300)
--
-- The code section ( >= 0x4300) is protected and can not be written to.
--
-- If FILENAME is specified, the data is written directly to that cartridge on disk. Up to 64 cartridges can be written in one session. See Cartridge Data for more information.
---@param DEST_ADDR number
---@param SOURCE_ADDR number
---@param LEN number
---@param FILENAME? string
---@overload fun()
function cstore(DEST_ADDR, SOURCE_ADDR, LEN, FILENAME) end

-- MEMSET(DEST_ADDR, VAL, LEN)
--
-- Write the 8-bit value VAL into memory starting at DEST_ADDR, for LEN bytes.
--
-- For example, to fill half of video memory with 0xC8:
-- ```
-- MEMSET(0x6000, 0xC8, 0x1000)
-- ```


-- =======================================================================
-- 6.8 MATH (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Math)
-- =======================================================================


-- MAX(X, Y)
--
-- Returns the maximum value of parameters
--- @param X number
--- @param Y number
--- @return number
function max(X, Y) return 0 end

-- MIN(X, Y)
--
-- Returns the minimum value of parameters
--- @param X number
--- @param Y number
--- @return number
function min(X, Y) return 0 end

-- MID(X, Y, Z)
--
-- Returns the middle value of parameters
-- ```
-- MID(7,5,10) -- 7
-- ```
--- @param X number
--- @param Y number
--- @param Z number
--- @return number
function mid(X, Y, Z) return 0 end

-- FLR(X)
--
-- Returns the largest integer that is less than or equal to x
-- ```
-- FLR ( 4.1) -->  4
-- FLR (-2.3) --> -3
-- ```
--- @param X number
--- @return number
function flr(X) return 0 end

-- CEIL(X)
--
-- Returns the smallest integer that is greater than or equal to x
-- ```
-- CEIL( 4.1) -->  5
-- CEIL(-2.3) --> -2
-- ```
--- @param X number
--- @return number
function ceil(X) return 0 end

-- COS(X)
--
-- Returns the cosine of x, where 1.0 means a full turn. For example, to animate a dial that turns once every second:
-- ```
-- FUNCTION _DRAW()
--   CLS()
--   CIRC(64, 64, 20, 7)
--   X = 64 + COS(T()) * 20
--   Y = 64 + SIN(T()) * 20
--   LINE(64, 64, X, Y)
-- END
-- ```
-- To get conventional radian-based trig functions without the y inversion, paste the following snippet near the start of your program:
-- ```
-- P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
-- P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
-- ```
--- @param X number
--- @return number
function cos(X) return 0 end

-- SIN(X)
--
-- Returns the sine of x, where 1.0 means a full turn. For example, to animate a dial that turns once every second:
-- ```
-- FUNCTION _DRAW()
--   CLS()
--   CIRC(64, 64, 20, 7)
--   X = 64 + COS(T()) * 20
--   Y = 64 + SIN(T()) * 20
--   LINE(64, 64, X, Y)
-- END
-- ```
-- PICO-8's SIN() returns an inverted result to suit screenspace (where Y means "DOWN", as opposed to mathematical diagrams where Y typically means "UP").
-- ```
-- SIN(0.25) -- RETURNS -1
-- ```
-- To get conventional radian-based trig functions without the y inversion, paste the following snippet near the start of your program:
-- ```
-- P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
-- P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
-- ```
--- @param X number
--- @return number
function sin(X) return 0 end

-- ATAN2(DX, DY)
--
-- Converts DX, DY into an angle from 0..1
--
-- As with cos/sin, angle is taken to run anticlockwise in screenspace. For example:
-- ```
-- ATAN(0, -1) -- RETURNS 0.25
-- ```
-- ATAN2 can be used to find the direction between two points:
-- ```
-- X=20 Y=30
-- FUNCTION _UPDATE()
--   IF (BTN(0)) X-=2
--   IF (BTN(1)) X+=2
--   IF (BTN(2)) Y-=2
--   IF (BTN(3)) Y+=2
-- END
--
-- FUNCTION _DRAW()
--   CLS()
--   CIRCFILL(X,Y,2,14)
--   CIRCFILL(64,64,2,7)
-- 
--   A=ATAN2(X-64, Y-64)
--   PRINT("ANGLE: "..A)
--   LINE(64,64,
--     64+COS(A)*10,
--     64+SIN(A)*10,7)
-- END
-- ```
--- @param DX number
--- @param DY number
--- @return number
function atan2(DX, DY) return 0 end

-- SQRT(X)
--
-- Return the square root of x
--- @param X number
--- @return number
function sqrt(X) return 0 end

-- ABS(X)
--
-- Returns the absolute (positive) value of x
--- @param X number
--- @return number
function abs(X) return 0 end

-- RND(X)
--
-- Returns a random number n, where 0 <= n < x
--
-- If you want an integer, use flr(rnd(x)). If x is an array-style table, return a random element between table[1] and table[#table].
--- @param X? number
--- @return number
function rnd(X) return 0 end

-- SRAND(X)
--
-- Sets the random number seed. The seed is automatically randomized on cart startup.
-- ```
-- FUNCTION _DRAW()
--   CLS()
--   SRAND(33)
--   FOR I=1,100 DO
--     PSET(RND(128),RND(128),7)
--   END
-- END
-- ```
--- @param X number
function srand(X) end

-- BAND(X, Y) 
--
-- Both bits are set
--
-- Operator: &
--- @param X number
--- @param Y number
--- @return number
function band(X, Y) return 0 end

-- BOR(X, Y)  
--
-- Either bit is set
--
-- Operator: |
--- @param X number
--- @param Y number
--- @return number
function bor(X, Y) return 0 end

-- BXOR(X, Y)
--
-- Either bit is set, but not both of them
--
-- Operator: ~
--- @param X number
--- @param Y number
--- @return number
function bxor(X, Y) return 0 end

-- BNOT(X)
--
-- Each bit is not set
--
-- Operator: ~
--- @param X number
--- @return number
function bnot(X) return 0 end

-- SHL(X, N)
--
-- Shift left n bits (zeros come in from the right)
--
-- Operator: <<
--- @param X number
--- @param N number
--- @return number
function shl(X, N) return 0 end

-- SHR(X, N)
--
-- Arithmetic right shift (the left-most bit state is duplicated)
--
-- Operator: >>
--- @param X number
--- @param N number
--- @return number
function shr(X, N) return 0 end

-- LSHR(X, N)
--
-- Logical right shift (zeros comes in from the left)
--
-- Operator: >>>
--- @param X number
--- @param N number
--- @return number
function lshr(X, N) return 0 end

-- ROTL(X, N)
--
-- Rotate all bits in x left by n places
--
-- Operator: <<>
--- @param X number
--- @param N number
--- @return number
function rotl(X, N) return 0 end

-- ROTR(X, N)
--
-- Rotate all bits in x right by n places
--
-- Operator: >><
--- @param X number
--- @param N number
--- @return number
function rotr(X, N) return 0 end


-- ===============================================================================================
-- 6.9 CUSTOM MENU ITEMS (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Custom_Menu_Items)
-- ===============================================================================================


-- MENUITEM(INDEX, [LABEL], [CALLBACK])
--
-- Add or update an item to the pause menu.
--
-- INDEX should be 1..5 and determines the order each menu item is displayed.
--
-- LABEL should be a string up to 16 characters long
--
-- CALLBACK is a function called when the item is selected by the user. If the callback returns true, the pause menu remains open.
--
-- When no label or function is supplied, the menu item is removed.
-- ```
-- MENUITEM(1, "RESTART PUZZLE",
--   FUNCTION() RESET_PUZZLE() SFX(10) END
-- )
-- ```
-- The callback takes a single argument that is a bitfield of L,R,X button presses.
-- ```
-- MENUITEM(1, "FOO",
--   FUNCTION(B) IF (B&1 > 0) THEN PRINTH("LEFT WAS PRESSED") END END
-- )
-- ```
-- To filter button presses that are able to trigger the callback, a mask can be supplied in bits 0xff00 of INDEX. For example, to disable L, R for a particular menu item, set bits 0x300 in the index:
-- ```
-- MENUITEM(2 | 0x300, "RESET PROGRESS",
--   FUNCTION() DSET(0,0) END
-- )
-- ```
-- Menu items can be updated, added or removed from within callbacks:
-- ```
-- MENUITEM(3, "SCREENSHAKE: OFF",
--   FUNCTION()
--     SCREENSHAKE = NOT SCREENSHAKE
--     MENUITEM(NIL, "SCREENSHAKE: "..(SCREENSHAKE AND "ON" OR "OFF"))
--     RETURN TRUE -- DON'T CLOSE
--   END
-- )
-- ```
---@param INDEX number
---@param LABEL? string
---@param CALLBACK? function
function menuitem(INDEX, LABEL, CALLBACK) end


-- ====================================================================================================================
-- 6.10 STRINGS AND TYPE CONVERSION (https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Strings_and_Type_Conversion)
-- ====================================================================================================================


-- TOSTR(VAL, [FORMAT_FLAGS])
--
-- Convert VAL to a string.
--
-- FORMAT_FLAGS is a bitfield:
-- ```
--   0x1: Write the raw hexadecimal value of numbers, functions or tables.
--   0x2: Write VAL as a signed 32-bit integer by shifting it left by 16 bits.
-- ```
-- TOSTR(NIL) returns "[nil]"
--
-- TOSTR() returns ""
-- ```
-- TOSTR(17)       -- "17"
-- TOSTR(17,0x1)   -- "0x0011.0000"
-- TOSTR(17,0x3)   -- "0x00110000"
-- TOSTR(17,0x2)   -- "1114112"
-- ```
--- @param VAL any
--- @param FORMAT_FLAGS? number
--- @return string
function tostr(VAL, FORMAT_FLAGS) return "" end

-- TONUM(VAL, [FORMAT_FLAGS])
--
-- Converts VAL to a number.
-- ```
-- TONUM("17.5")  -- 17.5
-- TONUM(17.5)    -- 17.5
-- TONUM("HOGE")  -- NO RETURN VALUE
-- ```
-- FORMAT_FLAGS is a bitfield:
-- ```
--   0x1: Read the string as written in (unsigned, integer) hexadecimal without the "0x" prefix
--        Non-hexadecimal characters are taken to be '0'.
--   0x2: Read the string as a signed 32-bit integer, and shift right 16 bits.
--   0x4: When VAL can not be converted to a number, return 0
-- ```
-- ```
-- TONUM("FF",       0x1)  -- 255
-- TONUM("1114112",  0x2)  -- 17
-- TONUM("1234abcd", 0x3)  -- 0x1234.abcd
-- ```
--- @param VAL any
--- @param FORMAT_FLAGS? number
--- @return number
function tonum(VAL, FORMAT_FLAGS) return 0 end

-- CHR(VAL0, VAL1, ...)
--
-- Convert one or more ordinal character codes to a string.
-- ```
-- CHR(64)                    -- "@"
-- CHR(104,101,108,108,111)   -- "hello"
-- ```
--- @vararg number
--- @return string
function chr(...) return "" end

-- ORD(STR, [INDEX], [NUM_RESULTS])
--
-- Convert one or more characters from string STR to their ordinal (0..255) character codes.
--
-- Use the INDEX parameter to specify which character in the string to use. When INDEX is out of range or str is not a string, ORD returns nil.
--
-- When NUM_RESULTS is given, ORD returns multiple values starting from INDEX.
-- ```
-- ORD("@")         -- 64
-- ORD("123",2)     -- 50 (THE SECOND CHARACTER: "2")
-- ORD("123",2,3)   -- 50,51,52
-- ```
--- @param STR string
--- @param INDEX? number
--- @param NUM_RESULTS? number
--- @return number
function ord(STR, INDEX, NUM_RESULTS) return 0 end

-- SUB(STR, POS0, [POS1])
--
-- Grab a substring from string str, from pos0 up to and including pos1. When POS1 is not specified, the remainder of the string is returned. When POS1 is specified, but not a number, a single character at POS0 is returned.
-- ```
-- S = "THE QUICK BROWN FOX"
-- PRINT(SUB(S,5,9))    --> "QUICK"
-- PRINT(SUB(S,5))      --> "QUICK BROWN FOX"
-- PRINT(SUB(S,5,TRUE)) --> "Q"
-- ```
--- @param STR string
--- @param POS0 number
--- @param POS1? number
--- @return string
function sub(STR, POS0, POS1) return "" end

-- SPLIT(STR, [SEPARATOR], [CONVERT_NUMBERS])
--
-- Split a string into a table of elements delimited by the given separator (defaults to ","). When separator is a number n, the string is split into n-character groups. When convert_numbers is true, numerical tokens are stored as numbers (defaults to true). Empty elements are stored as empty strings.
-- ```
-- SPLIT("1,2,3")               -- {1,2,3}
-- SPLIT("ONE:TWO:3",":",FALSE) -- {"ONE","TWO","3"}
-- SPLIT("1,,2,")               -- {1,"",2,""}
-- ```
--- @param STR string
--- @param SEPARATOR? string
--- @param CONVERT_NUMBERS? boolean
--- @return table
function split(STR, SEPARATOR, CONVERT_NUMBERS) return {} end

-- TYPE(VAL)
--
-- Returns the type of val as a string.
-- ```
-- > PRINT(TYPE(3))
-- NUMBER
-- > PRINT(TYPE("3"))
-- STRING
-- ```
--- @param VAL any
--- @return string
function type(VAL) return "" end
