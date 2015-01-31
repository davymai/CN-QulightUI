
if not Qulight["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup PetActionBar
---------------------------------------------------------------------------

local bar = QuPetBar
local link = QuLineToPetActionBarBackground
link:SetAlpha(0)
bar:SetAlpha(1)

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_CONTROL_LOST")
bar:RegisterEvent("PLAYER_CONTROL_GAINED")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
bar:RegisterEvent("PET_BAR_UPDATE")
bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
bar:RegisterEvent("PET_BAR_HIDE")
bar:RegisterEvent("UNIT_PET")
bar:RegisterEvent("UNIT_FLAGS")
bar:RegisterEvent("UNIT_AURA")
bar:SetScript("OnEvent", function(self, event, arg1)
	if event == "PLAYER_LOGIN" then
		PetActionBarFrame.showgrid = 1

		local button
		for i = 1, 10 do
			button = _G["PetActionButton"..i]
			button:ClearAllPoints()
			button:SetParent(QuPetBar)

			button:SetSize(petbuttonsize, petbuttonsize)
			if i == 1 then
				button:SetPoint("TOPLEFT", buttonspacing,-buttonspacing)
			else
				button:SetPoint("LEFT", _G["PetActionButton"..(i - 1)], "RIGHT", buttonspacing, 0)
			end
			button:Show()
			self:SetAttribute("addchild", button)
		end
		RegisterStateDriver(self, "visibility", "[pet,novehicleui,nopossessbar,nopetbattle] show; hide")
		hooksecurefunc("PetActionBar_Update", QuPetBarUpdate)
	elseif event == "PET_BAR_UPDATE" or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED"
	or event == "UNIT_FLAGS" or (event == "UNIT_PET" and arg1 == "player") or (arg1 == "pet" and event == "UNIT_AURA") then
		QuPetBarUpdate()
	elseif event == "PET_BAR_UPDATE_COOLDOWN" then
		PetActionBar_UpdateCooldowns()
	else
		StylePet()
	end
end)