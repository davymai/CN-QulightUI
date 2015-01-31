if Qulight["general"].centerpanel then
if Qulight["datatext"].mastery and Qulight["datatext"].mastery > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = LeftUpInfoPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(Qulight["media"].font, 10, "OVERLAY")
	PP(Qulight["datatext"].mastery, Text)

	local int = 1
	
	local function Update(self, t)
		int = int - t
		if int < 0 then
			Text:SetText("Mastery: "..qColor..GetCombatRating(26).."|r")
			int = 1
		end
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end
end