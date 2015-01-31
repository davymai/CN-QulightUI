if not Qulight["misk"].raidcooldowns then return end

----------------------------------------------------------------------------------------
--	Raid cooldowns(alRaidCD by Allez)
----------------------------------------------------------------------------------------
local show = {
	raid = true,
	party = true,
	arena = true,
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local timer = 0
local bars = {}

AnchorRaidCD = CreateFrame("Frame","Move_RaidCD",UIParent)
AnchorRaidCD:SetPoint("TOPLEFT", 40, -400)
CreateAnchor(AnchorRaidCD, "Move RaidCD", 186 + 32, 192)

local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", UIParent)
RaidCDAnchor:SetPoint("BOTTOM", AnchorRaidCD)
RaidCDAnchor:SetSize(186 + 32, 20)

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont(Qulight["media"].font, 10, "OUTLINE")
	fstring:SetShadowOffset(1 and 1 or 0, 1 and -1 or 0)
	return fstring
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("BOTTOMRIGHT", RaidCDAnchor, "BOTTOMRIGHT", -2, 2)
		else
			bars[i]:SetPoint("BOTTOMLEFT", bars[i-1], "TOPLEFT", 0, 13)
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	tremove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:AddDoubleLine(self.spell, self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		if GetRealNumRaidMembers() > 0 then
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "RAID")
		elseif GetRealNumPartyMembers() > 0 and not UnitInRaid("player") then
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "PARTY")
		else
			SendChatMessage(sformat("CD: ".." %s: %s", self.left:GetText(), self.right:GetText()), "SAY")
		end
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("HIGH")
	bar:SetSize(186 + 28, 20)
	
	bar:SetStatusBarTexture(Qulight["media"].texture)
	bar:SetMinMaxValues(0, 100)

	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(bar.backdrop, 2)
	bar.backdrop:SetFrameStrata("BACKGROUND")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(Qulight["media"].texture)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(186 - 30, 20)

	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", 1, 0)
	bar.right:SetJustifyH("RIGHT")

	bar.icon = CreateFrame("Button", nil, bar)
	bar.icon:SetWidth(bar:GetHeight())
	bar.icon:SetHeight(bar.icon:GetWidth())
	bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)

	bar.icon.backdrop = CreateFrame("Frame", nil, bar.icon)
	bar.icon.backdrop:SetPoint("TOPLEFT", -2, 2)
	bar.icon.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(bar.icon.backdrop, 2)
	bar.icon.backdrop:SetFrameStrata("BACKGROUND")
	
	return bar
end
raid_spells = {
		[20484] = 600,	-- Rebirth
		[113269] = 600,	-- Rebirth (Symbiosis)
		[61999] = 600,	-- Raise Ally
		[20707] = 600,	-- Soulstone
		[126393] = 600,	-- Eternal Guardian
		[64901] = 360,	-- Hymn of Hope
		[29166] = 180,	-- Innervate
		[16190] = 180,	-- Mana Tide Totem
		[108280] = 180,	-- Healing Tide Totem
}
local StartTimer = function(name, spellId)
	local bar = CreateBar()
	local spell, rank, icon = GetSpellInfo(spellId)
	bar.endTime = GetTime() + raid_spells[spellId]
	bar.startTime = GetTime()
	bar.left:SetText(name.." - "..spell)
	bar.right:SetText(FormatTime(raid_spells[spellId]))
	bar.icon:SetNormalTexture(icon)
	bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	
	bar.spell = spell
	bar:Show()
	local color = RAID_CLASS_COLORS[select(2, UnitClass(name))]
	if color then
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar.bg:SetVertexColor(color.r, color.g, color.b, 0.25)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
		bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.25)
	end
	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	tinsert(bars, bar)
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, _, sourceName, sourceFlags = ...

		if band(sourceFlags, filter) == 0 then return end
		local spellId = select(12, ...)

		if raid_spells[spellId] and show[select(2, IsInInstance())] then
			if eventType == "SPELL_RESURRECT" and not spellId == 61999 then
				if spellId == 95750 then spellId = 6203 end
				StartTimer(sourceName, spellId)
			elseif eventType == "SPELL_AURA_APPLIED" then
				if spellId == 20707 then
					local _, class = UnitClass(sourceName)
					if class == "WARLOCK" then
						StartTimer(sourceName, spellId)
					end
				end
			elseif eventType == "SPELL_CAST_SUCCESS" then
				StartTimer(sourceName, spellId)
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" then
		for k, v in pairs(bars) do
			StopTimer(v)
		end
	end
end

local addon = CreateFrame("Frame")
addon:SetScript("OnEvent", OnEvent)
addon:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")

SlashCmdList.RaidCD = function(msg)
	StartTimer(UnitName("player"), 20484)	-- Rebirth
	StartTimer(UnitName("player"), 20707)	-- Soulstone
	StartTimer(UnitName("player"), 6346)	-- Fear Ward
	StartTimer(UnitName("player"), 29166)	-- Innervate
	StartTimer(UnitName("player"), 32182)	-- Heroism
	StartTimer(UnitName("player"), 2825)	-- Bloodlust
end
SLASH_RaidCD1 = "/raidcd"
SLASH_RaidCD2 = "/êôøâñâ"