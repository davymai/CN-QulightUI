if not Qulight["actionbar"].enable == true then return end

if not Qulight["actionbar"].enable == true then
	QuPetBar:Hide()
	QuBar5:Hide()
	QuBar6:Hide()
	QuBar7:Hide()
	return
end

---------------------------------------------------------------------------
-- Manage all others stuff for actionbars
---------------------------------------------------------------------------

local QuOnLogon = CreateFrame("Frame")
QuOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
QuOnLogon:SetScript("OnEvent", function(self, event)	
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	local installed = QulightDataPerChar.install
	if installed then
		local b1, b2, b3, b4 = GetActionBarToggles()
		if (not b1 or not b2 or not b3 or not b4) then
			SetActionBarToggles(1, 1, 1, 1)
			StaticPopup_Show("Qu_FIX_AB")
		end
	end
	
	if Qulight["actionbar"].showgrid == true then
		ActionButton_HideGrid = dummy
		for i = 1, 12 do
			local button = _G[format("ActionButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			
			
			button = _G[format("MultiBarRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)

			button = _G[format("MultiBarBottomRightButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
			
			button = _G[format("MultiBarBottomLeftButton%d", i)]
			button:SetAttribute("showgrid", 1)
			ActionButton_ShowGrid(button)
		end
	end
end)
