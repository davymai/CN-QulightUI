if not Qulight["actionbar"].enable == true then return end

local _G = _G
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

function StyleButton(self)
	local name = self:GetName()

	if name:match("MultiCast") then return end

	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
	local BtnBG = _G[name..'FloatingBG']

	Flash:SetTexture("")
	Button:SetNormalTexture("")

	if float then
		float:Hide()
		float = dummy
	end

	if Border then
		Border:Hide()
		Border = dummy
	end

	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 0, 2)
	Count:SetFont(Qulight["media"].pxfont, 12, "OUTLINE")

	if Btname then
		Btname:SetText("")
		Btname:Hide()
	end

	if not _G[name.."Panel"] then

		if self:GetHeight() ~= buttonsize and not InCombatLockdown() then --Taint fix for Flyout Buttons
			self:SetSize(buttonsize, buttonsize)
		end

		local panel = CreateFrame("Frame", name.."Panel", self)
		CreatePanel(panel, buttonsize, buttonsize, "CENTER", self, "CENTER", 0, 0)
		CreateStyle(panel, 2)
		panel:SetFrameStrata(self:GetFrameStrata())
		panel:SetFrameLevel(self:GetFrameLevel() - 1)

		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:SetPoint("TOPLEFT", Button, 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
	end

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 0, -3)
	HotKey:SetFont(Qulight["media"].pxfont, 12, "OUTLINE")
	HotKey.ClearAllPoints = dummy
	HotKey.SetPoint = dummy

	if not Qulight["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Hide()
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end

	if BtnBG then
		BtnBG:Hide()
	end
end
-- used to update pet bar buttons
QuPetBarUpdate = function(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)

		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end

		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)

		if PetActionBackdrop then
			PetActionBackdrop:SetBackdropBorderColor(0, 1, 0)
			end

			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked()

			if PetActionBackdrop then
				PetActionBackdrop:SetBackdropBorderColor(parent:GetBackdropBorderColor())
			end

			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end
		end

		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end

		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end

		-- grid display
		if name then
			if not Qulight["actionbar"].showgrid then
				petActionButton:SetAlpha(1)
			end
		else
			if not Qulight["actionbar"].showgrid then
				petActionButton:SetAlpha(0)
			end
		end

		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end

		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

local _G = _G
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local replace = string.gsub

function StyleActionBarButton(self)
	local name = self:GetName()

	if name:match("MultiCast") then return end

	if name:match("ExtraActionButton") then return end

	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]
	local BtnBG = _G[name..'FloatingBG']

	Flash:SetTexture("")
	Button:SetNormalTexture("")

	if Border then
		Border:Hide()
		Border = dummy
	end

	if float then
		float:Hide()
		float = dummy
	end

	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 0, 2)
	Count:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")

--[[默认动作条不显示宏名称
	if Btname then
		Btname:SetText("")
		Btname:Hide()
	end
 ]]
 --动作条显示宏名称开关
 	if Btname then
		if Qulight["actionbar"].macrotext ~= true then
      		Btname:SetText("")
      		Btname:Hide()
      		Btname.Show = dummy
   		end
	end

	if not _G[name.."Panel"] then

		if self:GetHeight() ~= buttonsize and not InCombatLockdown() then --Taint fix for Flyout Buttons
			self:SetSize(buttonsize, buttonsize)
		end

		local panel = CreateFrame("Frame", name.."Panel", self)
		CreatePanel(panel, buttonsize, buttonsize, "CENTER", self, "CENTER", 0, 0)
		CreateStyle(panel, 2)
		panel:SetFrameStrata(self:GetFrameStrata())
		panel:SetFrameLevel(self:GetFrameLevel() - 1)

		Icon:SetTexCoord(.08, .92, .08, .92)
		Icon:SetPoint("TOPLEFT", Button, 2, -2)
		Icon:SetPoint("BOTTOMRIGHT", Button, -2, 2)
	end

	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 0, 0)
	HotKey:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")
	HotKey.ClearAllPoints = dummy
	HotKey.SetPoint = dummy

	if not Qulight["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Hide()
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end

	if BtnBG then
		BtnBG:Hide()
	end
end

function StyleActionBarPetAndShiftButton(normal, button, icon, name, pet)
	button:SetNormalTexture("")

	button.SetNormalTexture = dummy

	local Flash	 = _G[name.."Flash"]
	Flash:SetTexture("")

	if not _G[name.."Panel"] then
		button:SetWidth(petbuttonsize)
		button:SetHeight(petbuttonsize)

		local panel = CreateFrame("Frame", name.."Panel", button)
		CreatePanel(panel, petbuttonsize, petbuttonsize, "CENTER", button, "CENTER", 0, 0)
		panel:SetFrameStrata(button:GetFrameStrata())
		panel:SetFrameLevel(button:GetFrameLevel() - 1)
		CreateStyle(panel, 2)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:ClearAllPoints()
		if pet then
			if petbuttonsize < 30 then
				local autocast = _G[name.."AutoCastable"]
				autocast:SetAlpha(0)
			end
			local shine = _G[name.."Shine"]
			shine:SetSize(petbuttonsize, petbuttonsize)
			shine:ClearAllPoints()
			shine:SetPoint("CENTER", button, 0, 0)
			icon:SetPoint("TOPLEFT", button, 2, -2)
			icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
		else
			icon:SetPoint("TOPLEFT", button, 2, -2)
			icon:SetPoint("BOTTOMRIGHT", button, -2, 2)
		end
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function StyleShift()
	for i=1, NUM_STANCE_SLOTS do
		local name = "StanceButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		StyleActionBarPetAndShiftButton(normal, button, icon, name)
	end
end

function StylePet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		StyleActionBarPetAndShiftButton(normal, button, icon, name, true)
	end
end

function UpdateActionBarHotKey(self, actionButtonType)
	local hotkey = _G[self:GetName().."HotKey"]
	local text = hotkey:GetText()

	text = string.gsub(text, "(s%-)", "S")
	text = string.gsub(text, "(a%-)", "A")
	text = string.gsub(text, "(à%-)", "A") -- fix ruRU
	text = string.gsub(text, "(c%-)", "C")
	text = string.gsub(text, "(Mouse Button )", "M")
	text = string.gsub(text, "(ÐšÐ½Ð¾Ð¿ÐºÐ° Ð¼Ñ‹ÑˆÐ¸ )", "M")
	text = string.gsub(text, KEY_BUTTON3, "M3")
	text = string.gsub(text, KEY_PAGEUP, "PU")
	text = string.gsub(text, KEY_PAGEDOWN, "PD")
	text = string.gsub(text, KEY_SPACE, "SpB")
	text = string.gsub(text, KEY_INSERT, "Ins")
	text = string.gsub(text, KEY_HOME, "Hm")
	text = string.gsub(text, KEY_DELETE, "Del")
	text = string.gsub(text, KEY_NUMPADDECIMAL, "Nu.")
	text = string.gsub(text, KEY_NUMPADDIVIDE, "Nu/")
	text = string.gsub(text, KEY_NUMPADMINUS, "Nu-")
	text = string.gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
	text = string.gsub(text, KEY_NUMPADPLUS, "Nu+")
	text = string.gsub(text, KEY_NUMLOCK, "NuL")
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, "MWD")
	text = string.gsub(text, KEY_MOUSEWHEELUP, "MWU")

	if hotkey:GetText() == _G["RANGE_INDICATOR"] then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

local buttonNames = { "ActionButton",  "MultiBarBottomLeftButton", "MultiBarBottomRightButton", "MultiBarLeftButton", "MultiBarRightButton", "StanceButton", "PetActionButton", "MultiCastActionButton"}
for _, name in ipairs( buttonNames ) do
	for index = 1, 12 do
		local buttonName = name .. tostring(index)
		local button = _G[buttonName]
		local cooldown = _G[buttonName .. "Cooldown"]

		if ( button == nil or cooldown == nil ) then
			break
		end

		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
	end
end

local buttons = 0
local function SetupFlyoutButton()
	for i = 1, buttons do
		if _G["SpellFlyoutButton"..i] then
			StyleActionBarButton(_G["SpellFlyoutButton"..i])
			StyleButton(_G["SpellFlyoutButton"..i])

			if _G["SpellFlyoutButton"..i]:GetChecked() then
				_G["SpellFlyoutButton"..i]:SetChecked(false)
			end
		end
	end
end
SpellFlyout:HookScript("OnShow", SetupFlyoutButton)

function StyleActionBarFlyout(self)
	if not self.FlyoutArrow then return end

	self.FlyoutBorder:SetAlpha(0)
	self.FlyoutBorderShadow:SetAlpha(0)

	SpellFlyoutHorizontalBackground:SetAlpha(0)
	SpellFlyoutVerticalBackground:SetAlpha(0)
	SpellFlyoutBackgroundEnd:SetAlpha(0)

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			buttons = numSlots
			break
		end
	end

	local arrowDistance
	if ((SpellFlyout and SpellFlyout:IsShown() and SpellFlyout:GetParent() == self) or GetMouseFocus() == self) then
		arrowDistance = 5
	else
		arrowDistance = 2
	end

	if self:GetParent():GetParent():GetName() == "SpellBookSpellIconsFrame" then return end

	if self:GetAttribute("flyoutDirection") ~= nil then
		local SetPoint, _, _, _, _ = self:GetParent():GetParent():GetPoint()

		if strfind(SetPoint, "BOTTOM") then
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("TOP", self, "TOP", 0, arrowDistance)
			SetClampedTextureRotation(self.FlyoutArrow, 0)
		else
			self.FlyoutArrow:ClearAllPoints()
			self.FlyoutArrow:SetPoint("LEFT", self, "LEFT", -arrowDistance, 0)
			SetClampedTextureRotation(self.FlyoutArrow, 270)
		end
	end
end
local function StyleButton123(button)
	if button.SetHighlightTexture and not button.hover then
		local hover = button:CreateTexture("frame", nil, self)
		hover:SetTexture(1, 1, 1, 0.3)
		hover:SetPoint("TOPLEFT", 2, -2)
		hover:SetPoint("BOTTOMRIGHT", -2, 2)
		button.hover = hover
		button:SetHighlightTexture(hover)
	end

	if button.SetPushedTexture and not button.pushed then
		local pushed = button:CreateTexture("frame", nil, self)
		pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
		pushed:SetPoint("TOPLEFT", 2, -2)
		pushed:SetPoint("BOTTOMRIGHT", -2, 2)
		button.pushed = pushed
		button:SetPushedTexture(pushed)
	end

	if button.SetCheckedTexture and not button.checked then
		local checked = button:CreateTexture("frame", nil, self)
		checked:SetTexture(0,1,0,1)
		checked:SetPoint("TOPLEFT", 2, -2)
		checked:SetPoint("BOTTOMRIGHT", -2, 2)
		checked:SetAlpha(0.4)
		button.checked = checked
		button:SetCheckedTexture(checked)
	end

	local cooldown = button:GetName() and _G[button:GetName().."Cooldown"]
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:SetPoint("TOPLEFT", 2, -2)
		cooldown:SetPoint("BOTTOMRIGHT", -2, 2)
	end
end

do
	for i = 1, 12 do
		StyleButton123(_G["ActionButton"..i], true)
		StyleButton123(_G["MultiBarBottomLeftButton"..i],true)
		StyleButton123(_G["MultiBarBottomRightButton"..i],true)
		StyleButton123(_G["MultiBarLeftButton"..i],true)
		StyleButton123(_G["MultiBarRightButton"..i],true)
	end

	for i=1, 10 do
		StyleButton123(_G["StanceButton"..i], true)
		StyleButton123(_G["PetActionButton"..i], true)
	end
end

hooksecurefunc("ActionButton_Update", StyleActionBarButton)
hooksecurefunc("ActionButton_UpdateHotkeys", UpdateActionBarHotKey)
hooksecurefunc("ActionButton_UpdateFlyout", StyleActionBarFlyout)
hooksecurefunc("ActionButton_OnEvent", function(self, event, ...) if event == "PLAYER_ENTERING_WORLD" then ActionButton_UpdateHotkeys(self, self.buttonType) end end)

if not myclass == "SHAMAN" then return end

SLOT_EMPTY_TCOORDS = {
	[EARTH_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 3 / 256,
		bottom	= 33 / 256,
	},
	[FIRE_TOTEM_SLOT] = {
		left	= 67 / 128,
		right	= 97 / 128,
		top		= 100 / 256,
		bottom	= 130 / 256,
	},
	[WATER_TOTEM_SLOT] = {
		left	= 39 / 128,
		right	= 69 / 128,
		top		= 209 / 256,
		bottom	= 239 / 256,
	},
	[AIR_TOTEM_SLOT] = {
		left	= 66 / 128,
		right	= 96 / 128,
		top		= 36 / 256,
		bottom	= 66 / 256,
	},
}

local function StyleTotemFlyout(flyout)
	flyout.top:SetTexture(nil)
	flyout.middle:SetTexture(nil)

	local last = nil

	for _,button in ipairs(flyout.buttons) do
		CreateStyle(button, 2)
		local icon = select(1,button:GetRegions())
		icon:SetTexCoord(.09,.91,.09,.91)
		icon:SetDrawLayer("ARTWORK")
		icon:SetPoint("TOPLEFT",button,"TOPLEFT",2,-2)
		icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
		if not InCombatLockdown() then
			button:SetSize(30,30)
			button:ClearAllPoints()
			button:SetPoint("BOTTOM",last,"TOP",0,4)
		end
		if button:IsVisible() then last = button end
		button:SetBackdropBorderColor(flyout.parent:GetBackdropBorderColor())
		StyleButton(button)
	end

	flyout.buttons[1]:SetPoint("BOTTOM",flyout,"BOTTOM")

	if flyout.type == "slot" then
		local tcoords = SLOT_EMPTY_TCOORDS[flyout.parent:GetID()]
		flyout.buttons[1].icon:SetTexCoord(tcoords.left,tcoords.right,tcoords.top,tcoords.bottom)
	end

	local close = MultiCastFlyoutFrameCloseButton
	CreateStyle(close, 2)
	close:GetHighlightTexture():SetTexture([[Interface\Buttons\ButtonHilight-Square]])
	close:GetHighlightTexture():SetPoint("TOPLEFT",close,"TOPLEFT",1,-1)
	close:GetHighlightTexture():SetPoint("BOTTOMRIGHT",close,"BOTTOMRIGHT",-1,1)
	close:GetNormalTexture():SetTexture(nil)
	close:ClearAllPoints()
	close:SetPoint("BOTTOMLEFT",last,"TOPLEFT",0,4)
	close:SetPoint("BOTTOMRIGHT",last,"TOPRIGHT",0,4)
	close:SetHeight(8)

	close:SetBackdropBorderColor(last:GetBackdropBorderColor())
	flyout:ClearAllPoints()
	flyout:SetPoint("BOTTOM",flyout.parent,"TOP",0,4)
end
hooksecurefunc("MultiCastFlyoutFrame_ToggleFlyout",function(self) StyleTotemFlyout(self) end)

local function StyleTotemOpenButton(button, parent)
	button:GetHighlightTexture():SetTexture(nil)
	button:GetNormalTexture():SetTexture(nil)
	button:SetHeight(20)
	button:ClearAllPoints()
	button:SetPoint("BOTTOMLEFT", parent, "TOPLEFT", 0, -3)
	button:SetPoint("BOTTOMRIGHT", parent, "TOPRIGHT", 0, -3)
	if not button.visibleBut then
		button.visibleBut = CreateFrame("Frame",nil,button)
		button.visibleBut:SetHeight(8)
		button.visibleBut:SetWidth(button:GetWidth() + 2)
		button.visibleBut:SetPoint("CENTER")
		button.visibleBuhighlight = button.visibleBut:CreateTexture(nil,"HIGHLIGHT")
		button.visibleBuhighlight:SetTexture([[Interface\Buttons\ButtonHilight-Square]])
		button.visibleBuhighlight:SetPoint("TOPLEFT",button.visibleBut,"TOPLEFT",1,-1)
		button.visibleBuhighlight:SetPoint("BOTTOMRIGHT",button.visibleBut,"BOTTOMRIGHT",-1,1)
		CreateStyle(button.visibleBut, 2)
	end

	button.visibleBut:SetBackdropBorderColor(parent:GetBackdropBorderColor())
end
hooksecurefunc("MultiCastFlyoutFrameOpenButton_Show",function(button,_, parent) StyleTotemOpenButton(button, parent) end)

local bordercolors = {
	{.23,.45,.13},   -- Earth
	{.58,.23,.10},   -- Fire
	{.19,.48,.60},   -- Water
	{.42,.18,.74},   -- Air
}

local function StyleTotemSlotButton(button, index)
	CreateStyle(button, 2)
	button.overlayTex:SetTexture(nil)
	button.background:SetDrawLayer("ARTWORK")
	button.background:ClearAllPoints()
	button.background:SetPoint("TOPLEFT",button,"TOPLEFT",2,-2)
	button.background:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	if not InCombatLockdown() then button:SetSize(30,30) end
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	StyleButton(button)
end
hooksecurefunc("MultiCastSlotButton_Update",function(self, slot) StyleTotemSlotButton(self,tonumber( string.match(self:GetName(),"MultiCastSlotButton(%d)"))) end)

local function StyleTotemActionButton(button, index)
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:SetPoint("TOPLEFT",button,"TOPLEFT",2,-2)
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	button.overlayTex:SetTexture(nil)
	button.overlayTex:Hide()
	button:GetNormalTexture():SetTexCoord(0,0,0,0)
	if not InCombatLockdown() and button.slotButton then
		button:ClearAllPoints()
		button:SetAllPoints(button.slotButton)
		button:SetFrameLevel(button.slotButton:GetFrameLevel()+1)
	end
	button:SetBackdropBorderColor(unpack(bordercolors[((index-1) % 4) + 1]))
	button:SetBackdropColor(0,0,0,0)
	StyleButton(button, true)
end
hooksecurefunc("MultiCastActionButton_Update",function(actionButton, actionId, actionIndex, slot) StyleTotemActionButton(actionButton,actionIndex) end)

local function StyleTotemSpellButton(button, index)
	if not button then return end
	local icon = select(1,button:GetRegions())
	icon:SetTexCoord(.09,.91,.09,.91)
	icon:SetDrawLayer("ARTWORK")
	icon:SetPoint("TOPLEFT",button,"TOPLEFT",2,-2)
	icon:SetPoint("BOTTOMRIGHT",button,"BOTTOMRIGHT",-2,2)
	CreateStyle(button, 2)
	button:GetNormalTexture():SetTexture(nil)
	if not InCombatLockdown() then button:SetSize(30, 30) end
	_G[button:GetName().."Highlight"]:SetTexture(nil)
	_G[button:GetName().."NormalTexture"]:SetTexture(nil)
	StyleButton(button)
end
hooksecurefunc("MultiCastSummonSpellButton_Update", function(self) StyleTotemSpellButton(self,0) end)
hooksecurefunc("MultiCastRecallSpellButton_Update", function(self) StyleTotemSpellButton(self,5) end)

------------------------------------------------------------------------------------------
--	Make ExtraActionBarFrame movable(use macro /click ExtraActionButton1)
------------------------------------------------------------------------------------------
AnchorExtraActionBar = CreateFrame("Frame","Move_ExtraActionBar",UIParent)
AnchorExtraActionBar:SetPoint("BOTTOM", 172, 380)
CreateAnchor(AnchorExtraActionBar, "Move ExtraActionBar", 40, 40)

ExtraActionBarFrame:SetParent(UIParent)
ExtraActionBarFrame:ClearAllPoints()
ExtraActionBarFrame:SetPoint("CENTER", AnchorExtraActionBar, "CENTER")
DraenorZoneAbilityFrame:SetParent(UIParent)
DraenorZoneAbilityFrame:ClearAllPoints()
DraenorZoneAbilityFrame:SetPoint('CENTER', AnchorExtraActionBar, 'CENTER')
--DraenorZoneAbilityFrame:SetScript("OnShow", DraenorZoneAbilityFrame.Hide)
DraenorZoneAbilityFrame.ignoreFramePositionManager = true

------------------------------------------------------------------------------------------
--	Skin ExtraActionBarFrame(by Zork)
------------------------------------------------------------------------------------------
local button = ExtraActionButton1
local texture = button.style
local icon = button.icon
local disableTexture = function(style, texture)
	if texture then
		style:SetTexture(nil)
	end
end
icon:SetTexCoord(.08, .92, .08, .92)
icon:SetPoint("TOPLEFT", button, 2,-2)
icon:SetPoint("BOTTOMRIGHT", button, -2,2)
button.style:SetTexture(nil)
hooksecurefunc(texture, "SetTexture", disableTexture)
StyleButton(button, true)

local button = DraenorZoneAbilityFrame.SpellButton
local texture = button.Style
local disableTexture = function(style, texture)
	if texture then
		style:SetTexture(nil)
	end
end
button:SetSize(40,40)
button.Icon:SetTexCoord(.08, .92, .08, .92)
button.Icon:SetPoint("TOPLEFT", button, 2,-2)
button.Icon:SetPoint("BOTTOMRIGHT", button, -2,2)
button.Style:SetTexture(nil)
hooksecurefunc(texture, "SetTexture", disableTexture)