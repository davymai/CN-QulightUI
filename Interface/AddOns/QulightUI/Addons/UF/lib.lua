local addon, ns = ...
local cast = ns.cast
local _, playerClass = UnitClass("player")
local cast = CreateFrame("Frame")
local oUF = ns.oUF or oUF
oUF.colors.runes = {{0.87, 0.12, 0.23};{0.40, 0.95, 0.20};{0.14, 0.50, 1};{.70, .21, 0.94};}
--------------------------------------------------------------------------------------
highlight_texture = "Interface\\AddOns\\QulightUI\\Root\\Media\\raidbg"
fontsymbol = "Interface\\AddOns\\QulightUI\\Root\\Media\\symbol.ttf"
--------------------------------------------------------------------------------------
local fixStatusbar = function(bar)
    bar:GetStatusBarTexture():SetHorizTile(false)
    bar:GetStatusBarTexture():SetVertTile(false)
end
local retVal = function(f, val1, val2, val3, val4)
	if f.mystyle == "player" or f.mystyle == "target" then
		return val1
	elseif f.mystyle == "focus" then
		return val3
	elseif f.mystyle == "oUF_MT" then
		return val4
	else
		return val2
	end
end
menu = function(self)
    local unit = self.unit:sub(1, -2)
    local cunit = self.unit:gsub("(.)", string.upper, 1)
    if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
    elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
    end
end
init = function(f)
    f.menu = menu
    f:RegisterForClicks("AnyDown")
	f:SetAttribute("*type1", "target")
    f:SetAttribute("*type2", "menu")
    f:SetScript("OnEnter", UnitFrame_OnEnter)
    f:SetScript("OnLeave", UnitFrame_OnLeave)
end
UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b)
end
gen_fontstring = function(f, name, size, outline)
    local fs = f:CreateFontString(nil, "OVERLAY")
    fs:SetFont(name, size, "OUTLINE")
    return fs
end
PortraitUpdate = function(self, unit)

	self:SetAlpha(0) self:SetAlpha(0.3)
	if self:GetModel() and self:GetModel().find and self:GetModel():find("worgenmale") then
		self:SetCamera(1)
	end
end
HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end
local channelingTicks = {
	-- warlock
	[GetSpellInfo(689)] = 5, -- drain life
	[GetSpellInfo(5740)] = 4, -- rain of fire
	-- druid
	[GetSpellInfo(740)] = 4, -- Tranquility
	[GetSpellInfo(16914)] = 10, -- Hurricane
	-- priest
	[GetSpellInfo(15407)] = 3, -- mind flay
	[GetSpellInfo(48045)] = 5, -- mind sear
	[GetSpellInfo(47540)] = 2, -- penance
	-- mage
	[GetSpellInfo(5143)] = 5, -- arcane missiles
	[GetSpellInfo(10)] = 5, -- blizzard
	[GetSpellInfo(12051)] = 4, -- evocation
}
local ticks = {}
cast.setBarTicks = function(castBar, ticknum)
	if ticknum and ticknum > 0 then
		local delta = castBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = castBar:CreateTexture(nil, 'OVERLAY')
				ticks[k]:SetTexture(Qulight["media"].texture)
				ticks[k]:SetVertexColor(0, 0, 0)
				ticks[k]:SetWidth(1)
				ticks[k]:SetHeight(castBar:GetHeight())
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", castBar, "LEFT", delta * k, 0 )
			ticks[k]:Show()
		end
	else
		for k, v in pairs(ticks) do
			v:Hide()
		end
	end
end
cast.OnCastbarUpdate = function(self, elapsed)
	local currentTime = GetTime()
	if self.casting or self.channeling then
		local parent = self:GetParent()
		local duration = self.casting and self.duration + elapsed or self.duration - elapsed
		if (self.casting and duration >= self.max) or (self.channeling and duration <= 0) then
			self.casting = nil
			self.channeling = nil
			return
		end
		if parent.unit == 'player' and parent.unit == 'party' then
			if self.delay ~= 0 then
				self.Time:SetFormattedText('%.1f | |cffff0000%.1f|r', duration, self.casting and self.max + self.delay or self.max - self.delay)
			else
				self.Time:SetFormattedText('%.1f | %.1f', duration, self.max)
				self.Lag:SetFormattedText("%d ms", self.SafeZone.timeDiff * 1000)
			end
		else
			self.Time:SetFormattedText('%.1f | %.1f', duration, self.casting and self.max + self.delay or self.max - self.delay)
		end
		self.duration = duration
		self:SetValue(duration)
		self.Spark:SetPoint('CENTER', self, 'LEFT', (duration / self.max) * self:GetWidth(), 0)
	else
		self.Spark:Hide()
		local alpha = self:GetAlpha() - 0.02
		if alpha > 0 then
			self:SetAlpha(alpha)
		else
			self.fadeOut = nil
			self:Hide()
		end
	end
end
cast.OnCastSent = function(self, event, unit, spell, rank)
	if self.unit ~= unit or not self.Castbar.SafeZone then return end
	self.Castbar.SafeZone.sendTime = GetTime()
end
cast.PostCastStart = function(self, unit, name, rank, text)
	local pcolor = {255/255, 128/255, 128/255}
	local interruptcb = {95/255, 182/255, 255/255}
	self:SetAlpha(1.0)
	self.Spark:Show()
	self:SetStatusBarColor(unpack(self.casting and self.CastingColor or self.ChannelingColor))
	if unit == "player" then
		local sf = self.SafeZone
		sf.timeDiff = GetTime() - sf.sendTime
		sf.timeDiff = sf.timeDiff > self.max and self.max or sf.timeDiff
		sf:SetWidth(self:GetWidth() * sf.timeDiff / self.max)
		sf:Show()
		if self.casting then
			cast.setBarTicks(self, 0)
		else
			local spell = UnitChannelInfo(unit)
			self.channelingTicks = channelingTicks[spell] or 0
			cast.setBarTicks(self, self.channelingTicks)
		end
	elseif (unit == "target" or unit == "focus") and not self.interrupt then
		self:SetStatusBarColor(interruptcb[1],interruptcb[2],interruptcb[3],1)
	else
		self:SetStatusBarColor(pcolor[1], pcolor[2], pcolor[3],1)
	end
end
cast.PostCastStop = function(self, unit, name, rank, castid)
	if not unit == "party" then
	if not self.fadeOut then
		self:SetStatusBarColor(unpack(self.CompleteColor))
		self.fadeOut = true
	end
	self:SetValue(self.max)
	self:Show()
	end
end
cast.PostChannelStop = function(self, unit, name, rank)
	self.fadeOut = true
	self:SetValue(0)
	self:Show()
end
cast.PostCastFailed = function(self, event, unit, name, rank, castid)
	self:SetStatusBarColor(unpack(self.FailColor))
	self:SetValue(self.max)
	if not self.fadeOut then
		self.fadeOut = true
	end
	self:Show()
end

	UpdateShadowOrb = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= "SHADOW_ORBS") then return end
	local num = UnitPower(unit, SPELL_POWER_SHADOW_ORBS)
	local numMax = UnitPowerMax("player", SPELL_POWER_SHADOW_ORBS)
	local barWidth = self.ShadowOrbsBar:GetWidth()
	local spacing = select(4, self.ShadowOrbsBar[4]:GetPoint())
	local lastBar = 0

	if numMax ~= self.ShadowOrbsBar.maxPower then
		if numMax == 3 then
			self.ShadowOrbsBar[4]:Hide()
			self.ShadowOrbsBar[5]:Hide()
			for i = 1, 3 do
				if i ~= 3 then
					self.ShadowOrbsBar[i]:SetWidth(barWidth / 3)
					lastBar = lastBar + (barWidth / 3 + spacing)
				else
					self.ShadowOrbsBar[i]:SetWidth(barWidth - lastBar)
				end
			end
		else
			self.ShadowOrbsBar[4]:Show()
			self.ShadowOrbsBar[5]:Show()
			for i = 1, 5 do
				self.ShadowOrbsBar[i]:SetWidth(self.ShadowOrbsBar[i].width)
			end
		end
		self.ShadowOrbsBar.maxPower = numMax
	end

	for i = 1, 5 do
		if i <= num then
			self.ShadowOrbsBar[i]:SetAlpha(1)
		else
			self.ShadowOrbsBar[i]:SetAlpha(0.2)
		end
	end
end

do
	UpdateHoly = function(self, event, unit, powerType)
	if self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER") then return end
	local num = UnitPower(unit, SPELL_POWER_HOLY_POWER)
	local numMax = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)
	local barWidth = self.HolyPower:GetWidth()
	local spacing = select(4, self.HolyPower[4]:GetPoint())
	local lastBar = 0

	if numMax ~= self.HolyPower.maxPower then
		if numMax == 3 then
			self.HolyPower[4]:Hide()
			self.HolyPower[5]:Hide()
			for i = 1, 3 do
				if i ~= 3 then
					self.HolyPower[i]:SetWidth(barWidth / 3)
					lastBar = lastBar + (barWidth / 3 + spacing)
				else
					self.HolyPower[i]:SetWidth(barWidth - lastBar)
				end
			end
	else
			self.HolyPower[4]:Show()
			self.HolyPower[5]:Show()
			for i = 1, 5 do
				self.HolyPower[i]:SetWidth((self.HolyPower:GetWidth() -4 )/5)
			end
		end
		self.HolyPower.maxPower = numMax
	end

		for i = 1, 5 do
			if i <= num then
				self.HolyPower[i]:SetAlpha(1)
			else
				self.HolyPower[i]:SetAlpha(0.2)
			end
		end
	end

	ComboDisplay = function(self, event, unit)
		if(unit == 'pet') then return end

		local cpoints = self.CPoints
		local cp
		if (UnitHasVehicleUI("player") or UnitHasVehicleUI("vehicle")) then
			cp = GetComboPoints('vehicle', 'target')
		else
			cp = GetComboPoints('player', 'target')
		end

		for i=1, MAX_COMBO_POINTS do
			if(i <= cp) then
				cpoints[i]:SetAlpha(1)
			else
				cpoints[i]:SetAlpha(0.15)
			end
		end

		if cpoints[1]:GetAlpha() == 1 then
			for i=1, MAX_COMBO_POINTS do
				cpoints[i]:Show()
			end

		else
			for i=1, MAX_COMBO_POINTS do
				cpoints[i]:Hide()
			end

		end
	end
end
function AltPowerBarOnToggle(self)
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
end
function AltPowerBarPostUpdate(self, min, cur, max)
	local perc = math.floor((cur/max)*100)
	if perc < 35 then
		self:SetStatusBarColor(0, 1, 0)
	elseif perc < 70 then
		self:SetStatusBarColor(1, 1, 0)
	else
		self:SetStatusBarColor(1, 0, 0)
	end
	local unit = self:GetParent().unit or self:GetParent():GetParent().unit
	local type = select(10, UnitAlternatePowerInfo(unit))
end
gen_hpbar = function(f)
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(Qulight["media"].texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	s.Smooth = true
	fixStatusbar(s)
	s:SetHeight(retVal(f,42,28,34,22))
	if not Qulight["unitframes"].HealthcolorClass then
	s:SetStatusBarColor(.09,.09,.09,1) -- HealthBar Transparensy
	end
    s:SetWidth(f:GetWidth())
    s:SetPoint("TOP",0,0)
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
	if f.mystyle == "target" or f.mystyle == "player" then
		h:SetPoint("BOTTOMRIGHT",5,-5)
	elseif f.mystyle == "raid" then
		h:SetPoint("BOTTOMRIGHT",5,-5)
	else
		h:SetPoint("BOTTOMRIGHT",5,-5)
	end
	CreateStyle(h, -1)
    local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(Qulight["media"].texture)
	b:SetVertexColor(.5,.5,.5,.9)
    b:SetAllPoints(s)
	f.Health = s
end
gen_hpstrings = function(f)
	-- Change Font and Coord name on unitframe
    local name = gen_fontstring(f.Health, Qulight["media"].font, 10, retVal(f,17,12,12,15), "OUTLINE")
    name:SetPoint("LEFT", f.Health, "TOPLEFT", retVal(f,2,1,1,1), retVal(f,-19,-11,-15,-10))
    name:SetJustifyH("LEFT")
	-- Change Font and Coord health on unitframe
    local hpval = gen_fontstring(f.Health, Qulight["media"].font, 9, retVal(f,17,12,10,12), "OUTLINE")
    hpval:SetPoint("RIGHT", f.Health, "TOPRIGHT", retVal(f,0,-3,-1,-3), retVal(f,-7,-11,-15,-9))
    hpval.frequentUpdates = 0.1

	if f.mystyle == "player" then
		f:Tag(name, "[color][namelong][afk]")
	elseif f.mystyle == "target" then
		f:Tag(name, "[color][namelong][afk]")
	elseif f.mystyle == "focus" then
		f:Tag(name, "[color][namelong][afk]")
	else
		f:Tag(name, "[color][nameshort]")
	end
	f:Tag(hpval, retVal(f,"[hp][color]","","[hp][color]","[hp][color]"))

	local per = f.Health:CreateFontString(nil, "OVERLAY")
	per:SetPoint("RIGHT", 0, retVal(f, 4, 4, -3, -3))
	per:SetFont(Qulight["media"].font, 9, "OUTLINE")
	f:Tag(per, retVal(f,'[color][power] | [perpp]%','[hp]','','' ))
end
gen_ppbar = function(f)
    local s = CreateFrame("StatusBar", nil, f)
    s:SetStatusBarTexture(Qulight["media"].texture)
	s:GetStatusBarTexture():SetHorizTile(true)
	fixStatusbar(s)
	s.Smooth = true
	s:SetHeight(retVal(f,4,4,4,4))
	s:SetFrameLevel(4)
    s:SetPoint("BOTTOM",UIParent,"BOTTOM",0,1)

	if f.mystyle == "player" then
		s:SetPoint("BOTTOM",f,"BOTTOM", 0, 0)
		s:SetWidth(212)
	end
	if f.mystyle == "target" then
		s:SetPoint("BOTTOM",f,"BOTTOM", 0, 0)
		s:SetWidth(212)
	end
	if f.mystyle == "focus" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(172)
	end
	if f.mystyle == "oUF_MT" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(92)
	end
	if f.mystyle == "boss" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(142)
	end
	if f.mystyle == "oUF_Arena" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(142)
	end
	if f.mystyle == "pet" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(92)
	end
	if f.mystyle == "tot" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(92)
	end
	if f.mystyle == "focustarget" then
		s:SetPoint("BOTTOM",f,"BOTTOM",0,4)
		s:SetWidth(92)
	end

	local h = CreateFrame("Frame", nil, s)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	h:SetFrameLevel(3)
	CreateStyle(h, -1, 4, .9, 0.6)

	local b = s:CreateTexture(nil, "BACKGROUND")
    b:SetTexture(Qulight["media"].texture)
    b:SetAllPoints(s)
    f.Power = s
    f.Power.bg = b
end

gen_focusbar = function(f)
  --[[  local s1 = CreateFrame("StatusBar", nil, f)
    s1:SetStatusBarTexture(Qulight["media"].texture)
	s1:GetStatusBarTexture():SetHorizTile(true)
	fixStatusbar(s1)
	s1.Smooth = true
	s1:SetHeight(4)
	s1:SetFrameLevel(4)
    s1:SetPoint("BOTTOM", UIParent,"BOTTOM",0,1)
	local h = CreateFrame("Frame", nil, s1)
	s1:SetPoint("BOTTOM",UIParent,"BOTTOM", 0, 330)
	h:SetFrameLevel(3)
	s1:SetWidth(212)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateShadow00(h)

    local b1 = s1:CreateTexture(nil, "BACKGROUND")
    b1:SetTexture(Qulight["media"].texture)
    b1:SetAllPoints(s1)
    f.Power = s1
    f.Power.bg = b1 --]]
end
gen_portrait = function(f)
	local portrait = CreateFrame("PlayerModel", nil, f)
	portrait.PostUpdate = function(f) f:SetAlpha(0) f:SetAlpha(1) end
	portrait:SetAllPoints(f.Health)
	table.insert(f.__elements, HidePortrait)
	portrait.PostUpdate = PortraitUpdate
	f.Portrait = portrait

	local overlay = CreateFrame("Frame", nil, f)
	overlay:SetFrameLevel(2)

	bg = f.Health:CreateTexture(nil, 'BORDER')
	bg:SetAllPoints()
	bg:SetTexture(Qulight["media"].texture)
	bg:SetVertexColor(.4,.4,.4,1)
	bg:ClearAllPoints()
	bg:SetPoint('BOTTOMLEFT', f.Health:GetStatusBarTexture(), 'BOTTOMRIGHT')
	bg:SetPoint('TOPRIGHT', f.Health)
	bg:SetDrawLayer("OVERLAY")
	bg:SetParent(overlay)
end
gen_InfoIcons = function(f)
    local h = CreateFrame("Frame",nil,f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    if f.mystyle == 'player' then
      f.Combat = h:CreateTexture(nil, 'OVERLAY')
      f.Combat:SetSize(12,12)
      f.Combat:SetPoint('BOTTOMRIGHT', -4, 5)
      f.Combat:SetTexture('Interface\\CharacterFrame\\UI-StateIcon')
      f.Combat:SetTexCoord(0.58, 0.90, 0.08, 0.41)
    end

    li = h:CreateTexture(nil, "OVERLAY")
    li:SetPoint("TOPLEFT", f, 0, 8)
    li:SetSize(10,10)
    f.Leader = li
    ai = h:CreateTexture(nil, "OVERLAY")
    ai:SetPoint("TOPLEFT", f, 0, 8)
    ai:SetSize(10,10)
    f.Assistant = ai
    local ml = h:CreateTexture(nil, 'OVERLAY')
    ml:SetSize(8,8)
    ml:SetPoint('LEFT', f.Leader, 'RIGHT')
    f.MasterLooter = ml
end
addPhaseIcon = function(self)
	local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	picon:SetPoint('TOPRIGHT', self, 'TOPRIGHT', 40, 8)
	picon:SetSize(12, 12)
	self.PhaseIcon = picon
end
addQuestIcon = function(self)
	local qicon = self.Health:CreateTexture(nil, 'OVERLAY')
	qicon:SetPoint('TOPLEFT', self, 'TOPLEFT', 0, 8)
	qicon:SetSize(12, 12)
	self.QuestIcon = qicon
end
gen_RaidMark = function(f)
    local h = CreateFrame("Frame", nil, f)
    h:SetAllPoints(f)
    h:SetFrameLevel(10)
    h:SetAlpha(0.8)
    local ri = h:CreateTexture(nil,'OVERLAY',h)
    ri:SetPoint("CENTER", f, "TOP", 0, 2)
	local size = retVal(f, 12, 11, 9, 11)
	ri:SetTexture("Interface\\AddOns\\QulightUI\\Root\\Media\\raidicons")
    ri:SetSize(size, size)
    f.RaidIcon = ri
end
gen_highlight = function(f)
    local OnEnter = function(f)
		UnitFrame_OnEnter(f)
		f.Highlight:Show()
    end
    local OnLeave = function(f)
      UnitFrame_OnLeave(f)
      f.Highlight:Hide()
    end
    f:SetScript("OnEnter", OnEnter)
    f:SetScript("OnLeave", OnLeave)
    local hl = f.Health:CreateTexture(nil, "OVERLAY")
    hl:SetAllPoints(f.Health)
    hl:SetTexture(highlight_texture)
    hl:SetVertexColor(.5,.5,.5,.1)
    hl:SetBlendMode("ADD")
    hl:Hide()
    f.Highlight = hl
end
function CreateTargetBorder(self)
	local glowBorder = {edgeFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeSize = 1}
	self.TargetBorder = CreateFrame("Frame", nil, self)
	self.TargetBorder:SetPoint("TOPLEFT", self, "TOPLEFT", -1, 1)
	self.TargetBorder:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 1, -1)
	self.TargetBorder:SetBackdrop(glowBorder)
	self.TargetBorder:SetFrameLevel(2)
	self.TargetBorder:SetBackdropBorderColor(.7,.7,.7,1)
	self.TargetBorder:Hide()
end
function ChangedTarget(self, event, unit)
	if UnitIsUnit('target', self.unit) then
		self.TargetBorder:Show()
	else
		self.TargetBorder:Hide()
	end
end
gen_castbar = function(f)
	if not Qulight["unitframes"].Castbars then return end
	local cbColor = {.15,.15,.15}
    local s = CreateFrame("StatusBar", "oUF_Castbar"..f.mystyle, f)
    s:SetHeight(13)
    s:SetWidth(f:GetWidth()-22)
	if f.mystyle == "focus" then
		s:SetWidth(158)
	end
    if f.mystyle == "player" then
		s:SetHeight(15)
		s:SetWidth(200)
		s:SetPoint("TOP", f, "TOP", 10,20)
    elseif f.mystyle == "target" then
	    s:SetHeight(15)
		s:SetWidth(200)
		s:SetPoint("TOP", f, "TOP", -10,20)
	elseif f.mystyle == "focus" then
		s:SetWidth(f:GetWidth()-18)
        s:SetPoint("BOTTOM", Anchorfocuscastbar)
    end
	if f.mystyle == "boss"  then
	    s:SetHeight(10)
        s:SetWidth(135)
	    s:SetPoint("TOPRIGHT",f,"BOTTOMRIGHT",0,-6)
	end

    s:SetStatusBarTexture(Qulight["media"].texture)
    s:SetStatusBarColor(.15,.15,.15,1)
	s.colorClass = true
    s:SetFrameLevel(1)
    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)
    local txt = gen_fontstring(s, Qulight["media"].font, 10, "NONE")
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    local t = gen_fontstring(s, Qulight["media"].font, 10, "NONE")
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    local i = s:CreateTexture(nil, "ARTWORK")
	i:SetSize(s:GetHeight(),s:GetHeight())

	if f.mystyle == "player" then
	i:SetPoint("RIGHT", s, "LEFT", -5, 0)
	elseif f.mystyle == "target" then
    i:SetPoint("LEFT", s, "RIGHT", 5, 0)
	else
	i:SetPoint("RIGHT", s, "LEFT", -5, 0)
	end

    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
	CreateStyle(h2, -1)
    if f.mystyle == "player" then
        local z = s:CreateTexture(nil,"OVERLAY")
        z:SetTexture(Qulight["media"].texture)
        z:SetVertexColor(1,0.1,0,.6)
        z:SetPoint("TOPRIGHT")
        z:SetPoint("BOTTOMRIGHT")
	    s:SetFrameLevel(10)
        s.SafeZone = z
        local l = gen_fontstring(s, Qulight["media"].font, 10, "OUTLINE")
        l:SetPoint("CENTER", -2, 17)
        l:SetJustifyH("RIGHT")
	    l:Hide()
        s.Lag = l
        f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
    end
    s.OnUpdate = cast.OnCastbarUpdate
    s.PostCastStart = cast.PostCastStart
    s.PostChannelStart = cast.PostCastStart
    s.PostCastStop = cast.PostCastStop
    s.PostChannelStop = cast.PostChannelStop
    s.PostCastFailed = cast.PostCastFailed
    s.PostCastInterrupted = cast.PostCastFailed

    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end

gen_bigcastbar = function(f)
	if not Qulight["unitframes"].Castbars then return end
	local cbColor = {.15,.15,.15}
    local s = CreateFrame("StatusBar", "oUF_Castbar"..f.mystyle, f)
    s:SetHeight(13)
    s:SetWidth(f:GetWidth()-22)
	if f.mystyle == "focus" then
		s:SetWidth(158)
	end
    if f.mystyle == "player" then
		s:SetHeight(Qulight["unitframes"].heightbigcastbar)
		s:SetWidth(Qulight["unitframes"].widthbigcastbar)
		s:SetPoint("BOTTOM", Anchorplayercastbar, 14, 0)
    elseif f.mystyle == "target" then
	    s:SetHeight(18)
		s:SetWidth(f:GetWidth()-23)
	    s:SetPoint("BOTTOM", Anchortargetcastbar, 12, 0)
	elseif f.mystyle == "focus" then
		s:SetWidth(f:GetWidth()-18)
        s:SetPoint("BOTTOM", Anchorfocuscastbar)
    end
	if f.mystyle == "boss"  then
	    s:SetHeight(10)
        s:SetWidth(135)
	    s:SetPoint("TOPRIGHT",f,"BOTTOMRIGHT",0,-6)
	end

    s:SetStatusBarTexture(Qulight["media"].texture)
    s:SetStatusBarColor(.15,.15,.15,1)
    s:SetFrameLevel(1)
    s.CastingColor = cbColor
    s.CompleteColor = {20/255, 208/255, 0/255}
    s.FailColor = {255/255, 12/255, 0/255}
    s.ChannelingColor = cbColor
    local h = CreateFrame("Frame", nil, s)
    h:SetFrameLevel(0)
    h:SetPoint("TOPLEFT",-5,5)
    h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)
    sp = s:CreateTexture(nil, "OVERLAY")
    sp:SetBlendMode("ADD")
    sp:SetAlpha(0.5)
    sp:SetHeight(s:GetHeight()*2.5)
    local txt = gen_fontstring(s, Qulight["media"].font, 10, "NONE")
    txt:SetPoint("LEFT", 2, 0)
    txt:SetJustifyH("LEFT")
    local t = gen_fontstring(s, Qulight["media"].font, 10, "NONE")
    t:SetPoint("RIGHT", -2, 0)
    txt:SetPoint("RIGHT", t, "LEFT", -5, 0)
    local i = s:CreateTexture(nil, "ARTWORK")
    i:SetSize(s:GetHeight(),s:GetHeight())
	if f.mystyle == "target" then
		i:SetSize(s:GetHeight(),s:GetHeight())
	end

    i:SetPoint("RIGHT", s, "LEFT", -5, 0)
    i:SetTexCoord(0.1, 0.9, 0.1, 0.9)
    local h2 = CreateFrame("Frame", nil, s)
    h2:SetFrameLevel(0)
    h2:SetPoint("TOPLEFT",i,"TOPLEFT",-5,5)
    h2:SetPoint("BOTTOMRIGHT",i,"BOTTOMRIGHT",5,-5)
	CreateStyle(h2, -1)
    if f.mystyle == "player" then
        local z = s:CreateTexture(nil,"OVERLAY")
        z:SetTexture(Qulight["media"].texture)
        z:SetVertexColor(1,0.1,0,.6)
        z:SetPoint("TOPRIGHT")
        z:SetPoint("BOTTOMRIGHT")
	    s:SetFrameLevel(10)
        s.SafeZone = z
        local l = gen_fontstring(s, Qulight["media"].font, 10, "OUTLINE")
        l:SetPoint("CENTER", -2, 17)
        l:SetJustifyH("RIGHT")
	    l:Hide()
        s.Lag = l
        f:RegisterEvent("UNIT_SPELLCAST_SENT", cast.OnCastSent)
    end
    s.OnUpdate = cast.OnCastbarUpdate
    s.PostCastStart = cast.PostCastStart
    s.PostChannelStart = cast.PostCastStart
    s.PostCastStop = cast.PostCastStop
    s.PostChannelStop = cast.PostChannelStop
    s.PostCastFailed = cast.PostCastFailed
    s.PostCastInterrupted = cast.PostCastFailed

    f.Castbar = s
    f.Castbar.Text = txt
    f.Castbar.Time = t
    f.Castbar.Icon = i
    f.Castbar.Spark = sp
end
local formatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100))/100
end
local setTimer = function (self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = formatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end
local postCreateIcon = function(element, button)
	local diffPos = 0
	local self = element:GetParent()
	if self.mystyle == "target" then diffPos = 1 end

	element.disableCooldown = true
	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	local h = CreateFrame("Frame", nil, button)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)

	if self.mystyle == "player" then
		local time = gen_fontstring(button, Qulight["media"].pxfont, 10, "OUTLINE")
		time:SetPoint("BOTTOM", button, "BOTTOM", 2, -4)
		time:SetJustifyH("CENTER")
		time:SetVertexColor(1,1,1)
		button.time = time
	else
		local time = gen_fontstring(button, Qulight["media"].pxfont, 10, "OUTLINE")
		time:SetPoint("BOTTOM", button, "BOTTOM", 2, -4)
		time:SetJustifyH("CENTER")
		time:SetVertexColor(1,1,1)
		button.time = time
	end

	local count = gen_fontstring(button, Qulight["media"].pxfont, 10, "OUTLINE")
	count:SetPoint("CENTER", button, "TOPRIGHT", 0, 0)
	count:SetJustifyH("RIGHT")
	button.count = count

	button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
	button.icon:SetDrawLayer("ARTWORK")
end
local postUpdateIcon = function(element, unit, button, index)
	local _, _, _, _, _, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, button.filter)

	if duration and duration > 0 then
		button.time:Show()
		button.timeLeft = expirationTime
		button:SetScript("OnUpdate", setTimer)
	else
		button.time:Hide()
		button.timeLeft = math.huge
		button:SetScript("OnUpdate", nil)
	end

	if(button.debuff) then
		if(unit == "target") then
			if (unitCaster == "player" or unitCaster == "vehicle") then
				button.icon:SetDesaturated(false)
			elseif(not UnitPlayerControlled(unit)) then -- If Unit is Player Controlled don"t desaturate debuffs
				button:SetBackdropColor(0, 0, 0)
				button.overlay:SetVertexColor(0.3, 0.3, 0.3)
				button.icon:SetDesaturated(true)
			end
		end
	end
	button:SetScript('OnMouseUp', function(self, mouseButton)
		if mouseButton == 'RightButton' then
			CancelUnitBuff('player', index)
	end end)
	button.first = true
end
createAuras = function(f)
	Auras = CreateFrame("Frame", nil, f)
	Auras.size = 18
	Auras:SetHeight(42)
	Auras:SetWidth(f:GetWidth())
	Auras.spacing = 7
	if f.mystyle == "target" then
		Auras:SetPoint("BOTTOM", f, "BOTTOM", 0, -26)
		Auras.numBuffs = 10
		Auras.numDebuffs = 10
		Auras.size = 18
		--Auras.onlyShowPlayer = true
		Auras.spacing = 4.4
	end
	if f.mystyle == "tot" then
		Auras:SetPoint("BOTTOM", f, "BOTTOM", 0, -16)
		Auras.numBuffs = 0
		Auras.numDebuffs = 5
		Auras.spacing = 10
		Auras.size = 12
	end
	if f.mystyle == "focus" then
		Auras:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, 20)
		Auras.numBuffs = 0
		Auras.numDebuffs = 7
		Auras.spacing = 9
	end
	Auras.gap = true
	Auras.initialAnchor = "BOTTOMLEFT"
	Auras["growth-x"] = "RIGHT"
	Auras["growth-y"] = "DOWN"
	Auras.PostCreateIcon = postCreateIcon
	Auras.PostUpdateIcon = postUpdateIcon
	f.Auras = Auras
end
createBuffs = function(f)
    b = CreateFrame("Frame", nil, f)
	b.size = 20
    b.num = 40
    b.spacing = 8
    b.onlyShowPlayer = buffsOnlyShowPlayer
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
    if f.mystyle == "target" then
	    b.num = 10
		b:SetPoint("TOP", f, "TOP", 0, 50)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
    elseif f.mystyle == "player" then
	    b.size = 28
		b.num = 60
		b:SetWidth(500)
		b:SetPoint("TOPRIGHT", UIParent,  -20, -20)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
	elseif f.mystyle == "boss" then
	    b.size = 28
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 4
	elseif f.mystyle == "oUF_Arena" then
	    b.size = 28
		b:SetPoint("TOPRIGHT", f, "TOPLEFT", -8, 0)
		b.initialAnchor = "TOPRIGHT"
		b["growth-x"] = "LEFT"
		b["growth-y"] = "DOWN"
		b.num = 4
	else
		b.num = 0
    end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Buffs = b
end
createDebuffs = function(f)
    b = CreateFrame("Frame", nil, f)
    b.size = 20
	b.num = 6
	b.onlyShowPlayer = debuffsOnlyShowPlayer
    b.spacing = 5
    b:SetHeight((b.size+b.spacing)*4)
    b:SetWidth(f:GetWidth())
	if f.mystyle == "target" then
		b:SetPoint("TOP", f, "TOP", 0, 25)
		b.initialAnchor = "TOPLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "UP"
	elseif f.mystyle == "player" then
	    b.size = 30
		b:SetPoint("BOTTOM", f, "BOTTOM", 0, -39)
		b.initialAnchor = "BOTTOMLEFT"
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
		b.spacing = 8
	elseif f.mystyle == "boss" then
	    b.size = 28
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", 8, 0)
		b.initialAnchor = "TOPLEFT"
		b.onlyShowPlayer = true
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
		b.num = 4
	elseif f.mystyle == "oUF_Arena" then
	    b.size = 28
		b:SetPoint("TOPLEFT", f, "TOPRIGHT", 8, 0)
		b.initialAnchor = "TOPLEFT"
		b.onlyShowPlayer = true
		b["growth-x"] = "RIGHT"
		b["growth-y"] = "DOWN"
		b.num = 4
	else
		b.num = 0
	end
    b.PostCreateIcon = postCreateIcon
    b.PostUpdateIcon = postUpdateIcon

    f.Debuffs = b
end
addEclipseBar = function(self)
	if playerClass ~= "DRUID" then return end

	local eclipseBar = CreateFrame('Frame', nil, self)
	eclipseBar:SetPoint("TOPLEFT", self, "TOPLEFT", 3,-3)
	eclipseBar:SetSize((self:GetWidth()-120), 6)
	eclipseBar:SetFrameLevel(6)

	local h = CreateFrame("Frame", nil, eclipseBar)
	h:SetFrameLevel(0)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)

	local lunarBar = CreateFrame('StatusBar', nil, eclipseBar)
	lunarBar:SetPoint('LEFT', eclipseBar, 'LEFT', 0, 0)
	lunarBar:SetSize((self:GetWidth()-120), 6)
	lunarBar:SetStatusBarTexture(Qulight["media"].texture)
	lunarBar:SetStatusBarColor(0, 0, 1)
	eclipseBar.LunarBar = lunarBar

	local solarBar = CreateFrame('StatusBar', nil, eclipseBar)
	solarBar:SetPoint('LEFT', lunarBar:GetStatusBarTexture(), 'RIGHT', 0, 0)
	solarBar:SetSize((self:GetWidth()-120), 6)
	solarBar:SetStatusBarTexture(Qulight["media"].texture)
	solarBar:SetStatusBarColor(1, 3/5, 0)
	eclipseBar.SolarBar = solarBar

	local eclipseBarText = solarBar:CreateFontString(nil, 'OVERLAY')
	eclipseBarText:SetPoint("CENTER", eclipseBar, "CENTER", 0, 0)
	eclipseBarText:SetFont(Qulight["media"].font, 9, "OUTLINE")
	self:Tag(eclipseBarText, '[pereclipse]%')
	self.EclipseBar = eclipseBar
end
genHolyPower = function(self)
	if playerClass ~= "PALADIN" then return end
	local bars = CreateFrame("Frame", nil, self)
	bars:SetPoint("TOPLEFT", self, "TOPLEFT", 4,-3)
	bars:SetWidth(self:GetWidth()-100)
	bars:SetHeight(6)
	bars:SetFrameLevel(6)

	for i = 1, 5 do
		bars[i]=CreateFrame("StatusBar", nil, bars)
		bars[i]:SetHeight(bars:GetHeight())
		bars[i]:SetStatusBarTexture(Qulight["media"].texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		bars[i].bg = bars[i]:CreateTexture(nil, 'BORDER')
		bars[i]:SetStatusBarColor(228/255,225/255,16/255)
		bars[i].bg:SetTexture(228/255,225/255,16/255)

		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end

		bars[i].bg:SetAllPoints(bars[i])
		bars[i]:SetWidth((bars:GetWidth() - 2)/5)
		bars[i].bg:SetTexture(Qulight["media"].texture)
		bars[i].bg:SetAlpha(.15)
	end

	CreateStyle(bars, 4, 5, .9, 0.6)
	bars.Override = UpdateHoly
	self.HolyPower = bars
end
genRunes = function(self)
	if playerClass ~= "DEATHKNIGHT" then return end
	local runes = CreateFrame("Frame", nil, self)
	runes:SetPoint("TOPLEFT", self, "TOPLEFT",4,-3)
	runes:SetWidth(self:GetWidth()-100)
	runes:SetHeight(6)
	runes:SetFrameLevel(6)

	for i = 1, 6 do
		runes[i] = CreateFrame("StatusBar", nil, runes)
		runes[i]:SetHeight(runes:GetHeight())
		runes[i]:SetWidth((runes:GetWidth() - 5) / 6)

		if (i == 1) then
			runes[i]:SetPoint("LEFT", runes)
		else
			runes[i]:SetPoint("LEFT", runes[i-1], "RIGHT", 1, 0)
		end
		runes[i]:SetStatusBarTexture(Qulight["media"].texture)
		runes[i]:GetStatusBarTexture():SetHorizTile(false)
	end

	runes.backdrop = CreateFrame("Frame", nil, runes)

	CreateStyle(runes.backdrop, 2, 5, .9, 0.6)
	runes.backdrop:SetBackdropBorderColor(.2,.2,.2,1)
	runes.backdrop:SetPoint("TOPLEFT", -2, 2)
	runes.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	runes.backdrop:SetFrameLevel(runes:GetFrameLevel() - 1)

	self.Runes = runes
end
TotemBars = function(self)
if Qulight["unitframes"].TotemBars then
	if playerClass ~= "SHAMAN" then return end
	local totems = CreateFrame("Frame", nil, self)
	totems:SetPoint("TOPLEFT", self, "TOPLEFT",4,-3)
	totems:SetWidth(self:GetWidth()-140)
	totems:SetHeight(6)
	totems:SetFrameLevel(6)
	totems.Destroy = true
	totems.colors = {{233/255, 46/255, 16/255};{173/255, 217/255, 25/255};{35/255, 127/255, 255/255};{178/255, 53/255, 240/255};}

	for i = 1, 4 do
		totems[i] = CreateFrame("StatusBar", nil, totems)
		totems[i]:SetHeight(totems:GetHeight())
		totems[i]:SetWidth(((self:GetWidth()-140) - 3) / 4)

		if (i == 1) then
			totems[i]:SetPoint("LEFT", totems)
		else
			totems[i]:SetPoint("LEFT", totems[i-1], "RIGHT", 1, 0)
		end
		totems[i]:SetStatusBarTexture(Qulight["media"].texture)
		totems[i]:GetStatusBarTexture():SetHorizTile(false)
		totems[i]:SetMinMaxValues(0, 1)

		totems[i].bg = totems[i]:CreateTexture(nil, "BORDER")
		totems[i].bg:SetAllPoints()
		totems[i].bg:SetTexture(Qulight["media"].texture)
		totems[i].bg.multiplier = 0.3
	end
	totems.backdrop = CreateFrame("Frame", nil, totems)

	CreateStyle(totems.backdrop, 2, 5, .9, 0.6)
	totems.backdrop:SetBackdropBorderColor(.2,.2,.2,1)
	totems.backdrop:SetPoint("TOPLEFT", -2, 2)
	totems.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
	totems.backdrop:SetFrameLevel(5)
	self.TotemBar = totems
	end
end

Magebars = function(self)
	if myclass == "MAGE" then
		local mb = CreateFrame("Frame", "ArcaneBar", self)
		mb:SetPoint("TOPLEFT", self, "TOPLEFT",2,-2)
		mb:SetWidth(103)
		mb:SetHeight(6)
		mb:SetBackdrop(backdrop)
		mb:SetBackdropColor(0, 0, 0)
		mb:SetBackdropBorderColor(0, 0, 0)
		CreateStyle(mb, 4, 1, .9, 0.6)
		mb:SetFrameLevel(6)

		for i = 1, 4 do
		mb[i] = CreateFrame("StatusBar", "ArcaneBar"..i, mb)
		mb[i]:SetHeight(6)
		mb[i]:SetStatusBarTexture(Qulight["media"].texture)

			if i == 1 then
				mb[i]:SetWidth(100 / 4)
				mb[i]:SetPoint("LEFT", mb, "LEFT", 0, 0)
			else
				mb[i]:SetWidth(100 / 4)
				mb[i]:SetPoint("LEFT", mb[i-1], "RIGHT", 1, 0)
			end
				mb[i].bg = mb[i]:CreateTexture(nil, 'ARTWORK')
		end

		self.ArcaneChargeBar = mb

		local rp = CreateFrame("Frame", "RunePower", self)
		rp:SetPoint("TOPLEFT", self, "TOPLEFT", 108,-2)
		rp:SetWidth(41)
		rp:SetHeight(6)

		rp:SetBackdrop(backdrop)
		rp:SetBackdropColor(0, 0, 0)
		rp:SetBackdropBorderColor(0, 0, 0)
		CreateStyle(rp, 4, 1, .9, 0.6)
		rp:SetFrameLevel(6)
		for i = 1, 2 do
			rp[i] = CreateFrame("StatusBar", "RunePower"..i, rp)
			rp[i]:SetHeight(6)
			rp[i]:SetStatusBarTexture(Qulight["media"].texture)

			if i == 1 then
				rp[i]:SetWidth(40 / 2)
				rp[i]:SetPoint("LEFT", rp, "LEFT", 0, 0)
			else
				rp[i]:SetWidth(40 / 2)
				rp[i]:SetPoint("LEFT", rp[i-1], "RIGHT", 1, 0)
			end
				rp[i].bg = rp[i]:CreateTexture(nil, 'ARTWORK')
		end
		self.RunePower = rp
	end
end

genCPoints = function(self)
	local bars = CreateFrame("Frame", nil, self)
	bars:SetPoint("TOPLEFT", self, "TOPLEFT",4,-3)
	bars:SetWidth(120)
	bars:SetHeight(6)
	bars:SetFrameLevel(6)
	bars:SetBackdropBorderColor(0,0,0,0)
	bars:SetBackdropColor(0,0,0,0)

	for i = 1, 5 do
		bars[i] = CreateFrame("StatusBar", self:GetName().."_Combo"..i, bars)
		bars[i]:SetHeight(6)
		bars[i]:SetStatusBarTexture(Qulight["media"].texture)
		bars[i]:GetStatusBarTexture():SetHorizTile(false)

		if i == 1 then
			bars[i]:SetPoint("LEFT", bars)
		else
			bars[i]:SetPoint("LEFT", bars[i-1], "RIGHT", 1, 0)
		end
		bars[i]:SetAlpha(0.15)
		bars[i]:SetWidth(((self:GetWidth()-100) - 4)/5)
	end

	bars[1]:SetStatusBarColor(0.69, 0.31, 0.31)
	bars[2]:SetStatusBarColor(0.69, 0.31, 0.31)
	bars[3]:SetStatusBarColor(0.65, 0.63, 0.35)
	bars[4]:SetStatusBarColor(0.65, 0.63, 0.35)
	bars[5]:SetStatusBarColor(0.33, 0.59, 0.33)

	self.CPoints = bars
	self.CPoints.Override = ComboDisplay

	bars.FrameBackdrop = CreateFrame("Frame", nil, bars[1])

	CreateStyle(bars.FrameBackdrop, 2, 5, .9, 0.6)
	bars.FrameBackdrop:SetBackdropBorderColor(.2,.2,.2,1)
	bars.FrameBackdrop:SetPoint("TOPLEFT", bars, "TOPLEFT", -2, 2)
	bars.FrameBackdrop:SetPoint("BOTTOMRIGHT", bars, "BOTTOMRIGHT", 2, -2)
	bars.FrameBackdrop:SetFrameLevel(6)
end
genHarmony = function(self)
	if myclass == "MONK" then

		local hb = CreateFrame("Frame", "Harmony", self)
		hb:SetPoint("TOPLEFT", self, "TOPLEFT",2,-2)
		hb:SetWidth(120)
		hb:SetHeight(6)
		hb:SetBackdrop(backdrop)

		hb:SetBackdropBorderColor(0,0,0,0)
		hb:SetBackdropColor(0, 0, 0)
		CreateStyle(hb, 4, 1, .9, 0.6)
		hb:SetFrameLevel(6)
			for i = 1, 6 do
				hb[i] = CreateFrame("StatusBar", nil, hb)
				hb[i]:SetHeight(6)
				hb[i]:SetStatusBarTexture(Qulight["media"].texture)

					if i == 1 then
						hb[i]:SetWidth(120 / 6)
						hb[i]:SetPoint("LEFT", hb, "LEFT", 0, 0)
					else
						hb[i]:SetWidth((120 / 6) - 1)
						hb[i]:SetPoint("LEFT", hb[i-1], "RIGHT", 1, 0)
					end
						hb[i].bg = hb[i]:CreateTexture(nil, 'ARTWORK')
			end
		self.HarmonyBar = hb
	end
end
genShards = function(self)
	if myclass == "WARLOCK" then
		local wb = CreateFrame("Frame", "WarlockSpecBars", self)
		wb:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 4, -9)
		wb:SetWidth(120)
		wb:SetHeight(5)
		wb:SetBackdrop(backdrop)

		wb:SetBackdropColor(0, 0, 0)
		wb:SetBackdropBorderColor(0, 0, 0)
		CreateStyle(wb, 4, 1, .9, 0.6)
		wb:SetFrameLevel(6)
			for i = 1, 4 do
				wb[i] = CreateFrame("StatusBar", "WarlockSpecBars"..i, wb)
				wb[i]:SetHeight(5)
				wb[i]:SetStatusBarTexture(Qulight["media"].texture)

					if i == 1 then
						wb[i]:SetWidth((123 / 4))
						wb[i]:SetPoint("LEFT", wb, "LEFT", 0, 0)
					else
						wb[i]:SetWidth((123 / 4))
						wb[i]:SetPoint("LEFT", wb[i-1], "RIGHT", 1, 0)
					end
						wb[i].bg = wb[i]:CreateTexture(nil, 'ARTWORK')
			end
		wb:SetScript("OnShow", function(self)
		local f = self:GetParent()
		end)

		wb:SetScript("OnHide", function(self)
		local f = self:GetParent()
		end)

		self.WarlockSpecBars = wb
	end
end
genShadowOrbsBar = function(self)
	if myclass == "PRIEST" then

		self.ShadowOrbsBar = CreateFrame("Frame", self:GetName().."_ShadowOrbsBar", self)
		CreateStyle(self.ShadowOrbsBar, 4, 1, .9, 0.6)
		self.ShadowOrbsBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 4, -9)
		self.ShadowOrbsBar:SetSize(122, 6)
		self.ShadowOrbsBar:SetFrameLevel(6)

			for i = 1, 5 do
				self.ShadowOrbsBar[i] = CreateFrame("StatusBar", nil, self.ShadowOrbsBar)
				self.ShadowOrbsBar[i]:SetSize(120 / 5, 6)
				if i == 1 then
					self.ShadowOrbsBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 4, -9)
				else
					self.ShadowOrbsBar[i]:SetPoint("TOPLEFT", self.ShadowOrbsBar[i-1], "TOPRIGHT", 1, 0)
				end
				self.ShadowOrbsBar[i]:SetStatusBarTexture(Qulight["media"].texture)
				self.ShadowOrbsBar[i]:SetStatusBarColor(0.70, 0.32, 0.75)

				self.ShadowOrbsBar[i].bg = self.ShadowOrbsBar[i]:CreateTexture(nil, "BORDER")
				self.ShadowOrbsBar[i].bg:SetAllPoints()
				self.ShadowOrbsBar[i].bg:SetTexture(Qulight["media"].texture)
				self.ShadowOrbsBar[i].bg:SetVertexColor(0.70, 0.32, 0.75, 0.25)
				self.ShadowOrbsBar[i].width = self.ShadowOrbsBar[i]:GetWidth()
			end

			self.ShadowOrbsBar.Override = UpdateShadowOrb
	end
end
AltPowerBar = function(self)
	local AltPowerBar = CreateFrame("StatusBar", nil, self.Health)

	AltPowerBar:SetHeight(5)
	AltPowerBar:SetStatusBarTexture(Qulight["media"].texture)
	AltPowerBar:GetStatusBarTexture():SetHorizTile(false)
	AltPowerBar:EnableMouse(true)
	AltPowerBar:SetFrameStrata("HIGH")
	AltPowerBar:SetFrameLevel(4)

	AltPowerBar:SetPoint("LEFT", DataLeftPanel, 1, -1)
	AltPowerBar:SetPoint("RIGHT", DataLeftPanel, -1, 1)
	AltPowerBar:SetPoint("TOP", DataLeftPanel, 1, -1)
	AltPowerBar:SetPoint("BOTTOM", DataLeftPanel, -1, 1)

	AltPowerBar:SetBackdrop({
			bgFile = Qulight["media"].texture,
			edgeFile = Qulight["media"].texture,
			tile = false, tileSize = 0, edgeSize = 1,
			insets = { left = 0, right = 0, top = 0, bottom = 0}
		})

	AltPowerBar:SetBackdropColor(.05,.05,.05, 1)
	AltPowerBar:SetBackdropBorderColor(0, 0, 0, 0)

	AltPowerBar.text = SetFontString(AltPowerBar, Qulight["media"].font, 10, "OUTLINE")
	AltPowerBar.text:SetPoint("CENTER")
	self:Tag(AltPowerBar.text, '[altpower]')

	AltPowerBar:HookScript("OnShow", AltPowerBarOnToggle)
	AltPowerBar:HookScript("OnHide", AltPowerBarOnToggle)

	self.AltPowerBar = AltPowerBar
	self.AltPowerBar.PostUpdate = AltPowerBarPostUpdate
end
Experience = function(self)
	if Qulight["unitframes"].Experiencebar then
	local Experience = CreateFrame('StatusBar', nil, self)
	Experience:SetStatusBarTexture(Qulight["media"].texture)
	Experience:SetStatusBarColor(0, 0.7, 1)
	Experience:SetPoint('LEFT', ChatPanelRight, 'LEFT', -15, 0)
	--Experience:SetPoint('LEFT', ChatPanelRight, 'LEFT', 1, 0)
	--Experience:SetWidth(6)
	Experience:SetWidth(8)
	Experience:SetHeight(168)
	Experience:SetFrameLevel(2)
	Experience.Tooltip = true
	Experience:SetOrientation("VERTICAL")

	local h = CreateFrame("Frame", nil, Experience)
	h:SetFrameLevel(1)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	--经验条透明度
	h:SetAlpha(.5)
	CreateStyle(h, -1 )

	local Rested = CreateFrame('StatusBar', nil, Experience)
	Rested:SetStatusBarTexture(Qulight["media"].texture)
	Rested:SetStatusBarColor(0, 0.4, 1, 0.6)
	Rested:SetFrameLevel(2)
	Rested:SetOrientation("VERTICAL")
	Rested:SetAllPoints(Experience)

	self.Experience = Experience
	self.Experience.Rested = Rested
	self.Experience.PostUpdate = ExperiencePostUpdate
	end
end
Reputation = function(self)
	if Qulight["unitframes"].Reputationbar then
	local Reputation = CreateFrame('StatusBar', nil, self)
	Reputation:SetStatusBarTexture(Qulight["media"].texture)
	Reputation:SetWidth(6)
	Reputation:SetHeight(168)

	Reputation:SetPoint('RIGHT', ChatBackground, 'RIGHT', 8, 0)
	Reputation:SetFrameLevel(2)
	Reputation:SetOrientation("VERTICAL")

	local h = CreateFrame("Frame", nil, Reputation)
	h:SetFrameLevel(1)
	h:SetPoint("TOPLEFT",-5,5)
	h:SetPoint("BOTTOMRIGHT",5,-5)
	CreateStyle(h, -1)

	Reputation.PostUpdate = UpdateReputationColor
	Reputation.Tooltip = true
	self.Reputation = Reputation
	end
end
-----------------------------
-- STYLE FUNCTIONS
-----------------------------
local function CreatePlayerStyle(self, unit, isSingle)
	self.mystyle = "player"
	init(self)
	self.scale = scale
	self:SetSize(220,38)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_ppbar(self)
	gen_focusbar(self)
	gen_RaidMark(self)
	createDebuffs(self)
	if Qulight["unitframes"].showPlayerAuras then
		BuffFrame:Hide()
		createBuffs(self)
	end
	self.Health.frequentUpdates = true
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.frequentUpdates = true
	self.Power.bg.multiplier = 0.1
	if not Qulight["unitframes"].bigcastbar then
	gen_castbar(self)
	else
	gen_bigcastbar(self)
	end
	gen_InfoIcons(self)
	TotemBars(self)
	Magebars(self)

	Experience(self)
	Reputation(self)
	AltPowerBar(self)
	genHarmony(self)
	genShadowOrbsBar(self)
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
	if Qulight["unitframes"].showRunebar then genRunes(self) end
	if Qulight["unitframes"].showHolybar then genHolyPower(self) end
	if Qulight["unitframes"].showShardbar then genShards(self) end
	if Qulight["unitframes"].showEclipsebar then addEclipseBar(self) end
end
local function CreateTargetStyle(self, unit, isSingle)
	self.mystyle = "target"
	init(self)
	self.scale = scale
	self:SetSize(220,38)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_ppbar(self)
	gen_RaidMark(self)

	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.bg.multiplier = 0.1
	if not Qulight["unitframes"].bigcastbar then
	gen_castbar(self)
	else
	gen_bigcastbar(self)
	end

	addQuestIcon(self)
	createAuras(self)
	genCPoints(self)
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateFocusStyle(self, unit, isSingle)
	self.mystyle = "focus"
	init(self)
	self.scale = scale
	self:SetSize(180,34)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_ppbar(self)

	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	if Qulight["unitframes"].Powercolor then
	self.Power.colorClass = true
	else
	self.Power.colorPower = true
	end
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	gen_RaidMark(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	gen_castbar(self)
	createAuras(self)
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateToTStyle(self, unit, isSingle)
	self.mystyle = "tot"
	init(self)
	self.scale = scale
	self:SetSize(100,28)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_RaidMark(self)
	createAuras(self)
	gen_ppbar(self)
	self.Power.colorReaction = true
	self.Power.colorClass = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5

	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateFocusTargetStyle(self, unit, isSingle)
	self.mystyle = "focustarget"
	init(self)
	self.scale = scale
	self:SetSize(100,28)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_ppbar(self)
	self.Power.colorClass = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	gen_highlight(self)
	gen_RaidMark(self)

	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreatePetStyle(self, unit, isSingle)
	local _, playerClass = UnitClass("player")
	self.mystyle = "pet"
	init(self)
	self.scale = scale
	self:SetSize(100,28)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_ppbar(self)
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.colorClass = true
	self.Power.bg.multiplier = 0.5
	gen_highlight(self)
	gen_RaidMark(self)

	self.Health.frequentUpdates = false
	if PlayerClass == "HUNTER" then
		self.Power.colorReaction = false
		self.Power.colorClass = false
	end
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateBossStyle(self, unit, isSingle)
	self.mystyle = "boss"
	self:SetSize(150,28)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_RaidMark(self)
	gen_ppbar(self)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorClass = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	gen_castbar(self)

	AltPowerBar(self)
	createBuffs(self)
	createDebuffs(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateMTStyle(self)
	self.mystyle = "oUF_MT"
	self:SetSize(100,22)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_RaidMark(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].HealthcolorClass then
	self.Health.colorClass = true
	end
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
local function CreateArenaStyle(self, unit, isSingle)
	self.mystyle = "oUF_Arena"
	self:SetSize(150,28)
	gen_hpbar(self)
	gen_hpstrings(self)
	gen_highlight(self)
	gen_RaidMark(self)
	gen_ppbar(self)
	self.Power.colorTapping = true
	self.Power.colorDisconnected = true
	self.Power.colorClass = true
	self.Power.colorReaction = true
	self.Power.colorHealth = true
	self.Power.bg.multiplier = 0.5
	gen_castbar(self)
	createBuffs(self)
	createDebuffs(self)
	self.Health.frequentUpdates = false
	if Qulight["unitframes"].showPortrait then gen_portrait(self) end
end
-----------------------------
-- SPAWN UNITS
-----------------------------
oUF:RegisterStyle("Player", CreatePlayerStyle)
oUF:RegisterStyle("Target", CreateTargetStyle)
oUF:RegisterStyle("ToT", CreateToTStyle)
oUF:RegisterStyle("Focus", CreateFocusStyle)
oUF:RegisterStyle("FocusTarget", CreateFocusTargetStyle)
oUF:RegisterStyle("Pet", CreatePetStyle)
oUF:RegisterStyle("Boss", CreateBossStyle)
oUF:RegisterStyle("oUF_MT", CreateMTStyle)
oUF:RegisterStyle("oUF_Arena", CreateArenaStyle)

if not Qulight["unitframes"].enable == true then return end
oUF:Factory(function(self)
	self:SetActiveStyle("Player")
	local player = self:Spawn("player", "oUF_Player")
	player:SetPoint("BOTTOM", Anchorplayer)
	self:SetActiveStyle("Target")
	local target = self:Spawn("Target", "oUF_Target")
	target:SetPoint("BOTTOM", Anchortarget)
	if Qulight["unitframes"].showtot then
		self:SetActiveStyle("ToT")
		local targettarget = self:Spawn("targettarget", "oUF_tot")
		targettarget:SetPoint("BOTTOM", Anchortot)
	end
	if Qulight["unitframes"].showpet then
		self:SetActiveStyle("Pet")
		local pet = self:Spawn("pet", "oUF_pet")
		pet:SetPoint("BOTTOM", Anchorpet)
	end
	if Qulight["unitframes"].showfocus then
		self:SetActiveStyle("Focus")
		local focus = self:Spawn("focus", "oUF_focus")
		focus:SetPoint("BOTTOM", Anchorfocus)
	end
	if Qulight["unitframes"].showfocustarget then
		self:SetActiveStyle("FocusTarget")
		local focustarget = self:Spawn("focustarget", "oUF_focustarget")
		focustarget:SetPoint("LEFT", oUF_focus, "RIGHT", 8, -3)
	end

	if Qulight["unitframes"].MTFrames then
		oUF:SetActiveStyle("oUF_MT")
		local tank = oUF:SpawnHeader('oUF_MT', nil, 'raid',
			'oUF-initialConfigFunction', ([[
				self:SetWidth(%d)
				self:SetHeight(%d)
			]]):format(80, 22),
			'showRaid', true,
			'groupFilter', 'MAINTANK',
			'yOffset', 8,
			'point' , 'BOTTOM',
			'template', 'oUF_MainTank')
		tank:SetPoint("TOP", Anchortank)
    end
	if Qulight["unitframes"].showBossFrames then
		self:SetActiveStyle("Boss")
		local boss = {}
			for i = 1, MAX_BOSS_FRAMES do
				boss[i] = self:Spawn("boss"..i, "oUF_Boss"..i)
				if i == 1 then
					boss[i]:SetPoint("BOTTOM", Anchorboss)
				else
					boss[i]:SetPoint("BOTTOMRIGHT", boss[i-1], "BOTTOMRIGHT", 0, 50)
			end
		end
	end
	oUF:SetActiveStyle("oUF_Arena")
	if Qulight["unitframes"].ArenaFrames then
	local arena = {}
	for i = 1, 5 do
		arena[i] = self:Spawn("arena"..i, "oUF_Arena"..i)
		if i == 1 then
			arena[i]:SetPoint("BOTTOM", Anchorboss)
		else
			arena[i]:SetPoint("BOTTOMRIGHT", arena[i-1], "BOTTOMRIGHT", 0, 90)
		end
		arena[i]:SetSize(150, 28)
	end

	local QulightPrepArena = {}
	for i = 1, 5 do
		QulightPrepArena[i] = CreateFrame("Frame", "QulightPrepArena"..i, UIParent)
		QulightPrepArena[i]:SetAllPoints(arena[i])
		QulightPrepArena[i]:SetBackdropColor(0,0,0)
		CreateStyle(QulightPrepArena[i], 2)
		QulightPrepArena[i].Health = CreateFrame("StatusBar", nil, QulightPrepArena[i])
		QulightPrepArena[i].Health:SetAllPoints()
		QulightPrepArena[i].Health:SetStatusBarTexture(Qulight["media"].texture)
		QulightPrepArena[i].Health:SetStatusBarColor(.3, .3, .3, 1)
		QulightPrepArena[i].SpecClass = QulightPrepArena[i].Health:CreateFontString(nil, "OVERLAY")
		QulightPrepArena[i].SpecClass:SetFont(Qulight["media"].font, 9, "OUTLINE")
		QulightPrepArena[i].SpecClass:SetPoint("CENTER")
		QulightPrepArena[i]:Hide()
	end

	local ArenaListener = CreateFrame("Frame", "QulightArenaListener", UIParent)
	ArenaListener:RegisterEvent("PLAYER_ENTERING_WORLD")
	ArenaListener:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
	ArenaListener:RegisterEvent("ARENA_OPPONENT_UPDATE")
	ArenaListener:SetScript("OnEvent", function(self, event)
		if event == "ARENA_OPPONENT_UPDATE" then
			for i=1, 5 do
				local f = _G["QulightPrepArena"..i]
				f:Hide()
			end
		else
			local numOpps = GetNumArenaOpponentSpecs()

			if numOpps > 0 then
				for i=1, 5 do
					local f = _G["QulightPrepArena"..i]
					local s = GetArenaOpponentSpec(i)
					local _, spec, class = nil, "UNKNOWN", "UNKNOWN"

					if s and s > 0 then
						_, spec, _, _, _, _, class = GetSpecializationInfoByID(s)
					end

					if (i <= numOpps) then
						if class and spec then
							f.SpecClass:SetText(spec.."  -  "..LOCALIZED_CLASS_NAMES_MALE[class])

								local color = arena[i].colors.class[class]
								f.Health:SetStatusBarColor(unpack(color))

							f:Show()
						end
					else
						f:Hide()
					end
				end
			else
				for i=1, 5 do
					local f = _G["QulightPrepArena"..i]
					f:Hide()
				end
			end
		end
	end)

	end
end)


----------------------------------------------------------------------------------------
--	Test UnitFrames(by community)
----------------------------------------------------------------------------------------
SlashCmdList.TEST_UF = function(msg)
	if msg == "hide" or msg == "ршву" then
		for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget"}) do
			_G[frames].Hide = nil
		end


			for i = 1, 5 do
				_G["oUF_Arena"..i].Hide = nil
				_G["oUF_Arena"..i.."Target"].Hide = nil
			end



			for i = 1, MAX_BOSS_FRAMES do
				_G["oUF_Boss"..i].Hide = nil
			end

	else
			for i = 1, 5 do
				_G["oUF_Arena"..i].Hide = function() end
				_G["oUF_Arena"..i].unit = "player"
				_G["oUF_Arena"..i]:Show()
				_G["oUF_Arena"..i]:UpdateAllElements()
				_G["oUF_Arena"..i].Trinket.Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Necklace_37")

				_G["oUF_Arena"..i.."Target"].Hide = function() end
				_G["oUF_Arena"..i.."Target"].unit = "player"
				_G["oUF_Arena"..i.."Target"]:Show()
				_G["oUF_Arena"..i.."Target"]:UpdateAllElements()

					_G["oUF_Arena"..i].Talents:SetText(TALENTS)

			end

			for i = 1, MAX_BOSS_FRAMES do
				_G["oUF_Boss"..i].Hide = function() end
				_G["oUF_Boss"..i].unit = "player"
				_G["oUF_Boss"..i]:Show()
				_G["oUF_Boss"..i]:UpdateAllElements()
			end

	end
end
SLASH_TEST_UF1 = "/testui"
SLASH_TEST_UF2 = "/еуыегш"
SLASH_TEST_UF3 = "/testuf"
SLASH_TEST_UF4 = "/еуыега"