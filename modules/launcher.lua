-- Application/command launcher.  Example config:
--
-- config.launcher = {
--     mash = {"cmd", "ctrl"},
--     bindings = {
--         { key = "B", application = "Google Chrome" }
--         { key = "X", commmand = "/usr/bin/rsync ..." }
--     }
-- }

local notify = require 'hs.notify'
local application = require 'hs.application'
local hotkey = require 'hs.hotkey'

local function init_module()
    if config.launcher == nil then
        notify.show("Applications has no available configs", "", "Set some configs set in config.launcher or unload this module", "")
        return
    end

    for _, app in ipairs(config.launcher.bindings) do
        if app.key == nil then
            error("Application is missing a key value.")
        end

        if app.application ~= nil then
            hotkey.bind(config.launcher.mash or { "cmd", "ctrl", "alt" }, app.key, function() application.launchOrFocus(app.application) end)
        end

        if app.command ~= nil then
            hotkey.bind(config.launcher.mash or { "cmd", "ctrl", "alt" }, app.key, function() os.execute(app.command) end)
        end
    end
end

return {
    init = init_module
}
