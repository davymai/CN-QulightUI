
----------------------------------------------------------------------------------------
--	Dominos skin
----------------------------------------------------------------------------------------

CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = Qulight["media"].texture,
		edgeFile = Qulight["media"].texture,
		edgeSize = 1,
	})
	f:SetBackdropColor(.05,.05,.05, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(C.frames, f) end
end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	
	local b = CreateFrame("Frame", nil, f)
	b:SetPoint("TOPLEFT", -2, 2)
	b:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateBD(b)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end

function StyleButton(self)
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addon)
	if not IsAddOnLoaded("Dominos") then return end

	local function StyleNormalButton(self)
	
		local name = self:GetName()
		
		local button = self
		local icon = _G[name.."Icon"]
		local count = _G[name.."Count"]
		local flash = _G[name.."Flash"]
		local hotkey = _G[name.."HotKey"]
		local border = _G[name.."Border"]
		local btname = _G[name.."Name"]
		local normal = _G[name.."NormalTexture"]

		flash:SetTexture("")
		button:SetNormalTexture("")
		
		if border then
			border:Hide()
			border = dummy
		end

		if count then
			count:ClearAllPoints()
			count:SetPoint("BOTTOMRIGHT", 0, 2)
			count:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")
			count:SetShadowOffset(1, -1)
		end

		if btname then
			btname:ClearAllPoints()
			btname:SetPoint("BOTTOM", 0, 0)
			btname:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")
			btname:SetShadowOffset(1, -1)
		end

		if hotkey then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("TOPRIGHT", 2, 0)
			hotkey:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")
			hotkey:SetShadowOffset(1, -1)
			hotkey:SetWidth(button:GetWidth() - 1)
		end

		if not button.isSkinned then
			CreateBackdrop(button)
			button.backdrop:SetAllPoints()
			CreateStyle(button, 3, 0)
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:SetPoint("TOPLEFT", button, 1, -1)
			icon:SetPoint("BOTTOMRIGHT", button, -1, 1)

			button.isSkinned = true
		end

		if normal then
			normal:ClearAllPoints()
			normal:SetPoint("TOPLEFT")
			normal:SetPoint("BOTTOMRIGHT")
		end
		
		if button.SetHighlightTexture and not button.hover then
			local hover = button:CreateTexture("frame", nil, self)
			hover:SetTexture(1, 1, 1, 0.3)
			hover:SetPoint("TOPLEFT", 1, -1)
			hover:SetPoint("BOTTOMRIGHT", -1, 1)
			button.hover = hover
			button:SetHighlightTexture(hover)
		end

		if button.SetPushedTexture and not button.pushed then
			local pushed = button:CreateTexture("frame", nil, self)
			pushed:SetTexture(0.9, 0.8, 0.1, 0.3)
			pushed:SetPoint("TOPLEFT", 1, -1)
			pushed:SetPoint("BOTTOMRIGHT", -1, 1)
			button.pushed = pushed
			button:SetPushedTexture(pushed)
		end

		if button.SetCheckedTexture and not button.checked then
			local checked = button:CreateTexture("frame", nil, self)
			checked:SetTexture(0,1,0,1)
			checked:SetPoint("TOPLEFT", 1, -1)
			checked:SetPoint("BOTTOMRIGHT", -1, 1)
			checked:SetAlpha(0.4)
			button.checked = checked
			button:SetCheckedTexture(checked)
		end
	end

	local function StyleSmallButton(button, icon, name, hotkey, pet)
		if not button then return end
		local flash = _G[name.."Flash"]
		
		StyleButton(button)
		CreateStyle(button, 3, 0)
		button:SetNormalTexture("")
		button.SetNormalTexture = dummy
		
		if flash then
			flash:SetTexture(0.8, 0.8, 0.8, 0.5)
			flash:SetPoint("TOPLEFT", button, 1, -1)
			flash:SetPoint("BOTTOMRIGHT", button, -1, 1)
		end

		if hotkey then
			hotkey:ClearAllPoints()
			hotkey:SetPoint("TOPRIGHT", 0, 0)
			hotkey:SetFont(Qulight["media"].pxfont, 10, "OUTLINE")
			hotkey:SetShadowOffset(1, -1)
			hotkey:SetWidth(button:GetWidth() - 1)
		end

		if not button.isSkinned then
			CreateBackdrop(button)
			button.backdrop:SetAllPoints()

			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", button, 1, -1)
			icon:SetPoint("BOTTOMRIGHT", button, -1, 1)
			
			if pet then
				local autocast = _G[name.."AutoCastable"]
				autocast:SetSize((button:GetWidth() * 2) - 10, (button:GetWidth() * 2) - 10)
				autocast:ClearAllPoints()
				autocast:SetPoint("CENTER", button, 0, 0)

				local shine = _G[name.."Shine"]
				shine:SetSize(button:GetWidth(), button:GetWidth())

				local cooldown = _G[name.."Cooldown"]
				cooldown:SetSize(button:GetWidth() - 2, button:GetWidth() - 2)
			end

			button.isSkinned = true
		end	
		
		
	end

	do
		for i = 1, 60 do
			StyleButton(_G["DominosActionButton"..i])
		end

		for i = 1, 12 do
			StyleButton(_G["ActionButton"..i])
			StyleButton(_G["MultiBarBottomLeftButton"..i])
			StyleButton(_G["MultiBarBottomRightButton"..i])
			StyleButton(_G["MultiBarLeftButton"..i])
			StyleButton(_G["MultiBarRightButton"..i])
		end

		for i = 1, NUM_STANCE_SLOTS do
			local name = "DominosClassButton"..i
			local button = _G[name]
			local icon = _G[name.."Icon"]
			local hotkey = _G[name.."HotKey"]
			StyleSmallButton(button, icon, name, hotkey)
		end

		for i = 1, NUM_PET_ACTION_SLOTS do
			local name = "PetActionButton"..i
			local button = _G[name]
			local icon = _G[name.."Icon"]
			local hotkey = _G[name.."HotKey"]
			StyleSmallButton(button, icon, name, hotkey, true)
		end
	end
	
	hooksecurefunc("ActionButton_Update", StyleNormalButton)
	hooksecurefunc("ActionButton_UpdateFlyout", StyleActionBarFlyout)
	
end)

local buttons = 0
local function SetupFlyoutButton()
	for i = 1, buttons do
		if _G["SpellFlyoutButton"..i] then
			StyleButton(_G["SpellFlyoutButton"..i])
			CreateStyle(_G["SpellFlyoutButton"..i], 3, 0)
			if _G["SpellFlyoutButton"..i]:GetChecked() then
				_G["SpellFlyoutButton"..i]:SetChecked(nil)
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
	
	
	if self:GetAttribute("flyoutDirection") ~= nil then
		local SetPoint, _, _, _, _ = self:GetParent():GetParent():GetPoint()
		
		
	end
end