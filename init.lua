hs.loadSpoon("WinWin")
hs.loadSpoon("WindowGrid")
hs.loadSpoon("WindowHalfsAndThirds")
hs.loadSpoon("KSheet")
hs.loadSpoon("Seal")
hs.loadSpoon("SpoonInstall")

Install=spoon.SpoonInstall

local hyper = {'ctrl', 'cmd'}

local alert = require 'hs.alert'
local application = require 'hs.application'
local geometry = require 'hs.geometry'
local grid = require 'hs.grid'
local hints = require 'hs.hints'
local hotkey = require 'hs.hotkey'
local layout = require 'hs.layout'
local window = require 'hs.window'
local speech = require 'hs.speech'

hs.window.animationDuration = 0 -- don't waste time on animation when resize window

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
    return hs.hotkey.new({'rightcmd'}, oldKey, nil ,function()
        hs.eventtap.keyStroke({}, newKey, 1000)
    end)
end

local function reBindingKey(oldKey, newKey)
    return hs.hotkey.new(nil,  oldKey, nil ,function()
        hs.eventtap.keyStroke({}, newKey, 1000)
    end)
end

local hjklBindings = {
    -- ctrlBinding('h', 'left'),
    -- ctrlBinding('j', 'down'),
    -- ctrlBinding('k', 'up'),
    -- ctrlBinding('l', 'right')
    reBindingKey(';', 'left'),
    reBindingKey('\'', 'right'),
    reBindingKey('[', 'up'),
    reBindingKey('/', 'down')
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


-- local wf = hs.window.filter
-- -- hs.window.filter.new{'Google Chrome', '微信'}:getWindows()[2]
-- -- local hjklBindingApps = wf.new{"Google Chrome", "微信", "钉钉"}
-- local hjklBindingApps = wf.new{"Google Chrome", "微信", "访达"}
-- hjklBindingApps:subscribe(wf.windowFocused, function()
--   enableCtrlBindings()
-- end):subscribe(wf.windowUnfocused, function()
--   disableCtrlBindings()
-- end)

local ctrlBindingFlag = true
hs.hotkey.bind({'rightcmd'}, '`', nil, function()
    if ctrlBindingFlag then
        ctrlBindingFlag = false
        enableCtrlBindings()
        alert.show("enable hjkl mode")
    else
        ctrlBindingFlag = true
        disableCtrlBindings()
        alert.show("disable hjkl mode")
    end
end)


switcher = hs.window.switcher.new(
    hs.window.filter.new()
        :setAppFilter('Emacs', {allowRoles = '*', allowTitles = 1}), -- make emacs window show in switcher list
    {
        showTitles = false,               -- don't show window title
        thumbnailSize = 200,              -- window thumbnail size
        showSelectedThumbnail = false,    -- don't show bigger thumbnail
        backgroundColor = {0, 0, 0, 0.8}, -- background color
        highlightColor = {0.3, 0.3, 0.3, 0.8}, -- selected color
    }
)

hs.hotkey.bind("alt", "tab", function()
       switcher:next()
end)
hs.hotkey.bind("alt-shift", "tab", function()
                   switcher:previous()
                   updateFocusAppInputMethod()
end)

function findApplication(appPath)
    local apps = application.runningApplications()
    for i = 1, #apps do
        local app = apps[i]
        if app:path() == appPath then
            return app
        end
    end

    return nil
end


local key2App = {
    e = {'/Applications/iTerm.app'},
    m = {'/Applications/Emacs.app'},
    c = {'/Applications/Google Chrome.app'},
    w = {'/Applications/WeChat.app'},
    f = {"/System/Library/CoreServices/Finder.app" },
    v = { "/Applications/Visual Studio Code.app" },
    -- d = {'/Applications/Dash.app', 'English', 1},
    --  ctrl+cmd+d lookup dictionary with mouse pointer
    s = {'/Applications/DingTalk.app'},
    x = {'/Applications/网易有道词典.app'},
}

-- Toggle an application between being the frontmost app, and being hidden
function toggleApplication(app)
    local appPath = app[1]
    local app = findApplication(appPath)

    if not app then
        -- Application not running, launch app
        application.launchOrFocus(appPath)
    else
        if app:isFrontmost() then
            app:hide()
        else
            -- Focus target application if it not at frontmost.
            -- app:unhide()
            -- app:activate(true)
            application.open(app:bundleID())
            app:mainWindow():focus()
        end
    end

end

for key, app in pairs(key2App) do
    hotkey.bind(
        hyper, key,
        function()
            toggleApplication(app)
    end)
end


Install:andUse(
    "WindowHalfsAndThirds",
    {
        config = {use_frame_correctness = true},
        hotkeys = {max_toggle = {hyper, "="}}
})



-- Power operation.
caffeinateOnIcon = [[ASCII:
.....1a..........AC..........E
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
.....5c.......................
]]

    caffeinateOffIcon = [[ASCII:
.....1a.....x....AC.y.......zE
..............................
......4.......................
1..........aA..........CE.....
e.2......4.3...........h......
..............................
..............................
.......................h......
e.2......6.3..........t..q....
5..........c..........s.......
......6..................q....
......................s..t....
...x.5c....y.......z..........
]]

local caffeinateTrayIcon = hs.menubar.new()

local function caffeinateSetIcon(state)
    caffeinateTrayIcon:setIcon(state and caffeinateOnIcon or caffeinateOffIcon)

    if state then
        caffeinateTrayIcon:setTooltip("Sleep never sleep")
    else
        caffeinateTrayIcon:setTooltip("System will sleep when idle")
    end
end

local function toggleCaffeinate()
    local sleepStatus = hs.caffeinate.toggle("displayIdle")
    if sleepStatus then
        hs.notify.new({title="HammerSpoon", informativeText="System never sleep"}):send()
    else
        hs.notify.new({title="HammerSpoon", informativeText="System will sleep when idle"}):send()
    end

    caffeinateSetIcon(sleepStatus)
end

hs.hotkey.bind(hyper, "\\", toggleCaffeinate)
caffeinateTrayIcon:setClickCallback(toggleCaffeinate)
caffeinateSetIcon(sleepStatus)

-- https://github.com/sindresorhus/do-not-disturb-cli
local function toggleDndMode()
    hs.execute("/usr/local/opt/node@8/bin/node /usr/local/bin/dnd toggle")
end
hs.hotkey.bind(hyper, "`", toggleDndMode)


-- volume manager
function getVolumeIncrement()
  local volume = hs.audiodevice.current().volume
  -- When the volume gets near zero, change it in smaller increments. Otherwise even the first increment
  -- above zero may be too loud.
  -- NOTE(phil): I noticed that using a decimal smaller than 0.4 will sometimes result in the volume remaining
  -- unchanged after calling setVolume, as if OSX only lets you change the volume by large increments.
  if volume < 40 then return 5 else return 10 end
end

hs.hotkey.bind(hyper, "9", function()
  local except = hs.audiodevice.current().volume + getVolumeIncrement()
  except = math.floor(except + 0.5)
  if except > 100  then
      except = 100
  end
  alert.show("set volume: " .. except)
  hs.audiodevice.defaultOutputDevice():setVolume(except)
end)

hs.hotkey.bind(hyper, "8", function()
  local except = hs.audiodevice.current().volume - getVolumeIncrement()
  except = math.floor(except + 0.5)
  if except < 0  then
      except = 0
  end
  alert.show("set volume: " .. except)
  hs.audiodevice.defaultOutputDevice():setVolume(except)
end)


hs.hotkey.bind(hyper, "0", function()
  local muted  =  hs.audiodevice.defaultOutputDevice():muted()
  alert.show("set muted : " .. tostring(not muted))
  hs.audiodevice.defaultOutputDevice():setMuted(not muted)
end)
