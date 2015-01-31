if not Qulight["chatt"].enable == true then return end

ToggleChatColorNamesByClassGroup(true, "SAY")
ToggleChatColorNamesByClassGroup(true, "EMOTE")
ToggleChatColorNamesByClassGroup(true, "YELL")
ToggleChatColorNamesByClassGroup(true, "GUILD")
ToggleChatColorNamesByClassGroup(true, "OFFICER")
ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
ToggleChatColorNamesByClassGroup(true, "WHISPER")
ToggleChatColorNamesByClassGroup(true, "PARTY")
ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
ToggleChatColorNamesByClassGroup(true, "RAID")
ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
ToggleChatColorNamesByClassGroup(true, "CHANNEL11")

--General
ChangeChatColor("CHANNEL1", 195/255, 230/255, 232/255)
--Trade
ChangeChatColor("CHANNEL2", 232/255, 158/255, 121/255)
--Local Defense
ChangeChatColor("CHANNEL3", 232/255, 228/255, 121/255)

local Chat = CreateFrame("Frame")
local tabalpha = 1
local tabnoalpha = 0
local _G = _G
local origs = {}
local type = type
hidecombat = true

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = dummy
	object:Hide()
end
dummy = function() return end
for i = 1, 10 do
	local x=({_G["ChatFrame"..i.."EditBox"]:GetRegions()})
	x[9]:SetAlpha(0)
	x[10]:SetAlpha(0)
	x[11]:SetAlpha(0)
end

-- Function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if type(text) == "string" then
		text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
		text = text:gsub("|Hplayer:(.-)|h%[(.-)%]|h", Strip)
	end
	return origs[self](self, text, ...)
end

-- Global strings
_G.CHAT_INSTANCE_CHAT_GET = "|Hchannel:INSTANCE_CHAT|h[".."R".."]|h %s:\32"
_G.CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:INSTANCE_CHAT|h[".."RL".."]|h %s:\32"
_G.CHAT_BN_WHISPER_GET = "Fr".." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:GUILD|h[".."G".."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:OFFICER|h[".."O".."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:PARTY|h[".."P".."]|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:PARTY|h[".."PL".."]|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = CHAT_PARTY_LEADER_GET
_G.CHAT_RAID_GET = "|Hchannel:RAID|h[".."R".."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h[".."RL".."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "[".."RW".."] %s:\32"
_G.CHAT_PET_BATTLE_COMBAT_LOG_GET = "|Hchannel:PET_BATTLE_COMBAT_LOG|h[".."PB".."]|h:\32"
_G.CHAT_PET_BATTLE_INFO_GET = "|Hchannel:PET_BATTLE_INFO|h[".."PB".."]|h:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = "Fr".." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "|cffE7E716".."[AFK]".."|r "
_G.CHAT_FLAG_DND = "|cffFF0000".."[DND]".."|r "
_G.CHAT_FLAG_GM = "|cff4154F5".."[GM]".."|r "
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h ".." |cff298F00上线了|r."
_G.ERR_FRIEND_OFFLINE_S = "[%s] ".." |cffff0000下线了|r."

for i = 1, NUM_CHAT_WINDOWS do
	 if ( i ~= 6 ) then
      local f = _G["ChatFrame"..i]
      local am = f.AddMessage
      f.AddMessage = function(frame, text, ...)
        return am(frame, text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h'), ...)
      end
    end
end

local function ShortChannel(channel)
	return string.format("|Hchannel:%s|h[%s]|h", channel, strings[channel] or channel:gsub("channel:", ""))
end
Kill(FriendsMicroButton)
Kill(ChatFrameMenuButton)

if hidecombat==true then
    local EventFrame = CreateFrame("Frame");
    EventFrame:RegisterEvent("ADDON_LOADED");
    local function EventHandler(self, event, ...)
        if ... == "Blizzard_CombatLog" then
            local topbar = _G["CombatLogQuickButtonFrame_Custom"];
            if not topbar then return end
            topbar:Hide();
            topbar:HookScript("OnShow", function(self) topbar:Hide(); end);
            topbar:SetHeight(0);
        end
    end
    EventFrame:SetScript("OnEvent", EventHandler);
end
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	_G[chat]:SetClampRectInsets(0,0,0,0)

	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	Kill(_G[format("ChatFrame%sTabLeft", id)])
	Kill(_G[format("ChatFrame%sTabMiddle", id)])
	Kill(_G[format("ChatFrame%sTabRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	Kill(_G[format("ChatFrame%sTabHighlightLeft", id)])
	Kill(_G[format("ChatFrame%sTabHighlightMiddle", id)])
	Kill(_G[format("ChatFrame%sTabHighlightRight", id)])

	Kill(_G[format("ChatFrame%sTabSelectedLeft", id)])
	Kill(_G[format("ChatFrame%sTabSelectedMiddle", id)])
	Kill(_G[format("ChatFrame%sTabSelectedRight", id)])

	Kill(_G[format("ChatFrame%sButtonFrameUpButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameDownButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameBottomButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrameMinimizeButton", id)])
	Kill(_G[format("ChatFrame%sButtonFrame", id)])

	Kill(_G[format("ChatFrame%sEditBoxFocusLeft", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusMid", id)])
	Kill(_G[format("ChatFrame%sEditBoxFocusRight", id)])

	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()); Kill (a); Kill (b); Kill (c)

	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)
	_G[chat.."EditBox"]:Hide()
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)

	local editbox = _G["ChatFrame"..id.."EditBox"]
	local left, mid, right = select(6, editbox:GetRegions())
	left:Hide(); mid:Hide(); right:Hide()
	editbox:ClearAllPoints();
	editbox:SetPoint("CENTER", DataLeftPanel)
	editbox:SetWidth(440)
	editbox:SetHeight(15)
	CreateStyle(editbox, 2, 0 , 1, 0)
end
local function SetupChat(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		FCFTab_UpdateAlpha(frame)
	end

	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.BN_WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
end

for i=1, BNToastFrame:GetNumRegions() do
	if i ~= 10 then
		local region = select(i, BNToastFrame:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetTexture(nil)
		end
	end
end

CreateStyle(BNToastFrame, 2)

BNToastFrame:HookScript("OnShow", function(self)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -6, 82)
end)

local function SetupChatPosAndFont(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local tab = _G[format("ChatFrame%sTab", i)]
		local id = chat:GetID()
		local name = FCF_GetChatWindowInfo(id)
		local point = GetChatWindowSavedPosition(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)
		local _, _, _, _, _, _, _, _, docked, _ = GetChatWindowInfo(id)
		local _, fontSize = FCF_GetChatWindowInfo(id)

		--FCF_SetChatWindowFontSize(nil, chat, Qulight["media"].fontsize) 屏蔽无法修改文字大小
		ChatFrame1:ClearAllPoints()
		ChatFrame1:SetPoint("BOTTOMLEFT", ChatBackground, "BOTTOMLEFT", 6, 22)
	end
end
Chat:RegisterEvent("ADDON_LOADED")
Chat:RegisterEvent("PLAYER_ENTERING_WORLD")
Chat:SetScript("OnEvent", function(self, event, ...)
	for i = 1, NUM_CHAT_WINDOWS do
		_G["ChatFrame"..i]:SetClampRectInsets(0,0,0,0)
		_G["ChatFrame"..i]:SetWidth(410)
		_G["ChatFrame"..i]:SetHeight(124)
	end
	local addon = ...
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		SetupChatPosAndFont(self)
		Chat:UnregisterEvent("PLAYER_ENTERING_WORLD")
	end
	if event == "PLAYER_LOGIN" then
		SetupChatPosAndFont(self)
	end
end)
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)
for i = 1, NUM_CHAT_WINDOWS do
	local editBox = _G["ChatFrame"..i.."EditBox"]
	editBox:HookScript("OnTextChanged", function(self)
	   local text = self:GetText()
	   if text:len() < 5 then
		  if text:sub(1, 4) == "/tt " then
			 local unitname, realm
			 unitname, realm = UnitName("target")
			 if unitname then unitname = gsub(unitname, " ", "") end
			 if unitname and not UnitIsSameServer("player", "target") then
				unitname = unitname .. "-" .. gsub(realm, " ", "")
			 end
			 ChatFrame_SendTell((unitname or "Invalid Target"), ChatFrame1)
		  end
	   end
	end)
end
local SetItemRef_orig = SetItemRef
function ReURL_SetItemRef(link, text, button, chatFrame)
	if (strsub(link, 1, 3) == "url") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local url = strsub(link, 5);
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(url)
		ChatFrameEditBox:HighlightText()

	else
		SetItemRef_orig(link, text, button, chatFrame)
	end
end
SetItemRef = ReURL_SetItemRef
function ReURL_AddLinkSyntax(chatstring)
	if (type(chatstring) == "string") then
		local extraspace;
		if (not strfind(chatstring, "^ ")) then
			extraspace = true;
			chatstring = " "..chatstring;
		end
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", ReURL_Link("www.%1.%2"))
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", ReURL_Link("%1://%2"))
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", ReURL_Link("%1@%2%3%4"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4:%5"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", ReURL_Link("%1.%2.%3.%4"))
		if (extraspace) then
			chatstring = strsub(chatstring, 2);
		end
	end
	return chatstring
end

REURL_COLOR = "16FF5D"
ReURL_Brackets = false
ReUR_CustomColor = true

function ReURL_Link(url)
	if (ReUR_CustomColor) then
		if (ReURL_Brackets) then
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = " |cff"..REURL_COLOR.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (ReURL_Brackets) then
			url = " |Hurl:"..url.."|h["..url.."]|h "
		else
			url = " |Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end
for i=1, NUM_CHAT_WINDOWS do
	local frame = getglobal("ChatFrame"..i)
	local addmessage = frame.AddMessage
	frame.AddMessage = function(self, text, ...) addmessage(self, ReURL_AddLinkSyntax(text), ...) end
end

local Fane = CreateFrame'Frame'
local inherit = GameFontNormalSmall

local updateFS = function(self, inc, flags, ...)
	local fstring = self:GetFontString()

	local font, fontSize = inherit:GetFont()
	fstring:SetFont(Qulight["media"].font, Qulight["media"].fontsize, flags)
	if((...)) then
		fstring:SetTextColor(...)
	end
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID()..'TabFlash']:IsShown()
	updateFS(self, emphasis, nil, unpack(Qulight["datatext"].color))
end

local OnLeave = function(self)
	local r, g, b, al
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b, al = 1, 0.7, 0.7, 1
	elseif emphasis then
		r, g, b, al = 1, 0, 0, 1
	else
		r, g, b, al = 1, 1, 1, 1
	end

	updateFS(self, emphasis, nil, r, g, b, al)
end

local ChatFrame2_SetAlpha = function(self, alpha)
	if(CombatLogQuickButtonFrame_Custom) then
		CombatLogQuickButtonFrame_Custom:SetAlpha(alpha)
	end
end

local ChatFrame2_GetAlpha = function(self)
	if(CombatLogQuickButtonFrame_Custom) then
		return CombatLogQuickButtonFrame_Custom:GetAlpha()
	end
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.glow:SetTexture(nil)

		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		frame:SetAlpha(1)

		if(i ~= 2) then
			frame.SetAlpha = UIFrameFadeRemoveFrame
		else
			frame.SetAlpha = ChatFrame2_SetAlpha
			frame.GetAlpha = ChatFrame2_GetAlpha

			-- We do this here as people might be using AddonLoader together with Fane.
			if(CombatLogQuickButtonFrame_Custom) then
				CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
			end
		end

		frame.Fane = true
	end

	-- We can't trust sel. :(
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame, nil, nil, 1, 0.7, 0.7, 1)
	else
		updateFS(frame, nil, nil, unpack(Qulight["datatext"].color))
	end
end

hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
	updateFS(tab, true, nil, 1, 0, 0)
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)


for i=1, NUM_CHAT_WINDOWS do
	faneifyTab(_G['ChatFrame' .. i .. 'Tab'])
end
function Fane:ADDON_LOADED(event, addon)
	if(addon == 'Blizzard_CombatLog') then
		self:UnregisterEvent(event)
		self[event] = nil

		return CombatLogQuickButtonFrame_Custom:SetAlpha(.4)
	end
end
Fane:RegisterEvent'ADDON_LOADED'

Fane:SetScript('OnEvent', function(self, event, ...)
	return self[event](self, event, ...)
end)
-----------------------------------------------------------------------------
-- Copy Chat (by Shestak)
-----------------------------------------------------------------------------

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreateCopyFrame()
	frame = CreateFrame("Frame", "ChatCopyFrame", UIParent)
	CreateStyle(frame, 2)
	frame:SetWidth(440)
	frame:SetHeight(250)
	frame:SetScale(1)
	frame:SetPoint("BOTTOM", ChatBackground, "TOP", 0, 2)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "ChatCopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -30)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	editBox = CreateFrame("EditBox", "ChatCopyEditBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFont(Qulight["media"].font, 10, "OVERLAY")
	editBox:SetWidth(410)
	editBox:SetHeight(250)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
	close:GetNormalTexture():SetDesaturated(1)

	isf = true
end

local function GetLines(...)
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreateCopyFrame() end
	if frame:IsShown() then frame:Hide() return end
	frame:Show()
	editBox:SetText(text)
end

copyicon = "Interface\\AddOns\\QulightUI\\Root\\Media\\copy"

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("ChatFrame%d",  i)]
	local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
	button:SetPoint("TOPRIGHT", 5, 20)
	button:SetHeight(15)
	button:SetWidth(20)
	button:SetNormalTexture(copyicon)
	button:SetAlpha(0)
	CreateStyle(button, 2)




	button:SetScript("OnMouseUp", function(self)
		Copy(cf)
	end)
	button:SetScript("OnEnter", function()
		button:SetAlpha(1)
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(.4) end)
	button:SetAlpha(.4)

end

for i=1, NUM_CHAT_WINDOWS do
	local editbox = _G["ChatFrame"..i.."EditBox"]
	editbox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()

		local new, found = gsub(text, "|Kf(%S+)|k(%S+)%s(%S+)k:%s", "%2 %3: ")

		if found > 0 then
			new = new:gsub('|', '')
			self:SetText(new)
		end
	end)
end

local gsub = gsub
local color = "16FF5D"
local usebracket = false
local usecolor = true

local function PrintURL(url)
	if (usecolor) then
		if (usebracket) then
			url = "|cff"..color.."|Hurl:"..url.."|h["..url.."]|h|r "
		else
			url = "|cff"..color.."|Hurl:"..url.."|h"..url.."|h|r "
		end
	else
		if (usebracket) then
			url = "|Hurl:"..url.."|h["..url.."]|h "
		else
			url = "|Hurl:"..url.."|h"..url.."|h "
		end
	end
	return url
end

local FindURL = function(self, event, msg, ...)
	local newMsg, found = gsub(msg, "(%a+)://(%S+)%s?", PrintURL("%1://%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "www%.([_A-Za-z0-9-]+)%.(%S+)%s?", PrintURL("www.%1.%2"))
	if found > 0 then return false, newMsg, ... end

	newMsg, found = gsub(msg, "([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", PrintURL("%1@%2%3%4"))
	if found > 0 then return false, newMsg, ... end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND_LEADER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", FindURL)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", FindURL)

local currentLink = nil
local ChatFrame_OnHyperlinkShow_Original = ChatFrame_OnHyperlinkShow
ChatFrame_OnHyperlinkShow = function(self, link, ...)
	if (link):sub(1, 3) == "url" then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		currentLink = (link):sub(5)
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(currentLink)
		ChatFrameEditBox:HighlightText()
		currentLink = nil
		return
	end
	ChatFrame_OnHyperlinkShow_Original(self, link, ...)
end

local numlines = 3
function FloatingChatFrame_OnMouseScroll(self, delta)
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			for i=1, numlines do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			for i=1, numlines do
				self:ScrollUp()
			end
		end
	end
end

for i=1, NUM_CHAT_WINDOWS do
	local editbox = _G["ChatFrame"..i.."EditBox"]
	editbox:HookScript("OnTextChanged", function(self)
		local text = self:GetText()
		if text:len() < 5 then
			if text:sub(1, 4) == "/tt " then
				local unitname, realm = UnitName("target")
				if unitname then
					if unitname then unitname = gsub(unitname, " ", "") end
					if unitname and not UnitIsSameServer("player", "target") then
						unitname = unitname .. "-" .. gsub(realm, " ", "")
					end

					ChatFrame_SendTell((unitname), ChatFrame1)
				end
			end
		end
	end)
end

SLASH_TELLTARGET1 = "/tt"
SLASH_TELLTARGET2 = "/telltarget"
SlashCmdList.TELLTARGET = function(msg)
	SendChatMessage(msg, "WHISPER")
end


if not Qulight["misk"].armory_link == true then return end
----------------------------------------------------------------------------------------
--	Armory link on right click player name in chat
----------------------------------------------------------------------------------------
-- Find the Realm and Local
local realmName = string.lower(GetRealmName())
local realmLocal = string.lower(GetCVar("portal"))
local link

if realmLocal == "ru" then realmLocal = "eu" end

local function urlencode(obj)
	local currentIndex = 1;
	local charArray = {}
	while currentIndex <= #obj do
		local char = string.byte(obj, currentIndex);
		charArray[currentIndex] = char
		currentIndex = currentIndex + 1
	end
	local converchar = "";
	for _, char in ipairs(charArray) do
		converchar = converchar..string.format("%%%X", char)
	end
	return converchar;
end

realmName = realmName:gsub("'", "")
realmName = realmName:gsub(" ", "-")
local myserver = realmName:gsub("-", "")

if client == "ruRU" then
	link = "ru"
elseif client == "frFR" then
	link = "fr"
elseif client == "deDE" then
	link = "de"
elseif client == "esES" or client == "esMX" then
	link = "es"
elseif client == "ptBR" or client == "ptPT" then
	link = "pt"
elseif client == "itIT" then
	link = "it"
elseif client == "zhTW" then
	link = "zh"
elseif client == "koKR" then
	link = "ko"
else
	link = "en"
end

StaticPopupDialogs.LINK_COPY_DIALOG = {
	text = "Armory",
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

-- Dropdown menu link
hooksecurefunc("UnitPopup_OnClick", function(self)
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU
	local name = dropdownFrame.name
	local server = dropdownFrame.server
	if not server then
		server = myserver
	else
		server = string.lower(server:gsub("'", ""))
		server = server:gsub(" ", "-")
	end

	if name and self.value == "ARMORYLINK" then
		local inputBox = StaticPopup_Show("LINK_COPY_DIALOG")
		if realmLocal == "us" or realmLocal == "eu" or realmLocal == "tw" or realmLocal == "kr" then
			if server == myserver then
				linkurl = "http://"..realmLocal..".battle.net/wow/"..link.."/character/"..realmName.."/"..name.."/advanced"
			else
				linkurl = "http://"..realmLocal..".battle.net/wow/"..link.."/search?q="..name.."&f=wowcharacter"
			end
			inputBox.editBox:SetText(linkurl)
			inputBox.editBox:HighlightText()
			return
		elseif realmLocal == "cn" then
			local n, r = name:match"(.*)-(.*)"
			n = n or name
			r = r or GetRealmName()

			linkurl = "http://www.battlenet.com.cn/wow/character/"..urlencode(r).."/"..urlencode(n).."/advanced"
			inputBox.editBox:SetText(linkurl)
			inputBox.editBox:HighlightText()
			return
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00Unsupported realm location.|r")
			StaticPopup_Hide("LINK_COPY_DIALOG")
			return
		end
	end
end)

UnitPopupButtons["ARMORYLINK"] = {text = "Armory", dist = 0, func = UnitPopup_OnClick}

-- Comment armory function, becourse they causes error then choose in raid maintank
tinsert(UnitPopupMenus["FRIEND"], #UnitPopupMenus["FRIEND"] - 1, "ARMORYLINK")
tinsert(UnitPopupMenus["PARTY"], #UnitPopupMenus["PARTY"] - 1, "ARMORYLINK")
tinsert(UnitPopupMenus["RAID"], #UnitPopupMenus["RAID"] - 1, "ARMORYLINK")
tinsert(UnitPopupMenus["PLAYER"], #UnitPopupMenus["PLAYER"] - 1, "ARMORYLINK")