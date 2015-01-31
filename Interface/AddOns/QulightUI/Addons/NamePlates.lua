if not Qulight["nameplate"].enable == true then return end
----------------------------------------------------------------------------------------
--	Based on dNameplates(by Dawn, editor Elv22)
----------------------------------------------------------------------------------------

local function SpellName(id)
	local name = select(1, GetSpellInfo(id))
	return name
end

DebuffWhiteList = {
	-- Death Knight
	[SpellName(115001)] = true,	-- Remorseless Winter
	[SpellName(108194)] = true,	-- Asphyxiate
	[SpellName(47476)] = true,	-- Strangulate
	[SpellName(55078)] = true,	-- Blood Plague
	[SpellName(55095)] = true,	-- Frost Fever
	-- Druid
	[SpellName(33786)] = true,	-- Cyclone
	[SpellName(339)] = true,	-- Entangling Roots
	[SpellName(164812)] = true,	-- Moonfire
	[SpellName(164815)] = true,	-- Sunfire
	[SpellName(58180)] = true,	-- Infected Wounds
	[SpellName(33745)] = true,	-- Lacerate
	[SpellName(155722)] = true,	-- Rake
	[SpellName(1079)] = true,	-- Rip
	-- Hunter
	[SpellName(3355)] = true,	-- Freezing Trap
	-- Mage
	[SpellName(118)] = true,	-- Polymorph
	[SpellName(31661)] = true,	-- Dragon's Breath
	[SpellName(122)] = true,	-- Frost Nova
	[SpellName(111340)] = true,	-- Ice Ward
	[SpellName(44457)] = true,	-- Living Bomb
	[SpellName(114923)] = true,	-- Nether Tempest
	[SpellName(112948)] = true,	-- Frost Bomb
	[SpellName(83853)] = true,	-- Combustion
	[SpellName(44572)] = true,	-- Deep Freeze
	[SpellName(120)] = true,	-- Cone of Cold
	[SpellName(102051)] = true,	-- Frostjaw
	-- Monk
	[SpellName(115078)] = true,	-- Paralysis
	-- Paladin
	[SpellName(20066)] = true,	-- Repentance
	[SpellName(10326)] = true,	-- Turn Evil
	[SpellName(853)] = true,	-- Hammer of Justice
	[SpellName(105593)] = true,	-- Fist of Justice
	[SpellName(31803)] = true,	-- Censure
	-- Priest
	[SpellName(9484)] = true,	-- Shackle Undead
	[SpellName(8122)] = true,	-- Psychic Scream
	[SpellName(64044)] = true,	-- Psychic Horror
	[SpellName(15487)] = true,	-- Silence
	[SpellName(589)] = true,	-- Shadow Word: Pain
	[SpellName(34914)] = true,	-- Vampiric Touch
	-- Rogue
	[SpellName(6770)] = true,	-- Sap
	[SpellName(2094)] = true,	-- Blind
	[SpellName(1776)] = true,	-- Gouge
	-- Shaman
	[SpellName(51514)] = true,	-- Hex
	[SpellName(3600)] = true,	-- Earthbind
	[SpellName(8056)] = true,	-- Frost Shock
	[SpellName(8050)] = true,	-- Flame Shock
	[SpellName(63685)] = true,	-- Freeze
	-- Warlock
	[SpellName(710)] = true,	-- Banish
	[SpellName(6789)] = true,	-- Mortal Coil
	[SpellName(5782)] = true,	-- Fear
	[SpellName(5484)] = true,	-- Howl of Terror
	[SpellName(6358)] = true,	-- Seduction
	[SpellName(30283)] = true,	-- Shadowfury
	[SpellName(603)] = true,	-- Doom
	[SpellName(980)] = true,	-- Agony
	[SpellName(146739)] = true,	-- Corruption
	[SpellName(48181)] = true,	-- Haunt
	[SpellName(348)] = true,	-- Immolate
	[SpellName(30108)] = true,	-- Unstable Affliction
	-- Warrior
	[SpellName(5246)] = true,	-- Intimidating Shout
	[SpellName(132168)] = true,	-- Shockwave
	[SpellName(115767)] = true,	-- Deep Wounds
	-- Racial
	[SpellName(25046)] = true,	-- Arcane Torrent
	[SpellName(20549)] = true,	-- War Stomp
	[SpellName(107079)] = true,	-- Quaking Palm
}


local PlateBlacklist = {
	--Shaman Totems (Ones that don't matter)
	["Earth Elemental Totem"] = true,
	["Fire Elemental Totem"] = true,
	["Fire Resistance Totem"] = true,
	["Flametongue Totem"] = true,
	["Frost Resistance Totem"] = true,
	["Healing Stream Totem"] = true,
	["Magma Totem"] = true,
	["Mana Spring Totem"] = true,
	["Nature Resistance Totem"] = true,
	["Searing Totem"] = true,
	["Stoneclaw Totem"] = true,
	["Stoneskin Totem"] = true,
	["Strength of Earth Totem"] = true,
	["Windfury Totem"] = true,
	["Totem of Wrath"] = true,
	["Wrath of Air Totem"] = true,
	["Air Totem"] = true,
	["Water Totem"] = true,
	["Fire Totem"] = true,
	["Earth Totem"] = true,

	--Army of the Dead
	["Army of the Dead Ghoul"] = true,
}


-- Check Player's Role
local RoleUpdater = CreateFrame("Frame")
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", function() Role = CheckRole() end)

function UIScale()
	if Qulight["general"].AutoScale == true then
	Qulight["general"].UiScale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
UIScale()
-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/Qulight["general"].UiScale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end
function Scale(x) return scale(x) end
mult = mult


local frames, numChildren, select = {}, -1, select
local noscalemult = mult * Qulight["general"].UiScale
local goodR, goodG, goodB = 0.2, 0.8, 0.2
local badR, badG, badB = 1, 0, 0
local transitionR, transitionG, transitionB = 1, 1, 0

local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)
if Qulight["nameplate"].track_auras == true then
	NamePlates:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

local function Abbrev(name)
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return utf8sub(newname, 18, false)
end

local function QueueObject(frame, object)
	frame.queue = frame.queue or {}
	frame.queue[object] = true
end

local function HideObjects(frame)
	for object in pairs(frame.queue) do
		if object:GetObjectType() == "Texture" then
			object:SetTexture(nil)
		elseif object:GetObjectType() == "FontString" then
			object:SetWidth(0.001)
		else
			object:Hide()
		end
	end
end

-- Create a fake backdrop frame using textures
local function CreateVirtualFrame(frame, point)
	if point == nil then point = frame end
	if point.backdrop then return end

	frame.backdrop = frame:CreateTexture(nil, "BORDER")
	frame.backdrop:SetDrawLayer("BORDER", -8)
	frame.backdrop:SetPoint("TOPLEFT", point, "TOPLEFT", -noscalemult, noscalemult)
	frame.backdrop:SetPoint("BOTTOMRIGHT", point, "BOTTOMRIGHT", noscalemult, -noscalemult)
	frame.backdrop:SetTexture(0.05, 0.05, 0.05, 1)
end

local function SetVirtualBorder(frame, r, g, b)
end

-- Create aura icons
local function CreateAuraIcon(frame)
	local button = CreateFrame("Frame", nil, frame.hp)
	button:SetWidth(Qulight["nameplate"].auras_size)
	button:SetHeight(Qulight["nameplate"].auras_size)

	CreateStyle(button, 4)
	
	button.bg = button:CreateTexture(nil, "BACKGROUND")
	button.bg:SetTexture(0.05, 0.05, 0.05, 1)
	button.bg:SetAllPoints(button)

	button.bord = button:CreateTexture(nil, "BORDER")
	button.bord:SetTexture(.6,.6,.6,0)
	button.bord:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.bord:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)

	button.bg2 = button:CreateTexture(nil, "ARTWORK")
	button.bg2:SetTexture(0.05, 0.05, 0.05, 1)
	button.bg2:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.bg2:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
	button.icon:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.cd = CreateFrame("Cooldown", nil, button)
	button.cd:SetAllPoints(button)
	button.cd:SetReverse(true)

	button.count = button:CreateFontString(nil, "OVERLAY")
	button.count:SetFont(Qulight["media"].font, 10, "THINOUTLINE")
	button.count:SetShadowOffset(1, -1)
	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)

	return button
end

-- Update an aura icon
local function UpdateAuraIcon(button, unit, index, filter)
	local name, _, icon, count, debuffType, duration, expirationTime, _, _, _, spellID = UnitAura(unit, index, filter)

	button.icon:SetTexture(icon)
	button.cd:SetCooldown(expirationTime - duration, duration)
	button.expirationTime = expirationTime
	button.duration = duration
	button.spellID = spellID
	if count > 1 then
		button.count:SetText(count)
	else
		button.count:SetText("")
	end
	button.cd:SetScript("OnUpdate", function(self)
		if not button.cd.timer then
			self:SetScript("OnUpdate", nil)
			return
		end
		button.cd.timer.text:SetFont(Qulight["media"].font, 8, "THINOUTLINE")
		button.cd.timer.text:SetShadowOffset(1, -1)
	end)
	button:Show()
end

-- Filter auras on nameplate, and determine if we need to update them or not
local function OnAura(frame, unit)
	if not frame.icons or not frame.unit or not Qulight["nameplate"].track_auras then return end
	local i = 1
	for index = 1, 40 do
		if i > Qulight["nameplate"].width / Qulight["nameplate"].auras_size then return end
		local match
		local name, _, _, _, _, duration, _, caster, _, _, spellid = UnitAura(frame.unit, index, "HARMFUL")

		if DebuffWhiteList[name] and caster == "player" then match = true end

		if duration and match == true then
			if not frame.icons[i] then frame.icons[i] = CreateAuraIcon(frame) end
			local icon = frame.icons[i]
			if i == 1 then icon:SetPoint("RIGHT", frame.icons, "RIGHT") end
			if i ~= 1 and i <= Qulight["nameplate"].width / Qulight["nameplate"].auras_size then icon:SetPoint("RIGHT", frame.icons[i-1], "LEFT", -2, 0) end
			i = i + 1
			UpdateAuraIcon(icon, frame.unit, index, "HARMFUL")
		end
	end
	for index = i, #frame.icons do frame.icons[index]:Hide() end
end

-- Color the castbar depending on if we can interrupt or not
local function UpdateCastbar(frame)
	frame:ClearAllPoints()
	frame:SetSize(Qulight["nameplate"].width * noscalemult, Qulight["nameplate"].height * noscalemult)
	frame:SetPoint("TOP", frame:GetParent().hp, "BOTTOM", 0, -8)
	frame:GetStatusBarTexture():SetHorizTile(true)
	frame.bg:SetTexture(0.75, 0.75, 0.25, 0.2)
	if frame.shield:IsShown() then
		frame:SetStatusBarColor(0.78, 0.25, 0.25)
		frame.bg:SetTexture(0.78, 0.25, 0.25, 0.2)
	end
end

-- Determine whether or not the cast is Channelled or a Regular cast so we can grab the proper Cast Name
local function UpdateCastText(frame, curValue)
	local _, maxValue = frame:GetMinMaxValues()

	if UnitChannelInfo("target") then
		frame.time:SetFormattedText("%.1f ", curValue)
		if Qulight["nameplate"].show_castbar_name == true then
			frame.name:SetText(select(1, (UnitChannelInfo("target"))))
		end
	end

	if UnitCastingInfo("target") then
		frame.time:SetFormattedText("%.1f ", maxValue - curValue)
		if Qulight["nameplate"].show_castbar_name == true then
			frame.name:SetText(select(1, (UnitCastingInfo("target"))))
		end
	end
end

-- Sometimes castbar likes to randomly resize
local OnValueChanged = function(self, curValue)
	UpdateCastText(self, curValue)
	if self.needFix then
		UpdateCastbar(self)
		self.needFix = nil
	end
end

local OnSizeChanged = function(self)
	self.needFix = true
end

--
local function HealthBar_ValueChanged(frame)
	frame = frame:GetParent()
	frame.hp:SetMinMaxValues(frame.healthOriginal:GetMinMaxValues())
	frame.hp:SetValue(frame.healthOriginal:GetValue() - 1) -- Blizzard bug fix
	frame.hp:SetValue(frame.healthOriginal:GetValue())
end

-- We need to reset everything when a nameplate it hidden
local function OnHide(frame)
	frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
	frame.hp:SetScale(1)
	frame.overlay:Hide()
	frame.cb:Hide()
	frame.cb:SetScale(1)
	frame.unit = nil
	frame.guid = nil
	frame.isClass = nil
	frame.isFriendly = nil
	frame.isTapped = nil
	frame.hp.rcolor = nil
	frame.hp.gcolor = nil
	frame.hp.bcolor = nil
	if frame.icons then
		for _, icon in ipairs(frame.icons) do
			icon:Hide()
		end
	end
	frame:SetScript("OnUpdate", nil)
end

-- Color Nameplate
local function Colorize(frame)
	local r, g, b = frame.healthOriginal:GetStatusBarColor()
	local texcoord = {0, 0, 0, 0}

	for class, _ in pairs(RAID_CLASS_COLORS) do
		local r, g, b = floor(r * 100 + 0.5) / 100, floor(g * 100 + 0.5) / 100, floor(b * 100 + 0.5) / 100
		if class == "MONK" then
			b = b - 0.01
		end
		if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
			frame.isClass = true
			frame.isFriendly = false
			if Qulight["nameplate"].class_icons == true then
				texcoord = CLASS_BUTTONS[class]
				frame.class.Glow:Show()
				frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
			end
			frame.hp.name:SetTextColor(unpack(oUF_colors.class[class]))
			frame.hp:SetStatusBarColor(unpack(oUF_colors.class[class]))
			frame.hp.bg:SetTexture(oUF_colors.class[class][1], oUF_colors.class[class][2], oUF_colors.class[class][3], 0.2)
			return
		end
	end

	frame.isTapped = false
	frame.isClass = false

	if r + b + b > 2 then	-- Tapped
		r, g, b = 0.6, 0.6, 0.6
		frame.isFriendly = false
		frame.isTapped = true
	elseif g + b == 0 then	-- Hostile
		r, g, b = unpack(oUF_colors.reaction[1])
		frame.isFriendly = false
	elseif r + b == 0 then	-- Friendly npc
		r, g, b = unpack(oUF_colors.power["MANA"])
		frame.isFriendly = true
	elseif r + g > 1.59 then	-- Neutral
		r, g, b = unpack(oUF_colors.reaction[4])
		frame.isFriendly = false
	elseif r + g == 0 then	-- Friendly player
		r, g, b = unpack(oUF_colors.reaction[5])
		frame.isFriendly = true
	else	-- Enemy player
		frame.isFriendly = false	
	end

	if Qulight["nameplate"].class_icons == true then
		if frame.isClass == true then
			frame.class.Glow:Show()
		else
			frame.class.Glow:Hide()
		end
		frame.class:SetTexCoord(texcoord[1], texcoord[2], texcoord[3], texcoord[4])
	end

	frame.hp:SetStatusBarColor(r, g, b)
	frame.hp.bg:SetTexture(r, g, b, 0.2)
	frame.hp.name:SetTextColor(r, g, b)
end

-- HealthBar OnShow, use this to set variables for the nameplate
local function UpdateObjects(frame)
	frame = frame:GetParent()

	-- Set scale
	while frame.hp:GetEffectiveScale() < 1 do
		frame.hp:SetScale(frame.hp:GetScale() + 0.01)
	end

	while frame.cb:GetEffectiveScale() < 1 do
		frame.cb:SetScale(frame.cb:GetScale() + 0.01)
	end

	-- Have to reposition this here so it doesnt resize after being hidden
	frame.hp:ClearAllPoints()
	frame.hp:SetSize(Qulight["nameplate"].width * noscalemult, Qulight["nameplate"].height * noscalemult)
	frame.hp:SetPoint("TOP", frame, "TOP", 0, -15)
	frame.hp:GetStatusBarTexture():SetHorizTile(true)
	
	CreateStyle(frame.hp, 4)
	
	-- Match values
	HealthBar_ValueChanged(frame.hp)

	-- Colorize Plate
	Colorize(frame)
	frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor = frame.hp:GetStatusBarColor()
	SetVirtualBorder(frame.hp, 0.05, 0.05, 0.05, 1)

	-- Set the name text
	if Qulight["nameplate"].name_abbrev == true and Qulight["nameplate"].track_auras ~= true then
		frame.hp.name:SetText(Abbrev(frame.hp.oldname:GetText()))
	else
		frame.hp.name:SetText(frame.hp.oldname:GetText())
	end

	-- Setup level text
	local level, elite, mylevel = tonumber(frame.hp.oldlevel:GetText()), frame.hp.elite:IsShown(), UnitLevel("player")
	frame.hp.level:ClearAllPoints()
	if Qulight["nameplate"].class_icons == true and frame.isClass == true then
		frame.hp.level:SetPoint("RIGHT", frame.hp.name, "LEFT", -2, 0)
	else
		frame.hp.level:SetPoint("RIGHT", frame.hp, "LEFT", -2, 0)
	end
	frame.hp.level:SetTextColor(frame.hp.oldlevel:GetTextColor())
	if frame.hp.boss:IsShown() then
		frame.hp.level:SetText("??")
		frame.hp.level:SetTextColor(0.8, 0.05, 0)
		frame.hp.level:Show()
	elseif not elite and level == mylevel then
		frame.hp.level:Hide()
	else
		frame.hp.level:SetText(level..(elite and "+" or ""))
		frame.hp.level:Show()
	end

	HideObjects(frame)
end

-- This is where we create most 'Static' objects for the nameplate
local function SkinObjects(frame, nameFrame)
	local oldhp, cb = frame:GetChildren()
	local threat, hpborder, overlay, oldlevel, bossicon, raidicon, elite = frame:GetRegions()
	local oldname = nameFrame:GetRegions()
	local _, cbborder, cbshield, cbicon, cbname = cb:GetRegions()

	-- Health Bar
	frame.healthOriginal = oldhp
	local hp = CreateFrame("Statusbar", nil, frame)
	hp:SetFrameLevel(oldhp:GetFrameLevel())
	hp:SetFrameStrata(oldhp:GetFrameStrata())
	hp:SetStatusBarTexture(Qulight.media.texture)
	CreateVirtualFrame(hp)

	-- Create Level
	hp.level = hp:CreateFontString(nil, "OVERLAY")
	hp.level:SetFont(Qulight["media"].font, 8, "THINOUTLINE")
	hp.level:SetShadowOffset(1, -1)
	hp.level:SetTextColor(1, 1, 1)
	hp.oldlevel = oldlevel
	hp.boss = bossicon
	hp.elite = elite

	-- Create Health Text
	if Qulight["nameplate"].health_value == true then
		hp.value = hp:CreateFontString(nil, "OVERLAY")
		hp.value:SetFont(Qulight["media"].font, 8, "THINOUTLINE")
		hp.value:SetShadowOffset(1, -1)
		hp.value:SetPoint("RIGHT", hp, "RIGHT", 0, 0)
		hp.value:SetTextColor(1, 1, 1)
	end

	-- Create Name Text
	hp.name = hp:CreateFontString(nil, "OVERLAY")
	hp.name:SetPoint("BOTTOMLEFT", hp, "TOPLEFT", -3, 4)
	hp.name:SetPoint("BOTTOMRIGHT", hp, "TOPRIGHT", 3, 4)
	hp.name:SetFont(Qulight["media"].font, 8, "THINOUTLINE")
	hp.name:SetShadowOffset(1, -1)
	hp.oldname = oldname

	hp.bg = hp:CreateTexture(nil, "BORDER")
	hp.bg:SetAllPoints(hp)
	hp.bg:SetTexture(1, 1, 1, 0.2)

	hp:HookScript("OnShow", UpdateObjects)
	frame.hp = hp

	if not frame.threat then
		frame.threat = threat
	end

	-- Create Cast Bar
	cb:SetStatusBarTexture(Qulight.media.texture)
	CreateVirtualFrame(cb)
	
	CreateStyle(cb, 4)
	
	cb.bg = cb:CreateTexture(nil, "BORDER")
	cb.bg:SetAllPoints(cb)
	cb.bg:SetTexture(0.75, 0.75, 0.25, 0.2)

	-- Create Cast Time Text
	cb.time = cb:CreateFontString(nil, "ARTWORK")
	cb.time:SetPoint("RIGHT", cb, "RIGHT", 3, 0)
	cb.time:SetFont(Qulight["media"].font, 8, "THINOUTLINE")
	cb.time:SetShadowOffset(1, -1)
	cb.time:SetTextColor(1, 1, 1)

	cbname:ClearAllPoints()
	cbname:SetPoint("LEFT", cb, "LEFT", 3, 0)
	cbname:SetFont(Qulight["media"].font, 8, "THINOUTLINE")


	-- Create Class Icon
	if Qulight["nameplate"].class_icons == true then
		local cIconTex = hp:CreateTexture(nil, "OVERLAY")
		cIconTex:SetPoint("TOPRIGHT", hp, "TOPLEFT", -5, 2)
		cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		cIconTex:SetSize(Qulight["nameplate"].height, Qulight["nameplate"].height)
		frame.class = cIconTex

		frame.class.Glow = CreateFrame("Frame", nil, frame)
		CreateStyle(frame.class.Glow, 2)
		frame.class.Glow:SetScale(noscalemult)
		frame.class.Glow:SetPoint("TOPLEFT", frame.class, "TOPLEFT", 0, 0)
		frame.class.Glow:SetPoint("BOTTOMRIGHT", frame.class, "BOTTOMRIGHT", 0, 0)
		frame.class.Glow:SetFrameLevel(hp:GetFrameLevel() -1 > 0 and hp:GetFrameLevel() -1 or 0)
		frame.class.Glow:Hide()
	end

	-- Create CastBar Icon
	cbicon:ClearAllPoints()
	cbicon:SetPoint("TOPLEFT", hp, "TOPRIGHT", 8, 0)
	cbicon:SetSize(Qulight["nameplate"].height, Qulight["nameplate"].height)
	cbicon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	cbicon:SetDrawLayer("OVERLAY")
	cb.icon = cbicon
	CreateVirtualFrame(cb, cb.icon)
		
	cb.shield = cbshield
	cb:HookScript("OnShow", UpdateCastbar)
	cb:HookScript("OnSizeChanged", OnSizeChanged)
	cb:HookScript("OnValueChanged", OnValueChanged)
	frame.cb = cb

	-- Aura tracking
	if Qulight["nameplate"].track_auras == true then
		if not frame.icons then
			frame.icons = CreateFrame("Frame", nil, frame.hp)
			frame.icons:SetPoint("BOTTOMRIGHT", frame.hp, "TOPRIGHT", 0, 15)
			frame.icons:SetWidth(20 + Qulight["nameplate"].width)
			frame.icons:SetHeight(Qulight["nameplate"].auras_size)
			frame.icons:SetFrameLevel(frame.hp:GetFrameLevel() + 2)
			frame:RegisterEvent("UNIT_AURA")
			frame:HookScript("OnEvent", OnAura)
		end
	end

	-- Highlight texture
	if not frame.overlay then
		overlay:SetTexture(1, 1, 1, 0.15)
		overlay:SetParent(frame.hp)
		overlay:SetAllPoints()
		frame.overlay = overlay
	end

	-- Raid icon
	if not frame.raidicon then
		raidicon:SetParent(frame.hp)
		raidicon:ClearAllPoints()
		raidicon:SetPoint("BOTTOM", hp, "TOP", 0, Qulight["nameplate"].track_auras == true and 38 or 16)
		raidicon:SetSize((Qulight["nameplate"].height * 2) + 8, (Qulight["nameplate"].height * 2) + 8)
		frame.raidicon = raidicon
	end

	-- Hide Old Stuff
	QueueObject(frame, oldhp)
	QueueObject(frame, oldlevel)
	QueueObject(frame, threat)
	QueueObject(frame, hpborder)
	QueueObject(frame, cbshield)
	QueueObject(frame, cbborder)
	QueueObject(frame, oldname)
	QueueObject(frame, bossicon)
	QueueObject(frame, elite)

	UpdateObjects(hp)
	UpdateCastbar(cb)

	frame:HookScript("OnHide", OnHide)
	frames[frame] = true
end

local function UpdateThreat(frame, elapsed)
	Colorize(frame)

	if frame.isClass or frame.isTapped then return end

	if Qulight["nameplate"].enhance_threat ~= true then
		if frame.threat:IsShown() then
			local _, val = frame.threat:GetVertexColor()
			if val > 0.7 then
				SetVirtualBorder(frame.hp, transitionR, transitionG, transitionB)
			else
				SetVirtualBorder(frame.hp, badR, badG, badB)
			end
		else
			SetVirtualBorder(frame.hp, 0.05, 0.05, 0.05, 1)
		end
	else
		if not frame.threat:IsShown() then
			if InCombatLockdown() and frame.isFriendly ~= true then
				-- No Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.bg:SetTexture(badR, badG, badB, 0.2)
				else
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.bg:SetTexture(goodR, goodG, goodB, 0.2)
				end
			-- else
				-- Set colors to their original, not in combat
				-- frame.hp:SetStatusBarColor(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor)
				-- frame.hp.bg:SetTexture(frame.hp.rcolor, frame.hp.gcolor, frame.hp.bcolor, 0.2)
			end
		else
			-- Ok we either have threat or we're losing/gaining it
			local r, g, b = frame.threat:GetVertexColor()
			if g + b == 0 then
				-- Have Threat
				if Role == "Tank" then
					frame.hp:SetStatusBarColor(goodR, goodG, goodB)
					frame.hp.bg:SetTexture(goodR, goodG, goodB, 0.2)
				else
					frame.hp:SetStatusBarColor(badR, badG, badB)
					frame.hp.bg:SetTexture(badR, badG, badB, 0.2)
				end
			else
				-- Losing/Gaining Threat
				frame.hp:SetStatusBarColor(transitionR, transitionG, transitionB)
				frame.hp.bg:SetTexture(transitionR, transitionG, transitionB, 0.2)
			end
		end
	end
end

-- Create our blacklist for nameplates
local function CheckBlacklist(frame, ...)
	if Qulight["nameplate"].name_abbrev == true then return end
	if PlateBlacklist[frame.hp.name:GetText()] then
		frame:SetScript("OnUpdate", function() end)
		frame.hp:Hide()
		frame.cb:Hide()
		frame.overlay:Hide()
		frame.hp.oldlevel:Hide()
	end
end

-- Force the name text of a nameplate to be behind other nameplates unless it is our target
local function AdjustNameLevel(frame, ...)
	if UnitName("target") == frame.hp.name:GetText() and frame:GetParent():GetAlpha() == 1 then
		frame.hp.name:SetDrawLayer("OVERLAY")
	else
		frame.hp.name:SetDrawLayer("BORDER")
	end
end

-- Health Text, also border coloring for certain plates depending on health
local function ShowHealth(frame, ...)
	-- Match values
	HealthBar_ValueChanged(frame.hp)

	-- Show current health value
	local _, maxHealth = frame.healthOriginal:GetMinMaxValues()
	local valueHealth = frame.healthOriginal:GetValue()
	local d = (valueHealth / maxHealth) * 100

	if Qulight["nameplate"].health_value == true then
		frame.hp.value:SetText(ShortValue(valueHealth).." - "..(string.format("%d%%", math.floor((valueHealth / maxHealth) * 100))))
	end

	-- Setup frame shadow to change depending on enemy players health, also setup targetted unit to have white shadow
	if frame.isClass == true or frame.isFriendly == true then
		if d <= 50 and d >= 20 then
			SetVirtualBorder(frame.hp, 1, 1, 0)
		elseif d < 20 then
			SetVirtualBorder(frame.hp, 1, 0, 0)
		else
			SetVirtualBorder(frame.hp, 0.05, 0.05, 0.05, 1)
		end
	elseif (frame.isClass ~= true and frame.isFriendly ~= true) and Qulight["nameplate"].enhance_threat == true then
		SetVirtualBorder(frame.hp, 0.05, 0.05, 0.05, 1)
	end

	if UnitName("target") and frame:GetParent():GetAlpha() == 1 then
		frame.hp:SetSize((Qulight["nameplate"].width + Qulight["nameplate"].ad_width) * noscalemult, (Qulight["nameplate"].height + Qulight["nameplate"].ad_height) * noscalemult)
		frame.cb:SetSize((Qulight["nameplate"].width + Qulight["nameplate"].ad_width) * noscalemult, (Qulight["nameplate"].height + Qulight["nameplate"].ad_height) * noscalemult)
		frame.cb.icon:SetSize(((Qulight["nameplate"].height + Qulight["nameplate"].ad_height) * 2) + 8, ((Qulight["nameplate"].height + Qulight["nameplate"].ad_height) * 2) + 8)
	else
		frame.hp:SetSize(Qulight["nameplate"].width * noscalemult, Qulight["nameplate"].height * noscalemult)
		frame.cb:SetSize(Qulight["nameplate"].width * noscalemult, Qulight["nameplate"].height * noscalemult)
		frame.cb.icon:SetSize((Qulight["nameplate"].height * 2) + 8, (Qulight["nameplate"].height * 2) + 8)
	end
end

-- Scan all visible nameplate for a known unit
local function CheckUnit_Guid(frame, ...)
	if UnitExists("target") and frame:GetParent():GetAlpha() == 1 and UnitName("target") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("target")
		frame.unit = "target"
		OnAura(frame, "target")
	elseif frame.overlay:IsShown() and UnitExists("mouseover") and UnitName("mouseover") == frame.hp.name:GetText() then
		frame.guid = UnitGUID("mouseover")
		frame.unit = "mouseover"
		OnAura(frame, "mouseover")
	else
		frame.unit = nil
	end
end

-- Attempt to match a nameplate with a GUID from the combat log
local function MatchGUID(frame, destGUID, spellID)
	if not frame.guid then return end

	if frame.guid == destGUID then
		for _, icon in ipairs(frame.icons) do
			if icon.spellID == spellID then
				icon:Hide()
			end
		end
	end
end

-- Run a function for all visible nameplates, we use this for the blacklist, to check unitguid, and to hide drunken text
local function ForEachPlate(functionToRun, ...)
	for frame in pairs(frames) do
		if frame and frame:GetParent():IsShown() then
			functionToRun(frame, ...)
		end
	end
end

-- Check if the frames default overlay texture matches blizzards nameplates default overlay texture
local function HookFrames(...)
	for index = 1, select("#", ...) do
		local frame = select(index, ...)

		if frame:GetName() and not frame.isSkinned and frame:GetName():find("NamePlate%d") then
			local child1, child2 = frame:GetChildren()
			SkinObjects(child1, child2)
			frame.isSkinned = true
		end
	end
end

-- Core right here, scan for any possible nameplate frames that are Children of the WorldFrame
NamePlates:SetScript("OnUpdate", function(self, elapsed)
	if WorldFrame:GetNumChildren() ~= numChildren then
		numChildren = WorldFrame:GetNumChildren()
		HookFrames(WorldFrame:GetChildren())
	end

	if self.elapsed and self.elapsed > 0.2 then
		ForEachPlate(UpdateThreat, self.elapsed)
		ForEachPlate(AdjustNameLevel)
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end

	ForEachPlate(ShowHealth)
	ForEachPlate(CheckBlacklist)
	ForEachPlate(CheckUnit_Guid)
end)

function NamePlates:COMBAT_LOG_EVENT_UNFILTERED(_, event, ...)
	if event == "SPELL_AURA_REMOVED" then
		local _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = ...

		if sourceGUID == UnitGUID("player") or arg4 == UnitGUID("pet") then
			ForEachPlate(MatchGUID, destGUID, spellID)
		end
	end
end

-- Only show nameplates when in combat
if Qulight["nameplate"].combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")

	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if Qulight["nameplate"].combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	if Qulight["nameplate"].enhance_threat == true then
		SetCVar("threatWarning", 3)
	end
end