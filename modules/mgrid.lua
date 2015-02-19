--
-- An approximation of the mjolnir grid behavior.
--
-- TODO: make this configurable
--
local grid = require 'hs.grid'
local hotkey = require 'hs.hotkey'

grid.MARGINX = 2
grid.MARGINY = 2
grid.GRIDWIDTH = 8
grid.GRIDHEIGHT = 2

local function windowShortDown ()
    grid.resizeWindowShorter()
    grid.pushWindowDown()
end

local function windowShortUp ()
    grid.resizeWindowShorter()
    grid.pushWindowUp()
end

local function windowTallUp ()
    grid.pushWindowUp()
    grid.resizeWindowTaller()
end

local function init_module()
    local mash = {"cmd", "ctrl"}

    hotkey.bind(mash, 'A', grid.maximizeWindow)

    hotkey.bind(mash, 'N', grid.pushWindowNextScreen)
    hotkey.bind(mash, 'P', grid.pushWindowPrevScreen)

    hotkey.bind(mash, 'J', windowShortDown)
    hotkey.bind(mash, 'K', windowShortUp)
    hotkey.bind(mash, 'H', grid.pushWindowLeft)
    hotkey.bind(mash, 'L', grid.pushWindowRight)

    hotkey.bind(mash, 'U', windowTallUp)
    hotkey.bind(mash, 'O', grid.resizeWindowWider)
    hotkey.bind(mash, 'I', grid.resizeWindowThinner)
end

return {
    init = init_module
}
