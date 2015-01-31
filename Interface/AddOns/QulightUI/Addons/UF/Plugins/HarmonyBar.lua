local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, 'oUF_HarmonyBar was unable to locate oUF install')

if select(2, UnitClass('player')) ~= "MONK" then return end

local SPELL_POWER_CHI = SPELL_POWER_CHI

local Colors = { 
	[1] = {.69, .31, .31, 1},
	[2] = {.65, .42, .31, 1},
	[3] = {.65, .63, .35, 1},
	[4] = {.46, .63, .35, 1},
	[5] = {.33, .63, .33, 1},
	[6] = {.07, .63, .31, 1},
}

local function Update(self, event, unit, powerType)
	if(self.unit ~= unit and (powerType and (powerType ~= 'CHI' and powerType ~= 'DARK_FORCE'))) then return end
	
	local hb = self.HarmonyBar
	
	if(hb.PreUpdate) then
		hb:PreUpdate(unit)
	end
	
	local spacing = select(4, hb[4]:GetPoint())
	local w = hb:GetWidth()
	local s = 0
	local light = UnitPower("player", SPELL_POWER_CHI)
	local maxChi = UnitPowerMax("player", SPELL_POWER_CHI)
	
	if hb.maxChi ~= maxChi then
		if maxChi == 4 then
			hb[5]:Hide()
			hb[6]:Hide()			
		elseif maxChi == 5 then
			hb[5]:Show()
			hb[6]:Hide()	
		else
			hb[5]:Show()
			hb[6]:Show()
		end
		
		for i = 1, maxChi do
			if i ~= maxChi then
				hb[i]:SetWidth(w / maxChi - spacing)
				s = s + (w / maxChi)
			else
				hb[i]:SetWidth(w - s)
			end
		end
		
		hb.maxChi = maxChi
	end

	for i = 1, maxChi do
		if i <= light then
			hb[i]:SetAlpha(1)
		else
			hb[i]:SetAlpha(.2)
		end
	end
	
	if(hb.PostUpdate) then
		return hb:PostUpdate(light)
	end
end

local Path = function(self, ...)
	return (self.HarmonyBar.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'CHI')
end

local function Enable(self, unit)
	local hb = self.HarmonyBar
	if hb and unit == "player" then
		hb.__owner = self
		hb.ForceUpdate = ForceUpdate
		
		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent('PLAYER_TALENT_UPDATE', Path)
		
		for i = 1, 6 do
			local Point = hb[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end
			
			Point:SetStatusBarColor(unpack(Colors[i]))
			Point:SetFrameLevel(hb:GetFrameLevel() + 1)
			Point:GetStatusBarTexture():SetHorizTile(false)
		end
		
		hb.maxChi = 6
		
		return true
	end
end

local function Disable(self)
	if self.HarmonyBar then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent('PLAYER_TALENT_UPDATE', Path)
	end
end

oUF:AddElement('HarmonyBar', Update, Enable, Disable)