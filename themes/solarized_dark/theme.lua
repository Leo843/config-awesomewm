-- {{{ Main
theme            = {}
theme.config     = os.getenv("HOME") .. "/.config/awesome/themes/solarized_dark"
theme.layouts    = theme.config .. "/layouts/cyan"
theme.icons      = theme.config .. "/icons"
theme.wallpapers = theme.config .. "/wallpapers"
-- }}}
-- {{{ Wallpaper
theme.wallpaper = theme.wallpapers .. "/wp.jpg"
-- theme.wallpaper = theme.wallpapers .. "/wall_rainbow_cheatsheet.png"
-- }}}
-- {{{ Font
theme.font = "mono 13"
-- }}}
-- {{{ Colors
theme.solarized_base03     = '#002b36'
theme.solarized_base02     = '#073642'
theme.solarized_base01     = '#586e75'
theme.solarized_base00     = '#657b83'
theme.solarized_base0      = '#839496'
theme.solarized_base1      = '#93a1a1'
theme.solarized_base2      = '#eee8d5'
theme.solarized_base3      = '#fdf6e3'
theme.solarized_yellow     = '#b58900'
theme.solarized_orange     = '#cb4b16'
theme.solarized_red        = '#dc322f'
theme.solarized_magenta    = '#d33682'
theme.solarized_violet     = '#6c71c4'
theme.solarized_blue       = '#268bd2'
theme.solarized_cyan       = '#2aa198'
theme.solarized_green      = '#859900'

theme.bg_normal            = theme.solarized_base03
theme.bg_focus             = theme.solarized_base02
theme.bg_urgent            = theme.solarized_base03
theme.bg_minimize          = theme.solarized_base03

theme.fg_normal            = theme.solarized_base0
theme.fg_focus             = theme.solarized_base01
theme.fg_urgent            = theme.solarized_red
theme.fg_minimize          = theme.solarized_yellow

theme.tasklist_fg_focus    = theme.solarized_base1
theme.tasklist_bg_focus    = theme.solarized_base02
theme.bg_systray           = theme.solarized_base03
-- }}}
-- {{{ Taglist
theme.taglist_fg_focus     = theme.solarized_orange
-- }}}
-- {{{ Wibar
theme.wibar_border_width   = 1
theme.wibar_border_color   = theme.solarized_base01
-- }}}
-- {{{ Prompt
theme.prompt_fg            = theme.solarized_magenta
-- }}}
-- {{{ Hotkeys
theme.hotkeys_modifiers_fg = theme.solarized_green
theme.hotkeys_label_bg     = theme.solarized_base1
theme.hotkeys_label_fg     = theme.solarized_base03
-- }}}
-- {{{ Borders
theme.border_width         = 1
theme.border_normal        = theme.solarized_base03
theme.border_focus         = theme.solarized_base0
theme.border_tooltip       = theme.solarized_base0
-- }}}
-- {{{ Menu
theme.menu_height          = "16"
theme.menu_width           = "72"
theme.menu_border_width    = 1
theme.menu_border_color    = theme.solarized_base01
-- }}}
-- {{{ Icons
-- {{{ Submenu Icon
theme.menu_submenu_icon  = theme.icons .. "/submenu.png"
-- }}}
-- {{{  Widget Icons
theme.widget_arch        = theme.icons .. "/arch.svg"
theme.widget_poweroff    = theme.icons .. "/poweroff.png"
theme.widget_desktop     = theme.icons .. "/blue/cat.png"
theme.widget_windows     = theme.icons .. "/blue/bug_01.png"
theme.widget_uptime      = theme.icons .. "/blue/ac_01.png"
theme.widget_cpu         = theme.icons .. "/green/cpu.png"
theme.widget_temp        = theme.icons .. "/yellow/temp.png"
theme.widget_mem         = theme.icons .. "/blue/mem.png"
theme.widget_fs          = theme.icons .. "/green/usb.png"
theme.widget_netdown     = theme.icons .. "/green/net_down_03.png"
theme.widget_netup       = theme.icons .. "/red/net_up_03.png"
theme.widget_mail        = theme.icons .. "/yellow/mail.png"
theme.widget_mail_notify = theme.icons .. "/mail_notify.png"
theme.widget_sys         = theme.icons .. "/magenta/arch.png"
theme.widget_pac         = theme.icons .. "/magenta/pacman.png"
theme.widget_batt        = theme.icons .. "/yellow/bat_full_01.png"
theme.widget_clock       = theme.icons .. "/blue/clock.png"
theme.widget_vol         = theme.icons .. "/red/spkr_01.png"
theme.widget_mpd         = theme.icons .. "/red/note.png"
-- }}}
-- {{{ Taglist
theme.taglist_squares_sel   = theme.config .. "/taglist/squaref_b.png"
theme.taglist_squares_unsel = theme.config .. "/taglist/square_b.png"
-- }}}
-- {{{ Titlebar
theme.titlebar_close_button_focus               = theme.config .. "/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.config .. "/titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active        = theme.config .. "/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.config .. "/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.config .. "/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.config .. "/titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active       = theme.config .. "/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.config .. "/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.config .. "/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.config .. "/titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active     = theme.config .. "/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.config .. "/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.config .. "/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.config .. "/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active    = theme.config .. "/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.config .. "/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.config .. "/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.config .. "/titlebar/maximized_normal_inactive.png"
-- }}}
-- {{{ Misc
theme.tasklist_floating             = "F "
theme.tasklist_maximized_vertical   = ""
theme.tasklist_maximized_horizontal = "M "
theme.tasklist_sticky               = "S "
theme.tasklist_ontop                = "T "
theme.tasklist_disable_icon         = true
-- }}}
-- {{{ Layouts
theme.layout_floating       = theme.layouts .. "/floating.png"
theme.layout_tile           = theme.layouts .. "/tile.png"
theme.layout_tilebottom     = theme.layouts .. "/tilebottom.png"
theme.layout_fairv          = theme.layouts .. "/fairv.png"
theme.layout_fairh          = theme.layouts .. "/fairh.png"
theme.layout_max            = theme.layouts .. "/max.png"
theme.layout_magnifier      = theme.layouts .. "/magnifier.png"
-- }}}
-- }}}

return theme
