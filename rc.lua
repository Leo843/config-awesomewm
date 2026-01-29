-- {{{ Imports
local gears              = require("gears")
local awful              = require("awful")
local awful_autofocus    = require("awful.autofocus")
local wibox              = require("wibox")
local beautiful          = require("beautiful")
local naughty            = require("naughty")
local menubar            = require("menubar")
local vicious            = require("vicious")
local hotkeys_popup      = require("awful.hotkeys_popup")
local debian             = require("debian.menu")
-- }}}
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors,
  })
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal(
    -- stylua: ignore start
    "debug::error",
    function(err)
      -- Make sure we don't go into an endless error loop
      if in_error then return end
      in_error = true

      naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = tostring(err),
      })
      in_error = false
    end
    -- stylua: ignore end
  )
end
-- }}}
-- {{{ Variable definitions
local home             = os.getenv("HOME")
local confdir          = home .. "/.config/awesome"
local themes           = confdir .. "/themes"
local active_theme     = themes .. "/solarized_dark"
local default_themes   = gears.filesystem.get_themes_dir()
local default_theme    = default_themes .. "default/theme.lua"
local terminal         = "x-terminal-emulator"
local editor           = os.getenv("EDITOR") or "editor"
local editor_cmd       = terminal .. " -e " .. editor
local modkey           = "Mod4" -- Mod4 is the Win key
--- }}}
-- {{{ Theme
-- beautiful.init(default_theme)
beautiful.init(active_theme .. "/theme.lua")
-- }}}
-- {{{ Layouts
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  -- awful.layout.suit.tile.top,
  -- awful.layout.suit.fair,
  -- awful.layout.suit.fair.horizontal,
  -- awful.layout.suit.spiral,
  -- awful.layout.suit.spiral.dwindle,
  awful.layout.suit.max,
  -- awful.layout.suit.max.fullscreen,
  awful.layout.suit.magnifier,
  -- awful.layout.suit.corner.nw,
  -- awful.layout.suit.corner.ne,
  -- awful.layout.suit.corner.sw,
  -- awful.layout.suit.corner.se,
  awful.layout.suit.floating,
}
-- }}}
-- {{{ Wibar
local text_clock      = wibox.widget.textclock("%A %0d/%0m/%Y %0H:%0M ")
local keyboard_layout = awful.widget.keyboardlayout()

-- {{{ Defines actions preformed when clicking on a tag.
local taglist_buttons = gears.table.join(
  -- Move to the given tag with left click.
  awful.button({}, 1, function(t) t:view_only() end),

  -- Move the current client to the given tag with modkey + left click.
  awful.button(
    { modkey },
    1,
    function(t)
      if client.focus then client.focus:move_to_tag(t) end
    end
  ),

  -- Display (without binding) clients from the given tag in the current with
  -- right click.
  awful.button({}, 3, awful.tag.viewtoggle),

  -- Display and bind clients from the current tag into the given tag with
  -- modkey + right click.
  awful.button(
    { modkey },
    3,
    function(t)
      if client.focus then client.focus:toggle_tag(t) end
    end
  ),

  -- Switch to the next tag with scroll up
  awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),

  -- Switch to the previous tag with scroll down
  awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)
-- }}}
-- {{{ Defines actions performed when clicking on a task.
local tasklist_buttons = gears.table.join(
  -- Display/Minimized the given client with left click.
  awful.button(
    {},
    1,
    function(c)
      if c == client.focus then
        c.minimized = true
      else
        c:emit_signal("request::activate", "tasklist", { raise = true })
      end
    end
  ),

  -- Display a menu showing all clients.
  awful.button(
    {},
    3,
    function() awful.menu.client_list({ theme = { width = 250 } }) end
  ),

  -- Display the next client with scroll up.
  awful.button({}, 4, function() awful.client.focus.byidx(1) end),

  -- Display the previous client with scroll down.
  awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)
-- }}}

local function set_wallpaper(s)
  if beautiful.wallpaper then
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
  end
end
-- Set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

-- Create a wibox for each screen
awful.screen.connect_for_each_screen(function(s)
  -- Set the same wp for each screen.
  set_wallpaper(s)

  -- Each screen has its own tag table.
  awful.tag(
    { "1", "2", "3", "4", "5", "6", "7", "8", "9" },
    s,
    awful.layout.layouts[1]
  )

  -- Create a promptbox for each screen
  s.prompt_box = awful.widget.prompt({prompt = ' > '})

  -- Create an imagebox widget which will contain an icon indicating which
  -- layout we're using. We need one layoutbox per screen.
  s.layout_box = awful.widget.layoutbox(s)
  s.layout_box:buttons(
    gears.table.join(
      -- Change the layout with left/right click and scroll up/down.
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(1) end),
      awful.button({}, 5, function() awful.layout.inc(-1) end)
    )
  )

  -- Create a taglist widget
  s.tag_list = awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.all,
    buttons = taglist_buttons,
  })

  -- Create a tasklist widget
  s.task_list = awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
  })

  -- Create the wibox
  s.wibox = awful.wibar({ height = 20, position = "top", screen = s })

  -- Add widgets to the wibox
  s.wibox:setup({
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      s.tag_list,
      s.prompt_box,
    },
    s.task_list, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      keyboard_layout,
      text_clock,
      s.layout_box,
    },
  })
end)
-- }}}
-- {{{ Mouse bindings
root.buttons(gears.table.join(
 -- Change the current tag with scroll up/down (while the mouse is on the screen
 -- and no clients catch the event before).
  awful.button({}, 4, awful.tag.viewnext),
  awful.button({}, 5, awful.tag.viewprev)
))
-- }}}
-- {{{ Keyboard layouts
local function create_keyboard_layout_switch()
  local layouts = { "us", "fr" }
  local current = 1 -- us is our default layout
  return function()
    local total_layouts = #layouts
    current = current % total_layouts + 1
    local new_layout = layouts[current]
    os.execute("setxkbmap " .. new_layout)
  end
end
-- }}}
-- {{{ Key bindings
globalkeys = gears.table.join(
   -- Change keyboard layout
  awful.key(
    { modkey, "Shift" },
    "l",
    create_keyboard_layout_switch(),
    { description = "switch keyboard", group = "keyboard" }
  ),

  -- Show shortcuts
  awful.key(
    { modkey },
    "s",
    hotkeys_popup.show_help,
    { description = "show help", group = "awesome" }
  ),


  -- Tag navigation
  awful.key(
    { modkey },
    "Left",
    awful.tag.viewprev,
    { description = "view previous", group = "tag" }
  ),
  awful.key(
    { modkey },
    "Right",
    awful.tag.viewnext,
    { description = "view next", group = "tag" }
  ),
  awful.key(
    { modkey },
    "Escape",
    awful.tag.history.restore,
    { description = "go back", group = "tag" }
  ),

  -- Client navigation
  awful.key(
    { modkey },
    "j",
    function() awful.client.focus.byidx(1) end,
    { description = "focus next by index", group = "client" }
  ),
  awful.key(
    { modkey },
    "k",
    function() awful.client.focus.byidx(-1) end,
    { description = "focus previous by index", group = "client" }
  ),

  -- Layout manipulation
  awful.key(
    { modkey, "Shift" },
    "j",
    function() awful.client.swap.byidx(1) end,
    { description = "swap with next client by index", group = "client" }
  ),
  awful.key(
    { modkey, "Shift" },
    "k",
    function() awful.client.swap.byidx(-1) end,
    { description = "swap with previous client by index", group = "client" }
  ),
  awful.key(
    { modkey, "Control" },
    "j",
    function() awful.screen.focus_relative(1) end,
    { description = "focus the next screen", group = "screen" }
  ),
  awful.key(
    { modkey, "Control" },
    "k",
    function() awful.screen.focus_relative(-1) end,
    { description = "focus the previous screen", group = "screen" }
  ),
  awful.key(
    { modkey },
    "u",
    awful.client.urgent.jumpto,
    { description = "jump to urgent client", group = "client" }
  ),
  awful.key(
    { modkey },
    "Tab",
    function()
      awful.client.focus.history.previous()
      if client.focus then client.focus:raise() end
    end,
    { description = "go back", group = "client" }
  ),

  -- Standard program
  awful.key(
    { modkey },
    "Return",
    function() awful.spawn(terminal) end,
    { description = "open a terminal", group = "launcher" }
  ),
  awful.key(
    { modkey, "Control" },
    "r",
    awesome.restart,
    { description = "reload awesome", group = "awesome" }
  ),
  awful.key(
    { modkey, "Shift" },
    "q",
    awesome.quit,
    { description = "quit awesome", group = "awesome" }
  ),

  awful.key(
    { modkey },
    "l",
    function() awful.tag.incmwfact(0.05) end,
    { description = "increase master width factor", group = "layout" }
  ),
  awful.key(
    { modkey },
    "h",
    function() awful.tag.incmwfact(-0.05) end,
    { description = "decrease master width factor", group = "layout" }
  ),
  awful.key(
    { modkey, "Shift" },
    "h",
    function() awful.tag.incnmaster(1, nil, true) end,
    { description = "increase the number of master clients", group = "layout" }
  ),
  awful.key(
    { modkey, "Shift" },
    "l",
    function() awful.tag.incnmaster(-1, nil, true) end,
    { description = "decrease the number of master clients", group = "layout" }
  ),
  awful.key(
    { modkey, "Control" },
    "h",
    function() awful.tag.incncol(1, nil, true) end,
    { description = "increase the number of columns", group = "layout" }
  ),
  awful.key(
    { modkey, "Control" },
    "l",
    function() awful.tag.incncol(-1, nil, true) end,
    { description = "decrease the number of columns", group = "layout" }
  ),
  awful.key(
    { modkey },
    "space",
    function() awful.layout.inc(1) end,
    { description = "select next", group = "layout" }
  ),
  awful.key(
    { modkey, "Shift" },
    "space",
    function() awful.layout.inc(-1) end,
    { description = "select previous", group = "layout" }
  ),

  awful.key(
    { modkey, "Control" },
    "n",
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:emit_signal("request::activate", "key.unminimize", { raise = true })
      end
    end,
    { description = "restore minimized", group = "client" }
  ),

  -- Prompt
  awful.key(
    { modkey },
    "r",
    function() awful.screen.focused().prompt_box:run() end,
    { description = "run prompt", group = "launcher" }
  ),

  awful.key(
    { modkey },
    "x",
    function()
      awful.prompt.run({
        prompt = "Run Lua code: ",
        textbox = awful.screen.focused().prompt_box.widget,
        exe_callback = awful.util.eval,
        history_path = awful.util.get_cache_dir() .. "/history_eval",
      })
    end,
    { description = "lua execute prompt", group = "awesome" }
  ),

  -- Menubar
  awful.key(
    { modkey },
    "p",
    function() menubar.show() end,
    { description = "show the menubar", group = "launcher" }
  )
)

clientkeys = gears.table.join(
  awful.key(
    { modkey },
    "f",
    function(c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    { description = "toggle fullscreen", group = "client" }
  ),
  awful.key(
    { modkey, "Shift" },
    "c",
    function(c) c:kill() end,
    { description = "close", group = "client" }
  ),
  awful.key(
    { modkey, "Control" },
    "space",
    awful.client.floating.toggle,
    { description = "toggle floating", group = "client" }
  ),
  awful.key(
    { modkey, "Control" },
    "Return",
    function(c) c:swap(awful.client.getmaster()) end,
    { description = "move to master", group = "client" }
  ),
  awful.key(
    { modkey },
    "o",
    function(c) c:move_to_screen() end,
    { description = "move to screen", group = "client" }
  ),
  awful.key(
    { modkey },
    "t",
    function(c) c.ontop = not c.ontop end,
    { description = "toggle keep on top", group = "client" }
  ),
  awful.key(
    { modkey },
    "n",
    function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end,
    { description = "minimize", group = "client" }
  ),
  awful.key(
    { modkey },
    "m",
    function(c)
      c.maximized = not c.maximized
      c:raise()
    end,
    { description = "(un)maximize", group = "client" }
  ),
  awful.key(
    { modkey, "Control" },
    "m",
    function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end,
    { description = "(un)maximize vertically", group = "client" }
  ),
  awful.key(
    { modkey, "Shift" },
    "m",
    function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end,
    { description = "(un)maximize horizontally", group = "client" }
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  globalkeys = gears.table.join(
    globalkeys,

    -- View tag only.
    awful.key(
      { modkey },
      "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then tag:view_only() end
      end,
      { description = "view tag #" .. i, group = "tag" }
    ),

    -- Toggle tag display.
    awful.key(
      { modkey, "Control" },
      "#" .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then awful.tag.viewtoggle(tag) end
      end,
      { description = "toggle tag #" .. i, group = "tag" }
    ),

    -- Move client to tag.
    awful.key(
      { modkey, "Shift" },
      "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:move_to_tag(tag) end
        end
      end,
      { description = "move focused client to tag #" .. i, group = "tag" }
    ),

    -- Toggle tag on focused client.
    awful.key(
      { modkey, "Control", "Shift" },
      "#" .. i + 9,
      function()
        if client.focus then
          local tag = client.focus.screen.tags[i]
          if tag then client.focus:toggle_tag(tag) end
        end
      end,
      { description = "toggle focused client on tag #" .. i, group = "tag" }
    )
  )
end

clientbuttons = gears.table.join(
  awful.button(
    {},
    1,
    function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
    end
  ),
  awful.button(
    { modkey },
    1,
    function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.move(c)
    end
  ),
  awful.button(
    { modkey },
    3,
    function(c)
      c:emit_signal("request::activate", "mouse_click", { raise = true })
      awful.mouse.client.resize(c)
    end
  )
)

-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {

  -- All clients will match this rule.
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = clientkeys,
      buttons = clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  },

  -- Floating clients.
  {
    rule_any = {
      instance = {
        "DTA", -- Firefox addon DownThemAll.
        "copyq", -- Includes session name in class.
        "pinentry",
      },
      class = {
        "Arandr",
        "Blueman-manager",
        "Gpick",
        "Kruler",
        "MessageWin", -- kalarm.
        "Sxiv",
        "Tor Browser",
        "Wpa_gui",
        "veromix",
        "xtightvncviewer",
      },

      -- Note that the name property shown in xprop might be set slightly after
      -- creation of the client and the name shown there might not match defined
      -- rules here.
      name = {
        "Event Tester", -- xev.
      },
      role = {
        "AlarmWindow", -- Thunderbird's calendar.
        "ConfigManager", -- Thunderbird's about:config.
        "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
      },
    },
    properties = { floating = true },
  },

  -- Hode titlebars to normal clients and dialogs
  {
    rule_any = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = false },
  },

  -- Add titlebars to mvme clients and dialogs
  {
    rule_any = { class = { "mvme" } },
    properties = { titlebars_enabled = true },
  },
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
  -- Set the windows at the slave,
  -- i.e. put it at the end of others instead of setting it master.
  -- if not awesome.startup then awful.client.setslave(c) end

  if
    awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position
  then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button(
      {},
      1,
      function()
        c:emit_signal("request::activate", "titlebar", { raise = true })
        awful.mouse.client.move(c)
      end
    ),
    awful.button(
      {},
      3,
      function()
        c:emit_signal("request::activate", "titlebar", { raise = true })
        awful.mouse.client.resize(c)
      end
    )
  )

  awful.titlebar(c):setup({
    { -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    { -- Middle
      { -- Title
        align = "center",
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    { -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal(
  "mouse::enter",
  function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
  end
)

client.connect_signal(
  "focus",
  function(c) c.border_color = beautiful.border_focus end
)
client.connect_signal(
  "unfocus",
  function(c) c.border_color = beautiful.border_normal end
)
-- }}}
