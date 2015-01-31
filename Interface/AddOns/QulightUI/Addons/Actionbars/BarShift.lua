
if not Qulight["actionbar"].enable == true then return end
---------------------------------------------------------------------------
-- Setup Shapeshift Bar
---------------------------------------------------------------------------
-- used to update shift action bar buttons
ShiftBarUpdate = function(self)
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_STANCE_SLOTS do
		buttonName = "StanceButton"..i
		button = _G[buttonName]
		icon = _G[buttonName.."Icon"]
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)

			if not icon then return end

			icon:SetTexture(texture)

			cooldown = _G[buttonName.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end

			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)

			if isActive then
				StanceBarFrame.lastSelected = button:GetID()
				button:SetChecked(true)

				if button.Backdrop then
					button.Backdrop:SetBackdropBorderColor(0, 1, 0)
				end
			else
				button:SetChecked(false)

				if button.Backdrop then
					button.Backdrop:SetBackdropBorderColor(parent:GetBackdropBorderColor())
				end
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

AnchorShift = CreateFrame("Frame","Move_Shift",UIParent)
--[[关闭左右信息栏高度变化
	if Qulight["general"].centerpanel then
		AnchorShift:SetPoint("BOTTOMLEFT", UIParent, 3, 191)
	else
		AnchorShift:SetPoint("BOTTOMLEFT", UIParent, 3, 175)
	end
]]
AnchorShift:SetPoint("BOTTOMLEFT", UIParent, 3, 191)
CreateAnchor(AnchorShift, "Move Shift", petbuttonsize, petbuttonsize)

-- used for anchor totembar or STANCEbar
local bar = CreateFrame("Frame","barBar",UIParent)
bar:SetPoint("LEFT", AnchorShift, 0, -30)
bar:SetWidth((petbuttonsize * 5) + (petbuttonsize * 4))
bar:SetHeight(petbuttonsize/2)
bar:SetFrameStrata("MEDIUM")
bar:SetMovable(true)
bar:SetClampedToScreen(true)
bar:SetAlpha(1)

-- hide it if not needed and stop executing code
if Qulight.actionbar.hideSTANCE then bar:Hide() return end

local States = {
	["DRUID"] = "show",
	["WARRIOR"] = "show",
	["PALADIN"] = "show",
	["DEATHKNIGHT"] = "show",
	["ROGUE"] = "show,",
	["PRIEST"] = "show,",
	["HUNTER"] = "show,",
	["WARLOCK"] = "show,",
	["MONK"] = "show,",
}

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
bar:RegisterEvent("UPDATE_SHAPESHIFT_USABLE")
bar:RegisterEvent("UPDATE_SHAPESHIFT_COOLDOWN")
bar:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:RegisterEvent("PLAYER_TALENT_UPDATE")
bar:RegisterEvent("SPELLS_CHANGED")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		StanceBarFrame.ignoreFramePositionManager = true
		StripTextures(StanceBarFrame)
		StanceBarFrame:SetParent(bar)
		StanceBarFrame:ClearAllPoints()
		StanceBarFrame:SetPoint("BOTTOMLEFT", bar, "TOPLEFT", -11, 4)
		StanceBarFrame:EnableMouse(false)

		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			button:SetFrameStrata("LOW")
			if i ~= 1 then
				button:ClearAllPoints()
				local previous = _G["StanceButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", buttonspacing, 0)
			end
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end

		end
		RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle] hide; show")
	elseif event == "UPDATE_SHAPESHIFT_FORMS" then

		if InCombatLockdown() then return end -- > just to be safe ;p
		for i = 1, NUM_STANCE_SLOTS do
			local button = _G["StanceButton"..i]
			local _, name = GetShapeshiftFormInfo(i)
			if name then
				button:Show()
			else
				button:Hide()
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		ShiftBarUpdate(self)
		StyleShift(self)
	else
		ShiftBarUpdate(self)
	end
end)

RegisterStateDriver(bar, "visibility", "[vehicleui][petbattle][overridebar] hide; show")