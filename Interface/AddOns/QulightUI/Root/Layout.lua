buttonsize = Qulight["actionbar"].buttonsize
buttonspacing = Qulight["actionbar"].buttonspacing
petbuttonsize = Qulight["actionbar"].petbuttonsize
petbuttonspacing = Qulight["actionbar"].petbuttonspacing

if Qulight["general"].topbottompanel then
	local BottomPanel = CreateFrame("Frame", "BottomPanel", UIParent)
	CreatePanel(BottomPanel, 4000, 25, "BOTTOM", 0, -5)
	CreateStyle(BottomPanel, 2)
	BottomPanel:SetAlpha(.5)

	local TopPanel = CreateFrame("Frame", "TopPanel", UIParent)
	CreatePanel(TopPanel, 4000, 25, "TOP", 0, 5)
	CreateStyle(TopPanel, 2)
	TopPanel:SetAlpha(.5)
end

Anchorchatbgdummy = CreateFrame("Frame","Move_chatbgdummy",UIParent)
--Anchorchatbgdummy:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 3)
Anchorchatbgdummy:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 3, 18)
CreateAnchor(Anchorchatbgdummy, "Move Chat", 440, 172)

local ChatPanel = CreateFrame("Frame", "ChatBackground", UIParent)
CreatePanel(ChatPanel, 440, 172, "BOTTOMLEFT", Anchorchatbgdummy)
CreateStyle(ChatPanel, 2)
-- 聊天栏背景透明度
ChatPanel:SetAlpha(.5)

Anchordamagelol = CreateFrame("Frame","Move_damagelol",UIParent)
--Anchordamagelol:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 3)
Anchordamagelol:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -3, 18)
CreateAnchor(Anchordamagelol, "Move Damage Background", 440, 172)

local ChatPanelTwo = CreateFrame("Frame", "ChatPanelRight", UIParent)
CreatePanel(ChatPanelTwo, 440, 172, "BOTTOMRIGHT", Anchordamagelol)
CreateStyle(ChatPanelTwo, 2)
-- 右侧信息栏背景透明度
ChatPanelTwo:SetAlpha(.5)

if Qulight["chatt"].chatbar then
	local chatbar = CreateFrame("Frame", "chatbar", UIParent)
	CreatePanel(chatbar, 13, 121, "RIGHT", ChatBackground, "RIGHT", -4, -1)
	CreateStyle(chatbar, 2, 1)
end

local LeftInfoPanel = CreateFrame("Frame", "DataLeftPanel", UIParent)
SimpleBackground(LeftInfoPanel, 430, 15, "BOTTOM", ChatPanel, "BOTTOM", 0, 5)
CreateStyle(LeftInfoPanel, 3, 1)

local LeftTabPanel = CreateFrame("Frame", "LeftTabPanel", UIParent)
--SimpleBackground(LeftTabPanel, 430, 15, "TOP", ChatPanel, "TOP", 0, -5)
CreateStyle(LeftTabPanel, 3, 1)

local RightInfoPanel = CreateFrame("Frame", "DataRightPanel", UIParent)
SimpleBackground(RightInfoPanel, 437, 15, "BOTTOMRIGHT", ChatPanelTwo, "BOTTOMRIGHT", -2, -5)
--SimpleBackground(RightInfoPanel, 428, 15, "TOPRIGHT", ChatPanelTwo, "TOPRIGHT", -1, 0)
CreateStyle(RightInfoPanel, 3, 1)

--[[屏蔽左右信息栏
if Qulight["general"].centerpanel then
	local RightUpInfoPanel = CreateFrame ("Frame", "RightUpInfoPanel", UIParent)
	CreatePanel(RightUpInfoPanel, 438, 15, "TOP", ChatPanelTwo, "TOP", 0, 16)
	CreateStyle(RightUpInfoPanel, 3, 1)

	local LeftUpInfoPanel = CreateFrame("Frame", "LeftUpInfoPanel", UIParent)
	CreatePanel(LeftUpInfoPanel, 438, 15, "TOP", ChatPanel, 0, 16)
	CreateStyle(LeftUpInfoPanel, 3, 1)
end
]]
Anchorminimaplol = CreateFrame("Frame","Move_minimaplol",UIParent)
--Anchorminimaplol:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 3, -3)
Anchorminimaplol:SetPoint("TOPLEFT", ChatPanelTwo, "TOPLEFT", 0, 0)
CreateAnchor(Anchorminimaplol, "Move Minimap", Qulight["minimapp"].size+4, Qulight["minimapp"].size+4)

local minimaplol = CreateFrame("Frame", "minimaplol", UIParent)
CreatePanel(minimaplol, Qulight["minimapp"].size+4, Qulight["minimapp"].size+4, "BOTTOMRIGHT", Anchorminimaplol)
CreateStyle(minimaplol, 2, 1)

---------------------
--Acton Bar Panels
---------------------
if Qulight["actionbar"].enable then

	local mbWidth = Qulight.actionbar.mainbarWidth

	AnchorQuBar1 = CreateFrame("Frame","Move_Bar1",UIParent)
	--AnchorQuBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 278)
	AnchorQuBar1:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 4)
	CreateAnchor(AnchorQuBar1, "Move Bar1", (buttonsize * mbWidth) + (buttonspacing * (mbWidth-1)), buttonsize)

	local QuBar1 = CreateFrame("Frame", "QuBar1", UIParent, "SecureHandlerStateTemplate")
	CreatePanel(QuBar1, 1, 1, "BOTTOM", AnchorQuBar1, "BOTTOM")
	QuBar1:SetWidth((buttonsize * mbWidth) + (buttonspacing * (mbWidth-1)))
	QuBar1:SetHeight((buttonsize * 2) + (buttonspacing * 3))
	QuBar1:SetFrameStrata("BACKGROUND")
	QuBar1:SetFrameLevel(1)

	local QuBar2 = CreateFrame("Frame", "QuBar2", UIParent)
	CreatePanel(QuBar2, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 10)
	QuBar2:SetWidth((buttonsize * 6) + (buttonspacing * 7))
	QuBar2:SetHeight((buttonsize * 2) + (buttonspacing * 3))
	QuBar2:SetFrameStrata("BACKGROUND")
	QuBar2:SetFrameLevel(2)

	local QuBar3 = CreateFrame("Frame", "QuBar3", UIParent)
	CreatePanel(QuBar3, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 10)
	QuBar3:SetWidth((buttonsize * 6) + (buttonspacing * 7))
	QuBar3:SetHeight((buttonsize * 2) + (buttonspacing * 3))
	QuBar3:SetFrameStrata("BACKGROUND")
	QuBar3:SetFrameLevel(2)

	AnchorQuBar5 = CreateFrame("Frame","Move_Bar5",UIParent)
	--AnchorQuBar5:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 243)
	AnchorQuBar5:SetPoint("TOP", QuBar1, "TOP", 0, 0)
	CreateAnchor(AnchorQuBar5, "Move Bar5", (buttonsize * mbWidth) + (buttonspacing * (mbWidth-1)), buttonsize)

	local QuBar5 = CreateFrame("Frame", "QuBar5", UIParent)
	CreatePanel(QuBar5, 1, 1, "TOP", AnchorQuBar5, "TOP")
	QuBar5:SetWidth((buttonsize * mbWidth) + (buttonspacing * (mbWidth-1)))
	QuBar5:SetHeight((buttonsize * 2) + (buttonspacing * 3))
	QuBar5:SetFrameStrata("BACKGROUND")
	QuBar5:SetFrameLevel(2)

	AnchorQuBar4 = CreateFrame("Frame","Move_Bar4",UIParent)
	--[[ bar4 屏蔽左右信息栏高度修改，恢复默认信息栏请还原并把138行删除
		if Qulight["general"].centerpanel then
			AnchorQuBar4:SetPoint("TOPLEFT", ChatPanelTwo, "TOPLEFT", -3, 53)
		else
			AnchorQuBar4:SetPoint("TOPLEFT", ChatPanelTwo, "TOPLEFT", -3, 36)
		end
	]]
	AnchorQuBar4:SetPoint("TOPLEFT", ChatPanelTwo, "TOPLEFT", -3, 36)
	CreateAnchor(AnchorQuBar4, "Move Bar4", (buttonsize * 12) + (buttonspacing * 13), buttonsize)

	local QuBar4 = CreateFrame("Frame", "QuBar4", UIParent)
	CreatePanel(QuBar4, 1, 1, "TOP", AnchorQuBar4, "TOP")
	QuBar4:SetWidth((buttonsize * 12) + (buttonspacing * 13))
	QuBar4:SetHeight(buttonsize)
	QuBar4:SetFrameStrata("BACKGROUND")
	QuBar4:SetFrameLevel(2)
	QuBar4:SetAlpha(0)
	QuBar4:SetScale(0.99)

	AnchorQuBar6 = CreateFrame("Frame","Move_Bar6",UIParent)
	--AnchorQuBar6:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 4)
	--CreateAnchor(AnchorQuBar6, "Move Bar6", (buttonsize * 12) + (buttonspacing * 13), buttonsize)
	AnchorQuBar6:SetPoint("LEFT", ChatPanel, "BOTTOMRIGHT", 70, 36)
	CreateAnchor(AnchorQuBar6, "Move Bar6", (buttonsize * 6) + (buttonspacing * 7), (buttonsize * 2) + (buttonspacing * 4))

	local QuBar6 = CreateFrame("Frame", "QuBar6", UIParent)
	--QuBar6:SetWidth((buttonsize * 12) + (buttonspacing * 13))
	--QuBar6:SetHeight(buttonsize)
	QuBar6:SetWidth((buttonsize * 6) + (buttonspacing * 7))
	QuBar6:SetHeight((buttonsize * 2) + (buttonspacing * 4))
	QuBar6:SetPoint("TOP", AnchorQuBar6, "TOP")
	QuBar6:SetFrameStrata("BACKGROUND")
	QuBar6:SetFrameLevel(2)
	QuBar6:SetAlpha(0)

	AnchorQuBar7 = CreateFrame("Frame","Move_Bar7",UIParent)
	--AnchorQuBar7:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 41)
	--CreateAnchor(AnchorQuBar7, "Move Bar7", (buttonsize * 12) + (buttonspacing * 13), buttonsize)
	AnchorQuBar7:SetPoint("RIGHT", ChatPanelTwo, "BOTTOMLEFT", -70, 36)
	CreateAnchor(AnchorQuBar7, "Move Bar7", (buttonsize * 6) + (buttonspacing * 7), (buttonsize * 2) + (buttonspacing * 4))

	local QuBar7 = CreateFrame("Frame", "QuBar7", UIParent)
	--QuBar7:SetWidth((buttonsize * 12) + (buttonspacing * 13))
	--QuBar7:SetHeight(buttonsize)
	QuBar7:SetWidth((buttonsize * 6) + (buttonspacing * 7))
	QuBar7:SetHeight((buttonsize * 2) + (buttonspacing * 4))
	QuBar7:SetPoint("TOP", AnchorQuBar7, "TOP")
	QuBar7:SetFrameStrata("BACKGROUND")
	QuBar7:SetFrameLevel(2)
	QuBar7:SetAlpha(0)

	Anchorpetbg = CreateFrame("Frame","Move_petbar",UIParent)
	--[[ petbar 屏蔽左右信息栏高度修改，恢复默认信息栏请还原并把190行删除
		if Qulight["general"].centerpanel then
			Anchorpetbg:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 113, 193)
		else
			Anchorpetbg:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", 113, 177)
		end
	]]
	Anchorpetbg:SetPoint("TOPLEFT", ChatPanel, "TOPLEFT", 110, 34)
	CreateAnchor(Anchorpetbg, "Move petbar", (petbuttonsize * 10) + (petbuttonspacing * 11), petbuttonsize)


	local petbg = CreateFrame("Frame", "QuPetBar", UIParent, "SecureHandlerStateTemplate")
	CreatePanel(petbg, (petbuttonsize * 10) + (petbuttonspacing * 11),petbuttonsize + (petbuttonspacing * 2) , "TOP", Anchorpetbg, "TOP")

	local ltpetbg1 = CreateFrame("Frame", "QuLineToPetActionBarBackground", petbg)
	CreatePanel(ltpetbg1, 24, 265, "LEFT", petbg, "RIGHT", 0, 0)
	ltpetbg1:SetParent(petbg)
	CreateStyle(ltpetbg1, 2)

	local invbarbg = CreateFrame("Frame", "InvQuActionBarBackground", UIParent)
	invbarbg:SetPoint("TOPLEFT", QuBar2)
	invbarbg:SetPoint("BOTTOMRIGHT", QuBar3)
end


for i = 1, NUM_CHAT_WINDOWS do
	local SkadaButton = _G[format("DataRightPanel",  i)]
	local button = CreateFrame("Button", format("ButtonCF%d", i), SkadaButton)
	button:SetPoint("TOPLEFT", -70, 20)
	button:SetHeight(20)
	button:SetWidth(60)
	button:SetAlpha(0)
	CreateStyle(button, 3, 0, 1, 1)

	local Text  = button:CreateFontString(nil, "OVERLAY")
	Text:SetFont(Qulight["media"].font, 10, "OVERLAY")
	Text:SetText("Skada")
	Text:SetPoint("CENTER", 0, 0)

	button:SetScript("OnMouseUp", function(self)
		Skada:ToggleWindow()
	end)
	button:SetScript("OnEnter", function()
		button:SetAlpha(1)
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(0) end)

end