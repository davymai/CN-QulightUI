if Qulight["general"].centerpanel then
if Qulight["datatext"].power and Qulight["datatext"].power > 0 then
	local Stat = CreateFrame("Frame")
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = LeftUpInfoPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(Qulight["media"].font, 10, "OVERLAY")
	PP(Qulight["datatext"].power, Text)

	local int = 1

	local function Update(self, t)
		int = int - t
		local base, posBuff, negBuff = UnitAttackPower("player")
		local effective = base + posBuff + negBuff
		local Rbase, RposBuff, RnegBuff = UnitRangedAttackPower("player")
		local Reffective = Rbase + RposBuff + RnegBuff


		healpwr = GetSpellBonusHealing()

		Rattackpwr = Reffective
		spellpwr2 = GetSpellBonusDamage(7)
		attackpwr = effective

		if healpwr > spellpwr2 then
			spellpwr = healpwr
		else
			spellpwr = spellpwr2
		end

		if attackpwr > spellpwr and select(2, UnitClass("Player")) ~= "HUNTER" then
			pwr = attackpwr
			tp_pwr = "Attack Power"
		elseif select(2, UnitClass("Player")) == "HUNTER" then
			pwr = Reffective
			tp_pwr = "RAP"
		else
			pwr = spellpwr
			tp_pwr = "Spell Power"
		end
		if int < 0 then
			Text:SetText(tp_pwr..": |r"..qColor..pwr.. "|r")      
			int = 1
		end
	end

	Stat:SetScript("OnUpdate", Update)
	Update(Stat, 10)
end
end