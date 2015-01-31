--------------------------------------------------------------------
-- DURABILITY
--------------------------------------------------------------------
localSlots = {
	[1] = {1, "头部", 1000},
	[2] = {3, "肩部", 1000},
	[3] = {5, "胸甲", 1000},
	[4] = {6, "腰带", 1000},
	[5] = {9, "护腕", 1000},
	[6] = {10, "手套", 1000},
	[7] = {7, "腿部", 1000},
	[8] = {8, "靴子", 1000},
	[9] = {16, "主手武器", 1000},
	[10] = {17, "副手武器", 1000},
	[11] = {18, "远程武器", 1000}
}

if Qulight["datatext"].Durability and Qulight["datatext"].Durability > 0 then
	local Stat = CreateFrame("Frame")
	Stat:EnableMouse(true)
	Stat:SetFrameStrata("BACKGROUND")
	Stat:SetFrameLevel(3)

	local Text  = DataLeftPanel:CreateFontString(nil, "OVERLAY")
	Text:SetFont(Qulight["media"].font, 10, "OVERLAY")
	PP(Qulight["datatext"].Durability, Text)

	local Total = 0
	local current, max

	local function OnEvent(self)
		for i = 1, 11 do
			if GetInventoryItemLink("player", localSlots[i][1]) ~= nil then
				current, max = GetInventoryItemDurability(localSlots[i][1])
				if current then
					localSlots[i][3] = current/max
					Total = Total + 1
				end
			end
		end
		table.sort(localSlots, function(a, b) return a[3] < b[3] end)

		if Total > 0 then
			Text:SetText("耐久度: "..qColor..floor(localSlots[1][3]*100).."%" )
		else
			Text:SetText("耐久度: "..qColor..": 100%".."Armor")
		end
		-- Setup Durability Tooltip
		self:SetAllPoints(Text)
		self:SetScript("OnEnter", function()

				GameTooltip:SetOwner(self, "ANCHOR_TOP", -20, 6);
				GameTooltip:ClearAllPoints()
				GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, 1)
				GameTooltip:ClearLines()
				for i = 1, 11 do
					if localSlots[i][3] ~= 1000 then
						green = localSlots[i][3]*2
						red = 1 - green
						GameTooltip:AddDoubleLine(localSlots[i][2], floor(localSlots[i][3]*100).."%",1 ,1 , 1, red + 1, green, 0)
					end
				end
				GameTooltip:Show()

		end)
		self:SetScript("OnLeave", function() GameTooltip:Hide() end)
		Total = 0
	end

	Stat:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
	Stat:RegisterEvent("MERCHANT_SHOW")
	Stat:RegisterEvent("PLAYER_ENTERING_WORLD")
	Stat:SetScript("OnMouseDown", function() ToggleCharacter("PaperDollFrame") end)
	Stat:SetScript("OnEvent", OnEvent)
end