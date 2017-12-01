--  Aerosnap helper functions to get and set current window parameters
--  https://blog.jverkamp.com/2016/02/08/duplicating-aerosnap-on-osx-with-hammerspoon/
local function aerosnap_get_parameters()
   local window = hs.window.focusedWindow()
   local frame = window:frame()
   local screen = window:screen()
   local bounds = screen:frame()

   return window, frame, bounds
end

-- Aerosnap help to move a window to a specified position
local function aerosnap_move_window(x, y, w, h)
   local window, frame, bounds = aerosnap_get_parameters()

   frame.x = x
   frame.y = y
   frame.w = w
   frame.h = h

   window:setFrame(frame)
end

-- Save the current window's position so we can restore it
local function aerosnap_save_window()
   local window, frame, bounds = aerosnap_get_parameters()
   saved_window_sizes = saved_window_sizes or {}
   saved_window_sizes[window:id()] = {x = frame.x, y = frame.y, w = frame.w, h = frame.h}
end

local function init_module()
    local mash = {"cmd", "ctrl"}
    -- Aerosnap move window to the left half
    hs.hotkey.bind(mash, "Left", function()
        local window, frame, bounds = aerosnap_get_parameters()
        aerosnap_save_window()
        aerosnap_move_window(bounds.x, bounds.y, bounds.w / 2, bounds.h)
    end)

    -- Aerosnap move window to the right half
    hs.hotkey.bind(mash, "Right", function()
        local window, frame, bounds = aerosnap_get_parameters()
        aerosnap_save_window()
        aerosnap_move_window(bounds.x + bounds.w / 2, bounds.y, bounds.w / 2, bounds.h)
    end)

    -- Aerosnap maximize current window, saving size to restore
    hs.hotkey.bind(mash, "Up", function()
        local window, frame, bounds = aerosnap_get_parameters()
        aerosnap_save_window()
        aerosnap_move_window(bounds.x, bounds.y, bounds.w, bounds.h)
    end)

    -- Restore the last saved window configuration for a window (basically, a one level undo)
    hs.hotkey.bind(mash, "Down", function()
        local window, frame, bounds = aerosnap_get_parameters()

        old_bounds = saved_window_sizes[window:id()]
        if old_bounds ~= nil then
        aerosnap_move_window(old_bounds.x, old_bounds.y, old_bounds.w, old_bounds.h)
        saved_window_sizes[window:id()] = nil
        end
    end)


   -- hs.hotkey.bind({"cmd", "ctrl"}, "LEFT", function()
   --       local win = hs.window.focusedWindow()
   --       local f = win:frame()
   --       local screen = win:screen()
   --       local full = screen:fullFrame()

   --       f.x = full.x
   --       f.y = full.y
   --       f.w = full.w / 2
   --       f.h = full.h

   --       win:setFrame(f)
   -- end)

   -- hs.hotkey.bind({"cmd", "ctrl"}, "Right", function()
   --       local win = hs.window.focusedWindow()
   --       local f = win:frame()
   --       local screen = win:screen()
   --       local max = screen:fullFrame()

   --       f.x = max.x + (max.w / 2)
   --       f.y = max.y
   --       f.w = max.w / 2
   --       f.h = max.h
   --       win:setFrame(f)
   -- end)
end

return {
   init = init_module
}
