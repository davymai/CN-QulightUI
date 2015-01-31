local _
CreateFrame("GameTooltip", "LilSparkyDataScanTooltip", UIParent, "GameTooltipTemplate")
LilSparkyDataScanTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function FixedGetTradeSkillReagentItemLink(i,j)
    local tooltip = LilSparkyDataScanTooltip
    tooltip:ClearLines()
    tooltip:SetTradeSkillItem(i,j)
    local _, reagentLink = tooltip:GetItem()
    return reagentLink
end

local function new_Click(self)
    HandleModifiedItemClick(FixedGetTradeSkillReagentItemLink(TradeSkillFrame.selectedSkill, self:GetID()));
end

local function OnEvent(self, event, AddOn)
    if AddOn == "Blizzard_TradeSkillUI" then
		for i = 1, 8 do
			_G["TradeSkillReagent" .. i]:HookScript("OnClick", new_Click)
		end
   end
end

CustomTradeFrame = CreateFrame("Frame", "CustomTradeFrame", UIParent)

if (IsAddOnLoaded"Blizzard_TradeSkillUI") then
    OnEvent(CustomTradeFrame, "ADDON_LOADED", "Blizzard_TradeSkillUI")
else
    CustomTradeFrame:RegisterEvent("ADDON_LOADED")
	CustomTradeFrame:SetScript("OnEvent", OnEvent)
end

local incombat = CreateFrame("Frame")
incombat:RegisterEvent("PLAYER_REGEN_DISABLED")
incombat:RegisterEvent("PLAYER_REGEN_ENABLED")
incombat:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_REGEN_DISABLED" then
		AlertFrame:UnregisterEvent("GARRISON_MISSION_FINISHED")
	else
		AlertFrame:RegisterEvent("GARRISON_MISSION_FINISHED")
	end
	
	--self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	--self:UnregisterEvent("PLAYER_REGEN_ENABLED")
end)


