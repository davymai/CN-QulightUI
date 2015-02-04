if not Qulight["minimapp"].enable == true then return end

local font = Qulight["media"].font
local fontsize = 12
local fontflag = "OUTLINE"
local Scale = 1
local classcolors = true -- class color text

Minimap:ClearAllPoints()
Minimap:SetPoint("CENTER", minimaplol, "CENTER", 0, 0)
MinimapCluster:EnableMouse(false)
Minimap:SetSize(Qulight["minimapp"].size,Qulight["minimapp"].size)
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
Minimap:SetHitRectInsets(0, 0, 24*Scale, 24*Scale)
Minimap:SetFrameLevel(4)
Minimap:SetScale(Scale)
Minimap:SetArchBlobRingScalar(0);
Minimap:SetQuestBlobRingScalar(0);

if(IsAddOnLoaded('!ClassColors') and CUSTOM_CLASS_COLORS) then
	color = CUSTOM_CLASS_COLORS[select(2, UnitClass("player"))]
end

if classcolors == true then
	color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass("player"))]
else
	color = {r=255/255, g=255/255, b=255/255 } -- own textcolor
end

local oldOnClick = Minimap:GetScript("OnMouseUp")
Minimap:SetScript("OnMouseUp", function(self,click)
	if(click=="RightButton") then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
	elseif(click=="MiddleButton") then
		if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle()
	else
		oldOnClick(self)
	end
end)

local rd = CreateFrame("Frame", nil, Minimap)
rd:SetSize(24, 8)
rd:RegisterEvent("PLAYER_ENTERING_WORLD")
rd:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
rd:RegisterEvent("GUILD_PARTY_STATE_UPDATED")

local rdt = rd:CreateFontString(nil, "OVERLAY")
rdt:SetPoint("TOP", Minimap, "TOP", 0, -10)
rdt:SetFont(font, fontsize, fontflag)

rd:SetScript("OnEvent", function()
	local _, _, difficulty, _, maxPlayers = GetInstanceInfo()

	if difficulty == 0 then
		rdt:SetText("")
	elseif maxPlayers == 3 then
		rdt:SetText("3")
	elseif difficulty == 1 then
		rdt:SetText("5")
	elseif difficulty == 2 then
		rdt:SetText("5H")
	elseif difficulty == 3 then
		rdt:SetText("10")
	elseif difficulty == 4 then
		rdt:SetText("25")
	elseif difficulty == 5 then
		rdt:SetText("10H")
	elseif difficulty == 6 then
		rdt:SetText("25H")
	elseif difficulty == 7 then
		rdt:SetText("LFR")
	elseif difficulty == 8 then
		rdt:SetText("5CM")
	elseif difficulty == 9 then
		rdt:SetText("40")
	end

	if GuildInstanceDifficulty:IsShown() then
		rdt:SetTextColor(color.r, color.g, color.b)
	else
		rdt:SetTextColor(color.r, color.g, color.b)
	end
end)

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Hide()
			else
				region:SetTexture(nil)
			end
		end
	end
end
--[[ BG icon ]]

QueueStatusMinimapButton:SetParent(Minimap)
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("TOPRIGHT", 0, 0)
QueueStatusMinimapButtonBorder:Hide()
StripTextures(QueueStatusFrame)
CreateStyle(QueueStatusFrame, 2)

MiniMapWorldMapButton:Hide()

local function UpdateLFGTooltip()
	QueueStatusFrame:ClearAllPoints()
	QueueStatusFrame:SetPoint("TOPRIGHT", QueueStatusMinimapButton, "TOPLEFT", 0, 0)
end
QueueStatusFrame:HookScript("OnShow", UpdateLFGTooltip)
QueueStatusFrame:SetFrameStrata("TOOLTIP")

MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("BOTTOMRIGHT", Minimap, 0, 0)
MiniMapMailFrame:SetFrameStrata("LOW")
MiniMapMailIcon:SetTexture("Interface\\AddOns\\QulightUI\\Root\\Media\\mail.tga")
MiniMapMailBorder:Hide()

--[[Garrison Minimap Icon]]
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetParent(Minimap)
GarrisonLandingPageMinimapButton:SetSize(35,35)
GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", 5, 0)

MiniMapTracking:ClearAllPoints()
MiniMapTracking:SetParent(Minimap)
MiniMapTracking:SetPoint('TOPLEFT', 0, 0)
MiniMapTracking:SetAlpha(0)
MiniMapTrackingBackground:Hide()
MiniMapTrackingButtonBorder:SetTexture(nil)
MiniMapTrackingButton:SetHighlightTexture(nil)
MiniMapTrackingIconOverlay:SetTexture(nil)
MiniMapTrackingIcon:SetTexCoord(0.065, 0.935, 0.065, 0.935)
MiniMapTrackingIcon:SetWidth(20)
MiniMapTrackingIcon:SetHeight(20)

qMap = CreateFrame("Frame", "qMap", UIParent)
qMap:RegisterEvent("ADDON_LOADED")
qMap:SetScript("OnEvent", function(self, event, addon)

    qMap.tracking = CreateFrame("Frame", nil, Minimap)

	MiniMapTrackingButton:SetScript("OnEnter",function()
		MiniMapTracking:SetAlpha(1)
        qMap.tracking:SetAlpha(1)
	end)

    Minimap:SetScript("OnLeave", function()
        MiniMapTracking:SetAlpha(0)
        qMap.tracking:SetAlpha(0)
    end)

	MiniMapTrackingButton:SetScript("OnLeave", function()
        MiniMapTracking:SetAlpha(0)
        qMap.tracking:SetAlpha(0)
    end)

	MiniMapTrackingButton:SetScript("OnMouseUp", function(self,click)
	    if(click=="RightButton") then
		    ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, "cursor", 0, 0)
		elseif(click=="MiddleButton") then
			if (not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end Calendar_Toggle()
		end
	end)
	qMap.tracking.text = t

    self:UnregisterEvent(event)
end)

function GetMinimapShape() return "SQUARE" end

--[[ Hiding ugly things	]]
local dummy = function() end
local frames = {
    "MiniMapVoiceChatFrame",
    "MiniMapWorldMapButton",
    "MinimapZoneTextButton",
    "MiniMapMailBorder",
    "MiniMapInstanceDifficulty",
    "MinimapNorthTag",
    "MinimapZoomOut",
    "MinimapZoomIn",
    "MinimapBackdrop",
    "GameTimeFrame",
    "GuildInstanceDifficulty",
	"MiniMapChallengeMode",
	"MinimapBorderTop",
}
GameTimeFrame:SetAlpha(0)
GameTimeFrame:EnableMouse(false)
GameTimeCalendarInvitesTexture:SetParent("Minimap")

for i in pairs(frames) do
    _G[frames[i]]:Hide()
    _G[frames[i]].Show = dummy
end

Minimap:SetScript('OnMouseUp', function(self, button)
Minimap:StopMovingOrSizing()
    if (button == 'RightButton') then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    elseif (button == 'MiddleButton') then
        ToggleCalendar()
    else
        Minimap_OnClick(self)
    end
end)

--[[ Mousewheel zoom ]]
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(_, zoom)
    if zoom > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut()
    end
end)

--[[ Clock ]]
if not IsAddOnLoaded("Blizzard_TimeManager") then
	LoadAddOn("Blizzard_TimeManager")
end
local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
clockFrame:Hide()
clockTime:SetFont(Qulight["media"].font, fontsize, fontflag)
clockTime:SetShadowOffset(0,0)
clockTime:SetTextColor(color.r, color.g, color.b)
TimeManagerClockButton:ClearAllPoints()
TimeManagerClockButton:SetPoint("BOTTOM", Minimap, "BOTTOM", 0, -9)
TimeManagerClockButton:SetScript('OnShow', nil)
TimeManagerClockButton:Hide()
TimeManagerClockButton:SetScript('OnClick', function(self, button)
	if(button=="RightButton") then
		if(self.alarmFiring) then
			PlaySound('igMainMenuQuit')
			TimeManager_TurnOffAlarm()
		else
			ToggleTimeManager()
		end
	else
		ToggleCalendar()
	end
end)
TimeManagerFrame:ClearAllPoints()
TimeManagerFrame:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
TimeManagerFrame:SetClampedToScreen(true)
TimeManagerFrame:SetToplevel(true)

SlashCmdList["CALENDAR"] = function()
	ToggleCalendar()
end
SLASH_CALENDAR1 = "/cl"
SLASH_CALENDAR2 = "/calendar"

local cal = CreateFrame("Frame", nil, Minimap)
GameTimeFrame:HookScript("OnShow", cal.Show)
GameTimeFrame:SetScript("OnEvent", function(self, event, addon)


end)

if CalendarGetNumPendingInvites() ~= 0 then
		clockTime:SetTextColor(.67,.35,.35)
	else
		clockTime:SetTextColor(color.r, color.g, color.b)
end

local config = {
["showPicomenu"] = true,
}


if config.showPicomenu == true then
local menuFrame = CreateFrame('Frame', 'picomenuDropDownMenu', MainMenuBar, 'UIDropDownMenuTemplate')

local menuList = {
    {
        text = MAINMENU_BUTTON,
        isTitle = true,
        notCheckable = true,
    },
    {
        text = CHARACTER_BUTTON,
        icon = 'Interface\\PaperDollInfoFrame\\UI-EquipmentManager-Toggle',
        func = function()
            securecall(ToggleCharacter, 'PaperDollFrame')
        end,
                tooltipTitle = 'MOOO',
        notCheckable = true,
    },
    {
        text = SPELLBOOK_ABILITIES_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Class',
        func = function()
            securecall(ToggleSpellBook, BOOKTYPE_SPELL)
        end,
        notCheckable = true,
    },
    {
        text = TALENTS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\Ammunition',
        func = function()
			if (not PlayerTalentFrame) then
                LoadAddOn('Blizzard_TalentUI')
            end

			if (not GlyphFrame) then
                LoadAddOn('Blizzard_GlyphUI')
            end

			PlayerTalentFrame_Toggle()
        end,
        notCheckable = true,
    },
    {
        text = ACHIEVEMENT_BUTTON,
        icon = 'Interface\\AddOns\\QulightUI\\Root\\Media\\picomenu\\picomenuAchievement',
        func = function()
            securecall(ToggleAchievementFrame)
        end,
        notCheckable = true,
    },
    {
        text = QUESTLOG_BUTTON,
        icon = 'Interface\\GossipFrame\\ActiveQuestIcon',
        func = function()
        	ToggleQuestLog()
        end,
        notCheckable = true,
    },
    {
        text = GUILD,
        icon = 'Interface\\GossipFrame\\TabardGossipIcon',
        arg1 = IsInGuild('player'),
        func = function()
            ToggleGuildFrame()
        end,
        notCheckable = true,
    },
    {
        text = SOCIAL_BUTTON,
        icon = 'Interface\\FriendsFrame\\PlusManz-BattleNet',
        func = function()
            securecall(ToggleFriendsFrame, 1)
        end,
        notCheckable = true,
    },
    {
        --text = PLAYER_V_PLAYER,
        --icon = 'Interface\\MINIMAP\\TRACKING\\BattleMaster',
        --func = function()
            --securecall(TogglePVPUI, 1)
        --end,
        --notCheckable = true,
    },
    {
        text = DUNGEONS_BUTTON,
        icon = 'Interface\\MINIMAP\\TRACKING\\None',
        func = function()
            securecall(ToggleLFDParentFrame)
        end,
        notCheckable = true,
    },
    {
        text = MOUNTS_AND_PETS,
        icon = 'Interface\\MINIMAP\\TRACKING\\StableMaster',
        func = function()
            securecall(TogglePetJournal)
        end,
        notCheckable = true,
    },
    {
        text = RAID,
        icon = 'Interface\\TARGETINGFRAME\\UI-TargetingFrame-Skull',
        func = function()
            securecall(ToggleFriendsFrame, 4)
        end,
        notCheckable = true,
    },
    {
        text = ENCOUNTER_JOURNAL,
        icon = 'Interface\\MINIMAP\\TRACKING\\Profession',
        func = function()
            securecall(ToggleEncounterJournal)
        end,
        notCheckable = true,
    },
    {
        text = GM_EMAIL_NAME,
        icon = 'Interface\\CHATFRAME\\UI-ChatIcon-Blizz',
        func = function()
            securecall(ToggleHelpFrame)
        end,
        notCheckable = true,
    },
    {
        text = BATTLEFIELD_MINIMAP,
        colorCode = '|cff999999',
        func = function()
            securecall(ToggleBattlefieldMinimap)
        end,
        notCheckable = true,
    },
}


local f = CreateFrame('Button', nil, UIParent)
f:SetSize(11,8)
f:SetPoint('BOTTOMLEFT', Minimap, 'BOTTOMLEFT', 0, 0)
f:RegisterForClicks('Anyup')
f:RegisterEvent('ADDON_LOADED')

f:SetNormalTexture('Interface\\AddOns\\QulightUI\\Root\\Media\\picomenu\\picomenuNormal')
f:GetNormalTexture():SetSize(11,8)

f:SetHighlightTexture('Interface\\AddOns\\QulightUI\\Root\\Media\\picomenu\\picomenuHighlight')
f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())

f:SetScript('OnMouseDown', function(self)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER', 1, -1)
end)

f:SetScript('OnMouseUp', function(self, button)
    self:GetNormalTexture():ClearAllPoints()
    self:GetNormalTexture():SetPoint('CENTER')

    if (button == 'LeftButton') then
        if (self:IsMouseOver()) then
            if (DropDownList1:IsShown()) then
                DropDownList1:Hide()
            else
                securecall(EasyMenu, menuList, menuFrame, self, 27, 190, 'MENU', 8)
                -- DropDownList1:ClearAllPoints()
                -- DropDownList1:SetPoint('BOTTOMLEFT', self, 'TOPRIGHT')
            end
        end
    else
        if (self:IsMouseOver()) then
            ToggleFrame(GameMenuFrame)
        end
    end

    GameTooltip:Hide()
end)

f:SetScript('OnEnter', function(self)
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT', 25, -5)
    GameTooltip:AddLine(MAINMENU_BUTTON)
    GameTooltip:Show()
end)

f:SetScript('OnLeave', function()
    GameTooltip:Hide()
end)
end
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -26, 26)
HelpOpenTicketButton:SetScale(0.6)
HelpOpenTicketButton:SetParent(f)

----------------------------------------------------------------------------------------
-- Mouseover map, displaying zone and coords
----------------------------------------------------------------------------------------
--增加地图名称显示
local m_zone = CreateFrame("Frame","QuMinimapZone",UIParent)
SimpleBackground(m_zone, 85, 10, "TOP", UIParent, "TOP", 0, 0)
m_zone:SetSize(155, 16)
m_zone:SetPoint("TOP", UIParent, "TOP", 1, -3)
m_zone:SetFrameLevel(3)
m_zone:SetFrameStrata("MEDIUM")

local m_zone_text = m_zone:CreateFontString(nil, "Overlay")
m_zone_text:SetFont(Qulight["media"].font, 10 ,"OUTLINE")
m_zone_text:SetPoint("Center",0,0)
m_zone_text:SetJustifyH("CENTER")
m_zone_text:SetJustifyV("MIDDLE")
m_zone_text:SetHeight(10)

local zone_Update = function()
    local pvpType = GetZonePVPInfo()
    m_zone_text:SetText(strsub(GetMinimapZoneText(), 1, 50))
    if pvpType == "arena" then
        m_zone_text:SetTextColor(0.84, 0.03, 0.03)
    elseif pvpType == "friendly" then
        m_zone_text:SetTextColor(0.05, 0.85, 0.03)
    elseif pvpType == "contested" then
        m_zone_text:SetTextColor(0.9, 0.85, 0.05)
    elseif pvpType == "hostile" then
        m_zone_text:SetTextColor(0.84, 0.03, 0.03)
    elseif pvpType == "sanctuary" then
        m_zone_text:SetTextColor(0.0352941, 0.58823529, 0.84705882)
    elseif pvpType == "combat" then
        m_zone_text:SetTextColor(0.84, 0.03, 0.03)
    else
        m_zone_text:SetTextColor(0.84, 0.03, 0.03)
    end
end
m_zone:RegisterEvent("PLAYER_ENTERING_WORLD")
m_zone:RegisterEvent("ZONE_CHANGED_NEW_AREA")
m_zone:RegisterEvent("ZONE_CHANGED")
m_zone:RegisterEvent("ZONE_CHANGED_INDOORS")
m_zone:SetScript("OnEvent", zone_Update)
local a,k = CreateFrame("Frame"),4
a:SetScript("OnUpdate",function(self,t)
    k = k - t
    if k > 0 then return end
    self:Hide()
    zone_Update()
end)
---
local m_coord = CreateFrame("Frame","QuMinimapCoord",minimap)
m_coord:SetSize(30,15)
m_coord:SetPoint("TOP", minimaplol, "TOP", 0,0)
m_coord:SetFrameLevel(3)
m_coord:SetFrameStrata("MEDIUM")
m_coord:SetAlpha(0)

local m_coord_text = m_coord:CreateFontString("QuMinimapCoordText","minimap")
m_coord_text:SetFont(Qulight["media"].font, 8, "OUTLINE")
--m_coord_text:SetPoint("BOTTOMRIGHT", minimaplol, "BOTTOMRIGHT", -35,3)
m_coord_text:SetPoint("BOTTOM", minimaplol, "BOTTOM", 0,3)
m_coord_text:SetAlpha(0)
m_coord_text:SetText("00,00")

Minimap:SetScript("OnEnter",function()
	m_coord:SetAlpha(1)
	m_coord_text:SetAlpha(1)
end)

Minimap:SetScript("OnLeave",function()
	m_coord:SetAlpha(0)
	m_coord_text:SetAlpha(0)
end)

local ela = 0
local coord_Update = function(self,t)
	ela = ela - t
	if ela > 0 then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		m_coord_text:SetText("X _ X")
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		m_coord_text:SetText(xt..","..yt)
	end
	ela = .2
end
m_coord:SetScript("OnUpdate",coord_Update)