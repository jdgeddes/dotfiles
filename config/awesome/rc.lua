-- {{{ License
--
-- Awesome configuration, using awesome 3.4.10 on Ubuntu 11.10
--   * Tony N <tony@git-pull.com>
--
-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- based off Adrian C. <anrxc@sysphere.org>'s rc.lua
-- }}}


-- {{{ Libraries
require("awful")
require("awful.rules")
require("awful.autofocus")
require("naughty")
-- User libraries
require("vicious") -- ./vicious
require("helpers") -- helpers.lua
require("calendar2")

-- }}}

-- {{{ Default configuration
altkey = "Mod1"
modkey = "Mod4" -- your windows/apple key

--terminal = whereis_app('urxvtcd') and 'urxvtcd' or 'x-terminal-emulator' -- also accepts full path
-- terminal = 'gnome-terminal'
terminal = 'urxvt'
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
browser = 'google-chrome'
ide = 'gvim'

wallpaper_app = "feh" -- if you want to check for app before trying
wallpaper_dir = os.getenv("HOME") .. "/Pictures/Wallpaper" -- wallpaper dir

-- taglist numerals
--- arabic, chinese, {east|persian}_arabic, roman, thai, random
taglist_numbers = "arabic" -- we support arabic (1,2,3...),

cpugraph_enable = true -- Show CPU graph
cputext_format = " $1%" -- %1 average cpu, %[2..] every other thread individually

membar_enable = true -- Show memory bar
memtext_format = " $1%" -- %1 percentage, %2 used %3 total %4 free

date_format = "%a %m/%d/%Y %l:%M%p" -- refer to http://en.wikipedia.org/wiki/Date_(Unix) specifiers

--networks = {'eth0'} -- add your devices network interface here netwidget, only shows first one thats up.
networks = {} -- add your devices network interface here netwidget, only shows first one thats up.

require_safe('personal')

-- Create personal.lua in this same directory to override these defaults


-- }}}

-- {{{ Variable definitions
-- local wallpaper_cmd = "find " .. wallpaper_dir .. " -type f -name '*.jpg'  -print0 | shuf -n1 -z | xargs -0 feh --bg-scale"
local wallpaper_cmd = "feh --bg-max --no-xinerama ~/Pictures/utopiamist_w3840_h1080_cw3840_ch1080.jpg"
local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell

-- Beautiful theme
beautiful.init(awful.util.getdir("config") .. "/themes/zhongguo/zhongguo.lua")

-- Window management layouts
layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.tile.bottom,
  awful.layout.suit.tile.top,
  --awful.layout.suit.fair,
  awful.layout.suit.max,
  awful.layout.suit.magnifier,
  --awful.layout.suit.floating
}
-- }}}

-- {{{ Tags

-- Taglist numerals
taglist_numbers_langs = { 'arabic', 'chinese', 'traditional_chinese', 'east_arabic', 'persian_arabic', }
taglist_numbers_sets = {
	arabic={ 1, 2, 3, 4, 5, 6, 7, 8, 9 },
	chinese={"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"},
	traditional_chinese={"壹", "貳", "叄", "肆", "伍", "陸", "柒", "捌", "玖", "拾"},
	east_arabic={'١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'}, -- '٠' 0
	persian_arabic={'٠', '١', '٢', '٣', '۴', '۵', '۶', '٧', '٨', '٩'},
	roman={'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X'},
	thai={'๑', '๒', '๓', '๔', '๕', '๖', '๗', '๘', '๙', '๑๐'},
}
-- }}}

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
      --tags[s] = awful.tag({"一", "二", "三", "四", "五", "六", "七", "八", "九", "十"}, s, layouts[1])
      --tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
	if taglist_numbers == 'random' then
		math.randomseed(os.time())
		local taglist = taglist_numbers_sets[taglist_numbers_langs[math.random(table.getn(taglist_numbers_langs))]]
		tags[s] = awful.tag(taglist, s, layouts[1])
	else
		tags[s] = awful.tag(taglist_numbers_sets[taglist_numbers], s, layouts[1])
	end
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
-- }}}


-- {{{ Wibox
--
-- {{{ Widgets configuration
--
-- {{{ Reusable separator
separator = widget({ type = "imagebox" })
separator.image = image(beautiful.widget_sep)

spacer = widget({ type = "textbox" })
spacer.width = 3
-- }}}

-- {{{ CPU usage

-- cpu icon
cpuicon = widget({ type = "imagebox" })
cpuicon.image = image(beautiful.widget_cpu)

-- check for cpugraph_enable == true in config
if cpugraph_enable then
	-- Initialize widget
	cpugraph1 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph1:set_vertical(true):set_ticks(true)
	cpugraph1:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph1:set_background_color(beautiful.fg_off_widget)
	cpugraph1:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph1, vicious.widgets.cpu, "$2", 1)

	-- Initialize widget
	cpugraph2 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph2:set_vertical(true):set_ticks(true)
	cpugraph2:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph2:set_background_color(beautiful.fg_off_widget)
	cpugraph2:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph2, vicious.widgets.cpu, "$3", 1)

	-- Initialize widget
	cpugraph3 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph3:set_vertical(true):set_ticks(true)
	cpugraph3:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph3:set_background_color(beautiful.fg_off_widget)
	cpugraph3:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph3, vicious.widgets.cpu, "$4", 1)

	-- Initialize widget
	cpugraph4 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph4:set_vertical(true):set_ticks(true)
	cpugraph4:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph4:set_background_color(beautiful.fg_off_widget)
	cpugraph4:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph4, vicious.widgets.cpu, "$5", 1)

	-- Initialize widget
	cpugraph5 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph5:set_vertical(true):set_ticks(true)
	cpugraph5:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph5:set_background_color(beautiful.fg_off_widget)
	cpugraph5:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph5, vicious.widgets.cpu, "$6", 1)

	-- Initialize widget
	cpugraph6 = awful.widget.progressbar()
	-- Pogressbar properties
	cpugraph6:set_vertical(true):set_ticks(true)
	cpugraph6:set_height(16):set_width(8):set_ticks_size(2)
	cpugraph6:set_background_color(beautiful.fg_off_widget)
	cpugraph6:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(cpugraph6, vicious.widgets.cpu, "$7", 1)

end

-- cpu text widget
cpuwidget1 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget1, vicious.widgets.cpu, "$2%", 1) -- register
cpuwidget2 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget2, vicious.widgets.cpu, "$3%", 1) -- register
cpuwidget3 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget3, vicious.widgets.cpu, "$4%", 1) -- register
cpuwidget4 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget4, vicious.widgets.cpu, "$5%", 1) -- register
cpuwidget5 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget5, vicious.widgets.cpu, "$6%", 1) -- register
cpuwidget6 = widget({ type = "textbox" }) -- initialize
vicious.register(cpuwidget6, vicious.widgets.cpu, "$7%", 1) -- register

-- temperature
tzswidget = widget({ type = "textbox" })
vicious.register(tzswidget, vicious.widgets.thermal,
	function (widget, args)
		if args[1] > 0 then
			tzfound = true
			return " " .. args[1] .. "C°"
		else return "" 
		end
	end
	, 19, "thermal_zone0")

-- }}}


-- {{{ Battery state

-- Initialize widget
batwidget = widget({ type = "textbox" })
baticon = widget({ type = "imagebox" })

-- Register widget
vicious.register(batwidget, vicious.widgets.bat,
	function (widget, args)
		if args[2] == 0 then return ""
		else
			baticon.image = image(beautiful.widget_bat)
			return "<span color='white'>".. args[2] .. "%</span>"
		end
	end, 61, "BAT0"
)
-- }}}


-- {{{ Memory usage

-- icon
memicon = widget({ type = "imagebox" })
memicon.image = image(beautiful.widget_mem)

if membar_enable then
	-- Initialize widget
	membar = awful.widget.progressbar()
	-- Pogressbar properties
	membar:set_vertical(true):set_ticks(true)
	membar:set_height(16):set_width(8):set_ticks_size(2)
	membar:set_background_color(beautiful.fg_off_widget)
	membar:set_gradient_colors({ beautiful.fg_widget,
	   beautiful.fg_center_widget, beautiful.fg_end_widget
	}) -- Register widget
	vicious.register(membar, vicious.widgets.mem, "$1", 13)
end

-- mem text output
memtext = widget({ type = "textbox" })
vicious.register(memtext, vicious.widgets.mem, memtext_format, 13)
-- }}}

-- {{{ File system usage
fsicon = widget({ type = "imagebox" })
fsicon.image = image(beautiful.widget_fs)

-- {{{ Weather widget
weathericon = widget({ type = "textbox" })

function weather_icon()
    local f = io.popen("conkyForecast --datatype=WF")
    local value = f:read()
    f:close()
    return {value}
end

vicious.register(weathericon, weather_icon, "<span color='white' font='ConkyWeather'>$1</span>", 4000)


weatherwidget = widget({ type = "textbox" })
weather_t = awful.tooltip({ objects = { weatherwidget },})

vicious.register(weatherwidget, vicious.widgets.weather,
function (widget, args)
    weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windmph}"] .. "mph " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%\nWindchill: " .. args["{chillf}"] .. "°F")
    return args["{tempf}"] .. "°F"
end, 300, "KMSP")
--'1800': check every 30 minutes.
--                --'CYUL': the Montreal ICAO code.

-- Initialize widgets
fs = {
  r = awful.widget.progressbar(), s = awful.widget.progressbar()
}
-- Progressbar properties
for _, w in pairs(fs) do
  w:set_vertical(true):set_ticks(true)
  w:set_height(16):set_width(5):set_ticks_size(2)
  w:set_border_color(beautiful.border_widget)
  w:set_background_color(beautiful.fg_off_widget)
  w:set_gradient_colors({ beautiful.fg_widget,
     beautiful.fg_center_widget, beautiful.fg_end_widget
  }) -- Register buttons
  w.widget:buttons(awful.util.table.join(
    awful.button({ }, 1, function () exec("dolphin", false) end)
  ))
end -- Enable caching
vicious.cache(vicious.widgets.fs)
-- Register widgets
vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",            599)
vicious.register(fs.s, vicious.widgets.fs, "${/home}", 599)
-- }}}

-- {{{ Network usage
function print_net(name, down, up)
	return '<span color="'
	.. beautiful.fg_netdn_widget ..'">' .. down .. '</span> <span color="'
	.. beautiful.fg_netup_widget ..'">' .. up  .. '</span>'
end

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()

    local volume = tonumber(string.match(status, "(%d?%d?%d)%%"))
    local volumestr = string.format("% 3d", volume)
    volume = volume / 100

    status = string.match(status, "%[(o[^%]]*)%]")

    -- starting colour
    local sr, sg, sb = 0x3F, 0x3F, 0x3F
    -- ending colour
    local er, eg, eb = 0xDC, 0xDC, 0xCC

    local ir = volume * (er - sr) + sr
    local ig = volume * (eg - sg) + sg
    local ib = volume * (eb - sb) + sb
    interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
    if string.find(status, "on", 1, true) then
        volume = " <span>" .. volumestr .. "</span>"
    else
        volume = " <span color='red'> M </span>"
    end
    widget.text = volume
end



function volume_up(volbar, volwidget)
    exec("amixer set Master 2%+", false)
    update_volume(volwidget)
    vicious.force({volbar, volwidget})
end

function volume_down(volbar, volwidget)
    exec("amixer set Master 2%-", false) 
    update_volume(volwidget)
    vicious.force({volbar, volwidget})
end

function volume_mute(volbar, volwidget)
    exec("amixer -D pulse set Master 1+ toggle", false) 
    update_volume(volwidget)
    vicious.force({volbar, volwidget})
end


dnicon = widget({ type = "imagebox" })
upicon = widget({ type = "imagebox" })

-- Initialize widget
netwidget = widget({ type = "textbox" })
-- Register widget
vicious.register(netwidget, vicious.widgets.net,
	function (widget, args)
		for _,device in pairs(networks) do
			if tonumber(args["{".. device .." carrier}"]) > 0 then
				netwidget.found = true
				dnicon.image = image(beautiful.widget_net)
				upicon.image = image(beautiful.widget_netup)
				return print_net(device, args["{"..device .." down_kb}"], args["{"..device.." up_kb}"])
			end
		end
	end, 3)
-- }}}



-- {{{ Volume level
volicon = widget({ type = "imagebox" })
volicon.image = image(beautiful.widget_vol)
-- Initialize widgets
volbar    = awful.widget.progressbar()
volwidget = widget({ type = "textbox" })
-- Progressbar properties
volbar:set_vertical(true):set_ticks(true)
volbar:set_height(16):set_width(8):set_ticks_size(2)
volbar:set_background_color(beautiful.fg_off_widget)
volbar:set_gradient_colors({ beautiful.fg_widget,
   beautiful.fg_center_widget, beautiful.fg_end_widget
}) -- Enable caching
vicious.cache(vicious.widgets.volume)
-- Register widgets
vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master")
--vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "PCM")
-- Register buttons
volbar.widget:buttons(awful.util.table.join(
   awful.button({ }, 1, function () exec("kmix") end),
   awful.button({ }, 4, function () volume_up(volbar, volwidget) end),
   awful.button({ }, 5, function () volume_down(volbar, volwidget) end)
)) -- Register assigned buttons
volwidget:buttons(volbar.widget:buttons())

update_volume(volwidget)
awful.hooks.timer.register(1, function() update_volume(volwidget) end)

-- }}}

-- {{{ Date and time
dateicon = widget({ type = "imagebox" })
dateicon.image = image(beautiful.widget_date)
-- Initialize widget
datewidget = widget({ type = "textbox" })
-- Register widget
vicious.register(datewidget, vicious.widgets.date, date_format, 61)
calendar2.addCalendarToWidget(datewidget)
-- }}}

-- {{{ mpd

if whereis_app('curl') and whereis_app('mpd') then
	mpdwidget = widget({ type = "textbox" })
	vicious.register(mpdwidget, vicious.widgets.mpd,
		function (widget, args)
			if args["{state}"] == "Stop" or args["{state}"] == "Pause" or args["{state}"] == "N/A"
				or (args["{Artist}"] == "N/A" and args["{Title}"] == "N/A") then return ""
			else return '<span color="white">Playing: </span> '..
			     args["{Artist}"]..' - '.. args["{Title}"]
			end
		end
	)
end

-- }}}


-- {{{ System tray
systray = widget({ type = "systray" })
-- }}}
-- }}}

-- mystatusbar = awful.wibox({ position = "bottom", screen = 2, ontop = false, width = 1, height = 24 })

-- {{{ Wibox initialisation
wibox     = {}
promptbox = {}
layoutbox = {}
taglist   = {}
taglist.buttons = awful.util.table.join(
    awful.button({ },        1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ },        3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag),
    awful.button({ },        4, awful.tag.viewnext),
    awful.button({ },        5, awful.tag.viewprev
))


for s = 1, screen.count() do
    -- Create a promptbox
    promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a layoutbox
    layoutbox[s] = awful.widget.layoutbox(s)
    layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
        awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
    ))

    -- Create the taglist
    taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
    -- Create the wibox
    wibox[s] = awful.wibox({      screen = s,
        fg = beautiful.fg_normal, height = 16,
        bg = beautiful.bg_normal, position = "top",
        border_color = beautiful.border_normal,
        border_width = beautiful.border_width
    })
    -- Add widgets to the wibox
    wibox[s].widgets = {
        {   taglist[s], layoutbox[s], separator, promptbox[s],
            mpdwidget and spacer, mpdwidget or nil,
            ["layout"] = awful.widget.layout.horizontal.leftright
        },
        --s == screen.count() and systray or nil, -- show tray on last screen
        s == 1 and systray or nil, -- only show tray on first screen
        s == 1 and separator or nil, -- only show on first screen
        datewidget, dateicon,
        separator, weatherwidget, weathericon,
        baticon.image and separator, batwidget, baticon or nil,
        separator, volwidget,  volbar.widget, volicon,
        dnicon.image and separator, upicon, netwidget, dnicon or nil,
        separator, fs.r.widget, fs.s.widget, fsicon,
        separator, memtext, membar_enable and membar.widget or nil, memicon,
        separator, tzfound and tzswidget or nil,
        cpugraph_enable and cpugraph6.widget or nil, --cpuwidget6,
        cpugraph_enable and cpugraph5.widget or nil, --cpuwidget5,
        cpugraph_enable and cpugraph4.widget or nil, --cpuwidget4,
        cpugraph_enable and cpugraph3.widget or nil, --cpuwidget3,
        cpugraph_enable and cpugraph2.widget or nil, --cpuwidget2,
        cpugraph_enable and cpugraph1.widget or nil, cpuicon, --cpuwidget1, 
        ["layout"] = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}
-- }}}


-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Client bindings
clientbuttons = awful.util.table.join(
    awful.button({ },        1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)
-- }}}


-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.client.incmwfact( 0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.client.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, ",",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey,           }, ".",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey }, "b", function ()
         wibox[mouse.screen].visible = not wibox[mouse.screen].visible
    end),

    -- Prompt
    awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

   -- Multimedia keys
   awful.key({ }, "XF86AudioRaiseVolume",    function () volume_up(volbar, volgraph) end),
   awful.key({ }, "XF86AudioLowerVolume",    function () volume_down(volbar, volgraph) end),
   awful.key({ }, "XF86AudioMute",    function () volume_mute(volbar, volgraph) end),

   awful.key({ }, "XF86AudioNext",function () awful.util.spawn( "mpc next" ) end),
   awful.key({ }, "XF86AudioPrev",function () awful.util.spawn( "mpc prev" ) end),
   awful.key({ }, "XF86AudioPlay",function () awful.util.spawn( "mpc play" ) end),
   awful.key({ }, "XF86AudioStop",function () awful.util.spawn( "mpc pause" ) end),
   --awful.key({ }, "XF86Sleep", function() awful.util.spwan_with_shell("/home/john/.local/bin/sleeppc") end),
   awful.key({ }, "XF86Sleep", function() awful.util.spwan_with_shell("sudo pm-hibernate") end),

   awful.key({ modkey, "Control" }, "b",     function () awful.util.spawn(browser)         end),
   awful.key({ modkey, "Control" }, "e",     function () awful.util.spawn(ide)         end),
   awful.key({ modkey }, "o", awful.client.movetoscreen)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "t",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Shift" }, "t", function (c)
        if   c.titlebar then awful.titlebar.remove(c)
           else awful.titlebar.add(c, { modkey = modkey }) end
    end),
    awful.key({ modkey,           }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
    { rule = { class = "Chromium-browser" },   properties = { floating = false } },
    { rule = { class = "Google-chrome" },   properties = { floating = false } },
    { rule = { class = "Firefox" },   properties = { floating = false } },

    { rule = { instance = "plugin-container" }, properties = { floating = true , focus = yes} },
}
-- }}}


-- {{{ Signals
--
-- {{{ Manage signal handler
client.add_signal("manage", function (c, startup)
    -- Add titlebar to floaters, but remove those from rule callback
    if awful.client.floating.get(c)
    or awful.layout.get(c.screen) == awful.layout.suit.floating then
        if   c.titlebar then awful.titlebar.remove(c)
        else awful.titlebar.add(c, {modkey = modkey}) end
    end

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function (c)
        if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    -- Client placement
    if not startup then
        awful.client.setslave(c)

        if  not c.size_hints.program_position
        and not c.size_hints.user_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)
-- }}}

-- {{{ Focus signal handlers
client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
    local clients = awful.client.visible(s)
    local layout = awful.layout.getname(awful.layout.get(s))

    for _, c in pairs(clients) do -- Floaters are always on top
        if   awful.client.floating.get(c) or layout == "floating"
        then if not c.fullscreen then c.above       =  true  end
        else                          c.above       =  false end
    end
  end)
end
-- }}}
-- }}}

require_safe('autorun')

os.execute("nm-applet &")
