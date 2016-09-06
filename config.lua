local config = {}

-- no animation of window moving, please
hs.window.animationDuration = 0
local application = require 'hs.application'
local eventtap = require 'hs.eventtap'

config.modules = {
    "launcher",
    "mgrid",
    "arrangement",
    "monitors",
    "repl",
    "reload",
    "arrows",
    "lock",
    "fullscreen"
}

mash_keys = {"cmd", "ctrl"}

-- Maps monitor id -> screen index.
config.fullscreen = {
    mash = mash_keys,
    key = "Z"
}

-- Maps monitor id -> screen index.
config.monitors = {
    autodiscover = true,
    rows = 1
}

function switchit()
    application.launchOrFocus("Google Chrome")
    -- eventtap.keyStroke({"cmd", "shift"}, "M")
    eventtap.keyStroke({"cmd"}, "L")
    eventtap.keyStroke({}, "h")
    eventtap.keyStroke(hs.keycodes.map['down'])
    eventtap.keyStroke(hs.keycodes.map['down'])
    eventtap.keyStroke(hs.keycodes.map['down'])
end

-- Launch applications
config.launcher = {
    mash = mash_keys,
    bindings = {
        { key = "T", application = "Terminal" },
        { key = "C", application = "iTerm" },
        { key = "B", application = "Google Chrome" },
        { key = "E", application = "MacVim" },
        { key = "M", application = "OWA" },
        { key = "W", application = "Video" },
        { key = "S", command     = "/Users/" .. os.getenv('USER') .. "/bin/excluded/blink1-tool --red" },
        { key = "D", command     = "/Users/" .. os.getenv('USER') .. "/bin/excluded/blink1-tool --green" },
        { key = "F19", command   = "/Users/" .. os.getenv('USER') .. "/bin/blink1-panic" },
        { key = "Q", func = switchit }
    }
}

-- Window arrangements.
config.arrangements = {
    fuzzy_search = {
        mash = {"cmd", "ctrl", "alt"},
        key = "Z"
    },
    {
        name = "zen",
        alert = true,
        mash = { "cmd", "ctrl", "alt" },
        key = "A",
        arrangement = {
            {
                app_title = "^Mail",
                monitor = 1,
                position = "full_screen",
            },
            {
                app_title = "^Slack",
                monitor = 4,
                position = "left"
            },
            {
                app_title = "^Messages",
                monitor = 4,
                position = function(d)
                    return d:translate_from('bottom_right', {
                        y = 42,
                        h = -40
                    })
                end
            },
            {
                app_title = "^ChronoMate",
                monitor = 4,
                position = function(d)
                    return d:translate_from('top_right', {
                        h = 42
                    })
                end
            },
            {
                app_title = "^Spotify",
                monitor = 6,
                position = "full_screen",
            }
        }
    }
}

return config
