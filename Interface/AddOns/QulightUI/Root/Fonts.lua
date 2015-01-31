do
	SetFontString = function(parent, fontName, fontHeight, fontStyle)
		local fs = parent:CreateFontString(nil, "OVERLAY")
		fs:SetFont(Qulight["media"].font, fontHeight, fontStyle)
		fs:SetJustifyH("LEFT")
		fs:SetShadowColor(0, 0, 0)
		fs:SetShadowOffset(1.25, -1.25)
		return fs
	end
end

---------------------
-- Font
---------------------
local Fonts = CreateFrame("Frame", nil, UIParent)
SetFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end
Fonts:RegisterEvent("ADDON_LOADED")
Fonts:SetScript("OnEvent", function(self, event, addon)

	local NORMAL     =  Qulight["media"].font
	local COMBAT     =  Qulight["media"].font
	local NUMBER     =  Qulight["media"].font
	local _, editBoxFontSize, _, _, _, _, _, _, _, _ = GetChatWindowInfo(1)

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	UNIT_NAME_FONT     = NORMAL
	NAMEPLATE_FONT     = NORMAL
	DAMAGE_TEXT_FONT   = COMBAT
	STANDARD_TEXT_FONT = NORMAL

	SetFont(GameTooltipHeader,                  NORMAL, Qulight["media"].fontsize)
	SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, Qulight["media"].fontsize, "OUTLINE")
	SetFont(NumberFont_Outline_Huge,            NUMBER, 28, "THICKOUTLINE", 28)
	SetFont(NumberFont_Outline_Large,           NUMBER, 15, "OUTLINE")
	SetFont(NumberFont_Outline_Med,             Qulight["media"].font, Qulight["media"].fontsize, "OUTLINE")
	SetFont(NumberFont_Shadow_Med,              NORMAL, Qulight["media"].fontsize+1) --chat editbox uses this
	SetFont(NumberFont_Shadow_Small,            NORMAL, Qulight["media"].fontsize)
	SetFont(QuestFont,                          NORMAL, Qulight["media"].fontsize*0.9)
	SetFont(QuestFont_Large,                    NORMAL, 18)
	SetFont(SystemFont_Large,                   NORMAL, 15)
	SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, "THINOUTLINE") -- Raid Warning, Boss emote frame too
	SetFont(SystemFont_Med1,                    NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Med3,                    NORMAL, Qulight["media"].fontsize*1.1)
	SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 20, "THICKOUTLINE")
	SetFont(SystemFont_Outline_Small,           NUMBER, Qulight["media"].fontsize, "OUTLINE")
	SetFont(SystemFont_Shadow_Large,            NORMAL, 15)
	SetFont(SystemFont_Shadow_Med1,             NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Shadow_Med3,             NORMAL, Qulight["media"].fontsize*1.1)
	SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 20, "OUTLINE")
	SetFont(SystemFont_Shadow_Small,            NORMAL, Qulight["media"].fontsize*0.9)
	SetFont(SystemFont_Small,                   NORMAL, Qulight["media"].fontsize)
	SetFont(SystemFont_Tiny,                    NORMAL, Qulight["media"].fontsize)
	SetFont(Tooltip_Med,                        NORMAL, Qulight["media"].fontsize)
	SetFont(Tooltip_Small,                      NORMAL, Qulight["media"].fontsize)
	SetFont(ZoneTextString,						NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextString,					NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(PVPArenaTextString,					NORMAL, 22, "THINOUTLINE")
	SetFont(CombatTextFont,                     COMBAT, 100, "OUTLINE") -- number here just increase the font quality.
	SetFont(InvoiceFont_Med, 					NORMAL, 13)
	SetFont(InvoiceFont_Small,					NORMAL, 10)
	SetFont(MailFont_Large, 					NORMAL, 15)
	SetFont(QuestFont_Shadow_Huge, 				NORMAL, 19)
	SetFont(QuestFont_Shadow_Small, 			NORMAL, 15)
	SetFont(ReputationDetailFont, 				NORMAL, 10)
	SetFont(SpellFont_Small, 					NORMAL, 10)
	SetFont(FriendsFont_Small, 					NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_Normal, 				NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_Large, 					NORMAL, Qulight["media"].fontsize)
	SetFont(FriendsFont_UserText, 				NORMAL, Qulight["media"].fontsize)
	SetFont(ChatBubbleFont, 					NORMAL, Qulight["media"].fontsize)

	SetFont = nil
	self:SetScript("OnEvent", nil)
	self:UnregisterAllEvents()
	self = nil
end)