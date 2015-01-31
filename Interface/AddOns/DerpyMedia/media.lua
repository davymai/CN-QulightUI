local ns = select(2,...) -- Someone wanna hold main global table not in global var =P

ns[1] = {} -- non names here	-- is M, the first one
ns[2] = {} -- names here		-- is L, the second one

_G.DerpyData = ns -- Using "M,L,V = unpack(DerpyData)" to get this table --
INTERFACE_ACTION_BLOCKED = "" -- USELESS FOR NORMAL USERs
-- -- -- -- -- -- -- -- -- -- --
local M,L = unpack(select(2,...))

-- Some Media: Files + Colors set
local mediapath = "Interface\\AddOns\\DerpyMedia\\media\\"
M["media"] = {
	["path"] = mediapath,
	["font_s"] = mediapath.."sis.ttf",
	["blank"] = mediapath.."blankTex.tga",
	["glow"] = mediapath.."glowTex.tga",
	--["cdfont"] = mediapath.."cdfont.ttf",
	--["fontn"] = mediapath.."standart.ttf",
	["fontn_lang"] = "Fonts\\FRIZQT__.ttf",-- font change LeilaUI
	["barv"] = mediapath.."barv.tga",
	["walltex"] = mediapath.."wallTex.tga",
	["ricon"] = mediapath.."ricon.tga",
	["crosstex"] = mediapath.."CrossTex.tga",
	["prizvstudiu"] = mediapath.."polechudes.tga",
	["font"] = "Fonts\\FRIZQT__.ttf",-- font change LeilaUI
	["color"] = {0,.02,.04,.7},
	["shadow"] = {.05,.05,.05,.85},
	["border"] = {0,0,0,1},
	["gradient"] = {0,0,0,0,0,0,0,0},
	["button"] = {{1,.1,.1,.9},{0,.8,.8,.9},{.3,.3,.3,.9},{0,1,1,.9}},
}
	
-- Backdrop set
local ___inserts = {
	left = 3, 
	right = 3, 
	top = 3, 
	bottom = 3}
	
M["bg"] = {
	bgFile = M["media"].blank, 
	edgeFile = M["media"].glow, 
	edgeSize = 4,
	insets = ___inserts}
	
M["bg_edge"] = {
	edgeFile = M["media"].glow, 
	edgeSize = 4,
	insets = ___inserts}

-- Constants
M.RaidColors = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
M.L = GetLocale()
M.class = select(2,UnitClass("player"))
M.Class = M.class -- make more easy
M.oufspawn = 160
M.call = {} -- config menu table

-- Check main lang font
M["media"].font_lang = (M.L == "ruRU" and [=[Fonts\FRIZQT__.ttf]=]) -- RU  -- font change LeilaUI
	or (M.L == "koKR" and [=[Fonts\FRIZQT__.ttf]=]) -- KR
	or (M.L == "zhTW" and [=[Fonts\FRIZQT__.ttf]=]) -- TW
	or (M.L == "zhCN" and [[Fonts\FRIZQT__.ttf]]) -- CN
	or M["media"].font -- EN
	
if (M.L == "koKR" or M.L == "zhTW" or M.L == "zhCN") then
	M["media"].fontn_lang = M["media"].font_lang
else
	M["media"].fontn_lang = M["media"].fontn
end