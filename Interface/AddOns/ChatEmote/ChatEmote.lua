local _, ns = ...
local CurEB = "ChatFrame1EditBox"

local Config = {
	iconSize 			= 24,					-- 表情IconSize
	enableEmoteInput	= true,					-- 启用
	enableBubbleEmote	= true,					-- 聊天泡泡也显示表情
}
local fdir = "InterFace\\AddOns\\ChatEmote\\icon\\" -- 表情材质路径
----------------------------------------------------------------------------------------
local customEmoteStartIndex = 9

local emotes = {
	{"{rt1}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
	{"{rt2}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
	{"{rt3}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
	{"{rt4}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
	{"{rt5}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
	{"{rt6}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
	{"{rt7}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
	{"{rt8}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
	{"{天使}",	fdir.."Angel"},
	{"{生气}",	fdir.."Angry"},

	{"{大笑}",	fdir.."Biglaugh"},
	{"{鼓掌}",	fdir.."Clap"},
	{"{酷}",	fdir.."Cool"},
	{"{哭}",	fdir.."Cry"},
	{"{可爱}",	fdir.."Cutie"},
	{"{鄙视}",	fdir.."Despise"},
	{"{美梦}",	fdir.."Dreamsmile"},
	{"{尴尬}",	fdir.."Embarrass"},
	{"{邪恶}",	fdir.."Evil"},
	{"{兴奋}",	fdir.."Excited"},

	{"{晕}",	fdir.."Faint"},
	{"{打架}",	fdir.."Fight"},
	{"{流感}",	fdir.."Flu"},
	{"{呆}",	fdir.."Freeze"},
	{"{皱眉}",	fdir.."Frown"},
	{"{致敬}",	fdir.."Greet"},
	{"{鬼脸}",	fdir.."Grimace"},
	{"{龇牙}",	fdir.."Growl"},
	{"{开心}",	fdir.."Happy"},
	{"{心}",	fdir.."Heart"},

	{"{恐惧}",	fdir.."Horror"},
	{"{生病}",	fdir.."Ill"},
	{"{无辜}",	fdir.."Innocent"},
	{"{功夫}",	fdir.."Kongfu"},
	{"{花痴}",	fdir.."Love"},
	{"{邮件}",	fdir.."Mail"},
	{"{化妆}",	fdir.."Makeup"},
	{"{马里奥}",	fdir.."Mario"},
	{"{沉思}",	fdir.."Meditate"},
	{"{可怜}",	fdir.."Miserable"},

	{"{好}",	fdir.."Okay"},
	{"{漂亮}",	fdir.."Pretty"},
	{"{吐}",	fdir.."Puke"},
	{"{握手}",	fdir.."Shake"},
	{"{喊}",	fdir.."Shout"},
	{"{闭嘴}",	fdir.."Shuuuu"},
	{"{害羞}",	fdir.."Shy"},
	{"{睡觉}",	fdir.."Sleep"},
	{"{微笑}",	fdir.."Smile"},
	{"{吃惊}",	fdir.."Suprise"},

	{"{失败}",	fdir.."Surrender"},
	{"{流汗}",	fdir.."Sweat"},
	{"{流泪}",	fdir.."Tear"},
	{"{悲剧}",	fdir.."Tears"},
	{"{想}",	fdir.."Think"},
	{"{偷笑}",	fdir.."Titter"},
	{"{猥琐}",	fdir.."Ugly"},
	{"{胜利}",	fdir.."Victory"},
	{"{雷锋}",	fdir.."Volunteer"},
	{"{委屈}",	fdir.."Wronged"},
}

local fmtstring = format("\124T%%s:%d\124t",max(floor(select(2,SELECTED_CHAT_FRAME:GetFont())),Config.iconSize))

local function myChatFilter(self, event, msg, ...)
	for i = customEmoteStartIndex, #emotes do
		if msg:find(emotes[i][1]) then
			msg = msg:gsub(emotes[i][1],format(fmtstring,emotes[i][2]),1)
			break
		end
	end
	return false, msg, ...
end

local ShowEmoteTableButton
local EmoteTableFrame

function EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(frame.text)
	end
	ToggleEmoteTable()
end

function CreateEmoteTableFrame()
	EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", UIParent)

	EmoteTableFrame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true, tileSize = 16, edgeSize = 5,
		insets = { left = -1, right = -1, top = -1, bottom = -1 }
	})
	EmoteTableFrame:SetBackdropColor(0.05, 0.05, 0.05)
	EmoteTableFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)
	EmoteTableFrame:SetWidth((Config.iconSize+2) * 12+10)
	EmoteTableFrame:SetHeight((Config.iconSize+2) * 5+10)
	EmoteTableFrame:SetPoint("BOTTOM", ChatFrame1EditBox, 0, 30)
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i=1,#emotes do
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d",i), EmoteTableFrame)
		icon:SetWidth(Config.iconSize)
		icon:SetHeight(Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", 5+(col-1)*(Config.iconSize+2), -5-(row-1)*(Config.iconSize+2))
		icon:SetScript("OnMouseUp", EmoteIconMouseUp)
		icon:EnableMouse(true)
		col = col + 1
		if (col>12) then
			row = row + 1
			col = 1
		end
	end
end

function ToggleEmoteTable()
	if (not EmoteTableFrame) then CreateEmoteTableFrame() end
	if (EmoteTableFrame:IsShown()) then
		EmoteTableFrame:Hide()
	else
		EmoteTableFrame:Show()
	end

end

function ChatEmoteButtons()
	local button = CreateFrame("Button", format("ShowEmoteTableButton"), UIParent)
	button:SetPoint("BOTTOMRIGHT", ChatFrame1EditBox , -20, 25)
	button:SetHeight(24)
	button:SetWidth(24)
	button:SetAlpha(0)

	local buttontexture = button:CreateTexture(nil, "BORDER")
	buttontexture:SetTexture("InterFace\\AddOns\\ChatEmote\\icon\\text_push_icon")
	buttontexture:SetPoint("CENTER")
	buttontexture:SetHeight(24)
	buttontexture:SetWidth(24)

	button:SetScript("OnMouseUp", function(self, btn)
		self:SetPushedTexture("InterFace\\AddOns\\ChatEmote\\icon\\text_push_frame")
		PlaySound("igMainMenuOption")
		ToggleEmoteTable()
	end)
	button:SetScript("OnEnter", function()
		button:SetHighlightTexture("InterFace\\AddOns\\ChatEmote\\icon\\text_push_icon")
		button:SetAlpha(1)
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(0) end)
	button:Show()
	ShowEmoteTableButton = button
end

local MaxBubbleWidth = 250

function HandleBubbleEmote(frame, fontstring)
	if not frame:IsShown() then
		fontstring.cachedText = nil
		return
	end

	MaxBubbleWidth = math.max(frame:GetWidth(), MaxBubbleWidth)

	local text = fontstring:GetText() or ""

	if text == fontstring.cachedText then return end

	frame:SetBackdropBorderColor(fontstring:GetTextColor())
	--fontstring:SetFont(ChatFrame1:GetFont(),select(2,ChatFrame1:GetFont()))
	local term;
	for tag in string.gmatch(text, "%b{}") do
		term = strlower(string.gsub(tag, "[{}]", ""));
		if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
			text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
		end
	end

	for i = customEmoteStartIndex, #emotes do
		if text:find(emotes[i][1]) then
			text = text:gsub(emotes[i][1],format(fmtstring,emotes[i][2]),1)
			break
		end
	end
	fontstring:SetText(text)
	fontstring.cachedText = text
	fontstring:SetWidth(math.min(fontstring:GetStringWidth(), MaxBubbleWidth - 14))
end

function CheckBubbles()
	for i=1,WorldFrame:GetNumChildren() do
		local v = select(i, WorldFrame:GetChildren())
		local b = v:GetBackdrop()
		if b and b.bgFile == "Interface\\Tooltips\\ChatBubble-Background" then
			for i=1,v:GetNumRegions() do
				local frame = v
				local v = select(i, v:GetRegions())
				if v:GetObjectType() == "FontString" then
					HandleBubbleEmote(frame, v)
				end
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", myChatFilter)

if (Config.enableEmoteInput) then
	CreateEmoteTableFrame()
	ChatEmoteButtons()
end



if (Config.enableBubbleEmote) then
	local BubbleScanInterval = 0.15
	AddonFrame = CreateFrame("Frame")
	AddonFrame.interval = BubbleScanInterval
	AddonFrame:SetScript("OnUpdate",
	function(frame, elapsed)
		frame.interval = frame.interval - elapsed
		if frame.interval < 0 then
			frame.interval = BubbleScanInterval
			CheckBubbles()
		end
	end)
end

