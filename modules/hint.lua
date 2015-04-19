local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local function module_init()

   hotkey.bind(config:get('hint.mash', { "ctrl" }), config:get('hint.key', "tab"), function()
                  hs.hints.windowHints(getAllValidWindows())
   end)

   function getAllValidWindows ()
      local allWindows = window.allWindows()
      local windows = {}
      local index = 1
      for i = 1, #allWindows do
         local w = allWindows[i]
         if w:screen() then
            windows[index] = w
            index = index + 1
         end
      end
      return windows
   end
end


return {
   init = module_init
}
