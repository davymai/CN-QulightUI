----------------------------------------------
-- infCombatRess
----------------------------------------------

local infCombatRess = CreateFrame("Frame", "infCombatRess")
infCombatRess:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
infCombatRess:RegisterEvent("PLAYER_LOGIN")

local db
local inCombat = nil
local currentNumResses = 0
local resurrectingId = GetSpellInfo(160029)

local GetTime = GetTime
local UnitDebuff = UnitDebuff
local GetSpellCharges = GetSpellCharges
local CooldownFrame_SetTimer = CooldownFrame_SetTimer
local ActionButton_ShowOverlayGlow = ActionButton_ShowOverlayGlow
local ActionButton_HideOverlayGlow = ActionButton_HideOverlayGlow

local defaults = {
	moveable = false,
	xpos = -545.5,
	ypos = -336,
	scale = 1,
}

function infCombatRess:PLAYER_LOGIN()
	infCombatRessDB = infCombatRessDB or defaults
	db = infCombatRessDB
	for k in pairs(defaults) do
		if db[k] == nil then
			db[k] = defaults[k]
		end
	end

	--SlashCmdList["infCombatRess"] = function(msg) 
		--self:ChatCommand(msg) 
	--end
	--SLASH_infCombatRess1 = "/infcombatress"

	self:FrameCreation()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
end

function infCombatRess:FrameCreation()
	infCombatRess_frame = CreateFrame("Frame", nil, UIParent)
	infCombatRess_frame:SetSize(57, 57)
	infCombatRess_frame:SetPoint("CENTER", db.xpos, db.ypos)
	infCombatRess_frame:SetScale(db.scale)
	infCombatRess_frame:Hide()

	infCombatRess_frame.icon = infCombatRess_frame:CreateTexture(nil, "BACKGROUND")
	infCombatRess_frame.icon:SetTexture("Interface\\Icons\\Spell_Nature_Reincarnation")
	infCombatRess_frame.icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
	infCombatRess_frame.icon:SetAllPoints(true)

	infCombatRess_frame.cdtexture = CreateFrame("Cooldown", nil, infCombatRess_frame, "CooldownFrameTemplate")
	--infCombatRess_frame.cdtexture:SetHideCountdownNumbers(true)
	--infCombatRess_frame.cdtexture.noCooldownCount = true
	infCombatRess_frame.cdtexture:SetAllPoints(true)

	infCombatRess_frame.overlay = CreateFrame("Frame", nil, infCombatRess_frame)
	infCombatRess_frame.overlay:SetPoint("TOPLEFT", -3, 3)
	infCombatRess_frame.overlay:SetPoint("BOTTOMRIGHT", 3, -3)

	--[[infCombatRess_frame.text = infCombatRess_frame.cdtexture:CreateFontString(nil, "OVERLAY")
	infCombatRess_frame.text:SetFontObject(NumberFontNormalHuge)
	infCombatRess_frame.text:SetAllPoints(true)]]

	infCombatRess_frame.text = infCombatRess_frame.cdtexture:CreateFontString(nil, "OVERLAY")
	infCombatRess_frame.text:SetFontObject(NumberFontNormalLarge)
	infCombatRess_frame.text:SetPoint("BOTTOMRIGHT", 2, -2)

	if db.moveable == true then
		infCombatRess_frame:SetMovable(true)
		infCombatRess_frame:EnableMouse(true)	
		infCombatRess_frame:RegisterForDrag("LeftButton")
		infCombatRess_frame:SetScript("OnDragStart", function(self, button) 
			self:StartMoving() 
		end)
		infCombatRess_frame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			local scale = self:GetEffectiveScale() / UIParent:GetEffectiveScale()
			local x, y = self:GetCenter()
			x, y = x * scale, y * scale
			x = x - _G.GetScreenWidth() / 2
			y = y - _G.GetScreenHeight() / 2
			x = x / self:GetScale()
			y = y / self:GetScale()
			db.xpos, db.ypos = x, y
			self:SetUserPlaced(false)
		end)
	end
end

local function IsInRaid()
	local _, instanceType = IsInInstance()
	local raid = false
	if instanceType and instanceType == "raid" then
		raid = true
	end
	return raid
end

function infCombatRess:PLAYER_ENTERING_WORLD()
	if IsInRaid() then
		self:RegisterEvent("SPELL_UPDATE_CHARGES")
	else
		self:UnregisterEvent("SPELL_UPDATE_CHARGES")
	end
end

do
	local shineTimer = nil
	local function shineOff()
		ActionButton_HideOverlayGlow(infCombatRess_frame.overlay)
	end
	local function checkShine()
		local keepGlow = nil
		for i=1, GetNumGroupMembers() do
			local unitHasRess = UnitDebuff("raid"..i, resurrectingId)
			if unitHasRess then
				keepGlow = true
			end
		end
		if not keepGlow then
			ActionButton_HideOverlayGlow(infCombatRess_frame.overlay)
			if shineTimer then
				shineTimer:Cancel()
				shineTimer = nil
			end
		end
	end
	function infCombatRess:SPELL_UPDATE_CHARGES()
		local charges, _, start, duration = GetSpellCharges(20484) -- Rebirth
		if charges then
			if not inCombat then
				inCombat = true
				self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
				infCombatRess_frame:Show()
			end
			if currentNumResses ~= charges then
				if charges > currentNumResses then
					local timeStamp = GetTime()
					local timeLeft = start + duration - timeStamp
					CooldownFrame_SetTimer(infCombatRess_frame.cdtexture, timeStamp, timeLeft, true)
				else
					C_Timer.After(0.5, checkShine)
					C_Timer.After(4, checkShine)
				end
				currentNumResses = charges
				infCombatRess_frame.text:SetText(currentNumResses)
			end
		elseif inCombat and not charges then
			inCombat = nil
			currentNumResses = 0
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			CooldownFrame_SetTimer(infCombatRess_frame.cdtexture, 0, 0, true)
			ActionButton_HideOverlayGlow(infCombatRess_frame.overlay)
			infCombatRess_frame:Hide()
		end
	end
	function infCombatRess:COMBAT_LOG_EVENT_UNFILTERED(_, _, event)
		if event == "SPELL_RESURRECT" then
			ActionButton_ShowOverlayGlow(infCombatRess_frame.overlay)
			if shineTimer then
				shineTimer:Cancel()
				shineTimer = nil
			end
			shineTimer = C_Timer.NewTimer(60, shineOff)
		end
	end
end

--[[function infCombatRess:ChatCommand(input)
	local cmd, arg = string.split(" ", input, 2)
	cmd = string.lower(cmd or "")
	arg = string.lower(arg or "")

	if not input or input:trim() == "" then
		print("|cff3399FFinf|rCombatRess: /infcombatress lock to unlock/lock.")
		print("|cff3399FFinf|rCombatRess: /infcombatress scale <scale> to change the scale.")
	elseif cmd == "lock" then
		if db.moveable == true then
			infCombatRess_frame:SetMovable(false)
			infCombatRess_frame:EnableMouse(false)
			infCombatRess_frame:Hide()
			db.moveable = false
			print("|cff3399FFinf|rCombatRess: locked.")
		elseif db.moveable == false then
			infCombatRess_frame:SetMovable(true)
			infCombatRess_frame:EnableMouse(true)	
			infCombatRess_frame:RegisterForDrag("LeftButton")
			infCombatRess_frame:SetScript("OnDragStart", function(self, button) 
				self:StartMoving() 
			end)
			infCombatRess_frame:SetScript("OnDragStop", function(self)
				self:StopMovingOrSizing()
				local scale = self:GetEffectiveScale() / UIParent:GetEffectiveScale()
				local x, y = self:GetCenter()
				x, y = x * scale, y * scale
				x = x - _G.GetScreenWidth() / 2
				y = y - _G.GetScreenHeight() / 2
				x = x / self:GetScale()
				y = y / self:GetScale()
				db.xpos, db.ypos = x, y
				self:SetUserPlaced(false)
			end)
			infCombatRess_frame:Show()
			db.moveable = true
			print("|cff3399FFinf|rCombatRess: unlocked.")
		end
	elseif cmd == "scale" then
		if arg:match("^[0-9].+$") or arg:match("^[0-9]+$") then 
			db.scale = tonumber(arg)
			infCombatRess_frame:SetScale(arg)
			print("|cff3399FFinf|rCombatRess: Scale set to ".. arg ..".")
		elseif arg == "" then
			print("|cff3399FFinf|rCombatRess: Missing the scale.")
			print("|cff3399FFinf|rCombatRess: Example: /infcombatress scale 1.1")
		else
			print("|cff3399FFinf|rCombatRess: Invalid scale.")
		end
	end
end]]--

