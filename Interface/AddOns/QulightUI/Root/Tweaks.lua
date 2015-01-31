----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------
local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, _, isHeader = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("["..level.."] "..title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

----------------------------------------------------------------------------------------
-- Clear UIErrors frame(ncError by Nightcracker)
----------------------------------------------------------------------------------------
if Qulight["general"].BlizzardsErrorFrameHiding then
	local f, o, ncErrorDB = CreateFrame("Frame"), "No error ye", {
		["Inventory is full"] = true,
	}
	f:SetScript("OnEvent", function(self, event, error)
		if ncErrorDB[error] then
			UIErrorsFrame:AddMessage(error)
		else
		o = error
		end
	end)
	SLASH_NCERROR1 = "/error"
	function SlashCmdLisNCERROR() print(o) end
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE")
	f:RegisterEvent("UI_ERROR_MESSAGE")
end
----------------------------------------------------------------------------------------
-- Auto greed on green items(by Tekkub)
----------------------------------------------------------------------------------------
if Qulight["general"].AutoGreed  then
	local agog = CreateFrame("Frame", nil, UIParent)
	agog:RegisterEvent("START_LOOT_ROLL")
	agog:SetScript("OnEvent", function(_, _, id)
	if not id then return end 
	local _, _, _, quality, bop, _, _, canDE = GetLootRollItemInfo(id)
	if quality == 2 and not bop then RollOnLoot(id, canDE and 3 or 2) end
	end)
end
----------------------------------------------------------------------------------------
-- Disenchant confirmation(tekKrush by Tekkub)
----------------------------------------------------------------------------------------
if Qulight["general"].AutoDisenchant then
	local acd = CreateFrame("Frame")
	acd:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	acd:SetScript("OnEvent", function(self, event, id, rollType)
		for i=1,STATICPOPUP_NUMDIALOGS do
			local frame = _G["StaticPopup"..i]
			if frame.which == "CONFIRM_LOOT_ROLL" and frame.data == id and frame.data2 == rollType and frame:IsVisible() then StaticPopup_OnClick(frame, 1) end
		end
	end)
	
	StaticPopupDialogs["LOOT_BIND"].OnCancel = function(self, slot)
	if GetNumPartyMembers() == 0 and GetNumRaidMembers() == 0 then ConfirmLootSlot(slot) end
	end
end
----------------------------------------------------------------------------------------
-- Universal Mount macro : /script Mountz ("your_ground_mount","your_flying_mount") 
----------------------------------------------------------------------------------------
function Mountz(groundmount, flyingmount, underwatermount)
	local flyablex, swimablex, vjswim, InVj, nofly
	local num = C_MountJournal.GetNumMounts()
	if not num or IsMounted() then
		Dismount()
		return
	end
	if CanExitVehicle() then
		VehicleExit()
		return
	end
	if IsUsableSpell(59569) == nil then
		nofly = true
	end
	if not nofly and IsFlyableArea() then
		flyablex = true
	end
	for i = 1, 40 do
		local sid = select(11, UnitBuff("player", i))
		if sid == 73701 or sid == 76377 then
			InVj = true
		end
	end
	if InVj and IsSwimming() then
		vjswim = true
	end
	if IsSwimming() and nofly and not vjswim then
		swimablex = true
	end
	if IsControlKeyDown() then
		if not vjswim then
			flyablex = not flyablex
		else
			vjswim = not vjswim
		end
	end
	for i = 1, num, 1 do
		local _, info, id = GetCompanionInfo("MOUNT", i)
		if flyingmount and info == flyingmount and flyablex and not swimablex then
			CallCompanion("MOUNT", i)
			return
		elseif groundmount and info == groundmount and not flyablex and not swimablex and not vjswim then
			CallCompanion("MOUNT", i)
			return
		elseif underwatermount and info == underwatermount and swimablex then
			CallCompanion("MOUNT", i)
			return
		elseif id == 75207 and vjswim then
			CallCompanion("MOUNT", i)
			return
		end
	end
end



local f = CreateFrame("Frame")
f:SetScript("OnEvent", function()
		local c = 0
		for b=0,4 do
			for s=1,GetContainerNumSlots(b) do
				local l = GetContainerItemLink(b, s)
				if l then
					local p = select(11, GetItemInfo(l))*select(2, GetContainerItemInfo(b, s))
					if select(3, GetItemInfo(l))==0 then
						UseContainerItem(b, s)
						PickupMerchantItem()
						c = c+p
					end
				end
			end
		end
		if c>0 then
			local g, s, c = math.floor(c/10000) or 0, math.floor((c%10000)/100) or 0, c%100
			DEFAULT_CHAT_FRAME:AddMessage("Your vendor trash has been sold and you earned".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
		end
	if Qulight["general"].AutoRepair then
			cost, possible = GetRepairAllCost()
			if cost>0 then
				if possible then
					RepairAllItems()
					local c = cost%100
					local s = math.floor((cost%10000)/100)
					local g = math.floor(cost/10000)
					DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for".." |cffffffff"..g.."|cffffd700g|r".." |cffffffff"..s.."|cffc7c7cfs|r".." |cffffffff"..c.."|cffeda55fc|r"..".",255,255,0)
				else
					DEFAULT_CHAT_FRAME:AddMessage("You don't have enough money for repair!",255,0,0)
				end
			end
	end		
end)
f:RegisterEvent("MERCHANT_SHOW")
local savedMerchantItemButton_OnModifiedClick = MerchantItemButton_OnModifiedClick
function MerchantItemButton_OnModifiedClick(self, ...)
	if ( IsAltKeyDown() ) then
		local maxStack = select(8, GetItemInfo(GetMerchantItemLink(self:GetID())))
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(self:GetID())
		if ( maxStack and maxStack > 1 ) then
			BuyMerchantItem(self:GetID(), floor(maxStack / quantity))
		end
	end
	savedMerchantItemButton_OnModifiedClick(self, ...)
end

if Qulight["misk"].AutoScreen then
local function TakeScreen(delay, func, ...)
local waitTable = {}
local waitFrame = CreateFrame("Frame", "WaitFrame", UIParent)
	waitFrame:SetScript("onUpdate", function (self, elapse)
		local count = #waitTable
		local i = 1
		while (i <= count) do
			local waitRecord = tremove(waitTable, i)
			local d = tremove(waitRecord, 1)
			local f = tremove(waitRecord, 1)
			local p = tremove(waitRecord, 1)
			if (d > elapse) then
				tinsert(waitTable, i, {d-elapse, f, p})
				i = i + 1
			else
				count = count - 1
				f(unpack(p))
			end
		end
	end)
	tinsert(waitTable, {delay, func, {...} })
end
local function OnEvent(...)
	TakeScreen(1, Screenshot)
end
local AchScreen = CreateFrame("Frame")
AchScreen:RegisterEvent("ACHIEVEMENT_EARNED")
AchScreen:SetScript("OnEvent", OnEvent)
end

RaidBossEmoteFrame:ClearAllPoints()
RaidBossEmoteFrame:SetPoint("TOP", UIParent, "TOP", 0, -200) 
RaidBossEmoteFrame:SetScale(.9)

RaidWarningFrame:ClearAllPoints()
RaidWarningFrame:SetPoint("TOP", UIParent, "TOP", 0, -260) 
RaidWarningFrame:SetScale(.8)

----------------------------------------------------------------------------------------
--	Force readycheck warning
----------------------------------------------------------------------------------------
local ShowReadyCheckHook = function(self, initiator)
	if initiator ~= "player" then
		PlaySound("ReadyCheck", "Master")
	end
end
hooksecurefunc("ShowReadyCheck", ShowReadyCheckHook)

----------------------------------------------------------------------------------------
--	Force other warning
----------------------------------------------------------------------------------------
local ForceWarning = CreateFrame("Frame")
ForceWarning:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
ForceWarning:RegisterEvent("PET_BATTLE_QUEUE_PROPOSE_MATCH")
ForceWarning:RegisterEvent("LFG_PROPOSAL_SHOW")
ForceWarning:RegisterEvent("RESURRECT_REQUEST")
ForceWarning:SetScript("OnEvent", function(self, event)
	if event == "UPDATE_BATTLEFIELD_STATUS" then
		for i = 1, GetMaxBattlefieldID() do
			local status = GetBattlefieldStatus(i)
			if status == "confirm" then
				PlaySound("PVPTHROUGHQUEUE", "Master")
				break
			end
			i = i + 1
		end
	elseif event == "PET_BATTLE_QUEUE_PROPOSE_MATCH" then
		PlaySound("PVPTHROUGHQUEUE", "Master")
	elseif event == "LFG_PROPOSAL_SHOW" then
		PlaySound("ReadyCheck", "Master")
	elseif event == "RESURRECT_REQUEST" then
		PlaySoundFile("Sound\\Spells\\Resurrection.wav", "Master")
	end
end)

----------------------------------------------------------------------------------------
--	Misclicks for some popups
----------------------------------------------------------------------------------------
StaticPopupDialogs.RESURRECT.hideOnEscape = nil
StaticPopupDialogs.AREA_SPIRIT_HEAL.hideOnEscape = nil
StaticPopupDialogs.PARTY_INVITE.hideOnEscape = nil
StaticPopupDialogs.PARTY_INVITE_XREALM.hideOnEscape = nil
StaticPopupDialogs.CONFIRM_SUMMON.hideOnEscape = nil
StaticPopupDialogs.ADDON_ACTION_FORBIDDEN.button1 = nil
StaticPopupDialogs.TOO_MANY_LUA_ERRORS.button1 = nil
PetBattleQueueReadyFrame.hideOnEscape = nil
PVPReadyDialog.leaveButton:Hide()
PVPReadyDialog.enterButton:ClearAllPoints()
PVPReadyDialog.enterButton:SetPoint("BOTTOM", PVPReadyDialog, "BOTTOM", 0, 25)

----------------------------------------------------------------------------------------
--	Custom Lag Tolerance(by Elv22)
----------------------------------------------------------------------------------------

	local customlag = CreateFrame("Frame")
	local int = 5
	local _, _, latencyHome = GetNetStats()
	local LatencyUpdate = function(self, elapsed)
		int = int - elapsed
		if int < 0 then
			if GetCVar("reducedLagTolerance") ~= tostring(1) then SetCVar("reducedLagTolerance", tostring(1)) end
			if latencyHome ~= 0 and latencyHome <= 400 then
				SetCVar("maxSpellStartRecoveryOffset", tostring(latencyHome))
			end
			int = 5
		end
	end
	customlag:SetScript("OnUpdate", LatencyUpdate)
	LatencyUpdate(customlag, 10)


----------------------------------------------------------------------------------------
--	Auto select current event boss from LFD tool(EventBossAutoSelect by Nathanyel)
----------------------------------------------------------------------------------------
local firstLFD
LFDParentFrame:HookScript("OnShow", function()
	if not firstLFD then
		firstLFD = 1
		for i = 1, GetNumRandomDungeons() do
			local id = GetLFGRandomDungeonInfo(i)
			local isHoliday = select(15, GetLFGDungeonInfo(id))
			if isHoliday and not GetLFGDungeonRewards(id) then
				LFDQueueFrame_SetType(id)
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	Remove Boss Emote spam during BG(ArathiBasin SpamFix by Partha)
----------------------------------------------------------------------------------------
local Fixer = CreateFrame("Frame")
local RaidBossEmoteFrame, spamDisabled = RaidBossEmoteFrame

local function DisableSpam()
	if GetZoneText() == L_ZONE_ARATHIBASIN or GetZoneText() == L_ZONE_GILNEAS then
		RaidBossEmoteFrame:UnregisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = true
	elseif spamDisabled then
		RaidBossEmoteFrame:RegisterEvent("RAID_BOSS_EMOTE")
		spamDisabled = false
	end
end

Fixer:RegisterEvent("PLAYER_ENTERING_WORLD")
Fixer:RegisterEvent("ZONE_CHANGED_NEW_AREA")
Fixer:SetScript("OnEvent", DisableSpam)

----------------------------------------------------------------------------------------
--	Undress button in auction dress-up frame(by Nefarion)
----------------------------------------------------------------------------------------
local strip = CreateFrame("Button", "DressUpFrameUndressButton", DressUpFrame, "UIPanelButtonTemplate")
strip:SetText(L_MISC_UNDRESS)
strip:SetHeight(22)
strip:SetWidth(strip:GetTextWidth() + 40)
strip:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
strip:RegisterForClicks("AnyUp")
strip:SetScript("OnClick", function(self, button)
	if button == "RightButton" then
		self.model:UndressSlot(19)
	else
		self.model:Undress()
	end
	PlaySound("gsTitleOptionOK")
end)
strip.model = DressUpModel

strip:RegisterEvent("AUCTION_HOUSE_SHOW")
strip:RegisterEvent("AUCTION_HOUSE_CLOSED")
strip:SetScript("OnEvent", function(self)
	if AuctionFrame:IsVisible() and self.model ~= SideDressUpModel then
		self:SetParent(SideDressUpModel)
		self:ClearAllPoints()
		self:SetPoint("TOP", SideDressUpModelResetButton, "BOTTOM", 0, -3)
		self.model = SideDressUpModel
	elseif self.model ~= DressUpModel then
		self:SetParent(DressUpModel)
		self:ClearAllPoints()
		self:SetPoint("RIGHT", DressUpFrameResetButton, "LEFT", -2, 0)
		self.model = DressUpModel
	end
end)

----------------------------------------------------------------------------------------
--	GuildTab in FriendsFrame
----------------------------------------------------------------------------------------
--local n = FriendsFrame.numTabs + 1
--local gtframe = CreateFrame("Button", "FriendsFrameTab"..n, FriendsFrame, "FriendsFrameTabTemplate")
--gtframe:SetText(GUILD)
--gtframe:SetPoint("LEFT", _G["FriendsFrameTab"..n - 1], "RIGHT", -15, 0)
--PanelTemplates_DeselectTab(gtframe)
--gtframe:SetScript("OnClick", function() ToggleGuildFrame() end)


----------------------------------------------------------------------------------------
--	Add quest/achievement wowhead link
----------------------------------------------------------------------------------------
local linkQuest, linkAchievement
if client == "ruRU" then
	linkQuest = "http://ru.wowhead.com/quest=%d"
	linkAchievement = "http://ru.wowhead.com/achievement=%d"
elseif client == "frFR" then
	linkQuest = "http://fr.wowhead.com/quest=%d"
	linkAchievement = "http://fr.wowhead.com/achievement=%d"
elseif client == "deDE" then
	linkQuest = "http://de.wowhead.com/quest=%d"
	linkAchievement = "http://de.wowhead.com/achievement=%d"
elseif client == "esES" or client == "esMX" then
	linkQuest = "http://es.wowhead.com/quest=%d"
	linkAchievement = "http://es.wowhead.com/achievement=%d"
elseif client == "ptBR" or client == "ptPT" then
	linkQuest = "http://pt.wowhead.com/quest=%d"
	linkAchievement = "http://pt.wowhead.com/achievement=%d"
else
	linkQuest = "http://www.wowhead.com/quest=%d"
	linkAchievement = "http://www.wowhead.com/achievement=%d"
end

StaticPopupDialogs.WATCHFRAME_URL = {
	text = "Wowhead link",
	button1 = OKAY,
	timeout = 0,
	whileDead = true,
	hasEditBox = true,
	editBoxWidth = 350,
	OnShow = function(self, ...) self.editBox:SetFocus() end,
	EditBoxOnEnterPressed = function(self) self:GetParent():Hide() end,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	preferredIndex = 5,
}

hooksecurefunc("QuestObjectiveTracker_OnOpenDropDown", function(self)
	local _, b, i, info, questID
	b = self.activeFrame
	i = b.questLogIndex
	_, _, _, _, _, _, _, questID = GetQuestLogTitle(i)
	info = UIDropDownMenu_CreateInfo()
	info.text = L_WATCH_WOWHEAD_LINK
	info.func = function(id)
		local inputBox = StaticPopup_Show("WATCHFRAME_URL")
		inputBox.editBox:SetText(linkQuest:format(questID))
		inputBox.editBox:HighlightText()
	end
	info.arg1 = questID
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL)
end)

hooksecurefunc("AchievementObjectiveTracker_OnOpenDropDown", function(self)
	local _, b, i, info
	b = self.activeFrame
	i = b.id
	info = UIDropDownMenu_CreateInfo()
	info.text = L_WATCH_WOWHEAD_LINK
	info.func = function(_, i)
		local inputBox = StaticPopup_Show("WATCHFRAME_URL")
		inputBox.editBox:SetText(linkAchievement:format(i))
		inputBox.editBox:HighlightText()
	end
	info.arg1 = i
	info.notCheckable = true
	UIDropDownMenu_AddButton(info, UIDROPDOWN_MENU_LEVEL)
end)

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_AchievementUI" then
		hooksecurefunc("AchievementButton_OnClick", function(self)
			if self.id and IsControlKeyDown() then
				local inputBox = StaticPopup_Show("WATCHFRAME_URL")
				inputBox.editBox:SetText(linkAchievement:format(self.id))
				inputBox.editBox:HighlightText()
			end
		end)
	end
end)


local function SkinIt(bar)	
	local _, originalPoint, _, _, _ = bar:GetPoint()
	
	bar:ClearAllPoints()
	bar:SetPoint("TOPLEFT", originalPoint, "TOPLEFT", 2, -2)
	bar:SetPoint("BOTTOMRIGHT", originalPoint, "BOTTOMRIGHT", -2, 2)
		
	for i=1, bar:GetNumRegions() do
		local region = select(i, bar:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		elseif region:GetObjectType() == "FontString" then
			region:SetFont(Qulight["media"].font, 12, "THINOUTLINE")
			region:SetShadowColor(0,0,0,0)
		end
	end
	
	bar:SetStatusBarTexture(Qulight["media"].texture)
	bar:SetStatusBarColor(170/255, 10/255, 10/255)
	
	bar.backdrop = CreateFrame("Frame", nil, bar)
	bar.backdrop:SetFrameLevel(0)
	CreateStyle(bar.backdrop, 2)
	bar.backdrop:SetAllPoints(originalPoint)
end


local function SkinBlizzTimer(self, event)
	for _, b in pairs(TimerTracker.timerList) do
		if not b["bar"].skinned then
			SkinIt(b["bar"])
			b["bar"].skinned = true
		end
	end
end

local load = CreateFrame("Frame")
load:RegisterEvent("START_TIMER")
load:SetScript("OnEvent", SkinBlizzTimers)