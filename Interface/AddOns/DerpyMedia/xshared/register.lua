-- Register some media stuff in SharedMedia^
local M,L = unpack(select(2,...))

M.addenter(function() -- player_entering_world
	if not LibStub then return end
	local m = LibStub("LibSharedMedia-3.0",true); if m == nil then return  end
	local n = ({["koKR"] = 1, ["ruRU"] = 2, ["zhCN"] = 4, ["zhTW"] = 8})[M.L] or 128
	local A = M["media"]
	m:Register("statusbar",	"Derpy - StatusBar",		A.barv		)
	m:Register("background","Derpy - Blank",			A.blank		)
	m:Register("background","Derpy - WallPaper",		A.walltex	)
	m:Register("border",	"Derpy - Glow",				A.glow		)
	m:Register("font",		"Derpy - Font",				A.font,n	)
	m:Register("font",		"Derpy - SystemFont", 		A.font_s,n	)
	m:Register("font",		"Derpy - NormalFont", 		A.fontn,n	)
	m:Register("font",		"Derpy - CooldownFont", 	A.cdfont,n	)
	m:Register("font",		"Derpy - NullFont",			A.path.."null.ttf",n)
end)
