--- @enum SM_EVENT
SM_EVENT = {
    left = "left",
    right = "right"
}

--- @class SMEntry
--- @field name string
--- @field updates fun()[]
--- @field display_fn fun():string
--- @field disabled_draw_fn fun()
--- @field event_handlers table<SM_EVENT, fun()>
SMEntry = {
    --- @enum SMEntryControl
    Control = {
        left_right = "left_right",
    }
}
SMEntry.__index = SMEntry

--- @param name string
--- @param control? SMEntryControl
--- @return SMEntry
function SMEntry:new(name, control)
    local o = {
        name = name,
        updates = {},
        event_handlers = {}
    }
    setmetatable(o, self)

    if control == self.Control.left_right then
        o:with_left_right_action()
    end
        
    return o
end

--- @return string
function SMEntry:display_name()
    if self.display_fn then
        return self.display_fn()
    end

    return self.name
end

--- Sets left and right buttons to trigger actions
--- @return SMEntry
function SMEntry:with_left_right_action()
    local fn = function ()
        if btnp(BUTTONS.left) then
            self:handle_event(SM_EVENT.left)
        elseif btnp(BUTTONS.right) then
            self:handle_event(SM_EVENT.right)
        end
    end

    add(self.updates, fn)
    return self
end

--- Entry will increment or decrement a field in a table when left or right actions
--- are triggered. The field must match the name of the entry.
--- @param target table "Table to update"
--- @param increment number "Amount to increment or decrement"
--- @param min_val? number "Minimum value to clamp to"
--- @param max_val? number "Maximum value to clamp to"
--- @return SMEntry
function SMEntry:with_field_inc_dec(target, increment, min_val, max_val)
    local inc = function ()
        target[self.name] = target[self.name] + increment
        if max_val ~= nil then
            target[self.name] = min(target[self.name], max_val)
        end
    end
    self.event_handlers[SM_EVENT.right] = inc

    local dec = function ()
        target[self.name] = target[self.name] - increment
        if min_val ~= nil then
            target[self.name] = max(target[self.name], min_val)
        end
    end
    self.event_handlers[SM_EVENT.left] = dec

    self.display_fn = function ()
        return self.name .. ": " .. target[self.name]
    end

    return self
end

--- @param event SM_EVENT
function SMEntry:handle_event(event)
    local handler = self.event_handlers[event]
    if handler then
        handler()
    end
end

function SMEntry:update()
    for i = 1, #self.updates do
        self.updates[i]()
    end
end

--- @class SimpleMenu
--- @field entries SMEntry[]
--- @field selected integer
--- @field enabled_fn fun():boolean
--- @field select_fn fun()
SimpleMenu = {}
SimpleMenu.__index = SimpleMenu

--- @return SimpleMenu
function SimpleMenu:new()
    local o = {
        selected = 1,
        entries = {}
    }
    setmetatable(o, self)
    o:with_enabled(true)
    return o
end

--- Defines when the menu is enabled. Disabled menu does not update and is
--- not drawn.
--- @param enabled boolean | fun():boolean
--- @return SimpleMenu
function SimpleMenu:with_enabled(enabled)
    if type(enabled) == "boolean" then
        self.enabled_fn = function ()
            return enabled
        end
    else
        self.enabled_fn = enabled
    end
    return self
end

--- Defines what to draw when the menu is disabled.
--- @param draw_fn fun()
--- @return SimpleMenu
function SimpleMenu:with_disabled_draw(draw_fn)
    self.disabled_draw_fn = draw_fn
    return self
end

--- Enables up and down selection of the entries with the arrow keys.
--- @return SimpleMenu
function SimpleMenu:with_up_down_selection()
    self.select_fn = function ()
        if btnp(BUTTONS.up) then
            self.selected = mid(1, self.selected - 1, #self.entries)
        end
        if btnp(BUTTONS.down) then
            self.selected = mid(1, self.selected + 1, #self.entries)
        end
    end
    return self
end

--- @param name string
--- @param control? SMEntryControl
function SimpleMenu:add_entry(name, control)
    local entry = SMEntry:new(name, control)
    add(self.entries, entry)
    return entry
end

function SimpleMenu:update()
    if not self.enabled_fn() then
        return
    end

    self.entries[self.selected]:update()

    if self.select_fn then
        self.select_fn()
    end
end

function SimpleMenu:draw()
    if not self.enabled_fn() then
        if self.disabled_draw_fn then
            self.disabled_draw_fn()
        end

        return
    end

    for i = 1, #self.entries do
        local entry = self.entries[i]
        local color = i == self.selected and COLORS.orange or COLORS.white
        print(entry:display_name(), color)
    end
end