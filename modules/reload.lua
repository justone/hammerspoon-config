local hotkey = require 'hs.hotkey'

return {
    init = function()
        hotkey.bind(config:get("reload.mash", { "ctrl","cmd"  }), config:get("reload.key", "R"), hs.reload)
    end
}
