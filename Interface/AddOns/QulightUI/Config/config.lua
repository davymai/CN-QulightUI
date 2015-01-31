Qulight["media"] = {
	["font"] = [=[Interface\Addons\QulightUI\Root\Media\qFont.ttf]=], 			        -- main font in Qulight UI
	["pxfont"] = [=[Interface\Addons\QulightUI\Root\Media\pxFont.ttf]=],
	["fontsize"] = 13, 														    		-- size of font
	["texture"] = "Interface\\AddOns\\QulightUI\\Root\\Media\\statusbar4",				-- main texture in Qulight UI
	["blank"] = "Interface\\Buttons\\WHITE8x8",											-- clean texture
	--["glow"] = "Interface\\AddOns\\QulightUI\\Root\\Media\\glowTex",  屏蔽表框扩散效果
	["alpha"] = 0.5,
}
Qulight["general"] = {
	["AutoScale"] = true,  																-- mainly enabled for users that don't want to mess with the config file
	["UiScale"] = 0.75,																	-- set your value (between 0.64 and 1) of your uiscale if autoscale is off
	["MultisampleProtect"] = false,    													-- 1x antialazing
	["AutoRepair"] = false,																-- auto repair
	["AutoGreed"] = false,
	["topbottompanel"] = true,
	--["centerpanel"] = false,  屏蔽左右信息栏，若要打开需同时修改 Layout.lua 把第58行与68行的注释符号去掉，并且恢复下面的信息栏设置
	["autoinvite"] = true,
	["AutoDisenchant"] = true,															-- auto dis green items
	["BlizzardsErrorFrameHiding"] = true,												-- hide blizzard red errors
}
Qulight["actionbar"] = {
	["enable"] = true,                                  -- enable  action bars
	["hotkey"] = true,                                  -- enable hotkey display because it was a lot requested
	--增加动作条显示宏名称开关
	["macrotext"]=true,      							-- show/hide button macros text
	["hideSTANCE"] = false,                         	-- hide STANCE or totembar because it was a lot requested.
	["showgrid"] = true,                                -- show grid on empty button
	["buttonsize"] = 34,                                -- normal buttons size
	["petbuttonsize"] = 32,                             -- pet & stance buttons size
	["buttonspacing"] = 1,                              -- buttons spacing
	["petbuttonspacing"] = 1,
	["mainbarWidth"] = 12,
	["ownshdbar"] = false,                              -- use a complete new stance bar for shadow dance (rogue only)
}

Qulight["raidframes"] = {
	["aggro_border"] = true,					-- Aggro border
	["deficit_health"] = true,					-- Raid deficit health
	["vertical_health"] = false,				-- Vertical orientation of health
	["alpha_health"] = false,					-- Alpha of healthbars when 100%hp
	["power"] = true,					-- Alpha of healthbars when 100%hp
	["show_range"] = true,						-- Show range opacity for raidframes
	["range_alpha"] = 0.5,						-- Alpha of unitframes when unit is out of range
	["hp_value"] = false,
	["width"] = 81.7,
	["height"] = 32,

	["show_party"] = true,						-- Show party frames
	["show_raid"] = true,						-- Show raid frames
	["solo_mode"] = false,					-- Show player frame always
	["player_in_party"] = true,					-- Show player frame in party
	["raid_groups"] = 4,						-- Number of groups in raid
	["raid_groups_vertical"] = false,			-- Vertical raid groups(only for heal layout)

	["icons_role"] = true,						-- Role icon on frames
	["icons_raid_mark"] = true,					-- Raid mark icons on frames
	["icons_ready_check"] = true,				-- Ready check icons on frames
	["icons_leader"] = true,					-- Leader icon, assistant icon, master loot icon on frames

	["plugins_debuffhighlight_icon"] = false,	-- Debuff highlight texture + icon
	["plugins_aura_watch"] = true,				-- Raid debuff icons
	["plugins_aura_watch_timer"] = true,		-- Timer on raid debuff icons
	["plugins_healcomm"] = true,				-- Incoming heal bar on raid frame
	["plugins_auto_resurrection"] = false,		-- Auto cast resurrection on middle click when the unit is dead(doesn't work with Clique enabled)

	["own_color"] = true,
	["fontsize"] = 10,
    ["fontsizeEdge"] = 12,
    ["outline"] = "OUTLINE",
	["bar_color_value"] = false,
	["color_value"] = false,
	["plugins_smooth_bar"] = true,				-- Smooth bar
	["show_timer"] = true,
	["show_spiral"] = false,					-- Spiral on aura icons
	["debuff_color_type"] = true,				-- Color debuff by type
}
Qulight["unitframes"] = {
	["enable"] = true,																	-- enable/disable action bars
	["HealthcolorClass"] = false,														-- health color = class color
	["bigcastbar"] = true,
		["widthbigcastbar"] = 320,
		["heightbigcastbar"] = 20,
	["Powercolor"] = true,																-- power color = class color
	["showtot"] = true, 																-- show target of target frame
	["showpet"] = true,																	-- show pet frame
	["showfocus"] = true, 																-- show focus frame
	["showfocustarget"] = true, 														-- show focus target frame
	["showBossFrames"] = true, 															-- show boss frame
	["TotemBars"] = true, 																-- show totem bars
	["MTFrames"] = true, 																-- show main tank frames
	["ArenaFrames"]  = true, 															-- show arena frame
	["Reputationbar"] = true, 															-- show reputation bar
	["Experiencebar"] = true, 															-- show experience bar
	["showPlayerAuras"] = false, 														-- use a custom player buffs/debuffs frame instead of blizzard's default.
	["showPortrait"] = true,															-- show portraits
	["showRunebar"] = true, 															-- show dk rune bar
	["showHolybar"] = true, 															-- show paladin HolyPower bar
	["showEclipsebar"] = true, 															-- show druid eclipse bar
	["showShardbar"] = true, 															-- show warlock soulShard bar
	["Castbars"] = true, 																-- use built-in castbars
}
Qulight["chatt"] = {
	["enable"] = true,																	-- enable/disable chat
	["chatbar"] = false,																-- enable/disable chatbar
}
Qulight["buffdebuff"] = {
	["enable"] = true,
	["iconsize"] = 35, 																	-- buffs size
	["timefontsize"] = 12, 																-- time font size
	["countfontsize"] = 14,  															-- count font size
	["spacing"] = 3, 																	-- spacing between icons(buffs)
	["timeYoffset"] = 0, 																-- verticall offset value for time text field
	["BUFFS_PER_ROW"] = 15,
}
Qulight["addonskins"] = {
	["DBM"] = true, 																	-- Deadly Boss Mod skinning
	["PallyPower"] = true, 																-- Pally Power skinning
	["Skada"] = true, 																	-- Skada skinning
	["Recount"] = true, 																-- Recount skinning
	["Omen"] = true, 																	-- Omen skinning
	["KLE"] = true, 																	-- KLE skinning
	["Quartz"] = true, 																	-- Quartz skinning
	["Bigwigs"] = true, 																-- BigWigs Bossmod skinning
	["DXE"] = true,
	["CoolLine"] = true,
}
Qulight["datatext"] = {
--[[ 默认信息栏样式，若恢复默认信息栏样式，请注释或删除144-157行,且把QulightUI\Addons\Infotext\默认文件 里的文件覆盖Infotext里的文件
	["Durability"] = 2,                													-- show your equipment durability on panels.
	["System"] = 1,                														-- show fps and ms on panels, and total addon memory in tooltip
	["Gold"] = 4,                														-- show your current gold on panels
	["Guild"] = 3,       			  													-- show guild info
	["Wowtime"] = 8,              														-- show time on panels
	["Friends"] = 7,                													-- show number of friends connected.
	["Bags"] = 6,                														-- show space used in bags on panels
	["specswitcher"] = 9,
	["haste"] = 11,
	["mastery"] = 16,
	["power"] = 13,
	["crit"] = 12,
	["hps"] = 14,
	["dps"] = 15,
]]
	["System"] = 1,                														-- show fps and ms on panels, and total addon memory in tooltip
	["Durability"] = 2,                													-- show your equipment durability on panels.
	["Guild"] = 3,       			  													-- show guild info
	["Friends"] = 4,                													-- show number of friends connected.
	["Gold"] = 5,                														-- show your current gold on panels
	["Bags"] = 6,                														-- show space used in bags on panels
	["specswitcher"] = 7,
	["Wowtime"] = 8,              														-- show time on panels
	["hps"] = 9,
	["haste"] = 10,
	["mastery"] = 11,
	["power"] = 12,
	["crit"] = 13,
	["dps"] = 14,
	["Time24"] = true,            														-- set time to 24h format(if wowtime enable)
	["Localtime"] = true,  																-- local time(if wowtime enable)
	["classcolor"] = true,																-- class color text info
	["color"] = { .7, .7, .7, 1 }, 														-- if ["classcolor"] = false,
}
Qulight["nameplate"] = {
	["enable"] = true, 							-- Enable nameplate
	["combat"] = false,							-- Automatically show nameplate in combat
	["health_value"] = true,					-- Numeral health value
	["show_castbar_name"] = false,				-- Show castbar name
	["enhance_threat"] = true,					-- If tank good aggro = green, bad = red
	["class_icons"] = false,					-- Icons by class in pvp
	["name_abbrev"] = false,					-- Display the abbreviated names
	["track_auras"] = true,						-- Show debuffs
	["healer_icon"] = false,					-- Show icon above enemy healers nameplate in battlegrounds
	["height"] = 15,							-- Nameplate height
	["width"] = 150,							-- Nameplate width
	["ad_height"] = 0,							-- Additional height for selected nameplate
	["ad_width"] = 0,							-- Additional width for selected nameplate
	["good_color"] = {0.2, 0.8, 0.2},			-- Good threat color
	["near_color"] = {1, 1, 0},					-- Near threat color
	["bad_color"] = {1, 0, 0},					-- Bad threat color
	["auras_size"] = 22,						-- Debuffs size
}
Qulight["minimapp"] = {
	["enable"] = true,																	-- enable/disable minimap
	["size"] = 160,																		-- minimap size
}
Qulight["tooltip"] = {
	["enable"] = true,                      											-- true to enable this mod, false to disable
	["hidecombat"] = false,               												-- hide bottom-right tooltip when in combat
	["hidebuttons"] = false,                											-- always hide action bar buttons tooltip.
	["hideuf"] = false,                     											-- hide tooltip on unitframes
	["cursor"] = false,                     											-- tooltip via cursor only
	["itemlevel"] = true,																-- show item level
	["spellid"] = true,
	["title"] = false,	-- show speel id
}
Qulight["bags"] = {   --关闭默认背包，整合DerpyBags ,若要还原，请把false改成true,并删除DerpyMedia与DerpyStuffing文件夹。
	["Enable"] = false,																	-- enable/disable bags
	["buttonsize"] = 32,																	-- Buttons size
	["buttonspace"] = 3,																	-- Buttons space
	["bankcolumns"] = 17,																	-- Horizontal number of columns in bank
	["BagBars"] = false,																	-- enable/disable bags bar
}
Qulight["loot"] = {
	["lootframe"] = true,                  												-- enable/disable loot addon
	["rolllootframe"] = true,															-- enable/disable loot roll addon
}
Qulight["cooldown"] = {
	["enable"] = true,                     												-- enable/disable cooldown addon(for buttons)
}
Qulight["misk"] = {
	["addonmanager"] = true,														-- enable disable addonmanager
	["armory_link"] = false,															-- enable armory_link
	["filger"] = true,																	-- enable disable filger
	["classtimer"] = false,																-- enable disable classtimer
	["BuffReminderRaidBuffs"] = true,													-- enable disable raid buffs reminder
	["Reminder"] = true,																-- enable disable reminder(self buff)
	["CooldownFlash"] = true,															-- enable disable cooldown flash
	["raidcooldowns"] = false,
	["AutoScreen"] = true,
	["Threatbar"] = true,
	["raidmarker"] = true,
	["raidutility"] = true,														-- enable disable raid utility
}