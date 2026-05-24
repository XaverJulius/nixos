-- TODO: Review all commands below. Many were omarchy-specific and have
--       been replaced with best-guess NixOS equivalents. Adjust as needed.

-- Monitor configuration
hl.monitor({ output = "DP-3",    mode = "2560x1440@144", position = "0x0",        scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "2560x200",   scale = 1 })
hl.monitor({ output = "",        mode = "preferred",     position = "auto",       scale = 1 })

-- Environment variables
hl.env("GDK_SCALE", "1")

-- Input settings
hl.config({
    input = {
        kb_layout = "de",
        kb_options = "compose:caps",
        repeat_rate = 40,
        repeat_delay = 300,
        numlock_by_default = true,
        touchpad = {
            scroll_factor = 0.4,
        },
    },
})

-- General look and feel
hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 2,
    },
    decoration = {
        rounding = 8,
    },
})

-- Window rules
hl.window_rule({ match = { class = "(Alacritty|kitty|foot)" },         scroll_touchpad = 1.5 })
hl.window_rule({ match = { class = "com.mitchellh.ghostty" },          scroll_touchpad = 0.2 })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("nm-applet")
end)

-- Application bindings

-- TODO: Replace $TERMINAL with your terminal of choice (foot, kitty, ghostty, etc.)
-- TODO: omarchy-cmd-terminal-cwd provided the current working directory — may need a custom script

-- Tmux terminal
hl.bind("SUPER + ALT + RETURN", hl.dsp.exec_cmd("foot tmux new"), { description = "Tmux" })

-- Terminal
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("foot"), { description = "Terminal" })

-- Browser
-- TODO: Replace firefox with your browser of choice
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("firefox"), { description = "Browser" })

-- File manager
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd("nautilus --new-window"), { description = "File manager" })

-- Private browser
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd("firefox --private-window"), { description = "Browser (private)" })

-- Music
-- TODO: Replace spotify with your music app
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("spotify"), { description = "Music" })

-- Music TUI
-- TODO: Replace cliamp with your TUI music player
hl.bind("SUPER + SHIFT + ALT + M", hl.dsp.exec_cmd("cliamp"), { description = "Music TUI" })

-- Editor
-- TODO: Replace code with your editor command
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("code"), { description = "Editor" })

-- Activity monitor
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("btop"), { description = "Activity" })

-- Docker
-- TODO: lazydocker may need to be installed
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("lazydocker"), { description = "Docker" })

-- Signal
hl.bind("SUPER + SHIFT + G", hl.dsp.exec_cmd("signal-desktop"), { description = "Signal" })

-- Obsidian
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "Obsidian" })

-- 1Password
hl.bind("SUPER + SHIFT + slash", hl.dsp.exec_cmd("1password"), { description = "Passwords" })

-- ChatGPT
-- TODO: Replace with your preferred method for launching webapps
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("firefox --new-window https://chatgpt.com"), { description = "ChatGPT" })

-- Grok
hl.bind("SUPER + SHIFT + ALT + A", hl.dsp.exec_cmd("firefox --new-window https://grok.com"), { description = "Grok" })

-- Calendar
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("firefox --new-window https://app.hey.com/calendar/weeks/"), { description = "Calendar" })

-- Email
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("thunderbird"), { description = "Email" })

-- YouTube
-- TODO: Replace with your YouTube PWA or browser
hl.bind("SUPER + SHIFT + Y", hl.dsp.exec_cmd("firefox --new-window https://youtube.com/"), { description = "YouTube" })

-- WhatsApp
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("firefox --new-window https://web.whatsapp.com/"), { description = "WhatsApp" })

-- Google Messages
hl.bind("SUPER + SHIFT + CTRL + G", hl.dsp.exec_cmd("firefox --new-window https://messages.google.com/web/conversations"), { description = "Google Messages" })

-- X/Twitter
hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd("firefox --new-window https://x.com/"), { description = "X" })

-- X Post
hl.bind("SUPER + SHIFT + ALT + X", hl.dsp.exec_cmd("firefox --new-window https://x.com/compose/post"), { description = "X Post" })
