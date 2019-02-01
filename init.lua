local alert = require 'hs.alert'

import = require('utils/import')
import.clear_cache()

config = import('config')

function config:get(key_path, default)
   local root = self
   for part in string.gmatch(key_path, "[^\\.]+") do
      root = root[part]
      if root == nil then
         return default
      end
   end
   return root
end

local modules = {}

for _, v in ipairs(config.modules) do
   local module_name = 'modules/' .. v
   local module = import(module_name)

   if type(module.init) == "function" then
      module.init()
   end

   table.insert(modules, module)
end

local buf = {}

if hs.wasLoaded == nil then
   hs.wasLoaded = true
   table.insert(buf, "Hammerspoon loaded: ")
else
   table.insert(buf, "Hammerspoon re-loaded: ")
end

table.insert(buf, #modules .. " modules.")

alert.show(table.concat(buf))

-- hs.hotkey.bind({"cmd", "ctrl"}, "Y", function()
      -- hs.alert.show("hello world!")
      -- hs.notify.new({title="Hammerspoon", informativeText="hello world"}):send()
      -- local win = hs.window.focusedWindow()
      -- local f = win:frame()
      -- f.x = f.x - 10
      -- win:setFrame(f)
-- end)

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/",function(files)
    local doReload = false
    -- for _, file in pairs(files) do
    --    hs.alert.show(file .. " had changed")
    -- end
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
            break
        end
    end

    if doReload then
        hs.alert.show("hs config had changed,reload ")
        hs.reload()
    end
end):start()

hs.application.watcher.new(function(appName, eventType, appObject)
      if(eventType == hs.application.watcher.activated) then
         if(appName == "Finder") then
            -- appObject:selectMenuItem({"窗口", "前置全部窗口"})
         end
      end
end):start()

hs.urlevent.bind("someAlert", function(eventName, params)
    hs.alert.show("Received someAlert")
end)


local function do_issw_cmd(arg)
    hs.execute("/usr/local/bin/issw " .. arg)
end

-- local function Chinese()
--   do_issw_cmd("com.sogou.inputmethod.sogou.pinyin")
-- end

-- local function English()
--   do_issw_cmd("com.apple.keylayout.US")
-- end

local function Chinese()
    -- hs.keycodes.setMethod("Pinyin - Simplified")
    -- hs.alert.show("switch to chinese ")
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
    -- hs.keycodes.setLayout("U.S.")
    -- hs.alert.show("switch to english ")
    hs.keycodes.currentSourceID("com.apple.keylayout.US")
end

local function set_app_input_method(app_name, set_input_method_function, event)
    event = event or hs.window.filter.windowFocused

    hs.window.filter.new(app_name)
    :subscribe(event, function()
        set_input_method_function()
    end)
end

set_app_input_method('Hammerspoon', English, hs.window.filter.windowCreated)
set_app_input_method('聚焦', English, hs.window.filter.windowCreated)
set_app_input_method('网易有道词典',Chinese)
set_app_input_method('Emacs', English)
set_app_input_method('iTerm2', English)
set_app_input_method('Google Chrome', English)
set_app_input_method('WeChat', Chinese)
set_app_input_method('钉钉', Chinese)
-- set_app_input_method('Telegram', Chinese)


-- -- Sends "escape" if "caps lock" is held for less than .2 seconds, and no other keys are pressed.

-- local send_escape = false
-- local last_mods = {}
-- local control_key_timer = hs.timer.delayed.new(0.2, function()
--     send_escape = false
-- end)

-- hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, function(evt)
--     local new_mods = evt:getFlags()
--     if last_mods["ctrl"] == new_mods["ctrl"] then
--         return false
--     end
--     if not last_mods["ctrl"] then
--         last_mods = new_mods
--         send_escape = true
--         control_key_timer:start()
--     else
--         if send_escape then
--             hs.eventtap.keyStroke({}, "escape")
--         end
--         last_mods = new_mods
--         control_key_timer:stop()
--     end
--     return false
-- end):start()


-- hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(evt)
--     send_escape = false
--     return false
-- end):start()



-- Load Hammerspoon bits from https://github.com/jasonrudolph/ControlEscape.spoon
-- ctrl + ctrl = escape
hs.loadSpoon('ControlEscape'):start()

-- https://github.com/kkamdooong/hammerspoon-control-hjkl-to-arrow
-- local function pressFn(mods, oldKey, newKey)
--     return function()
--         if hs.application.frontmostApplication():name() == "Emacs"  then
--             -- alert.show(hs.application.frontmostApplication():name())
--             -- alert.show(mods)
--             -- alert.show(oldKey)
--             hs.eventtap.keyStroke(mods, oldKey, 1000)
--             -- alert.show(newKey)
--             -- return true
--             hs.hotkeys:exit()
--         else
--             hs.eventtap.keyStroke({}, newKey, 1000)
--         end
--     end
-- end

-- local function remap(mods, key, pressFn)
-- 	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)
-- end



-- remap({'ctrl'}, 'h', pressFn({'ctrl'}, 'h', 'left'))
-- remap({'ctrl'}, 'j', pressFn('down'))
-- remap({'ctrl'}, 'k', pressFn('up'))
-- remap({'ctrl'}, 'l', pressFn('right'))



local function  ctrlBinding(oldKey, newKey)
    return hs.hotkey.new({'ctrl'}, oldKey, nil ,function()
        hs.eventtap.keyStroke({}, newKey, 1000)
    end)
end

local hjklBindings = {
    ctrlBinding('h', 'left'),
    ctrlBinding('j', 'down'),
    ctrlBinding('k', 'up'),
    ctrlBinding('l', 'right')
}


local function enableCtrlBindings()
  -- hs.console.printStyledtext("focused")
  for k,v in pairs(hjklBindings) do
    v:enable()
  end
end

local function disableCtrlBindings()
  -- hs.console.printStyledtext("unfocused")
  for k,v in pairs(hjklBindings) do
    v:disable()
  end
end

local wf = hs.window.filter
-- hs.window.filter.new{'Google Chrome', '微信'}:getWindows()[2]
-- local hjklBindingApps = wf.new{"Google Chrome", "微信", "钉钉"}
local hjklBindingApps = wf.new{"Google Chrome", "微信", "访达"}
hjklBindingApps:subscribe(wf.windowFocused, function()
  enableCtrlBindings()
end):subscribe(wf.windowUnfocused, function()
  disableCtrlBindings()
end)

-- local ctrlBindingFlag = true
-- hs.hotkey.bind({'ctrl'}, 'f12', nil, function()
--     alert.show(ctrlBindingFlag)
--     if ctrlBindingFlag then
--         ctrlBindingFlag = false
--         enableCtrlBindings()
--     else
--         ctrlBindingFlag = true
--         disableCtrlBindings()
--     end
-- end)
