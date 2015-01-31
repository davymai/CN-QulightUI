if Qulight["general"].centerpanel then
if Qulight["datatext"].haste and Qulight["datatext"].haste > 0 then

	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = RightUpInfoPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(Qulight["media"].font, 10, "OVERLAY")
	PP(Qulight["datatext"].haste, Text)

	local int = 1

	local function Update(self, t)
		
		local playerint = select(2, UnitStat("player", 4));
		local playeragi	= select(2, UnitStat("player", 2));
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;
		local spellhaste = UnitSpellHaste("player")
		local rangedhaste = GetRangedHaste()
		local attackhaste = GetMeleeHaste()
		
		if (playerap < playerint) or (playeragi < playerint) then
			haste = spellhaste
		elseif select(2, UnitClass("Player")) == "HUNTER" then
			haste = rangedhaste
		else
			haste = attackhaste
		end
		
		int = int - t

		if int < 0 then
			Text:SetText("Haste: ".."|r"..qColor..format("%.2f", haste).. "% |r")
			int = 1
		end     
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end
end
