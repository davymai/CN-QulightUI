-----------------
-- Slash commands
-----------------
SlashCmdList["FRAME"] = function() print(GetMouseFocus():GetName()) end
SLASH_FRAME1 = "/gn"
SLASH_FRAME2 = "/frame"

SlashCmdList["GETPARENT"] = function() print(GetMouseFocus():GetParent():GetName()) end
SLASH_GETPARENT1 = "/gp"
SLASH_GETPARENT2 = "/parent"

SlashCmdList["RELOADUI"] = function() ReloadUI() end
SLASH_RELOADUI1 = "/rl"
SLASH_RELOADUI2 = ".κδ"

SlashCmdList["RCSLASH"] = function() DoReadyCheck() end
SLASH_RCSLASH1 = "/rc"
SLASH_RCSLASH2 = "/κρ"

SlashCmdList["TICKET"] = function() ToggleHelpFrame() end
SLASH_TICKET1 = "/ticket"
SLASH_TICKET2 = "/gm"
SLASH_TICKET3 = "/γμ"

SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = function(arg)
	if arg ~= "" then
		arg = _G[arg]
	else
		arg = GetMouseFocus()
	end
	if arg ~= nil and arg:GetName() ~= nil then
		local SetPoint, relativeTo, relativePoint, xOfs, yOfs = arg:GetPoint()
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
		ChatFrame1:AddMessage("Name: |cffFFD100"..arg:GetName())
		if arg:GetParent() and arg:GetParent():GetName() then
			ChatFrame1:AddMessage("Parent: |cffFFD100"..arg:GetParent():GetName())
		end

		ChatFrame1:AddMessage("Width: |cffFFD100"..format("%.2f",arg:GetWidth()))
		ChatFrame1:AddMessage("Height: |cffFFD100"..format("%.2f",arg:GetHeight()))
		ChatFrame1:AddMessage("Strata: |cffFFD100"..arg:GetFrameStrata())
		ChatFrame1:AddMessage("Level: |cffFFD100"..arg:GetFrameLevel())

		if xOfs then
			ChatFrame1:AddMessage("X: |cffFFD100"..format("%.2f",xOfs))
		end
		if yOfs then
			ChatFrame1:AddMessage("Y: |cffFFD100"..format("%.2f",yOfs))
		end
		if relativeTo and relativeTo:GetName() then
			ChatFrame1:AddMessage("SetPoint: |cffFFD100"..SetPoint.."|r anchored to "..relativeTo:GetName().."'s |cffFFD100"..relativePoint)
		end
		ChatFrame1:AddMessage("|cffCC0000----------------------------")
	elseif arg == nil then
		ChatFrame1:AddMessage("Invalid frame name")
	else
		ChatFrame1:AddMessage("Could not find frame info")
	end
end
-----------------
-- Check Player's Role
-----------------
CheckRole = function()
	local role = ""
	local tree = GetSpecialization()

	if tree then
		role = select(6, GetSpecializationInfo(tree))
	end

	return role
end
-----------------
-- wait Frame
-----------------
local waitTable = {}
local waitFrame
function Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
				  tinsert(waitTable,i,{d-elapse,f,p})
				  i = i + 1
				else
				  count = count - 1
				  f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end
-------------------------------------------
-- Focuser
-------------------------------------------
local modifier = "shift"
local mouseButton = "1"

local function SetFocusHotkey(frame)
	frame:SetAttribute(modifier.."-type"..mouseButton,"focus")
end

local function CreateFrame_Hook(type, name, parent, template)
	if template == "SecureUnitButtonTemplate" then
		SetFocusHotkey(_G[name])
	end
end

hooksecurefunc("CreateFrame", CreateFrame_Hook)

local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate")
f:SetAttribute("type1","macro")
f:SetAttribute("macrotext","/focus mouseover")
SetOverrideBindingClick(FocuserButton,true,modifier.."-BUTTON"..mouseButton,"FocuserButton")

local duf = {
	PlayerFrame,
	PetFrame,
	PartyMemberFrame1,
	PartyMemberFrame2,
	PartyMemberFrame3,
	PartyMemberFrame4,
	PartyMemberFrame1PetFrame,
	PartyMemberFrame2PetFrame,
	PartyMemberFrame3PetFrame,
	PartyMemberFrame4PetFrame,
	TargetFrame,
	TargetofTargetFrame,
}

for i,frame in pairs(duf) do
	SetFocusHotkey(frame)
end
----------------------------------------------------------------------------------------
--	Based on AchievementMover
----------------------------------------------------------------------------------------
local AchievementAnchor = CreateFrame("Frame", "AchievementAnchor", UIParent)
AchievementAnchor:SetWidth(DungeonCompletionAlertFrame1:GetWidth() - 36)
AchievementAnchor:SetHeight(DungeonCompletionAlertFrame1:GetHeight() - 4)
AchievementAnchor:SetPoint("CENTER", 0, 0)

local POSITION, ANCHOR_POINT, YOFFSET = "BOTTOM", "TOP", -9

local function fixAnchors()
	local point = select(1, AchievementAnchor:GetPoint())

	if string.find(point, "TOP") or point == "CENTER" or point == "LEFT" or point == "RIGHT" then
		POSITION = "TOP"
		ANCHOR_POINT = "BOTTOM"
		YOFFSET = 9
	else
		POSITION = "BOTTOM"
		ANCHOR_POINT = "TOP"
		YOFFSET = -9
	end

	AlertFrame:ClearAllPoints()
	AlertFrame:SetPoint(POSITION, AchievementAnchor, POSITION, 2, YOFFSET)

	GroupLootContainer:ClearAllPoints()
	GroupLootContainer:SetPoint(POSITION, AlertFrame, ANCHOR_POINT, -100, YOFFSET)
end
hooksecurefunc("AlertFrame_FixAnchors", fixAnchors)

local function AlertFrame_SetLootAnchors(alertAnchor)
	if MissingLootFrame:IsShown() then
		MissingLootFrame:ClearAllPoints()
		MissingLootFrame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
		if GroupLootContainer:IsShown() then
			GroupLootContainer:ClearAllPoints()
			GroupLootContainer:SetPoint(POSITION, MissingLootFrame, ANCHOR_POINT, 0, YOFFSET)
		end
	elseif GroupLootContainer:IsShown() then
		GroupLootContainer:ClearAllPoints()
		GroupLootContainer:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetLootAnchors", AlertFrame_SetLootAnchors)

local function AlertFrame_SetLootWonAnchors(alertAnchor)
	for i = 1, #LOOT_WON_ALERT_FRAMES do
		local frame = LOOT_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			alertAnchor = frame
		end
	end
end
hooksecurefunc("AlertFrame_SetLootWonAnchors", AlertFrame_SetLootWonAnchors)

local function AlertFrame_SetMoneyWonAnchors(alertAnchor)
	for i = 1, #MONEY_WON_ALERT_FRAMES do
		local frame = MONEY_WON_ALERT_FRAMES[i]
		if frame:IsShown() then
			frame:ClearAllPoints()
			frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
			alertAnchor = frame
		end
	end
end
hooksecurefunc("AlertFrame_SetMoneyWonAnchors", AlertFrame_SetMoneyWonAnchors)

local function AlertFrame_SetAchievementAnchors(alertAnchor)
	if AchievementAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				alertAnchor = frame
			end
		end
	end
end
hooksecurefunc("AlertFrame_SetAchievementAnchors", AlertFrame_SetAchievementAnchors)

local function AlertFrame_SetCriteriaAnchors(alertAnchor)
	if CriteriaAlertFrame1 then
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]
			if frame and frame:IsShown() then
				frame:ClearAllPoints()
				frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
				alertAnchor = frame
			end
		end
	end
end
hooksecurefunc("AlertFrame_SetCriteriaAnchors", AlertFrame_SetCriteriaAnchors)

local function AlertFrame_SetChallengeModeAnchors(alertAnchor)
	local frame = ChallengeModeAlertFrame1
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetChallengeModeAnchors", AlertFrame_SetChallengeModeAnchors)

local function AlertFrame_SetDungeonCompletionAnchors(alertAnchor)
	local frame = DungeonCompletionAlertFrame1
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetDungeonCompletionAnchors", AlertFrame_SetDungeonCompletionAnchors)

local function AlertFrame_SetScenarioAnchors(alertAnchor)
	local frame = ScenarioAlertFrame1
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetScenarioAnchors", AlertFrame_SetScenarioAnchors)

local function AlertFrame_SetGuildChallengeAnchors(alertAnchor)
	local frame = GuildChallengeAlertFrame
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetGuildChallengeAnchors", AlertFrame_SetGuildChallengeAnchors)

hooksecurefunc(GroupLootContainer, "SetPoint", function(self, point, anchorTo, attachPoint, xOffset, yOffset)
	if _G[anchorTo] == UIParent or _G[anchorTo] == AchievementAnchor then
		fixAnchors()
	end
end)
hooksecurefunc("AlertFrame_SetGarrisonFollowerAlertFrameAnchors", AlertFrame_SetGarrisonFollowerAlertFrameAnchors)

function AlertFrame_SetGarrisonBuildingAlertFrameAnchors(alertAnchor)
	local frame = GarrisonBuildingAlertFrame
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetGarrisonBuildingAlertFrameAnchors", AlertFrame_SetGarrisonBuildingAlertFrameAnchors)

function AlertFrame_SetGarrisonBuildingAlertFrameAnchors(alertAnchor)
	local frame = GarrisonBuildingAlertFrame
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end
hooksecurefunc("AlertFrame_SetGarrisonMissionAlertFrameAnchors", AlertFrame_SetGarrisonMissionAlertFrameAnchors)

function AlertFrame_SetGarrisonBuildingAlertFrameAnchors(alertAnchor)
	local frame = GarrisonMissionAlertFrame
	if frame:IsShown() then
		frame:ClearAllPoints()
		frame:SetPoint(POSITION, alertAnchor, ANCHOR_POINT, 0, YOFFSET)
	end
end

if Qulight["general"].autoinvite then

	local CheckFriend = function(name)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == name then
				return true
			end
		end
		for i = 1, select(2, BNGetNumFriends()) do
			local presenceID, _, _, _, _, _, client, isOnline = BNGetFriendInfo(i)
			if client == "WoW" and isOnline then
				local _, toonName, _, realmName = BNGetToonInfo(presenceID)
				if name == toonName or name == toonName.."-"..realmName then
					return true
				end
			end
		end
		if IsInGuild() then
			for i = 1, GetNumGuildMembers() do
				if GetGuildRosterInfo(i) == name then
					return true
				end
			end
		end
	end

	local ai = CreateFrame("Frame")
	ai:RegisterEvent("PARTY_INVITE_REQUEST")
	ai:SetScript("OnEvent", function(self, event, name)
		if QueueStatusMinimapButton:IsShown() or GetNumGroupMembers() > 0 then return end
		if CheckFriend(name) then
			RaidNotice_AddMessage(RaidWarningFrame, "Accepted invite from: "..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format("|cffffff00".."Accepted invite from: "..name.."."))
			AcceptGroup()
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which == "PARTY_INVITE" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				elseif frame:IsVisible() and frame.which == "PARTY_INVITE_XREALM" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE_XREALM")
					return
				end
			end
		else
			SendWho(name)
		end
end)
end

local function ForceTaintPopupHide()
 if GetBuildInfo == "5.4.1" then
  hooksecurefunc("StaticPopup_Show", function(which)
   if (which == "ADDON_ACTION_FORBIDDEN") then
    StaticPopup_Hide(which)
   end
  end)
 end
end

local Fixes = CreateFrame("Frame")
Fixes:RegisterEvent("PLAYER_ENTERING_WORLD")
Fixes:SetScript("OnEvent", function(self, event, ...)
 if event == "PLAYER_ENTERING_WORLD" then
  ForceTaintPopupHide()
  self:UnregisterEvent("PLAYER_ENTERING_WORLD")
 end
end)

----------------------------------------------------------------------------------------
--	Creating Coordinate
----------------------------------------------------------------------------------------

local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
coords:SetFrameLevel(90)
coords.PlayerText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.PlayerText:SetPoint("BOTTOMLEFT", WorldMapFrame.UIElementsFrame, "BOTTOMLEFT", 5, 5)
coords.PlayerText:SetJustifyH("LEFT")
coords.PlayerText:SetText(UnitName("player")..": 0,0")
coords.PlayerText:SetTextColor(1, 1, 1)
coords.PlayerText:SetFontObject(SystemFont_Med1)

coords.MouseText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.MouseText:SetJustifyH("LEFT")
coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
coords.MouseText:SetText("Mouse:   0, 0")
coords.MouseText:SetTextColor(1, 1, 1)
coords.MouseText:SetFontObject(SystemFont_Med1)

local int = 0
WorldMapFrame:HookScript("OnUpdate", function(self, elapsed)
	int = int + 1
	if int >= 3 then
		local inInstance, _ = IsInInstance()
		local x,y = GetPlayerMapPosition("player")
			x = math.floor(100 * x)
			y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			coords.PlayerText:SetText(UnitName("player")..":   "..x..", "..y)
		else
			coords.PlayerText:SetText(" ")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if (adjustedX >= 0  and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1) then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			coords.MouseText:SetText(MOUSE_LABEL..":   "..adjustedX..", "..adjustedY)
		else
			coords.MouseText:SetText(" ")
		end
		int = 0
	end
end)
--------------------------------------------------------add by myself--------------------------------------------------------
-------------------
--mouse flasher
-------------------
local frame = CreateFrame("Frame", nil, UIParent);
frame:SetFrameStrata("TOOLTIP");

local texture = frame:CreateTexture();
texture:SetTexture([[Interface\Cooldown\star4]]);
texture:SetBlendMode("ADD");
texture:SetAlpha(0.5);

local x = 0;
local y = 0;
local speed = 0;
local function OnUpdate(_, elapsed)
  local dX = x;
  local dY = y;
  x, y = GetCursorPosition();
  dX = x - dX;
  dY = y - dY;
  local weight = 2048 ^ -elapsed;
  speed = math.min(weight * speed + (1 - weight) * math.sqrt(dX * dX + dY * dY) / elapsed, 1024);
  local size = speed / 6 - 16;
  if (size > 0) then
    local scale = UIParent:GetEffectiveScale();
    texture:SetHeight(size);
    texture:SetWidth(size);
    texture:SetPoint("CENTER", UIParent, "BOTTOMLEFT", (x + 0.5 * dX) / scale, (y + 0.5 * dY) / scale);
    texture:Show();
  else
    texture:Hide();
  end
end
frame:SetScript("OnUpdate", OnUpdate);
----------------------
--Gbank use
----------------------
local AutoRepair = true
local g = CreateFrame("Frame")
g:RegisterEvent("MERCHANT_SHOW")
g:SetScript("OnEvent", function()
   if(AutoRepair==true and CanMerchantRepair()) then
           local cost = GetRepairAllCost()
      if cost > 0 then
         local money = GetMoney()
         if IsInGuild() then
            local guildMoney = GetGuildBankWithdrawMoney()
            if guildMoney > GetGuildBankMoney() then
               guildMoney = GetGuildBankMoney()
            end
            if guildMoney > cost and CanGuildBankRepair() then
               RepairAllItems(1)
               print(format("|cfff07100公会修理花费: %.1fg|r", cost * 0.0001))
               return
            end
         end
         if money > cost then
               RepairAllItems()
               print(format("|cffead000修理花费: %.1fg|r", cost * 0.0001))
         else
            print("Go farm newbie.")
         end
      end
end
end)
----------------------------------------------------------------------------------------
--	Roll ico
----------------------------------------------------------------------------------------
local roll = CreateFrame("Button", "rollMacro", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("type", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetScript('OnMouseDown', function(self, button)
      if InCombatLockdown() then return end
      if (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and button == "RightButton" then
      DoReadyCheck()
      end
   end)
roll:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 430, 170) -- 可自己调整位置


roll:SetSize(20,20) -- 大小
roll.t = roll:CreateTexture()
roll.t:SetAllPoints()
roll.t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
----------------------------------------------------------------------------------------
--	CombatAlert
----------------------------------------------------------------------------------------
local MyAddon = CreateFrame("Frame")
local imsg = CreateFrame("Frame", "ComatAlert")
imsg:SetSize(418, 72)
imsg:SetPoint("TOP", 0, -190)
imsg:Hide()
imsg.bg = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.bg:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.bg:SetPoint('BOTTOM')
imsg.bg:SetSize(326, 103)
imsg.bg:SetTexCoord(0.00195313, 0.63867188, 0.03710938, 0.23828125)
imsg.bg:SetVertexColor(1, 1, 1, 0.6)

imsg.lineTop = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.lineTop:SetDrawLayer('BACKGROUND', 2)
imsg.lineTop:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.lineTop:SetPoint("TOP")
imsg.lineTop:SetSize(418, 7)
imsg.lineTop:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

imsg.lineBottom = imsg:CreateTexture(nil, 'BACKGROUND')
imsg.lineBottom:SetDrawLayer('BACKGROUND', 2)
imsg.lineBottom:SetTexture([[Interface\LevelUp\LevelUpTex]])
imsg.lineBottom:SetPoint("BOTTOM")
imsg.lineBottom:SetSize(418, 7)
imsg.lineBottom:SetTexCoord(0.00195313, 0.81835938, 0.01953125, 0.03320313)

imsg.text = imsg:CreateFontString(nil, 'ARTWORK', 'GameFont_Gigantic')
imsg.text:SetPoint("BOTTOM", 0, 12)
imsg.text:SetTextColor(1, 0.82, 0)
imsg.text:SetJustifyH("CENTER")

MyAddon:RegisterEvent("PLAYER_REGEN_ENABLED")
MyAddon:RegisterEvent("PLAYER_REGEN_DISABLED")

start_msg =  {"擦，进战斗了！","进入战斗！","开始战斗了哦，亲","有刺客！"}
end_msg =  {"终于逃掉了","脱离战斗！","竟然还没死","搞定！"}

MyAddon:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_DISABLED" then
		imsg.text:SetTextColor(1, 0, 0)
		imsg.text:SetText(start_msg[math.random(1,table.getn(start_msg))])
		ComatAlert:Show()
	else
		imsg.text:SetTextColor(1, 0.82, 0)
		imsg.text:SetText(end_msg[math.random(1,table.getn(end_msg))])
		ComatAlert:Show()
	end
end)

local timer = 0

imsg:SetScript("OnShow", function(self)
	timer = 0
	self:SetScript("OnUpdate", function(self, elasped)
		timer = timer + elasped
		if (timer<0.5) then self:SetAlpha(timer*2) end
		if (timer>1 and timer<1.5) then self:SetAlpha(1-(timer-1)*2) end
		if (timer>=1.5 ) then self:Hide() end
	end)
end)