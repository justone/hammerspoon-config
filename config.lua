local config = {}

-- no animation of window moving, please
hs.window.animationDuration = 0

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

-- Maps monitor id -> screen index.
config.monitors = {
    autodiscover = true,
    rows = 1
}

-- Launch applications
config.launcher = {
    mash = {"cmd", "ctrl"},
    bindings = {
        { key = "T", application = "Terminal" },
        { key = "C", application = "iTerm" },
        { key = "B", application = "Google Chrome" },
        { key = "S", command     = "/Users/" .. os.getenv('USER') .. "/bin/excluded/blink1-tool --red" },
        { key = "D", command     = "/Users/" .. os.getenv('USER') .. "/bin/excluded/blink1-tool --green" },
        { key = "F19", command   = "/Users/" .. os.getenv('USER') .. "/bin/blink1-panic" }
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
