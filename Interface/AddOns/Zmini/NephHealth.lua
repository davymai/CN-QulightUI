local myFrame = CreateFrame("Frame", "NephHealthFrame", UIParent)
myFrame:SetAllPoints() 
myFrame:SetFrameStrata("BACKGROUND")
myFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
myFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...); end)

local warningTexture = myFrame:CreateTexture(nil, "BACKGROUND")
warningTexture:SetTexture("Interface\\FullScreenTextures\\LowHealth")
warningTexture:SetAllPoints(myFrame)
warningTexture:SetBlendMode("ADD")
myFrame.texture = warningTexture

local showWarning = false
myFrame:Hide()

function NephHealthFrame:UNIT_HEALTH(_, arg1)
	if UnitIsDeadOrGhost("player") then
		if showWarning then
			showWarning = false
			myFrame:Hide()
		end
	else
		local lowHealth = (UnitHealth("player") / UnitHealthMax("player") < 0.25)
		if lowHealth and not showWarning then
			showWarning = true
			myFrame:Show()
			PlaySoundFile("Sound\\interface\\RaidWarning.wav")
		elseif not lowHealth and showWarning then
			showWarning = false
			myFrame:Hide()
		end
	end
end

