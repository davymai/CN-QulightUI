if not Qulight["addonskins"].CoolLine == true then return end

----------------------------------------------------------------------------------------
--	CoolLine skin
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addon)
	if not IsAddOnLoaded("CoolLine") then return end

	CoolLineDB.border = "None"
	CoolLineDB.bgcolor.a = 0
	--CoolLineDB.inactivealpha = 1
	--CoolLineDB.activealpha = 1
	CoolLineDB.inactivealpha = .45
	CoolLineDB.activealpha = .8
	CoolLineDB.font = "Hooge"
	CoolLineDB.fontsize = Qulight["media"].fontsize
	--CoolLineDB.w = (Qulight["actionbar"].buttonsize * 8) + (Qulight["actionbar"].buttonspacing * 7) - 4
	--CoolLineDB.h = Qulight["actionbar"].buttonsize - 18
	CoolLineDB.w = (Qulight["actionbar"].buttonsize * 12) + (Qulight["actionbar"].buttonspacing * 13) - 4
	CoolLineDB.h = Qulight["actionbar"].buttonsize - 12

	local CoolLineBar = CreateFrame("Frame", "CoolLineBar", CoolLine)
	CoolLineBar:SetPoint("TOPLEFT", CoolLine, "TOPLEFT", -2, 2)
	CoolLineBar:SetPoint("BOTTOMRIGHT", CoolLine, "BOTTOMRIGHT", 2, -2)
	CreateStyle(CoolLineBar, 2)
	CoolLineBar:SetFrameStrata("BACKGROUND")
end)