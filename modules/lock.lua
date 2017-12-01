local hotkey = require 'hs.hotkey'

local function module_init()
    local mash = config:get("lock.mash", { "ctrl","cmd" })
    local key = config:get("lock.key", "L")

    hotkey.bind(mash, key, function()
        os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
    end)

end

return {
    init = module_init
}
