local Stat = CreateFrame("Frame")
Stat:EnableMouse(true)
Stat:SetFrameStrata("BACKGROUND")
Stat:SetFrameLevel(3)
 
local Text = DataRightPanel:CreateFontString(nil, "OVERLAY")
Text:SetFont(Qulight["media"].font, 10,  "OVERLAY")
PP(Qulight["datatext"].specswitcher, Text)
 
local function Update(self)
	if not GetSpecialization() then
		Text:SetText(qColor.."No Talents:") 
	else
		local tree = GetSpecialization()
		local spec = select(2,GetSpecializationInfo(tree)) or ""
		Text:SetText(qColor.."Talents:|r "..spec.."|r")
	end
	self:SetAllPoints(Text)
end
 
Stat:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
Stat:RegisterEvent("CONFIRM_TALENT_WIPE")
Stat:RegisterEvent("PLAYER_TALENT_UPDATE")
Stat:SetScript("OnEvent", Update)
Stat:SetScript("OnMouseDown", function()
	local c = GetActiveSpecGroup(false,false)
	SetActiveSpecGroup(c == 1 and 2 or 1)
end)
