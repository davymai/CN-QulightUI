----------------------------------------------------------------------------------------
--	Move ObjectiveTrackerFrame
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame", "WatchFrameAnchor", UIParent)
frame:ClearAllPoints()
frame.ClearAllPoints = function() return end
frame:SetWidth(250)
frame:SetHeight(500)
frame:SetPoint("TOPRIGHT", AnchorWatchFrame)
frame.SetPoint = function() return end

ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, 0)
ObjectiveTrackerFrame:SetHeight(tonumber(string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")) / 1.6)

hooksecurefunc(ObjectiveTrackerFrame, "SetPoint", function(_, _, parent)
	if parent ~= frame then
		ObjectiveTrackerFrame:ClearAllPoints()
		ObjectiveTrackerFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, 0)
	end
end)

----------------------------------------------------------------------------------------
--	Skin ObjectiveTrackerFrame item buttons
----------------------------------------------------------------------------------------
hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	local item = block.itemButton

	if item and not item.skinned then
		item:SetSize(34, 34)
		item:SetNormalTexture(nil)
		CreateStyle(item, 3)

		item.icon:SetTexCoord(.08, .92, .08, .92)
		item.icon:SetPoint("TOPLEFT", item, 2, -2)
		item.icon:SetPoint("BOTTOMRIGHT", item, -2, 2)

		item.HotKey:ClearAllPoints()
		item.HotKey:SetPoint("BOTTOMRIGHT", 0, 2)
		item.HotKey:SetFont(Qulight["media"].font, 10, "OUTLINE")

		item.Count:ClearAllPoints()
		item.Count:SetPoint("TOPLEFT", 1, -1)
		item.Count:SetFont(Qulight["media"].font, 10, "OUTLINE")

		item.skinned = true
	end
end)

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	local header = ObjectiveTrackerFrame.BlocksFrame[headerName].Background:Hide()
end
	
	local button = ObjectiveTrackerFrame.HeaderMenu.MinimizeButton
	button:SetSize(17, 17)
	button.minus = button:CreateTexture(nil, "OVERLAY")
	button.minus:SetSize(5, 1)
	button.minus:SetTexCoord(.08, .92, .08, .92)
	button.minus:SetPoint("CENTER")
	button.minus:SetTexture("")

	button.plus = button:CreateTexture(nil, "OVERLAY")
	button.plus:SetSize(1, 5)
	button.plus:SetTexCoord(.08, .92, .08, .92)
	button.plus:SetPoint("CENTER")
	button.plus:SetTexture("")

	button:HookScript("OnEnter", SetModifiedBackdrop)
	button:HookScript("OnLeave", SetOriginalBackdrop)
	CreateBD(button, 4)
	

	button.plus:Hide()
	hooksecurefunc("ObjectiveTracker_Collapse", function()
	button.plus:Show()
end)
	hooksecurefunc("ObjectiveTracker_Expand", function()
	button.plus:Hide()
end)
	
----------------------------------------------------------------------------------------
--	Auto collapse ObjectiveTrackerFrame in instance
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	if IsInInstance() then
		ObjectiveTracker_Collapse()
	elseif ObjectiveTrackerFrame.collapsed and not InCombatLockdown() then
		ObjectiveTracker_Expand()
	end
end)