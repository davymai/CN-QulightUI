
----------------------------------------------------------------------------------------
--	Based on FreebAutoRez(by Freebaser)
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

local classList = {
	["DEATHKNIGHT"] = {
		combat = GetSpellInfo(61999),	-- Raise Ally
	},
	["DRUID"] = {
		combat = GetSpellInfo(20484),	-- Rebirth
		ooc = GetSpellInfo(50769),		-- Revive
	},
	["MONK"] = {
		ooc = GetSpellInfo(115178),		-- Resuscitate
	},
	["PALADIN"] = {
		ooc = GetSpellInfo(7328),		-- Redemption
	},
	["PRIEST"] = {
		ooc = GetSpellInfo(2006),		-- Resurrection
	},
	["SHAMAN"] = {
		ooc = GetSpellInfo(2008),		-- Ancestral Spirit
	},
	["WARLOCK"] = {
		combat = GetSpellInfo(6203),	-- Soulstone
		ooc = GetSpellInfo(6203),		-- Soulstone
	},
}

local body = ""
local function macroBody(class)
	local combatspell = classList[class].combat
	local oocspell = classList[class].ooc

	body = "/stopmacro [@mouseover,nodead]\n"
	if combatspell then
		body = body.."/use [combat,@mouseover,help,dead] "..combatspell.."; "

		if oocspell then
			body = body.."[@mouseover,help,dead] "..oocspell.."; "
		end

		if class == "WARLOCK" then
			local spellname = select(1, GetSpellInfo(6203))
			body = body.."\n/use "..spellname.."\n "
		end
	elseif oocspell then
		body = body.."/use [@mouseover,help,dead] "..oocspell.."; "
	end

	return body
end

local Enable = function(self)
	local _, class = UnitClass("player")
	if not class then return end

	if classList[class] and not IsAddOnLoaded("Clique") then
		self:SetAttribute("*type3", "macro")
		self:SetAttribute("macrotext3", macroBody(class))
		return true
	end
end

local Disable = function(self)
	self:SetAttribute("*type3", nil)
end

oUF:AddElement("AutoResurrect", nil, Enable, Disable)