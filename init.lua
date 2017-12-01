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
