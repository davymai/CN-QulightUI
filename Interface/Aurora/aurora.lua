local alpha, useButtonGradientColour
local LATEST_API_VERSION = "6.0"

local addon, core = ...

core[1] = {} -- F, functions
core[2] = {} -- C, constants/config

Aurora = core

AuroraConfig = {}

local F, C = unpack(select(2, ...))

C.classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}

C.media = {
	["arrowUp"] = "Interface\\AddOns\\Aurora\\media\\arrow-up-active",
	["arrowDown"] = "Interface\\AddOns\\Aurora\\media\\arrow-down-active",
	["arrowLeft"] = "Interface\\AddOns\\Aurora\\media\\arrow-left-active",
	["arrowRight"] = "Interface\\AddOns\\Aurora\\media\\arrow-right-active",
	["backdrop"] = Qulight["media"].texture,
	["checked"] = "Interface\\AddOns\\Aurora\\media\\CheckButtonHilight",
	["font"] = [=[Interface\Addons\QulightUI\Root\Media\qFont.ttf]=],
	["glow"] = Qulight["media"].glow,
	["gradient"] = "Interface\\AddOns\\Aurora\\media\\gradient",
	["roleIcons"] = "Interface\\AddOns\\Aurora\\media\\UI-LFG-ICON-ROLES",
}

C.defaults = {
	["alpha"] = 0.9,
	["buttonGradientColour"] = {0, 0, 0, .3},
	["buttonSolidColour"] = {.35, .35, .35, .35},
	["useButtonGradientColour"] = false,
	["useCustomColour"] = false,
		["customColour"] = {r = 1, g = 1, b = 1},
	["qualityColour"] = true,
}

C.shouldStyleTooltips = true -- set to false if one of the above is loaded or AuroraConfig.tooltips is false

C.frames = {}

-- [[ Functions ]]

local _, class = UnitClass("player")

if CUSTOM_CLASS_COLORS then
	C.classcolours = CUSTOM_CLASS_COLORS
end

local r, g, b = C.classcolours[class].r, C.classcolours[class].g, C.classcolours[class].b

F.dummy = function() end

F.CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = C.media.backdrop,
		edgeFile = C.media.backdrop,
		edgeSize = 1,
	})
	f:SetBackdropColor(.05,.05,.05, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(C.frames, f) end
end

F.CreateBG = function(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture(C.media.backdrop)
	bg:SetVertexColor(0, 0, 0)

	return bg
end

F.CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = size or 5	
	sd.offset = offset or 0
	sd:SetBackdrop({
		edgeFile = C.media.glow,
		edgeSize = sd.size,
	})
	sd:SetPoint("TOPLEFT", parent, -4, 4)
	sd:SetPoint("BOTTOMRIGHT", parent, 4, -4)
	sd:SetBackdropBorderColor(r or 0, g or 0, b or 0)
	sd:SetAlpha(alpha or 1)
end

local buttonR, buttonG, buttonB, buttonA

F.CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(useButtonGradientColour and C.media.gradient or C.media.backdrop)
	tex:SetVertexColor(0.11, 0.11, 0.11, 1)

	return tex
end

local function colourButton(f)
	if not f:IsEnabled() then return end

	if useButtonGradientColour then
		f:SetBackdropColor(r, g, b, .3)
	else
		f.tex:SetVertexColor(r / 4, g / 4, b / 4)
	end

	f:SetBackdropBorderColor(0, 0, 0)
end

local function clearButton(f)
	if useButtonGradientColour then
		f:SetBackdropColor(0, 0, 0, 0)
	else
		f.tex:SetVertexColor(0.11, 0.11, 0.11, 1)
	end

	f:SetBackdropBorderColor(0, 0, 0)
end

F.Reskin = function(f, noHighlight)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	F.CreateBD(f, .0)

	f.tex = F.CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", colourButton)
 		f:HookScript("OnLeave", clearButton)
	end
end

F.ReskinTab = function(f)
	f:DisableDrawLayer("BACKGROUND")

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 8, -3)
	bg:SetPoint("BOTTOMRIGHT", -8, 0)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)
	F.CreateSD(bg)
	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 9, -4)
	hl:SetPoint("BOTTOMRIGHT", -9, 1)
	hl:SetVertexColor(r, g, b, .25)
end

local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
end

F.ReskinScroll = function(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	F.CreateBD(bu.bg, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)

	F.Reskin(up, true)
	F.Reskin(down, true)

	up:SetDisabledTexture(C.media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(C.media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(C.media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.tex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(C.media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.tex = downtex

	up:HookScript("OnEnter", colourScroll)
	up:HookScript("OnLeave", clearScroll)
	down:HookScript("OnEnter", colourScroll)
	down:HookScript("OnLeave", clearScroll)
end

local function colourArrow(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearArrow(f)
	f.tex:SetVertexColor(1, 1, 1)
end

F.colourArrow = colourArrow
F.clearArrow = clearArrow

F.ReskinDropDown = function(f)
	local frame = f:GetName()

	local left = _G[frame.."Left"]
	local middle = _G[frame.."Middle"]
	local right = _G[frame.."Right"]

	if left then left:SetAlpha(0) end
	if middle then middle:SetAlpha(0) end
	if right then right:SetAlpha(0) end

	local down = _G[frame.."Button"]

	down:SetSize(20, 20)
	down:ClearAllPoints()
	down:SetPoint("RIGHT", -18, 2)

	F.Reskin(down, true)

	down:SetDisabledTexture(C.media.backdrop)
	local dis = down:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	local tex = down:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowDown)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	tex:SetVertexColor(1, 1, 1)
	down.tex = tex

	down:HookScript("OnEnter", colourArrow)
	down:HookScript("OnLeave", clearArrow)

	local bg = CreateFrame("Frame", nil, f)
	bg:SetPoint("TOPLEFT", 16, -4)
	bg:SetPoint("BOTTOMRIGHT", -18, 8)
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bg, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bg, -1, 1)
end

local function colourClose(f)
	if f:IsEnabled() then
		for _, pixel in pairs(f.pixels) do
			pixel:SetVertexColor(r, g, b)
		end
	end
end

local function clearClose(f)
	for _, pixel in pairs(f.pixels) do
		pixel:SetVertexColor(1, 1, 1)
	end
end

F.ReskinClose = function(f, a1, p, a2, x, y)
	f:SetSize(17, 17)

	if not a1 then
		f:SetPoint("TOPRIGHT", -6, -6)
	else
		f:ClearAllPoints()
		f:SetPoint(a1, p, a2, x, y)
	end

	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	F.CreateBD(f, 0)

	F.CreateGradient(f)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .4)
	dis:SetDrawLayer("OVERLAY")
	dis:SetAllPoints()

	f.pixels = {}

	for i = 1, 9 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:SetSize(1, 1)
		tex:SetPoint("BOTTOMLEFT", 3+i, 3+i)
		tinsert(f.pixels, tex)
	end

	for i = 1, 9 do
		local tex = f:CreateTexture()
		tex:SetTexture(1, 1, 1)
		tex:SetSize(1, 1)
		tex:SetPoint("TOPLEFT", 3+i, -3-i)
		tinsert(f.pixels, tex)
	end

	f:HookScript("OnEnter", colourClose)
 	f:HookScript("OnLeave", clearClose)
end

F.ReskinInput = function(f, height, width)
	local frame = f:GetName()

	local left = f.Left or _G[frame.."Left"]
	local middle = f.Middle or _G[frame.."Middle"] or _G[frame.."Mid"]
	local right = f.Right or _G[frame.."Right"]

	left:Hide()
	middle:Hide()
	right:Hide()

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", -2, 0)
	bd:SetPoint("BOTTOMRIGHT")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local gradient = F.CreateGradient(f)
	gradient:SetPoint("TOPLEFT", bd, 1, -1)
	gradient:SetPoint("BOTTOMRIGHT", bd, -1, 1)

	if height then f:SetHeight(height) end
	if width then f:SetWidth(width) end
end

F.ReskinArrow = function(f, direction)
	f:SetSize(18, 18)
	F.Reskin(f, true)

	f:SetDisabledTexture(C.media.backdrop)
	local dis = f:GetDisabledTexture()
	dis:SetVertexColor(0, 0, 0, .3)
	dis:SetDrawLayer("OVERLAY")

	local tex = f:CreateTexture(nil, "ARTWORK")
	tex:SetTexture("Interface\\AddOns\\Aurora\\media\\arrow-"..direction.."-active")
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")
	f.tex = tex

	f:HookScript("OnEnter", colourArrow)
	f:HookScript("OnLeave", clearArrow)
end

F.ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(C.media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end

local function colourRadio(f)
	f.bd:SetBackdropBorderColor(r, g, b)
end

local function clearRadio(f)
	f.bd:SetBackdropBorderColor(0, 0, 0)
end

F.ReskinRadio = function(f)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetCheckedTexture(C.media.backdrop)

	local ch = f:GetCheckedTexture()
	ch:SetPoint("TOPLEFT", 4, -4)
	ch:SetPoint("BOTTOMRIGHT", -4, 4)
	ch:SetVertexColor(r, g, b, .6)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 3, -3)
	bd:SetPoint("BOTTOMRIGHT", -3, 3)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)
	f.bd = bd

	local tex = F.CreateGradient(f)
	tex:SetPoint("TOPLEFT", 4, -4)
	tex:SetPoint("BOTTOMRIGHT", -4, 4)

	f:HookScript("OnEnter", colourRadio)
	f:HookScript("OnLeave", clearRadio)
end

F.ReskinSlider = function(f)
	f:SetBackdrop(nil)
	f.SetBackdrop = F.dummy

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 14, -2)
	bd:SetPoint("BOTTOMRIGHT", -15, 3)
	bd:SetFrameStrata("BACKGROUND")
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bd, 0)

	F.CreateGradient(bd)

	local slider = select(4, f:GetRegions())
	slider:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	slider:SetBlendMode("ADD")
end

local function colourExpandOrCollapse(f)
	if f:IsEnabled() then
		f.plus:SetVertexColor(r, g, b)
		f.minus:SetVertexColor(r, g, b)
	end
end

local function clearExpandOrCollapse(f)
	f.plus:SetVertexColor(1, 1, 1)
	f.minus:SetVertexColor(1, 1, 1)
end

F.colourExpandOrCollapse = colourExpandOrCollapse
F.clearExpandOrCollapse = clearExpandOrCollapse

F.ReskinExpandOrCollapse = function(f)
	f:SetSize(13, 13)

	F.Reskin(f, true)
	f.SetNormalTexture = F.dummy

	f.minus = f:CreateTexture(nil, "OVERLAY")
	f.minus:SetSize(7, 1)
	f.minus:SetPoint("CENTER")
	f.minus:SetTexture(C.media.backdrop)
	f.minus:SetVertexColor(1, 1, 1)

	f.plus = f:CreateTexture(nil, "OVERLAY")
	f.plus:SetSize(1, 7)
	f.plus:SetPoint("CENTER")
	f.plus:SetTexture(C.media.backdrop)
	f.plus:SetVertexColor(1, 1, 1)

	f:HookScript("OnEnter", colourExpandOrCollapse)
	f:HookScript("OnLeave", clearExpandOrCollapse)
end

F.SetBD = function(f, x, y, x2, y2)
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:SetPoint("TOPLEFT", x, y)
		bg:SetPoint("BOTTOMRIGHT", x2, y2)
	end
	bg:SetFrameLevel(f:GetFrameLevel()-1)
	F.CreateBD(bg)
	F.CreateSD(bg)
end

F.ReskinPortraitFrame = function(f, isButtonFrame)
	local name = f:GetName()

	_G[name.."Bg"]:Hide()
	_G[name.."TitleBg"]:Hide()
	_G[name.."Portrait"]:Hide()
	_G[name.."PortraitFrame"]:Hide()
	_G[name.."TopRightCorner"]:Hide()
	_G[name.."TopLeftCorner"]:Hide()
	_G[name.."TopBorder"]:Hide()
	_G[name.."TopTileStreaks"]:SetTexture("")
	_G[name.."BotLeftCorner"]:Hide()
	_G[name.."BotRightCorner"]:Hide()
	_G[name.."BottomBorder"]:Hide()
	_G[name.."LeftBorder"]:Hide()
	_G[name.."RightBorder"]:Hide()

	if isButtonFrame then
		_G[name.."BtnCornerLeft"]:SetTexture("")
		_G[name.."BtnCornerRight"]:SetTexture("")
		_G[name.."ButtonBottomBorder"]:SetTexture("")

		f.Inset.Bg:Hide()
		f.Inset:DisableDrawLayer("BORDER")
	end

	F.CreateBD(f)
	F.CreateSD(f)
	F.ReskinClose(_G[name.."CloseButton"])
end

F.CreateBDFrame = function(f, a)
	local frame
	if f:GetObjectType() == "Texture" then
		frame = f:GetParent()
	else
		frame = f
	end

	local lvl = frame:GetFrameLevel()

	local bg = CreateFrame("Frame", nil, frame)
	bg:SetPoint("TOPLEFT", f, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", f, 1, -1)
	bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)

	F.CreateBD(bg, a or .5)

	return bg
end

F.ReskinColourSwatch = function(f)
	local name = f:GetName()

	local bg = _G[name.."SwatchBg"]

	f:SetNormalTexture(C.media.backdrop)
	local nt = f:GetNormalTexture()

	nt:SetPoint("TOPLEFT", 3, -3)
	nt:SetPoint("BOTTOMRIGHT", -3, 3)

	bg:SetTexture(0, 0, 0)
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
end

F.ReskinFilterButton = function(f)
	f.TopLeft:Hide()
	f.TopRight:Hide()
	f.BottomLeft:Hide()
	f.BottomRight:Hide()
	f.TopMiddle:Hide()
	f.MiddleLeft:Hide()
	f.MiddleRight:Hide()
	f.BottomMiddle:Hide()
	f.MiddleMiddle:Hide()
	
	F.Reskin(f)
	f.Icon:SetTexture(C.media.arrowRight)

	f.Text:SetPoint("CENTER")
	f.Icon:SetPoint("RIGHT", f, "RIGHT", -5, 0)
	f.Icon:SetSize(8, 8)
end

F.ReskinNavBar = function(f)
	local overflowButton = f.overflowButton
	f:GetRegions():Hide()
	f:DisableDrawLayer("BORDER")
	f.overlay:Hide()
	f.homeButton:GetRegions():Hide()

	F.Reskin(f.homeButton)
	F.Reskin(overflowButton, true)

	local tex = overflowButton:CreateTexture(nil, "ARTWORK")
	tex:SetTexture(C.media.arrowLeft)
	tex:SetSize(8, 8)
	tex:SetPoint("CENTER")

	overflowButton.tex = tex
	overflowButton:HookScript("OnEnter", colourArrow)
	overflowButton:HookScript("OnLeave", clearArrow)
end

F.ReskinGarrisonPortrait = function(portrait)
	local level = portrait.Level
	local cover = portrait.PortraitRingCover

	portrait.PortraitRing:Hide()
	portrait.PortraitRingQuality:SetTexture("")

	portrait.LevelBorder:SetTexture(0, 0, 0, .5)
	portrait.LevelBorder:SetSize(44, 11)
	portrait.LevelBorder:ClearAllPoints()
	portrait.LevelBorder:SetPoint("BOTTOM", 0, 12)

	level:ClearAllPoints()
	level:SetPoint("BOTTOM", portrait, 0, 12)

	local squareBG = CreateFrame("Frame", nil, portrait)
	squareBG:SetFrameLevel(portrait:GetFrameLevel()-1)
	squareBG:SetPoint("TOPLEFT", 3, -3)
	squareBG:SetPoint("BOTTOMRIGHT", -3, 11)

	F.CreateBD(squareBG, 1)
	portrait.squareBG = squareBG
	
	if cover then
		cover:SetTexture(0, 0, 0)
		cover:SetAllPoints(squareBG)
	end
end

F.ReskinIcon = function(icon)
	icon:SetTexCoord(.08, .92, .08, .92)
	F.CreateBG(icon)
end

-- [[ Module handling ]]

C.modules = {}
C.modules["Aurora"] = {}

local Skin = CreateFrame("Frame", nil, UIParent)
Skin:RegisterEvent("ADDON_LOADED")
Skin:SetScript("OnEvent", function(self, event, addon)
	if addon == "Aurora" then
		-- [[ Load Variables ]]

		-- remove deprecated or corrupt variables
		for key, value in pairs(AuroraConfig) do
			if C.defaults[key] == nil then
				AuroraConfig[key] = nil
			end
		end

		-- load or init variables
		for key, value in pairs(C.defaults) do
			if AuroraConfig[key] == nil then
				if type(value) == "table" then
					AuroraConfig[key] = {}
					for k, v in pairs(value) do
						AuroraConfig[key][k] = value[k]
					end
				else
					AuroraConfig[key] = value
				end
			end
		end

		alpha = AuroraConfig.alpha
		useButtonGradientColour = AuroraConfig.useButtonGradientColour

		if useButtonGradientColour then
			buttonR, buttonG, buttonB, buttonA = unpack(AuroraConfig.buttonGradientColour)
		else
			buttonR, buttonG, buttonB, buttonA = unpack(AuroraConfig.buttonSolidColour)
		end

		if AuroraConfig.useCustomColour then
			r, g, b = AuroraConfig.customColour.r, AuroraConfig.customColour.g, AuroraConfig.customColour.b
		end
		-- for modules
		C.r, C.g, C.b = r, g, b
	end

	for module, moduleFunc in pairs(C.modules) do
		if type(moduleFunc) == "function" then
			if module == addon then
				moduleFunc()
			end
		elseif type(moduleFunc) == "table" then
			if module == addon then
				for _, moduleFunc in pairs(C.modules[module]) do
					moduleFunc()
				end
			end
		end
	end

	if addon == "Aurora" then
	
		-- [[ Headers ]]

		local header = {"GameMenuFrame", "InterfaceOptionsFrame", "AudioOptionsFrame", "VideoOptionsFrame", "ChatConfigFrame", "ColorPickerFrame"}
		for i = 1, #header do
		local title = _G[header[i].."Header"]
			if title then
				title:SetTexture("")
				title:ClearAllPoints()
				if title == _G["GameMenuFrameHeader"] then
					title:SetPoint("TOP", GameMenuFrame, 0, 7)
				else
					title:SetPoint("TOP", header[i], 0, 0)
				end
			end
		end

		-- [[ Simple backdrops ]]

		local bds = {"AutoCompleteBox", "TicketStatusFrameButton", "GearManagerDialogPopup", "TokenFramePopup", "RaidInfoFrame", "ScrollOfResurrectionSelectionFrame", "ScrollOfResurrectionFrame", "VoiceChatTalkers", "ReportPlayerNameDialog", "ReportCheatingDialog", "QueueStatusFrame"}

		for i = 1, #bds do
			local bd = _G[bds[i]]
			if bd then
				F.CreateBD(bd)
			else
				print("Aurora: "..bds[i].." was not found.")
			end
		end

		local lightbds = {"SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4", "ChatConfigChatSettingsClassColorLegend", "ChatConfigChannelSettingsClassColorLegend", "FriendsFriendsList", "HelpFrameTicketScrollFrame", "HelpFrameGM_ResponseScrollFrame1", "HelpFrameGM_ResponseScrollFrame2", "FriendsFriendsNoteFrame", "AddFriendNoteFrame", "ScrollOfResurrectionSelectionFrameList", "HelpFrameReportBugScrollFrame", "HelpFrameSubmitSuggestionScrollFrame", "ReportPlayerNameDialogCommentFrame", "ReportCheatingDialogCommentFrame"}
		for i = 1, #lightbds do
			local bd = _G[lightbds[i]]
			if bd then
				F.CreateBD(bd, .25)
			else
				print("Aurora: "..lightbds[i].." was not found.")
			end
		end

		-- [[ Scroll bars ]]

		local scrollbars = {"FriendsFrameFriendsScrollFrameScrollBar", "CharacterStatsPaneScrollBar", "LFDQueueFrameSpecificListScrollFrameScrollBar", "HelpFrameKnowledgebaseScrollFrameScrollBar", "HelpFrameReportBugScrollFrameScrollBar", "HelpFrameSubmitSuggestionScrollFrameScrollBar", "HelpFrameTicketScrollFrameScrollBar", "PaperDollTitlesPaneScrollBar", "PaperDollEquipmentManagerPaneScrollBar", "SendMailScrollFrameScrollBar", "OpenMailScrollFrameScrollBar", "RaidInfoScrollFrameScrollBar", "FriendsFriendsScrollFrameScrollBar", "HelpFrameGM_ResponseScrollFrame1ScrollBar", "HelpFrameGM_ResponseScrollFrame2ScrollBar", "HelpFrameKnowledgebaseScrollFrame2ScrollBar", "WhoListScrollFrameScrollBar", "GearManagerDialogPopupScrollFrameScrollBar", "LFDQueueFrameRandomScrollFrameScrollBar", "ScrollOfResurrectionSelectionFrameListScrollFrameScrollBar", "ChannelRosterScrollFrameScrollBar"}
		for i = 1, #scrollbars do
			local scrollbar = _G[scrollbars[i]]
			if scrollbar then
				F.ReskinScroll(scrollbar)
			else
				print("Aurora: "..scrollbars[i].." was not found.")
			end
		end

		-- [[ Dropdowns ]]

		for _, dropdown in pairs({"LFDQueueFrameTypeDropDown", "WhoFrameDropDown", "FriendsFriendsFrameDropDown", "RaidFinderQueueFrameSelectionDropDown", "Advanced_GraphicsAPIDropDown"}) do
			F.ReskinDropDown(_G[dropdown])
		end

		-- [[ Input frames ]]

		for _, input in pairs({"AddFriendNameEditBox", "GearManagerDialogPopupEditBox", "HelpFrameKnowledgebaseSearchBox", "ChannelFrameDaughterFrameChannelName", "ChannelFrameDaughterFrameChannelPassword", "ScrollOfResurrectionSelectionFrameTargetEditBox", "ScrollOfResurrectionFrameNoteFrame", "FriendsFrameBroadcastInput"}) do
			F.ReskinInput(_G[input])
		end

		-- [[Reagent Bank Buttons]]
		F.Reskin(ReagentBankFrame.DespositButton)
		F.Reskin(ReagentBankFrameUnlockInfoPurchaseButton)
		ReagentBankFrame:DisableDrawLayer("BACKGROUND")
		ReagentBankFrame:DisableDrawLayer("BORDER")
		ReagentBankFrame:DisableDrawLayer("ARTWORK")

		ReagentBankFrame:HookScript("OnShow", function()
			for i = 1, 98 do
				local item = _G["ReagentBankFrameItem"..i]
				local icon = _G["ReagentBankFrameItem"..i].icon
				local border = _G["ReagentBankFrameItem"..i].IconBorder

				icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)
			end
		end)


		-- [[ Arrows ]]
		F.ReskinArrow(SpellBookPrevPageButton, "left")
		F.ReskinArrow(SpellBookNextPageButton, "right")
		F.ReskinArrow(InboxPrevPageButton, "left")
		F.ReskinArrow(InboxNextPageButton, "right")
		F.ReskinArrow(MerchantPrevPageButton, "left")
		F.ReskinArrow(MerchantNextPageButton, "right")
		F.ReskinArrow(CharacterFrameExpandButton, "left")
		F.ReskinArrow(TabardCharacterModelRotateLeftButton, "left")
		F.ReskinArrow(TabardCharacterModelRotateRightButton, "right")

		hooksecurefunc("CharacterFrame_Expand", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(C.media.arrowLeft)
		end)

		hooksecurefunc("CharacterFrame_Collapse", function()
			select(15, CharacterFrameExpandButton:GetRegions()):SetTexture(C.media.arrowRight)
		end)

		-- [[ Check boxes ]]

		local checkboxes = {"TokenFramePopupInactiveCheckBox", "TokenFramePopupBackpackCheckBox"}
		for i = 1, #checkboxes do
			local checkbox = _G[checkboxes[i]]
			if checkbox then
				F.ReskinCheck(checkbox)
			else
				print("Aurora: "..checkboxes[i].." was not found.")
			end
		end

		-- [[ Radio buttons ]]

		local radiobuttons = {"ReportPlayerNameDialogPlayerNameCheckButton", "ReportPlayerNameDialogGuildNameCheckButton", "SendMailSendMoneyButton", "SendMailCODButton"}
		for i = 1, #radiobuttons do
			local radiobutton = _G[radiobuttons[i]]
			if radiobutton then
				F.ReskinRadio(radiobutton)
			else
				print("Aurora: "..radiobuttons[i].." was not found.")
			end
		end
		-- [[Chat Bubbles]]
		local bubbleHook = CreateFrame("Frame")

		local function styleBubble(frame)
			local scale = UIParent:GetScale()

				for i = 1, frame:GetNumRegions() do
					local region = select(i, frame:GetRegions())
					if region:GetObjectType() == "Texture" then
						region:SetTexture(nil)
					elseif region:GetObjectType() == "FontString" then
						region:SetFont(C.media.font, 10)
						region:SetShadowOffset(scale, -scale)
					end
				end

				frame:SetBackdrop({
					bgFile = C.media.backdrop,
					edgeFile = C.media.backdrop,
					edgeSize = scale,
				})
				frame:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
				frame:SetBackdropBorderColor(0, 0, 0)
			end

			local function isChatBubble(frame)
				if frame:GetName() then return end
				if not frame:GetRegions() then return end
				return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
			end

			local last = 0
			local numKids = 0

			bubbleHook:SetScript("OnUpdate", function(self, elapsed)
				last = last + elapsed
				if last > .1 then
					last = 0
					local newNumKids = WorldFrame:GetNumChildren()
					if newNumKids ~= numKids then
						for i=numKids + 1, newNumKids do
							local frame = select(i, WorldFrame:GetChildren())

							if isChatBubble(frame) then
								styleBubble(frame)
							end
						end
						numKids = newNumKids
					end
				end
			end)


		-- [[ Backdrop frames ]]

		F.SetBD(DressUpFrame, 10, -12, -34, 74)
		F.SetBD(HelpFrame)
		F.SetBD(RaidParentFrame)

		local FrameBDs = {"GameMenuFrame", "InterfaceOptionsFrame", "VideoOptionsFrame", "AudioOptionsFrame", "ChatConfigFrame", "StackSplitFrame", "AddFriendFrame", "FriendsFriendsFrame", "ColorPickerFrame", "ReadyCheckFrame", "GuildInviteFrame", "ChannelFrameDaughterFrame"}
		for i = 1, #FrameBDs do
			local FrameBD = _G[FrameBDs[i]]
			F.CreateBD(FrameBD)
			F.CreateSD(FrameBD)
		end

		-- Dropdown lists

		hooksecurefunc("UIDropDownMenu_CreateFrames", function(level, index)
			for i = 1, UIDROPDOWNMENU_MAXLEVELS do
				local menu = _G["DropDownList"..i.."MenuBackdrop"]
				local backdrop = _G["DropDownList"..i.."Backdrop"]
				if not backdrop.reskinned then
					F.CreateBD(menu)
					F.CreateBD(backdrop)
					backdrop.reskinned = true
				end
			end
		end)

		local createBackdrop = function(parent, texture)
			local bg = parent:CreateTexture(nil, "BACKGROUND")
			bg:SetTexture(0, 0, 0, .5)
			bg:SetPoint("CENTER", texture)
			bg:SetSize(12, 12)
			parent.bg = bg

			local left = parent:CreateTexture(nil, "BACKGROUND")
			left:SetWidth(1)
			left:SetTexture(0, 0, 0)
			left:SetPoint("TOPLEFT", bg)
			left:SetPoint("BOTTOMLEFT", bg)
			parent.left = left

			local right = parent:CreateTexture(nil, "BACKGROUND")
			right:SetWidth(1)
			right:SetTexture(0, 0, 0)
			right:SetPoint("TOPRIGHT", bg)
			right:SetPoint("BOTTOMRIGHT", bg)
			parent.right = right

			local top = parent:CreateTexture(nil, "BACKGROUND")
			top:SetHeight(1)
			top:SetTexture(0, 0, 0)
			top:SetPoint("TOPLEFT", bg)
			top:SetPoint("TOPRIGHT", bg)
			parent.top = top

			local bottom = parent:CreateTexture(nil, "BACKGROUND")
			bottom:SetHeight(1)
			bottom:SetTexture(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", bg)
			bottom:SetPoint("BOTTOMRIGHT", bg)
			parent.bottom = bottom
		end

		local toggleBackdrop = function(bu, show)
			if show then
				bu.bg:Show()
				bu.left:Show()
				bu.right:Show()
				bu.top:Show()
				bu.bottom:Show()
			else
				bu.bg:Hide()
				bu.left:Hide()
				bu.right:Hide()
				bu.top:Hide()
				bu.bottom:Hide()
			end
		end

		hooksecurefunc("ToggleDropDownMenu", function(level, _, dropDownFrame, anchorName)
			if not level then level = 1 end

			local uiScale = UIParent:GetScale()

			local listFrame = _G["DropDownList"..level]

			if level == 1 then
				if not anchorName then
					local xOffset = dropDownFrame.xOffset and dropDownFrame.xOffset or 16
					local yOffset = dropDownFrame.yOffset and dropDownFrame.yOffset or 9
					local point = dropDownFrame.point and dropDownFrame.point or "TOPLEFT"
					local relativeTo = dropDownFrame.relativeTo and dropDownFrame.relativeTo or dropDownFrame
					local relativePoint = dropDownFrame.relativePoint and dropDownFrame.relativePoint or "BOTTOMLEFT"

					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset, yOffset)

					-- make sure it doesn't go off the screen
					local offLeft = listFrame:GetLeft()/uiScale
					local offRight = (GetScreenWidth() - listFrame:GetRight())/uiScale
					local offTop = (GetScreenHeight() - listFrame:GetTop())/uiScale
					local offBottom = listFrame:GetBottom()/uiScale

					local xAddOffset, yAddOffset = 0, 0
					if offLeft < 0 then
						xAddOffset = -offLeft
					elseif offRight < 0 then
						xAddOffset = offRight
					end

					if offTop < 0 then
						yAddOffset = offTop
					elseif offBottom < 0 then
						yAddOffset = -offBottom
					end
					listFrame:ClearAllPoints()
					listFrame:SetPoint(point, relativeTo, relativePoint, xOffset + xAddOffset, yOffset + yAddOffset)
				elseif anchorName ~= "cursor" then
					-- this part might be a bit unreliable
					local _, _, relPoint, xOff, yOff = listFrame:GetPoint()
					if relPoint == "BOTTOMLEFT" and xOff == 0 and floor(yOff) == 5 then
						listFrame:SetPoint("TOPLEFT", anchorName, "BOTTOMLEFT", 16, 9)
					end
				end
			else
				local point, anchor, relPoint, _, y = listFrame:GetPoint()
				if point:find("RIGHT") then
					listFrame:SetPoint(point, anchor, relPoint, -14, y)
				else
					listFrame:SetPoint(point, anchor, relPoint, 9, y)
				end
			end

			for j = 1, UIDROPDOWNMENU_MAXBUTTONS do
				local bu = _G["DropDownList"..level.."Button"..j]
				local _, _, _, x = bu:GetPoint()
				if bu:IsShown() and x then
					local hl = _G["DropDownList"..level.."Button"..j.."Highlight"]
					local check = _G["DropDownList"..level.."Button"..j.."Check"]

					hl:SetPoint("TOPLEFT", -x + 1, 0)
					hl:SetPoint("BOTTOMRIGHT", listFrame:GetWidth() - bu:GetWidth() - x - 1, 0)

					if not bu.bg then
						createBackdrop(bu, check)
						hl:SetTexture(r, g, b, .2)
						_G["DropDownList"..level.."Button"..j.."UnCheck"]:SetTexture("")

						local arrow = _G["DropDownList"..level.."Button"..j.."ExpandArrow"]
						arrow:SetNormalTexture(C.media.arrowRight)
						arrow:SetSize(8, 8)
					end

					if not bu.notCheckable then
						toggleBackdrop(bu, true)

						-- only reliable way to see if button is radio or or check...
						local _, co = check:GetTexCoord()

						if co == 0 then
							check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
							check:SetVertexColor(r, g, b, 1)
							check:SetSize(20, 20)
							check:SetDesaturated(true)
						else
							check:SetTexture(C.media.backdrop)
							check:SetVertexColor(r, g, b, .6)
							check:SetSize(10, 10)
							check:SetDesaturated(false)
						end

						check:SetTexCoord(0, 1, 0, 1)
					else
						toggleBackdrop(bu, false)
					end
				end
			end
		end)

		-- Tab text position

		hooksecurefunc("PanelTemplates_DeselectTab", function(tab)
			_G[tab:GetName().."Text"]:SetPoint("CENTER", tab, "CENTER")
		end)

		hooksecurefunc("PanelTemplates_SelectTab", function(tab)
			_G[tab:GetName().."Text"]:SetPoint("CENTER", tab, "CENTER")
		end)

		-- [[ Custom skins ]]

		-- Pet stuff

		if class == "HUNTER" or class == "MAGE" or class == "DEATHKNIGHT" or class == "WARLOCK" then
			if class == "HUNTER" then
				PetStableBottomInset:DisableDrawLayer("BACKGROUND")
				PetStableBottomInset:DisableDrawLayer("BORDER")
				PetStableLeftInset:DisableDrawLayer("BACKGROUND")
				PetStableLeftInset:DisableDrawLayer("BORDER")
				PetStableModelShadow:Hide()
				PetStableModelRotateLeftButton:Hide()
				PetStableModelRotateRightButton:Hide()
				PetStableFrameModelBg:Hide()
				PetStablePrevPageButtonIcon:SetTexture("")
				PetStableNextPageButtonIcon:SetTexture("")

				F.ReskinPortraitFrame(PetStableFrame, true)
				F.ReskinArrow(PetStablePrevPageButton, "left")
				F.ReskinArrow(PetStableNextPageButton, "right")

				PetStableSelectedPetIcon:SetTexCoord(.08, .92, .08, .92)
				F.CreateBG(PetStableSelectedPetIcon)

				for i = 1, NUM_PET_ACTIVE_SLOTS do
					local bu = _G["PetStableActivePet"..i]

					bu.Background:Hide()
					bu.Border:Hide()

					bu:SetNormalTexture("")
					bu.Checked:SetTexture("")

					_G["PetStableActivePet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
					F.CreateBD(bu, .25)
				end

				for i = 1, NUM_PET_STABLE_SLOTS do
					local bu = _G["PetStableStabledPet"..i]
					local bd = CreateFrame("Frame", nil, bu)
					bd:SetPoint("TOPLEFT", -1, 1)
					bd:SetPoint("BOTTOMRIGHT", 1, -1)
					F.CreateBD(bd, .25)
					bu:SetNormalTexture("")
					bu:DisableDrawLayer("BACKGROUND")
					_G["PetStableStabledPet"..i.."IconTexture"]:SetTexCoord(.08, .92, .08, .92)
				end
			end

			hooksecurefunc("PetPaperDollFrame_UpdateIsAvailable", function()
				if not HasPetUI() then
					CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "LEFT", 0, 0)
				else
					CharacterFrameTab3:SetPoint("LEFT", CharacterFrameTab2, "RIGHT", -15, 0)
				end
			end)

			PetModelFrameRotateLeftButton:Hide()
			PetModelFrameRotateRightButton:Hide()
			PetModelFrameShadowOverlay:Hide()
			PetPaperDollPetModelBg:SetAlpha(0)
		end

		-- Ghost frame
		F.CreateSD(GhostFrame)
		GhostFrameContentsFrameIcon:SetTexCoord(.08, .92, .08, .92)

		local GhostBD = CreateFrame("Frame", nil, GhostFrameContentsFrame)
		GhostBD:SetPoint("TOPLEFT", GhostFrameContentsFrameIcon, -1, 1)
		GhostBD:SetPoint("BOTTOMRIGHT", GhostFrameContentsFrameIcon, 1, -1)
		F.CreateBD(GhostBD, 0)

		-- Mail frame

		SendMailMoneyInset:DisableDrawLayer("BORDER")
		InboxFrame:GetRegions():Hide()
		SendMailMoneyBg:Hide()
		SendMailMoneyInsetBg:Hide()
		OpenMailFrameIcon:Hide()
		OpenMailHorizontalBarLeft:Hide()
		select(18, MailFrame:GetRegions()):Hide()
		select(25, OpenMailFrame:GetRegions()):Hide()
		for i = 4, 7 do
			select(i, SendMailFrame:GetRegions()):Hide()
		end

		OpenMailLetterButton:SetNormalTexture("")
		OpenMailLetterButton:SetPushedTexture("")
		OpenMailLetterButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		for i = 1, 2 do
			F.ReskinTab(_G["MailFrameTab"..i])
		end

		local bgmail = CreateFrame("Frame", nil, OpenMailLetterButton)
		bgmail:SetPoint("TOPLEFT", -1, 1)
		bgmail:SetPoint("BOTTOMRIGHT", 1, -1)
		bgmail:SetFrameLevel(OpenMailLetterButton:GetFrameLevel()-1)
		F.CreateBD(bgmail)

		OpenMailMoneyButton:SetNormalTexture("")
		OpenMailMoneyButton:SetPushedTexture("")
		OpenMailMoneyButtonIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bgmoney = CreateFrame("Frame", nil, OpenMailMoneyButton)
		bgmoney:SetPoint("TOPLEFT", -1, 1)
		bgmoney:SetPoint("BOTTOMRIGHT", 1, -1)
		bgmoney:SetFrameLevel(OpenMailMoneyButton:GetFrameLevel()-1)
		F.CreateBD(bgmoney)

		SendMailSubjectEditBox:SetPoint("TOPLEFT", SendMailNameEditBox, "BOTTOMLEFT", 0, -1)

		for i = 1, INBOXITEMS_TO_DISPLAY do
			local it = _G["MailItem"..i]
			local bu = _G["MailItem"..i.."Button"]
			local st = _G["MailItem"..i.."ButtonSlot"]
			local ic = _G["MailItem"..i.."Button".."Icon"]
			local line = select(3, _G["MailItem"..i]:GetRegions())

			local a, b = it:GetRegions()
			a:Hide()
			b:Hide()

			bu:SetCheckedTexture(C.media.checked)

			st:Hide()
			line:Hide()
			ic:SetTexCoord(.08, .92, .08, .92)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bg, 0)
		end

		for i = 1, ATTACHMENTS_MAX_SEND do
			local bu = _G["SendMailAttachment"..i]
			local border = bu.IconBorder

			bu:GetRegions():Hide()

			border:SetTexture(C.media.backdrop)
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetPoint("BOTTOMRIGHT", 1, -1)
			border:SetDrawLayer("BACKGROUND")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		-- sigh
		-- we mess with quality colour numbers, so we have to fix this
		hooksecurefunc("SendMailFrame_Update", function()
			for i = 1, ATTACHMENTS_MAX_SEND do
				local bu = _G["SendMailAttachment"..i]

				if bu:GetNormalTexture() == nil and bu.IconBorder:IsShown() then
					bu.IconBorder:Hide()
				end
			end
		end)

		for i = 1, ATTACHMENTS_MAX_RECEIVE do
			local bu = _G["OpenMailAttachmentButton"..i]
			local ic = _G["OpenMailAttachmentButton"..i.."IconTexture"]
			local border = bu.IconBorder

			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			ic:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(C.media.backdrop)
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetPoint("BOTTOMRIGHT", 1, -1)
			border:SetDrawLayer("BACKGROUND")

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		hooksecurefunc("SendMailFrame_Update", function()
			for i = 1, ATTACHMENTS_MAX_SEND do
				local button = _G["SendMailAttachment"..i]
				if button:GetNormalTexture() then
					button:GetNormalTexture():SetTexCoord(.08, .92, .08, .92)
				end
			end
		end)

		F.ReskinPortraitFrame(MailFrame, true)
		F.ReskinPortraitFrame(OpenMailFrame, true)
		F.ReskinInput(SendMailNameEditBox, 20)
		F.ReskinInput(SendMailSubjectEditBox)
		F.ReskinInput(SendMailMoneyGold)
		F.ReskinInput(SendMailMoneySilver)
		F.ReskinInput(SendMailMoneyCopper)

		-- Currency frame

		local function updateButtons()
			local buttons = TokenFrameContainer.buttons

			for i = 1, #buttons do
				local bu = buttons[i]

				if not bu.styled then
					bu.highlight:SetPoint("TOPLEFT", 1, 0)
					bu.highlight:SetPoint("BOTTOMRIGHT", -1, 0)
					bu.highlight.SetPoint = F.dummy
					bu.highlight:SetTexture(r, g, b, .2)
					bu.highlight.SetTexture = F.dummy

					bu.categoryMiddle:SetAlpha(0)
					bu.categoryLeft:SetAlpha(0)
					bu.categoryRight:SetAlpha(0)

					bu.icon:SetTexCoord(.08, .92, .08, .92)
					bu.bg = F.CreateBG(bu.icon)

					bu.styled = true
				end

				if bu.isHeader then
					bu.bg:Hide()
				else
					bu.bg:Show()
				end
			end
		end

		TokenFrame:HookScript("OnShow", updateButtons)
		hooksecurefunc(TokenFrameContainer, "update", updateButtons)

		F.ReskinScroll(TokenFrameContainerScrollBar)

		-- Reputation frame

		ReputationDetailCorner:Hide()
		ReputationDetailDivider:Hide()
		ReputationListScrollFrame:GetRegions():Hide()
		select(2, ReputationListScrollFrame:GetRegions()):Hide()

		ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", 1, -28)

		local function UpdateFactionSkins()
			for i = 1, GetNumFactions() do
				local statusbar = _G["ReputationBar"..i.."ReputationBar"]

				if statusbar then
					statusbar:SetStatusBarTexture(C.media.backdrop)

					if not statusbar.reskinned then
						F.CreateBD(statusbar, .25)
						statusbar.reskinned = true
					end

					_G["ReputationBar"..i.."Background"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight1"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarAtWarHighlight2"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarLeftTexture"]:SetTexture(nil)
					_G["ReputationBar"..i.."ReputationBarRightTexture"]:SetTexture(nil)
				end
			end
		end

		ReputationFrame:HookScript("OnShow", UpdateFactionSkins)
		ReputationFrame:HookScript("OnEvent", UpdateFactionSkins)

		for i = 1, NUM_FACTIONS_DISPLAYED do
			local bu = _G["ReputationBar"..i.."ExpandOrCollapseButton"]
			F.ReskinExpandOrCollapse(bu)
		end

		hooksecurefunc("ReputationFrame_Update", function()
			local numFactions = GetNumFactions()
			local factionIndex, factionButton, isCollapsed
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)

			for i = 1, NUM_FACTIONS_DISPLAYED do
				factionIndex = factionOffset + i
				factionButton = _G["ReputationBar"..i.."ExpandOrCollapseButton"]

				if factionIndex <= numFactions then
					_, _, _, _, _, _, _, _, _, isCollapsed = GetFactionInfo(factionIndex)
					if isCollapsed then
						factionButton.plus:Show()
					else
						factionButton.plus:Hide()
					end
				end
			end
		end)

		F.CreateBD(ReputationDetailFrame)
		F.CreateSD(ReputationDetailFrame)
		F.ReskinClose(ReputationDetailCloseButton)
		F.ReskinCheck(ReputationDetailAtWarCheckBox)
		F.ReskinCheck(ReputationDetailInactiveCheckBox)
		F.ReskinCheck(ReputationDetailMainScreenCheckBox)
		F.ReskinCheck(ReputationDetailLFGBonusReputationCheckBox)
		F.ReskinScroll(ReputationListScrollFrameScrollBar)

		select(3, ReputationDetailFrame:GetRegions()):Hide()

		-- Raid frame (social frame)

		F.ReskinCheck(RaidFrameAllAssistCheckButton)

		-- Professions

		local professions = {"PrimaryProfession1", "PrimaryProfession2", "SecondaryProfession1", "SecondaryProfession2", "SecondaryProfession3", "SecondaryProfession4"}

		for _, button in pairs(professions) do
			local bu = _G[button]
			bu.professionName:SetTextColor(1, 1, 1)
			bu.missingHeader:SetTextColor(1, 1, 1)
			bu.missingText:SetTextColor(1, 1, 1)

			bu.statusBar:SetHeight(13)
			bu.statusBar:SetStatusBarTexture(C.media.backdrop)
			bu.statusBar:GetStatusBarTexture():SetGradient("VERTICAL", 0, .6, 0, 0, .8, 0)
			bu.statusBar.rankText:SetPoint("CENTER")

			local _, p = bu.statusBar:GetPoint()
			bu.statusBar:SetPoint("TOPLEFT", p, "BOTTOMLEFT", 1, -3)

			_G[button.."StatusBarLeft"]:Hide()
			bu.statusBar.capRight:SetAlpha(0)
			_G[button.."StatusBarBGLeft"]:Hide()
			_G[button.."StatusBarBGMiddle"]:Hide()
			_G[button.."StatusBarBGRight"]:Hide()

			local bg = CreateFrame("Frame", nil, bu.statusBar)
			bg:SetPoint("TOPLEFT", -1, 1)
			bg:SetPoint("BOTTOMRIGHT", 1, -1)
			bg:SetFrameLevel(bu:GetFrameLevel()-1)
			F.CreateBD(bg, .25)
		end

		local professionbuttons = {"PrimaryProfession1SpellButtonTop", "PrimaryProfession1SpellButtonBottom", "PrimaryProfession2SpellButtonTop", "PrimaryProfession2SpellButtonBottom", "SecondaryProfession1SpellButtonLeft", "SecondaryProfession1SpellButtonRight", "SecondaryProfession2SpellButtonLeft", "SecondaryProfession2SpellButtonRight", "SecondaryProfession3SpellButtonLeft", "SecondaryProfession3SpellButtonRight", "SecondaryProfession4SpellButtonLeft", "SecondaryProfession4SpellButtonRight"}

		for _, button in pairs(professionbuttons) do
			local icon = _G[button.."IconTexture"]
			local bu = _G[button]
			_G[button.."NameFrame"]:SetAlpha(0)

			bu:SetPushedTexture("")
			bu:SetCheckedTexture(C.media.checked)
			bu:GetHighlightTexture():Hide()

			if icon then
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:ClearAllPoints()
				icon:SetPoint("TOPLEFT", 2, -2)
				icon:SetPoint("BOTTOMRIGHT", -2, 2)
				F.CreateBG(icon)
			end
		end

		for i = 1, 2 do
			local bu = _G["PrimaryProfession"..i]

			_G["PrimaryProfession"..i.."IconBorder"]:Hide()

			bu.professionName:ClearAllPoints()
			bu.professionName:SetPoint("TOPLEFT", 100, -4)

			bu.icon:SetAlpha(1)
			bu.icon:SetTexCoord(.08, .92, .08, .92)
			bu.icon:SetDesaturated(false)
			F.CreateBG(bu.icon)

			local bg = CreateFrame("Frame", nil, bu)
			bg:SetPoint("TOPLEFT")
			bg:SetPoint("BOTTOMRIGHT", 0, -4)
			bg:SetFrameLevel(0)
			F.CreateBD(bg, .25)
		end

		hooksecurefunc("FormatProfession", function(frame, index)
			if index then
				local _, texture = GetProfessionInfo(index)

				if frame.icon and texture then
					frame.icon:SetTexture(texture)
				end
			end
		end)

		-- Merchant Frame

		MerchantMoneyInset:DisableDrawLayer("BORDER")
		MerchantExtraCurrencyInset:DisableDrawLayer("BORDER")
		BuybackBG:SetAlpha(0)
		MerchantMoneyBg:Hide()
		MerchantMoneyInsetBg:Hide()
		MerchantFrameBottomLeftBorder:SetAlpha(0)
		MerchantFrameBottomRightBorder:SetAlpha(0)
		MerchantExtraCurrencyBg:SetAlpha(0)
		MerchantExtraCurrencyInsetBg:Hide()

		F.ReskinPortraitFrame(MerchantFrame, true)
		F.ReskinDropDown(MerchantFrameLootFilter)

		MerchantFrameTab1:ClearAllPoints()
		MerchantFrameTab1:SetPoint("CENTER", MerchantFrame, "BOTTOMLEFT", 50, -14)
		MerchantFrameTab2:SetPoint("LEFT", MerchantFrameTab1, "RIGHT", -15, 0)

		for i = 1, 2 do
			F.ReskinTab(_G["MerchantFrameTab"..i])
		end

		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			local button = _G["MerchantItem"..i]
			local bu = _G["MerchantItem"..i.."ItemButton"]
			local mo = _G["MerchantItem"..i.."MoneyFrame"]
			local ic = bu.icon

			bu:SetHighlightTexture("")

			_G["MerchantItem"..i.."SlotTexture"]:Hide()
			_G["MerchantItem"..i.."NameFrame"]:Hide()
			_G["MerchantItem"..i.."Name"]:SetHeight(20)

			local a1, p, a2= bu:GetPoint()
			bu:SetPoint(a1, p, a2, -2, -2)
			bu:SetNormalTexture("")
			bu:SetPushedTexture("")
			bu:SetSize(40, 40)

			local a3, p2, a4, x, y = mo:GetPoint()
			mo:SetPoint(a3, p2, a4, x, y+2)

			F.CreateBD(bu, 0)

			button.bd = CreateFrame("Frame", nil, button)
			button.bd:SetPoint("TOPLEFT", 39, 0)
			button.bd:SetPoint("BOTTOMRIGHT")
			button.bd:SetFrameLevel(0)
			F.CreateBD(button.bd, .25)

			ic:SetTexCoord(.08, .92, .08, .92)
			ic:ClearAllPoints()
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)

			for j = 1, 3 do
				F.CreateBG(_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"])
				_G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]:SetTexCoord(.08, .92, .08, .92)
			end
		end

		hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
			local numMerchantItems = GetMerchantNumItems()
			for i = 1, MERCHANT_ITEMS_PER_PAGE do
				local index = ((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i
				if index <= numMerchantItems then
					local name, texture, price, stackCount, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(index)
					if extendedCost and (price <= 0) then
						_G["MerchantItem"..i.."AltCurrencyFrame"]:SetPoint("BOTTOMLEFT", "MerchantItem"..i.."NameFrame", "BOTTOMLEFT", 0, 35)
					end

					local bu = _G["MerchantItem"..i.."ItemButton"]
					local name = _G["MerchantItem"..i.."Name"]
					if bu.link then
						local _, _, quality = GetItemInfo(bu.link)
						local r, g, b = GetItemQualityColor(quality)

						name:SetTextColor(r, g, b)
					else
						name:SetTextColor(1, 1, 1)
					end
				end
			end

			local name = GetBuybackItemLink(GetNumBuybackItems())
			if name then
				local _, _, quality = GetItemInfo(name)
				local r, g, b = GetItemQualityColor(quality)

				MerchantBuyBackItemName:SetTextColor(r, g, b)
			end
		end)

		hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
			for i = 1, BUYBACK_ITEMS_PER_PAGE do
				local itemLink = GetBuybackItemLink(i)
				local name = _G["MerchantItem"..i.."Name"]

				if itemLink then
					local _, _, quality = GetItemInfo(itemLink)
					local r, g, b = GetItemQualityColor(quality)

					name:SetTextColor(r, g, b)
				else
					name:SetTextColor(1, 1, 1)
				end
			end
		end)

		MerchantBuyBackItemSlotTexture:SetAlpha(0)
		MerchantBuyBackItemNameFrame:Hide()
		MerchantBuyBackItemItemButton:SetNormalTexture("")
		MerchantBuyBackItemItemButton:SetPushedTexture("")

		F.CreateBD(MerchantBuyBackItemItemButton, 0)
		F.CreateBD(MerchantBuyBackItem, .25)

		MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(.08, .92, .08, .92)
		MerchantBuyBackItemItemButtonIconTexture:ClearAllPoints()
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("TOPLEFT", 1, -1)
		MerchantBuyBackItemItemButtonIconTexture:SetPoint("BOTTOMRIGHT", -1, 1)

		MerchantBuyBackItemName:SetHeight(25)
		MerchantBuyBackItemName:ClearAllPoints()
		MerchantBuyBackItemName:SetPoint("LEFT", MerchantBuyBackItemSlotTexture, "RIGHT", -5, 8)

		MerchantGuildBankRepairButton:SetPushedTexture("")
		F.CreateBG(MerchantGuildBankRepairButton)
		MerchantGuildBankRepairButtonIcon:SetTexCoord(0.595, 0.8075, 0.05, 0.52)

		MerchantRepairAllButton:SetPushedTexture("")
		F.CreateBG(MerchantRepairAllButton)
		MerchantRepairAllIcon:SetTexCoord(0.31375, 0.53, 0.06, 0.52)

		MerchantRepairItemButton:SetPushedTexture("")
		F.CreateBG(MerchantRepairItemButton)
		local ic = MerchantRepairItemButton:GetRegions()
		ic:SetTexture("Interface\\Icons\\INV_Hammer_20")
		ic:SetTexCoord(.08, .92, .08, .92)

		hooksecurefunc("MerchantFrame_UpdateCurrencies", function()
			for i = 1, MAX_MERCHANT_CURRENCIES do
				local bu = _G["MerchantToken"..i]
				if bu and not bu.reskinned then
					local ic = _G["MerchantToken"..i.."Icon"]
					local co = _G["MerchantToken"..i.."Count"]

					ic:SetTexCoord(.08, .92, .08, .92)
					ic:SetDrawLayer("OVERLAY")
					ic:SetPoint("LEFT", co, "RIGHT", 2, 0)
					co:SetPoint("TOPLEFT", bu, "TOPLEFT", -2, 0)

					F.CreateBG(ic)
					bu.reskinned = true
				end
			end
		end)

		-- Friends Frame

		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		IgnoreListFrameTop:Hide()
		IgnoreListFrameMiddle:Hide()
		IgnoreListFrameBottom:Hide()
		PendingListFrameTop:Hide()
		PendingListFrameMiddle:Hide()
		PendingListFrameBottom:Hide()

		for i = 1, 4 do
			F.ReskinTab(_G["FriendsFrameTab"..i])
		end

		FriendsFrameIcon:Hide()

		for i = 1, FRIENDS_TO_DISPLAY do
			local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]
			local ic = bu.gameIcon

			bu.background:Hide()
			bu.travelPassButton:SetAlpha(0)
			bu.travelPassButton:EnableMouse(false)

			bu:SetHighlightTexture(C.media.backdrop)
			bu:GetHighlightTexture():SetVertexColor(.24, .56, 1, .2)

			ic:SetSize(22, 22)
			ic:SetTexCoord(.15, .85, .15, .85)

			bu.bg = CreateFrame("Frame", nil, bu)
			bu.bg:SetAllPoints(ic)
			F.CreateBD(bu.bg, 0)
		end

		local function UpdateScroll()
			for i = 1, FRIENDS_TO_DISPLAY do
				local bu = _G["FriendsFrameFriendsScrollFrameButton"..i]

				if bu.gameIcon:IsShown() then
					bu.bg:Show()
					bu.gameIcon:SetPoint("TOPRIGHT", bu, "TOPRIGHT", -2, -2)
				else
					bu.bg:Hide()
				end
			end
		end

		local bu1 = FriendsFrameFriendsScrollFrameButton1
		bu1.bg:SetPoint("BOTTOMRIGHT", bu1.gameIcon, 0, -1)

		hooksecurefunc("FriendsFrame_UpdateFriends", UpdateScroll)
		hooksecurefunc(FriendsFrameFriendsScrollFrame, "update", UpdateScroll)

		FriendsFrameStatusDropDown:ClearAllPoints()
		FriendsFrameStatusDropDown:SetPoint("TOPLEFT", FriendsFrame, "TOPLEFT", 10, -28)

		for _, button in pairs({FriendsTabHeaderSoRButton, FriendsTabHeaderRecruitAFriendButton}) do
			button:SetPushedTexture("")
			button:GetRegions():SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(button)
		end

		F.CreateBD(FriendsFrameBattlenetFrame.UnavailableInfoFrame)
		FriendsFrameBattlenetFrame.UnavailableInfoFrame:SetPoint("TOPLEFT", FriendsFrame, "TOPRIGHT", 1, -18)

		FriendsFrameBattlenetFrame:GetRegions():Hide()
		F.CreateBD(FriendsFrameBattlenetFrame, .25)

		FriendsFrameBattlenetFrame.Tag:SetParent(FriendsListFrame)
		FriendsFrameBattlenetFrame.Tag:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)

		hooksecurefunc("FriendsFrame_CheckBattlenetStatus", function()
			if BNFeaturesEnabled() then
				local frame = FriendsFrameBattlenetFrame

				frame.BroadcastButton:Hide()

				if BNConnected() then
					frame:Hide()
					FriendsFrameBroadcastInput:Show()
					FriendsFrameBroadcastInput_UpdateDisplay()
				end
			end
		end)

		hooksecurefunc("FriendsFrame_Update", function()
			if FriendsFrame.selectedTab == 1 and FriendsTabHeader.selectedTab == 1 and FriendsFrameBattlenetFrame.Tag:IsShown() then
				FriendsFrameTitleText:Hide()
			else
				FriendsFrameTitleText:Show()
			end
		end)

		local whoBg = CreateFrame("Frame", nil, WhoFrameEditBoxInset)
		whoBg:SetPoint("TOPLEFT")
		whoBg:SetPoint("BOTTOMRIGHT", -1, 1)
		whoBg:SetFrameLevel(WhoFrameEditBoxInset:GetFrameLevel()-1)
		F.CreateBD(whoBg, .25)

		F.ReskinPortraitFrame(FriendsFrame, true)
		F.Reskin(FriendsFrameAddFriendButton)
		F.Reskin(FriendsFrameSendMessageButton)
		F.Reskin(FriendsFrameIgnorePlayerButton)
		F.Reskin(FriendsFrameUnsquelchButton)
		F.Reskin(FriendsFrameMutePlayerButton)
		F.ReskinDropDown(FriendsFrameStatusDropDown)

		-- Battlenet toast frame

		F.CreateBD(BNToastFrame)
		F.CreateBD(BNToastFrame.TooltipFrame)
		BNToastFrameCloseButton:SetAlpha(0)

		-- Battletag invite frame

		F.CreateBD(BattleTagInviteFrame)

		local send, cancel = BattleTagInviteFrame:GetChildren()
		F.Reskin(send)
		F.Reskin(cancel)

		-- Character frame

		do
			local i = 1
			while _G["CharacterFrameTab"..i] do
				F.ReskinTab(_G["CharacterFrameTab"..i])
				i = i + 1
			end
		end

		F.ReskinPortraitFrame(CharacterFrame, true)

		local function colourPopout(self)
			local aR, aG, aB
			local glow = self:GetParent().IconBorder

			if glow:IsShown() then
				aR, aG, aB = glow:GetVertexColor()
			else
				aR, aG, aB = r, g, b
			end

			self.arrow:SetVertexColor(aR, aG, aB)
		end

		local function clearPopout(self)
			self.arrow:SetVertexColor(1, 1, 1)
		end

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Character"..slots[i].."Slot"]
			local border = slot.IconBorder

			_G["Character"..slots[i].."SlotFrame"]:Hide()

			slot:SetNormalTexture("")
			slot:SetPushedTexture("")
			slot.icon:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(C.media.backdrop)
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetPoint("BOTTOMRIGHT", 1, -1)
			border:SetDrawLayer("BACKGROUND")

			local popout = slot.popoutButton

			popout:SetNormalTexture("")
			popout:SetHighlightTexture("")

			local arrow = popout:CreateTexture(nil, "OVERLAY")

			if slot.verticalFlyout then
				arrow:SetSize(13, 8)
				arrow:SetTexture(C.media.arrowDown)
				arrow:SetPoint("TOP", slot, "BOTTOM", 0, 1)
			else
				arrow:SetSize(8, 14)
				arrow:SetTexture(C.media.arrowRight)
				arrow:SetPoint("LEFT", slot, "RIGHT", -1, 0)
			end

			popout.arrow = arrow

			popout:HookScript("OnEnter", clearPopout)
			popout:HookScript("OnLeave", colourPopout)
		end

		select(11, CharacterMainHandSlot:GetRegions()):Hide()
		select(11, CharacterSecondaryHandSlot:GetRegions()):Hide()

		hooksecurefunc("PaperDollItemSlotButton_Update", function(button)
			-- also fires for bag slots, we don't want that
			if button.popoutButton then
				button.icon:SetShown(button.hasItem)
				colourPopout(button.popoutButton)
			end
		end)

		for i = 1, #PAPERDOLL_SIDEBARS do
			local tab = _G["PaperDollSidebarTab"..i]

			if i == 1 then
				for i = 1, 4 do
					local region = select(i, tab:GetRegions())
					region:SetTexCoord(0.16, 0.86, 0.16, 0.86)
					region.SetTexCoord = F.dummy
				end
			end

			tab.Highlight:SetTexture(r, g, b, .2)
			tab.Highlight:SetPoint("TOPLEFT", 3, -4)
			tab.Highlight:SetPoint("BOTTOMRIGHT", -1, 0)
			tab.Hider:SetTexture(.3, .3, .3, .4)
			tab.TabBg:SetAlpha(0)

			select(2, tab:GetRegions()):ClearAllPoints()
			if i == 1 then
				select(2, tab:GetRegions()):SetPoint("TOPLEFT", 3, -4)
				select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, 0)
			else
				select(2, tab:GetRegions()):SetPoint("TOPLEFT", 2, -4)
				select(2, tab:GetRegions()):SetPoint("BOTTOMRIGHT", -1, -1)
			end

			tab.bg = CreateFrame("Frame", nil, tab)
			tab.bg:SetPoint("TOPLEFT", 2, -3)
			tab.bg:SetPoint("BOTTOMRIGHT", 0, -1)
			tab.bg:SetFrameLevel(0)
			F.CreateBD(tab.bg)

			tab.Hider:SetPoint("TOPLEFT", tab.bg, 1, -1)
			tab.Hider:SetPoint("BOTTOMRIGHT", tab.bg, -1, 1)
		end

		for i = 1, NUM_GEARSET_ICONS_SHOWN do
			local bu = _G["GearManagerDialogPopupButton"..i]
			local ic = _G["GearManagerDialogPopupButton"..i.."Icon"]

			bu:SetCheckedTexture(C.media.checked)
			select(2, bu:GetRegions()):Hide()
			ic:SetPoint("TOPLEFT", 1, -1)
			ic:SetPoint("BOTTOMRIGHT", -1, 1)
			ic:SetTexCoord(.08, .92, .08, .92)

			F.CreateBD(bu, .25)
		end

		local sets = false
		PaperDollSidebarTab3:HookScript("OnClick", function()
			if sets == false then
				for i = 1, 9 do
					local bu = _G["PaperDollEquipmentManagerPaneButton"..i]
					local bd = _G["PaperDollEquipmentManagerPaneButton"..i.."Stripe"]
					local ic = _G["PaperDollEquipmentManagerPaneButton"..i.."Icon"]
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgTop"]:SetAlpha(0)
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgMiddle"]:Hide()
					_G["PaperDollEquipmentManagerPaneButton"..i.."BgBottom"]:SetAlpha(0)

					bu.HighlightBar:SetTexture(r, g, b, .1)
					bu.HighlightBar:SetDrawLayer("BACKGROUND")
					bu.SelectedBar:SetTexture(r, g, b, .2)
					bu.SelectedBar:SetDrawLayer("BACKGROUND")

					bd:Hide()
					bd.Show = F.dummy
					ic:SetTexCoord(.08, .92, .08, .92)

					F.CreateBG(ic)
				end
				sets = true
			end
		end)

		-- Equipment flyout

		EquipmentFlyoutFrameHighlight:Hide()

		local border = F.CreateBDFrame(EquipmentFlyoutFrame, 0)
		border:SetBackdropBorderColor(1, 1, 1)
		border:SetPoint("TOPLEFT", 2, -2)
		border:SetPoint("BOTTOMRIGHT", -2, 2)

		local navFrame = EquipmentFlyoutFrame.NavigationFrame

		EquipmentFlyoutFrameButtons.bg1:SetAlpha(0)
		EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
		Test2:Hide() -- wat

		navFrame:SetWidth(204)
		navFrame:SetPoint("TOPLEFT", EquipmentFlyoutFrameButtons, "BOTTOMLEFT", 1, 0)

		hooksecurefunc("EquipmentFlyout_DisplayButton", function(button)
			if not button.styled then
				button:SetNormalTexture("")
				button:SetPushedTexture("")
				button.bg = F.CreateBG(button)

				button.icon:SetTexCoord(.08, .92, .08, .92)

				button.styled = true
			end

			local location = button.location
			if not location then return end
			if location >= EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION then return end

			local id = EquipmentManager_GetItemInfoByLocation(location)
			local _, _, quality = GetItemInfo(id)
			local r, g, b = GetItemQualityColor(quality)

			if r == 1 and g == 1 then r, g, b = 0, 0, 0 end

			button.bg:SetVertexColor(r, g, b)
		end)

		F.CreateBD(EquipmentFlyoutFrame.NavigationFrame)
		F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.PrevButton, "left")
		F.ReskinArrow(EquipmentFlyoutFrame.NavigationFrame.NextButton, "right")
	
	-- QuestMapFrame

local QuestMapFrame = QuestMapFrame

	-- [[ Quest scroll frame ]]

	local QuestScrollFrame = QuestScrollFrame
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	F.CreateBD(QuestScrollFrame.StoryTooltip)
	F.Reskin(QuestScrollFrame.ViewAll)
	F.ReskinScroll(QuestScrollFrame.ScrollBar)

	-- Story header

	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	do
		local bg = F.CreateBDFrame(StoryHeader, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)

		local hl = StoryHeader.HighlightTexture

		hl:SetTexture(C.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -5, 1)
		hl:SetDrawLayer("BACKGROUND")
		hl:Hide()

		StoryHeader:HookScript("OnEnter", function()
			hl:Show()
		end)

		StoryHeader:HookScript("OnLeave", function()
			hl:Hide()
		end)
	end

	-- [[ Quest details ]]

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(3, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	F.Reskin(DetailsFrame.BackButton)
	F.Reskin(DetailsFrame.AbandonButton)
	F.Reskin(DetailsFrame.ShareButton)
	F.Reskin(DetailsFrame.TrackButton)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame

	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	-- Scroll frame

	F.ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():Hide()
	select(2, CompleteQuestFrame:GetRegions()):Hide()
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()

	F.Reskin(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	local QuestLogPopupDetailFrame = QuestLogPopupDetailFrame

	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	QuestLogPopupDetailFramePageBg:Hide()
	QuestLogPopupDetailFrameScrollFrameTop:Hide()
	QuestLogPopupDetailFrameScrollFrameBottom:Hide()
	QuestLogPopupDetailFrameScrollFrameMiddle:Hide()

	F.ReskinPortraitFrame(QuestLogPopupDetailFrame, true)
	F.ReskinScroll(QuestLogPopupDetailFrameScrollFrameScrollBar)
	F.Reskin(QuestLogPopupDetailFrame.AbandonButton)
	F.Reskin(QuestLogPopupDetailFrame.TrackButton)
	F.Reskin(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:Hide()
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	F.Reskin(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)

	-- [[ Item reward highlight ]]

	QuestInfoItemHighlight:GetRegions():Hide()

	local function clearHighlight()
		for _, button in pairs(QuestInfoRewardsFrame.RewardButtons) do
			button.bg:SetBackdropColor(0, 0, 0, .25)
		end
	end

	local function setHighlight(self)
		clearHighlight()

		local _, point = self:GetPoint()
		if point then
			point.bg:SetBackdropColor(r, g, b, .2)
		end
	end

	hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
	QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
	QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

	-- [[ Shared ]]

	local function restyleSpellButton(bu)
		local name = bu:GetName()
		local icon = bu.Icon

		_G[name.."NameFrame"]:Hide()
		_G[name.."SpellBorder"]:Hide()

		icon:SetPoint("TOPLEFT", 3, -2)
		icon:SetDrawLayer("ARTWORK")
		icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(icon)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", 2, -1)
		bg:SetPoint("BOTTOMRIGHT", 0, 14)
		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)
	end

	-- [[ Objectives ]]

	restyleSpellButton(QuestInfoSpellObjectiveFrame)

	local function colourObjectivesText()
		if not QuestInfoFrame.questLog then return end

		local objectivesTable = QuestInfoObjectivesFrame.Objectives
		local numVisibleObjectives = 0

		for i = 1, GetNumQuestLeaderBoards() do
			local text, type, finished = GetQuestLogLeaderBoard(i)

			if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = objectivesTable[numVisibleObjectives]

				if finished then
					objective:SetTextColor(.9, .9, .9)
				else
					objective:SetTextColor(1, 1, 1)
				end
			end
		end
	end

	hooksecurefunc("QuestMapFrame_ShowQuestDetails", colourObjectivesText)
	hooksecurefunc("QuestInfo_Display", colourObjectivesText)

	-- [[ Quest rewards ]]

	restyleSpellButton(QuestInfoRewardSpell)

	local function restyleRewardButton(bu, isMapQuestInfo)
		bu.NameFrame:Hide()

		bu.Icon:SetTexCoord(.08, .92, .08, .92)
		bu.Icon:SetDrawLayer("BACKGROUND", 1)
		F.CreateBG(bu.Icon, 1)

		local bg = CreateFrame("Frame", nil, bu)
		bg:SetPoint("TOPLEFT", bu, 1, 1)

		if isMapQuestInfo then
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 0)
			bu.Icon:SetSize(29, 29)
		else
			bg:SetPoint("BOTTOMRIGHT", bu, -3, 1)
		end

		bg:SetFrameLevel(0)
		F.CreateBD(bg, .25)

		bu.bg = bg
	end

	hooksecurefunc("QuestInfo_GetRewardButton", function(rewardsFrame, index)
		local bu = rewardsFrame.RewardButtons[index]

		if not bu.restyled then
			restyleRewardButton(bu, rewardsFrame == MapQuestInfoRewardsFrame)

			bu.restyled = true
		end
	end)

	restyleRewardButton(QuestInfoSkillPointFrame)
	restyleRewardButton(MapQuestInfoRewardsFrame.SpellFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.XPFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.MoneyFrame, true)
	restyleRewardButton(MapQuestInfoRewardsFrame.SkillPointFrame, true)

	MapQuestInfoRewardsFrame.XPFrame.Name:SetShadowOffset(0, 0)

	-- [[ Change text colours ]]

	hooksecurefunc(QuestInfoRequiredMoneyText, "SetTextColor", function(self, r, g, b)
		if r == 0 then
			self:SetTextColor(.8, .8, .8)
		elseif r == .2 then
			self:SetTextColor(1, 1, 1)
		end
	end)

	QuestInfoTitleHeader:SetTextColor(1, 1, 1)
	QuestInfoTitleHeader.SetTextColor = F.dummy
	QuestInfoTitleHeader:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
	QuestInfoDescriptionHeader.SetTextColor = F.dummy
	QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)

	QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
	QuestInfoObjectivesHeader.SetTextColor = F.dummy
	QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)

	QuestInfoRewardsFrame.Header:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.Header.SetTextColor = F.dummy
	QuestInfoRewardsFrame.Header:SetShadowColor(0, 0, 0)

	QuestInfoDescriptionText:SetTextColor(1, 1, 1)
	QuestInfoDescriptionText.SetTextColor = F.dummy

	QuestInfoObjectivesText:SetTextColor(1, 1, 1)
	QuestInfoObjectivesText.SetTextColor = F.dummy

	QuestInfoGroupSize:SetTextColor(1, 1, 1)
	QuestInfoGroupSize.SetTextColor = F.dummy

	QuestInfoRewardText:SetTextColor(1, 1, 1)
	QuestInfoRewardText.SetTextColor = F.dummy

	QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
	QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy

	QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemChooseText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.ItemReceiveText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.SpellLearnText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.SpellLearnText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.PlayerTitleText.SetTextColor = F.dummy

	QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)
	QuestInfoRewardsFrame.XPFrame.ReceiveText.SetTextColor = F.dummy

		-- Quest Frame

		F.ReskinPortraitFrame(QuestFrame, true)


		QuestFrameDetailPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameProgressPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameRewardPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameGreetingPanel:DisableDrawLayer("BACKGROUND")
		QuestFrameDetailPanel:DisableDrawLayer("BORDER")
		QuestFrameRewardPanel:DisableDrawLayer("BORDER")


		QuestDetailScrollFrameTop:Hide()
		QuestDetailScrollFrameBottom:Hide()
		QuestDetailScrollFrameMiddle:Hide()
		QuestProgressScrollFrameTop:Hide()
		QuestProgressScrollFrameBottom:Hide()
		QuestProgressScrollFrameMiddle:Hide()
		QuestRewardScrollFrameTop:Hide()
		QuestRewardScrollFrameBottom:Hide()
		QuestRewardScrollFrameMiddle:Hide()
		QuestGreetingScrollFrameTop:Hide()
		QuestGreetingScrollFrameBottom:Hide()
		QuestGreetingScrollFrameMiddle:Hide()

		QuestNPCModelShadowOverlay:Hide()
		QuestNPCModelBg:Hide()
		QuestNPCModel:DisableDrawLayer("OVERLAY")
		QuestNPCModelNameText:SetDrawLayer("ARTWORK")
		QuestNPCModelTextFrameBg:Hide()
		QuestNPCModelTextFrame:DisableDrawLayer("OVERLAY")

		QuestInfoItemHighlight:GetRegions():Hide()
		QuestInfoSpellObjectiveFrameNameFrame:Hide()
		QuestFrameProgressPanelMaterialTopLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialTopRight:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotLeft:SetAlpha(0)
		QuestFrameProgressPanelMaterialBotRight:SetAlpha(0)


		local line = QuestFrameGreetingPanel:CreateTexture()
		line:SetTexture(1, 1, 1, .2)
		line:SetSize(256, 1)
		line:SetPoint("CENTER", QuestGreetingFrameHorizontalBreak)

		QuestGreetingFrameHorizontalBreak:SetTexture("")

		QuestFrameGreetingPanel:HookScript("OnShow", function()
			line:SetShown(QuestGreetingFrameHorizontalBreak:IsShown())
		end)

		local npcbd = CreateFrame("Frame", nil, QuestNPCModel)
		npcbd:SetPoint("TOPLEFT", -1, 1)
		npcbd:SetPoint("RIGHT", 1, 0)
		npcbd:SetPoint("BOTTOM", QuestNPCModelTextScrollFrame)
		npcbd:SetFrameLevel(0)
		F.CreateBD(npcbd)

		local npcLine = CreateFrame("Frame", nil, QuestNPCModel)
		npcLine:SetPoint("BOTTOMLEFT", 0, -2)
		npcLine:SetPoint("BOTTOMRIGHT", 0, -2)
		npcLine:SetHeight(1)
		npcLine:SetFrameLevel(0)
		F.CreateBD(npcLine, 0)

		QuestInfoSkillPointFrameIconTexture:SetSize(40, 40)
		QuestInfoSkillPointFrameIconTexture:SetTexCoord(.08, .92, .08, .92)

		local bg = CreateFrame("Frame", nil, QuestInfoSkillPointFrame)
		bg:SetPoint("TOPLEFT", -3, 0)
		bg:SetPoint("BOTTOMRIGHT", -3, 0)
		bg:Lower()
		F.CreateBD(bg, .25)

		QuestInfoSkillPointFrameNameFrame:Hide()
		QuestInfoSkillPointFrameName:SetParent(bg)
		QuestInfoSkillPointFrameIconTexture:SetParent(bg)

		local skillPointLine = QuestInfoSkillPointFrame:CreateTexture(nil, "BACKGROUND")
		skillPointLine:SetSize(1, 40)
		skillPointLine:SetPoint("RIGHT", QuestInfoSkillPointFrameIconTexture, 1, 0)
		skillPointLine:SetTexture(C.media.backdrop)
		skillPointLine:SetVertexColor(0, 0, 0)

		QuestInfoRewardSpellIconTexture:SetSize(40, 40)
		QuestInfoRewardSpellIconTexture:SetTexCoord(.08, .92, .08, .92)
		QuestInfoRewardSpellIconTexture:SetDrawLayer("OVERLAY")

		local bg = CreateFrame("Frame", nil, QuestInfoRewardSpell)
		bg:SetPoint("TOPLEFT", 9, -1)
		bg:SetPoint("BOTTOMRIGHT", -10, 13)
		bg:Lower()
		F.CreateBD(bg, .25)

		QuestInfoRewardSpellNameFrame:Hide()
		QuestInfoRewardSpellSpellBorder:Hide()
		QuestInfoRewardSpellName:SetParent(bg)
		QuestInfoRewardSpellIconTexture:SetParent(bg)

		local spellLine = QuestInfoRewardSpell:CreateTexture(nil, "BACKGROUND")
		spellLine:SetSize(1, 40)
		spellLine:SetPoint("RIGHT", QuestInfoRewardSpellIconTexture, 1, 0)
		spellLine:SetTexture(C.media.backdrop)
		spellLine:SetVertexColor(0, 0, 0)

		local function clearHighlight()
			for i = 1, MAX_NUM_ITEMS do
				_G["QuestInfoItem"..i]:SetBackdropColor(0, 0, 0, .25)
			end
		end

		local function setHighlight(self)
			clearHighlight()

			local _, point = self:GetPoint()
			point:SetBackdropColor(r, g, b, .2)
		end

		hooksecurefunc(QuestInfoItemHighlight, "SetPoint", setHighlight)
		QuestInfoItemHighlight:HookScript("OnShow", setHighlight)
		QuestInfoItemHighlight:HookScript("OnHide", clearHighlight)

		for i = 1, MAX_REQUIRED_ITEMS do
			local bu = _G["QuestProgressItem"..i]
			local ic = _G["QuestProgressItem"..i.."IconTexture"]
			local na = _G["QuestProgressItem"..i.."NameFrame"]
			local co = _G["QuestProgressItem"..i.."Count"]

			ic:SetSize(40, 40)
			ic:SetTexCoord(.08, .92, .08, .92)
			ic:SetDrawLayer("OVERLAY")

			F.CreateBD(bu, .25)

			na:Hide()
			co:SetDrawLayer("OVERLAY")

			local line = CreateFrame("Frame", nil, bu)
			line:SetSize(1, 40)
			line:SetPoint("RIGHT", ic, 1, 0)
			F.CreateBD(line)
		end

		QuestDetailScrollFrame:SetWidth(302) -- else these buttons get cut off


		hooksecurefunc("QuestFrame_ShowQuestPortrait", function(parentFrame, _, _, _, _, y)
			QuestNPCModel:SetPoint("TOPLEFT", parentFrame, "TOPRIGHT", 2, y)
		end)

		hooksecurefunc(QuestProgressRequiredMoneyText, "SetTextColor", function(self, r, g, b)
			if r == 0 then
				self:SetTextColor(.8, .8, .8)
			elseif r == .2 then
				self:SetTextColor(1, 1, 1)
			end
		end)

		for _, questButton in pairs({"QuestFrameAcceptButton", "QuestFrameDeclineButton", "QuestFrameCompleteQuestButton", "QuestFrameCompleteButton", "QuestFrameGoodbyeButton", "QuestFrameGreetingGoodbyeButton"}) do
			F.Reskin(_G[questButton])
		end

		F.ReskinScroll(QuestProgressScrollFrameScrollBar)
		F.ReskinScroll(QuestRewardScrollFrameScrollBar)
		F.ReskinScroll(QuestDetailScrollFrameScrollBar)
		F.ReskinScroll(QuestGreetingScrollFrameScrollBar)
		F.ReskinScroll(QuestNPCModelTextScrollFrameScrollBar)

		-- Gossip Frame

		GossipGreetingScrollFrameTop:Hide()
		GossipGreetingScrollFrameBottom:Hide()
		GossipGreetingScrollFrameMiddle:Hide()
		select(19, GossipFrame:GetRegions()):Hide()

		GossipGreetingText:SetTextColor(1, 1, 1)

		NPCFriendshipStatusBar:GetRegions():Hide()
		NPCFriendshipStatusBarNotch1:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch1:SetSize(1, 16)
		NPCFriendshipStatusBarNotch2:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch2:SetSize(1, 16)
		NPCFriendshipStatusBarNotch3:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch3:SetSize(1, 16)
		NPCFriendshipStatusBarNotch4:SetTexture(0, 0, 0)
		NPCFriendshipStatusBarNotch4:SetSize(1, 16)
		select(7, NPCFriendshipStatusBar:GetRegions()):Hide()

		NPCFriendshipStatusBar.icon:SetPoint("TOPLEFT", -30, 7)
		F.CreateBDFrame(NPCFriendshipStatusBar, .25)

		F.ReskinPortraitFrame(GossipFrame, true)
		F.Reskin(GossipFrameGreetingGoodbyeButton)
		F.ReskinScroll(GossipGreetingScrollFrameScrollBar)

		-- Help frame

		for i = 1, 15 do
			local bu = _G["HelpFrameKnowledgebaseScrollFrameButton"..i]
			bu:DisableDrawLayer("ARTWORK")
			F.CreateBD(bu, 0)

			F.CreateGradient(bu)
		end

		local function colourTab(f)
			f.text:SetTextColor(1, 1, 1)
		end

		local function clearTab(f)
			f.text:SetTextColor(1, .82, 0)
		end

		local function styleTab(bu)
			bu.selected:SetTexture(r, g, b, .2)
			bu.selected:SetDrawLayer("BACKGROUND")
			bu.text:SetFont(C.media.font, 14)
			F.Reskin(bu, true)
			bu:SetScript("OnEnter", colourTab)
			bu:SetScript("OnLeave", clearTab)
		end

		for i = 1, 6 do
			styleTab(_G["HelpFrameButton"..i])
		end
		styleTab(HelpFrameButton16)

		HelpFrameAccountSecurityOpenTicket.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpOpenTicket.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpTopIssues.text:SetFont(C.media.font, 14)
		HelpFrameOpenTicketHelpItemRestoration.text:SetFont(C.media.font, 14)

		HelpFrameCharacterStuckHearthstone:SetSize(56, 56)
		F.CreateBG(HelpFrameCharacterStuckHearthstone)
		HelpFrameCharacterStuckHearthstoneIconTexture:SetTexCoord(.08, .92, .08, .92)


		F.Reskin(HelpBrowserNavHome)
		F.Reskin(HelpBrowserNavReload)
		F.Reskin(HelpBrowserNavStop)
		F.Reskin(HelpBrowserBrowserSettings)
		F.ReskinArrow(HelpBrowserNavBack, "left")
		F.ReskinArrow(HelpBrowserNavForward, "right")

		HelpBrowserNavHome:SetSize(18, 18)
		HelpBrowserNavReload:SetSize(18, 18)
		HelpBrowserNavStop:SetSize(18, 18)
		HelpBrowserBrowserSettings:SetSize(18, 18)

		HelpBrowserNavHome:SetPoint("BOTTOMLEFT", HelpBrowser, "TOPLEFT", 2, 4)
		HelpBrowserBrowserSettings:SetPoint("TOPRIGHT", HelpFrameCloseButton, "BOTTOMLEFT", -4, -1)
		LoadingIcon:ClearAllPoints()
		LoadingIcon:SetPoint("LEFT", HelpBrowserNavStop, "RIGHT")

		for i = 1, 9 do
			select(i, BrowserSettingsTooltip:GetRegions()):Hide()
		end

		F.CreateBD(BrowserSettingsTooltip)
		F.Reskin(BrowserSettingsTooltip.CacheButton)
		F.Reskin(BrowserSettingsTooltip.CookiesButton)

		-- Option panels

		local options = false
		VideoOptionsFrame:HookScript("OnShow", function()
			if options == true then return end
			options = true

			local line = VideoOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:SetSize(1, 512)
			line:SetPoint("LEFT", 205, 30)
			line:SetTexture(1, 1, 1, .2)

			F.CreateBD(AudioOptionsSoundPanelPlayback, .25)
			F.CreateBD(AudioOptionsSoundPanelHardware, .25)
			F.CreateBD(AudioOptionsSoundPanelVolume, .25)
			F.CreateBD(AudioOptionsVoicePanelTalking, .25)
			F.CreateBD(AudioOptionsVoicePanelBinding, .25)
			F.CreateBD(AudioOptionsVoicePanelListening, .25)

			AudioOptionsSoundPanelPlaybackTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelPlayback, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelHardwareTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelHardware, "TOPLEFT", 5, 2)
			AudioOptionsSoundPanelVolumeTitle:SetPoint("BOTTOMLEFT", AudioOptionsSoundPanelVolume, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelTalkingTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelTalking, "TOPLEFT", 5, 2)
			AudioOptionsVoicePanelListeningTitle:SetPoint("BOTTOMLEFT", AudioOptionsVoicePanelListening, "TOPLEFT", 5, 2)

			local dropdowns = {"Display_DisplayModeDropDown", "Display_ResolutionDropDown", "Display_RefreshDropDown", "Display_PrimaryMonitorDropDown", "Display_AntiAliasingDropDown", "Display_VerticalSyncDropDown", "Graphics_TextureResolutionDropDown", "Graphics_FilteringDropDown", "Graphics_ProjectedTexturesDropDown", "Graphics_ShadowsDropDown", "Graphics_LiquidDetailDropDown", "Graphics_SunshaftsDropDown", "Graphics_ParticleDensityDropDown", "Graphics_ViewDistanceDropDown", "Graphics_EnvironmentalDetailDropDown", "Graphics_GroundClutterDropDown", "Graphics_SSAODropDown", "Graphics_RefractionDropDown", "RaidGraphics_TextureResolutionDropDown", "RaidGraphics_FilteringDropDown", "RaidGraphics_ProjectedTexturesDropDown", "RaidGraphics_ShadowsDropDown", "RaidGraphics_LiquidDetailDropDown", "RaidGraphics_SunshaftsDropDown", "RaidGraphics_ParticleDensityDropDown", "RaidGraphics_ViewDistanceDropDown", "RaidGraphics_EnvironmentalDetailDropDown", "RaidGraphics_GroundClutterDropDown", "RaidGraphics_SSAODropDown", "RaidGraphics_RefractionDropDown", "Advanced_BufferingDropDown", "Advanced_LagDropDown", "Advanced_HardwareCursorDropDown", "AudioOptionsSoundPanelHardwareDropDown", "AudioOptionsSoundPanelSoundChannelsDropDown", "AudioOptionsVoicePanelInputDeviceDropDown", "AudioOptionsVoicePanelChatModeDropDown", "AudioOptionsVoicePanelOutputDeviceDropDown", "InterfaceOptionsLanguagesPanelLocaleDropDown"}
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end

			Graphics_RightQuality:GetRegions():Hide()
			Graphics_RightQuality:DisableDrawLayer("BORDER")

			local sliders = {"Graphics_Quality", "RaidGraphics_Quality", "Advanced_UIScaleSlider", "Advanced_MaxFPSSlider", "Advanced_MaxFPSBKSlider", "Advanced_GammaSlider", "AudioOptionsSoundPanelMasterVolume", "AudioOptionsSoundPanelSoundVolume", "AudioOptionsSoundPanelMusicVolume", "AudioOptionsSoundPanelAmbienceVolume", "AudioOptionsSoundPanelDialogVolume", "AudioOptionsVoicePanelMicrophoneVolume", "AudioOptionsVoicePanelSpeakerVolume", "AudioOptionsVoicePanelSoundFade", "AudioOptionsVoicePanelMusicFade", "AudioOptionsVoicePanelAmbienceFade"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			Graphics_Quality.SetBackdrop = F.dummy

			local checkboxes = {"Advanced_UseUIScale", "Advanced_MaxFPSCheckBox", "Advanced_MaxFPSBKCheckBox", "Advanced_DesktopGamma", "NetworkOptionsPanelOptimizeSpeed", "NetworkOptionsPanelUseIPv6", "NetworkOptionsPanelAdvancedCombatLogging", "AudioOptionsSoundPanelEnableSound", "AudioOptionsSoundPanelSoundEffects", "AudioOptionsSoundPanelErrorSpeech", "AudioOptionsSoundPanelEmoteSounds", "AudioOptionsSoundPanelPetSounds", "AudioOptionsSoundPanelMusic", "AudioOptionsSoundPanelLoopMusic", "AudioOptionsSoundPanelPetBattleMusic", "AudioOptionsSoundPanelAmbientSounds", "AudioOptionsSoundPanelSoundInBG", "AudioOptionsSoundPanelReverb", "AudioOptionsSoundPanelHRTF", "AudioOptionsSoundPanelEnableDSPs", "AudioOptionsVoicePanelEnableVoice", "AudioOptionsVoicePanelEnableMicrophone", "AudioOptionsVoicePanelPushToTalkSound"}for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			F.Reskin(RecordLoopbackSoundButton)
			F.Reskin(PlayLoopbackSoundButton)
			F.Reskin(AudioOptionsVoicePanelChatMode1KeyBindingButton)
		end)

		local interface = false
		InterfaceOptionsFrame:HookScript("OnShow", function()
			if interface == true then return end
			interface = true

			local line = InterfaceOptionsFrame:CreateTexture(nil, "ARTWORK")
			line:SetSize(1, 546)
			line:SetPoint("LEFT", 205, 10)
			line:SetTexture(1, 1, 1, .2)

			local checkboxes = {"InterfaceOptionsControlsPanelStickyTargeting", "InterfaceOptionsControlsPanelAutoDismount", "InterfaceOptionsControlsPanelAutoClearAFK", "InterfaceOptionsControlsPanelBlockTrades", "InterfaceOptionsControlsPanelBlockGuildInvites", "InterfaceOptionsControlsPanelBlockChatChannelInvites", "InterfaceOptionsControlsPanelLootAtMouse", "InterfaceOptionsControlsPanelAutoLootCorpse", "InterfaceOptionsControlsPanelInteractOnLeftClick", "InterfaceOptionsControlsPanelReverseCleanUpBags", "InterfaceOptionsControlsPanelReverseNewLoot", "InterfaceOptionsCombatPanelAttackOnAssist", "InterfaceOptionsCombatPanelStopAutoAttack", "InterfaceOptionsNamesPanelUnitNameplatesNameplateClassColors", "InterfaceOptionsCombatPanelTargetOfTarget", "InterfaceOptionsCombatPanelShowSpellAlerts", "InterfaceOptionsCombatPanelReducedLagTolerance", "InterfaceOptionsCombatPanelActionButtonUseKeyDown", "InterfaceOptionsCombatPanelEnemyCastBarsOnPortrait", "InterfaceOptionsCombatPanelEnemyCastBarsOnNameplates", "InterfaceOptionsCombatPanelEnemyCastBarsOnOnlyTargetNameplates", "InterfaceOptionsCombatPanelEnemyCastBarsNameplateSpellNames", "InterfaceOptionsCombatPanelAutoSelfCast", "InterfaceOptionsCombatPanelLossOfControl", "InterfaceOptionsDisplayPanelShowCloak", "InterfaceOptionsDisplayPanelShowHelm", "InterfaceOptionsDisplayPanelShowAggroPercentage", "InterfaceOptionsDisplayPanelPlayAggroSounds", "InterfaceOptionsDisplayPanelShowSpellPointsAvg", "InterfaceOptionsDisplayPanelShowFreeBagSpace", "InterfaceOptionsDisplayPanelCinematicSubtitles", "InterfaceOptionsDisplayPanelRotateMinimap", "InterfaceOptionsDisplayPanelShowAccountAchievments", "InterfaceOptionsObjectivesPanelAutoQuestTracking", "InterfaceOptionsObjectivesPanelMapFade", "InterfaceOptionsSocialPanelProfanityFilter", "InterfaceOptionsSocialPanelSpamFilter", "InterfaceOptionsSocialPanelChatBubbles", "InterfaceOptionsSocialPanelPartyChat", "InterfaceOptionsSocialPanelChatHoverDelay", "InterfaceOptionsSocialPanelGuildMemberAlert", "InterfaceOptionsSocialPanelChatMouseScroll", "InterfaceOptionsSocialPanelWholeChatWindowClickable", "InterfaceOptionsActionBarsPanelBottomLeft", "InterfaceOptionsActionBarsPanelBottomRight", "InterfaceOptionsActionBarsPanelRight", "InterfaceOptionsActionBarsPanelRightTwo", "InterfaceOptionsActionBarsPanelLockActionBars", "InterfaceOptionsActionBarsPanelAlwaysShowActionBars", "InterfaceOptionsActionBarsPanelSecureAbilityToggle", "InterfaceOptionsActionBarsPanelCountdownCooldowns", "InterfaceOptionsNamesPanelMyName", "InterfaceOptionsNamesPanelMinus", "InterfaceOptionsNamesPanelFriendlyPlayerNames", "InterfaceOptionsNamesPanelFriendlyPets", "InterfaceOptionsNamesPanelFriendlyGuardians", "InterfaceOptionsNamesPanelFriendlyTotems", "InterfaceOptionsNamesPanelUnitNameplatesFriends", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyPets", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesFriendlyTotems", "InterfaceOptionsNamesPanelGuilds", "InterfaceOptionsNamesPanelGuildTitles", "InterfaceOptionsNamesPanelTitles", "InterfaceOptionsNamesPanelNonCombatCreature", "InterfaceOptionsNamesPanelEnemyPlayerNames", "InterfaceOptionsNamesPanelEnemyPets", "InterfaceOptionsNamesPanelEnemyGuardians", "InterfaceOptionsNamesPanelEnemyTotems", "InterfaceOptionsNamesPanelUnitNameplatesEnemies", "InterfaceOptionsNamesPanelUnitNameplatesEnemyPets", "InterfaceOptionsNamesPanelUnitNameplatesEnemyGuardians", "InterfaceOptionsNamesPanelUnitNameplatesEnemyTotems", "InterfaceOptionsNamesPanelUnitNameplatesEnemyMinus", "InterfaceOptionsCombatTextPanelTargetDamage", "InterfaceOptionsCombatTextPanelPeriodicDamage", "InterfaceOptionsCombatTextPanelPetDamage", "InterfaceOptionsCombatTextPanelHealing", "InterfaceOptionsCombatTextPanelHealingAbsorbTarget", "InterfaceOptionsCombatTextPanelTargetEffects", "InterfaceOptionsCombatTextPanelOtherTargetEffects", "InterfaceOptionsCombatTextPanelEnableFCT", "InterfaceOptionsCombatTextPanelDodgeParryMiss", "InterfaceOptionsCombatTextPanelDamageReduction", "InterfaceOptionsCombatTextPanelRepChanges", "InterfaceOptionsCombatTextPanelReactiveAbilities", "InterfaceOptionsCombatTextPanelFriendlyHealerNames", "InterfaceOptionsCombatTextPanelCombatState", "InterfaceOptionsCombatTextPanelHealingAbsorbSelf", "InterfaceOptionsCombatTextPanelComboPoints", "InterfaceOptionsCombatTextPanelLowManaHealth", "InterfaceOptionsCombatTextPanelEnergyGains", "InterfaceOptionsCombatTextPanelPeriodicEnergyGains", "InterfaceOptionsCombatTextPanelHonorGains", "InterfaceOptionsCombatTextPanelAuras", "InterfaceOptionsCombatTextPanelPetBattle", "InterfaceOptionsStatusTextPanelPlayer", "InterfaceOptionsStatusTextPanelPet", "InterfaceOptionsStatusTextPanelParty", "InterfaceOptionsStatusTextPanelTarget", "InterfaceOptionsStatusTextPanelAlternateResource", "InterfaceOptionsStatusTextPanelXP", "InterfaceOptionsBattlenetPanelOnlineFriends", "InterfaceOptionsBattlenetPanelOfflineFriends", "InterfaceOptionsBattlenetPanelBroadcasts", "InterfaceOptionsBattlenetPanelFriendRequests", "InterfaceOptionsBattlenetPanelConversations", "InterfaceOptionsBattlenetPanelShowToastWindow", "InterfaceOptionsCameraPanelFollowTerrain", "InterfaceOptionsCameraPanelHeadBob", "InterfaceOptionsCameraPanelWaterCollision", "InterfaceOptionsCameraPanelSmartPivot", "InterfaceOptionsMousePanelInvertMouse", "InterfaceOptionsMousePanelClickToMove", "InterfaceOptionsMousePanelWoWMouse", "InterfaceOptionsHelpPanelShowTutorials", "InterfaceOptionsHelpPanelEnhancedTooltips", "InterfaceOptionsHelpPanelShowLuaErrors", "InterfaceOptionsHelpPanelColorblindMode", "InterfaceOptionsHelpPanelMovePad", "InterfaceOptionsControlsPanelAutoOpenLootHistory", "InterfaceOptionsUnitFramePanelPartyPets", "InterfaceOptionsUnitFramePanelArenaEnemyFrames", "InterfaceOptionsUnitFramePanelArenaEnemyCastBar", "InterfaceOptionsUnitFramePanelArenaEnemyPets", "InterfaceOptionsUnitFramePanelFullSizeFocusFrame", "InterfaceOptionsBuffsPanelDispellableDebuffs", "InterfaceOptionsBuffsPanelCastableBuffs", "InterfaceOptionsBuffsPanelConsolidateBuffs", "InterfaceOptionsBuffsPanelShowAllEnemyDebuffs"}
			for i = 1, #checkboxes do
				F.ReskinCheck(_G[checkboxes[i]])
			end

			local dropdowns = {"InterfaceOptionsControlsPanelAutoLootKeyDropDown", "InterfaceOptionsCombatPanelFocusCastKeyDropDown", "InterfaceOptionsCombatPanelSelfCastKeyDropDown", "InterfaceOptionsCombatPanelLossOfControlFullDropDown", "InterfaceOptionsCombatPanelLossOfControlSilenceDropDown", "InterfaceOptionsCombatPanelLossOfControlInterruptDropDown", "InterfaceOptionsCombatPanelLossOfControlDisarmDropDown", "InterfaceOptionsCombatPanelLossOfControlRootDropDown", "InterfaceOptionsDisplayPanelOutlineDropDown", "InterfaceOptionsObjectivesPanelQuestSorting", "InterfaceOptionsSocialPanelChatStyle", "InterfaceOptionsSocialPanelTimestamps", "InterfaceOptionsSocialPanelWhisperMode", "InterfaceOptionsSocialPanelBnWhisperMode", "InterfaceOptionsSocialPanelConversationMode", "InterfaceOptionsActionBarsPanelPickupActionKeyDropDown", "InterfaceOptionsNamesPanelNPCNamesDropDown", "InterfaceOptionsNamesPanelUnitNameplatesMotionDropDown", "InterfaceOptionsCombatTextPanelTargetModeDropDown", "InterfaceOptionsCombatTextPanelFCTDropDown", "InterfaceOptionsStatusTextPanelDisplayDropDown", "InterfaceOptionsCameraPanelStyleDropDown", "InterfaceOptionsMousePanelClickMoveStyleDropDown"}
			for i = 1, #dropdowns do
				F.ReskinDropDown(_G[dropdowns[i]])
			end

			local sliders = {"InterfaceOptionsCombatPanelSpellAlertOpacitySlider", "InterfaceOptionsCombatPanelMaxSpellStartRecoveryOffset", "InterfaceOptionsBattlenetPanelToastDurationSlider", "InterfaceOptionsCameraPanelMaxDistanceSlider", "InterfaceOptionsCameraPanelFollowSpeedSlider", "InterfaceOptionsMousePanelMouseSensitivitySlider", "InterfaceOptionsMousePanelMouseLookSpeedSlider"}
			for i = 1, #sliders do
				F.ReskinSlider(_G[sliders[i]])
			end

			F.Reskin(InterfaceOptionsHelpPanelResetTutorials)

			if IsAddOnLoaded("Blizzard_CompactRaidFrames") then
				CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateBG:Hide()

				local boxes = {CompactUnitFrameProfilesRaidStylePartyFrames, CompactUnitFrameProfilesGeneralOptionsFrameKeepGroupsTogether, CompactUnitFrameProfilesGeneralOptionsFrameHorizontalGroups, CompactUnitFrameProfilesGeneralOptionsFrameDisplayIncomingHeals, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPowerBar, CompactUnitFrameProfilesGeneralOptionsFrameDisplayAggroHighlight, CompactUnitFrameProfilesGeneralOptionsFrameUseClassColors, CompactUnitFrameProfilesGeneralOptionsFrameDisplayPets, CompactUnitFrameProfilesGeneralOptionsFrameDisplayMainTankAndAssist, CompactUnitFrameProfilesGeneralOptionsFrameDisplayBorder, CompactUnitFrameProfilesGeneralOptionsFrameShowDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameDisplayOnlyDispellableDebuffs, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate2Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate3Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate5Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate10Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate15Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate25Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivate40Players, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec1, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivateSpec2, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvP, CompactUnitFrameProfilesGeneralOptionsFrameAutoActivatePvE}

				for _, box in next, boxes do
					F.ReskinCheck(box)
				end

				F.Reskin(CompactUnitFrameProfilesSaveButton)
				F.Reskin(CompactUnitFrameProfilesDeleteButton)
				F.Reskin(CompactUnitFrameProfilesGeneralOptionsFrameResetPositionButton)
				F.ReskinDropDown(CompactUnitFrameProfilesProfileSelector)
				F.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameSortByDropdown)
				F.ReskinDropDown(CompactUnitFrameProfilesGeneralOptionsFrameHealthTextDropdown)
				F.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameHeightSlider)
				F.ReskinSlider(CompactUnitFrameProfilesGeneralOptionsFrameWidthSlider)
			end
		end)

		hooksecurefunc("InterfaceOptions_AddCategory", function()
			local num = #INTERFACEOPTIONS_ADDONCATEGORIES
			for i = 1, num do
				local bu = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
				if bu and not bu.reskinned then
					F.ReskinExpandOrCollapse(bu)
					bu:SetPushedTexture("")
					bu.SetPushedTexture = F.dummy
					bu.reskinned = true
				end
			end
		end)

		hooksecurefunc("OptionsListButtonToggle_OnClick", function(self)
			if self:GetParent().element.collapsed then
				self.plus:Show()
			else
				self.plus:Hide()
			end
		end)

		-- SideDressUp

		SideDressUpModel:HookScript("OnShow", function(self)
			self:ClearAllPoints()
			self:SetPoint("LEFT", self:GetParent():GetParent(), "RIGHT", 1, 0)
		end)

		SideDressUpModel.bg = CreateFrame("Frame", nil, SideDressUpModel)
		SideDressUpModel.bg:SetPoint("TOPLEFT", 0, 1)
		SideDressUpModel.bg:SetPoint("BOTTOMRIGHT", 1, -1)
		SideDressUpModel.bg:SetFrameLevel(SideDressUpModel:GetFrameLevel()-1)
		F.CreateBD(SideDressUpModel.bg)

		-- Trade Frame

		TradePlayerEnchantInset:DisableDrawLayer("BORDER")
		TradePlayerItemsInset:DisableDrawLayer("BORDER")
		TradeRecipientEnchantInset:DisableDrawLayer("BORDER")
		TradeRecipientItemsInset:DisableDrawLayer("BORDER")
		TradePlayerInputMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientMoneyInset:DisableDrawLayer("BORDER")
		TradeRecipientBG:Hide()
		TradePlayerEnchantInsetBg:Hide()
		TradePlayerItemsInsetBg:Hide()
		TradePlayerInputMoneyInsetBg:Hide()
		TradeRecipientEnchantInsetBg:Hide()
		TradeRecipientItemsInsetBg:Hide()
		TradeRecipientMoneyBg:Hide()
		TradeRecipientPortraitFrame:Hide()
		TradeRecipientBotLeftCorner:Hide()
		TradeRecipientLeftBorder:Hide()
		select(4, TradePlayerItem7:GetRegions()):Hide()
		select(4, TradeRecipientItem7:GetRegions()):Hide()
		TradeFramePlayerPortrait:Hide()
		TradeFrameRecipientPortrait:Hide()

		F.ReskinPortraitFrame(TradeFrame, true)
		F.Reskin(TradeFrameTradeButton)
		F.Reskin(TradeFrameCancelButton)
		F.ReskinInput(TradePlayerInputMoneyFrameGold)
		F.ReskinInput(TradePlayerInputMoneyFrameSilver)
		F.ReskinInput(TradePlayerInputMoneyFrameCopper)

		TradePlayerInputMoneyFrameSilver:SetPoint("LEFT", TradePlayerInputMoneyFrameGold, "RIGHT", 1, 0)
		TradePlayerInputMoneyFrameCopper:SetPoint("LEFT", TradePlayerInputMoneyFrameSilver, "RIGHT", 1, 0)

		for i = 1, MAX_TRADE_ITEMS do
			local bu1 = _G["TradePlayerItem"..i.."ItemButton"]
			local bu2 = _G["TradeRecipientItem"..i.."ItemButton"]

			_G["TradePlayerItem"..i.."SlotTexture"]:Hide()
			_G["TradePlayerItem"..i.."NameFrame"]:Hide()
			_G["TradeRecipientItem"..i.."SlotTexture"]:Hide()
			_G["TradeRecipientItem"..i.."NameFrame"]:Hide()

			bu1:SetNormalTexture("")
			bu1:SetPushedTexture("")
			bu1.icon:SetTexCoord(.08, .92, .08, .92)
			bu2:SetNormalTexture("")
			bu2:SetPushedTexture("")
			bu2.icon:SetTexCoord(.08, .92, .08, .92)

			local bg1 = CreateFrame("Frame", nil, bu1)
			bg1:SetPoint("TOPLEFT", -1, 1)
			bg1:SetPoint("BOTTOMRIGHT", 1, -1)
			bg1:SetFrameLevel(bu1:GetFrameLevel()-1)
			F.CreateBD(bg1, .25)

			local bg2 = CreateFrame("Frame", nil, bu2)
			bg2:SetPoint("TOPLEFT", -1, 1)
			bg2:SetPoint("BOTTOMRIGHT", 1, -1)
			bg2:SetFrameLevel(bu2:GetFrameLevel()-1)
			F.CreateBD(bg2, .25)
		end

		-- Tutorial Frame

		F.CreateBD(TutorialFrame)

		TutorialFrameBackground:Hide()
		TutorialFrameBackground.Show = F.dummy
		TutorialFrame:DisableDrawLayer("BORDER")

		F.Reskin(TutorialFrameOkayButton, true)
		F.ReskinClose(TutorialFrameCloseButton)
		F.ReskinArrow(TutorialFramePrevButton, "left")
		F.ReskinArrow(TutorialFrameNextButton, "right")

		TutorialFrameOkayButton:ClearAllPoints()
		TutorialFrameOkayButton:SetPoint("BOTTOMLEFT", TutorialFrameNextButton, "BOTTOMRIGHT", 10, 0)

		-- because gradient alpha and OnUpdate doesn't work for some reason...

		select(14, TutorialFrameOkayButton:GetRegions()):Hide()
		select(15, TutorialFramePrevButton:GetRegions()):Hide()
		select(15, TutorialFrameNextButton:GetRegions()):Hide()
		select(14, TutorialFrameCloseButton:GetRegions()):Hide()
		TutorialFramePrevButton:SetScript("OnEnter", nil)
		TutorialFrameNextButton:SetScript("OnEnter", nil)
		TutorialFrameOkayButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFramePrevButton:SetBackdropColor(0, 0, 0, .25)
		TutorialFrameNextButton:SetBackdropColor(0, 0, 0, .25)

		-- Master looter frame

		for i = 1, 9 do
			select(i, MasterLooterFrame:GetRegions()):Hide()
		end

		MasterLooterFrame.Item.NameBorderLeft:Hide()
		MasterLooterFrame.Item.NameBorderRight:Hide()
		MasterLooterFrame.Item.NameBorderMid:Hide()
		MasterLooterFrame.Item.IconBorder:Hide()

		MasterLooterFrame.Item.Icon:SetTexCoord(.08, .92, .08, .92)
		MasterLooterFrame.Item.Icon:SetDrawLayer("ARTWORK")
		MasterLooterFrame.Item.bg = F.CreateBG(MasterLooterFrame.Item.Icon)

		MasterLooterFrame:HookScript("OnShow", function(self)
			self.Item.bg:SetVertexColor(self.Item.IconBorder:GetVertexColor())
			LootFrame:SetAlpha(.4)
		end)

		MasterLooterFrame:HookScript("OnHide", function(self)
			LootFrame:SetAlpha(1)
		end)

		F.CreateBD(MasterLooterFrame)
		F.ReskinClose(select(3, MasterLooterFrame:GetChildren()))

		hooksecurefunc("MasterLooterFrame_UpdatePlayers", function()
			for i = 1, MAX_RAID_MEMBERS do
				local playerFrame = MasterLooterFrame["player"..i]
				if playerFrame then
					if not playerFrame.styled then
						playerFrame.Bg:SetPoint("TOPLEFT", 1, -1)
						playerFrame.Bg:SetPoint("BOTTOMRIGHT", -1, 1)
						playerFrame.Highlight:SetPoint("TOPLEFT", 1, -1)
						playerFrame.Highlight:SetPoint("BOTTOMRIGHT", -1, 1)

						playerFrame.Highlight:SetTexture(C.media.backdrop)

						F.CreateBD(playerFrame, 0)

						playerFrame.styled = true
					end
					local colour = C.classcolours[select(2, UnitClass(playerFrame.Name:GetText()))]
					playerFrame.Name:SetTextColor(colour.r, colour.g, colour.b)
					playerFrame.Highlight:SetVertexColor(colour.r, colour.g, colour.b, .2)
				else
					break
				end
			end
		end)

		-- Missing loot frame

		MissingLootFrameCorner:Hide()

		hooksecurefunc("MissingLootFrame_Show", function()
			for i = 1, GetNumMissingLootItems() do
				local bu = _G["MissingLootFrameItem"..i]

				if not bu.styled then
					_G["MissingLootFrameItem"..i.."NameFrame"]:Hide()

					bu.icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(bu.icon)

					bu.styled = true
				end
			end
		end)

		F.CreateBD(MissingLootFrame)
		F.ReskinClose(MissingLootFramePassButton)

		-- BN conversation

		BNConversationInviteDialogHeader:SetTexture("")

		F.CreateBD(BNConversationInviteDialog)
		F.CreateBD(BNConversationInviteDialogList, .25)

		F.Reskin(BNConversationInviteDialogInviteButton)
		F.Reskin(BNConversationInviteDialogCancelButton)
		F.ReskinScroll(BNConversationInviteDialogListScrollFrameScrollBar)
		for i = 1, BN_CONVERSATION_INVITE_NUM_DISPLAYED do
			F.ReskinCheck(_G["BNConversationInviteDialogListFriend"..i].checkButton)
		end

		-- Tabard frame

		TabardFrameMoneyInset:DisableDrawLayer("BORDER")
		TabardFrameCustomizationBorder:Hide()
		TabardFrameMoneyBg:Hide()
		TabardFrameMoneyInsetBg:Hide()

		for i = 19, 28 do
			select(i, TabardFrame:GetRegions()):Hide()
		end

		for i = 1, 5 do
			_G["TabardFrameCustomization"..i.."Left"]:Hide()
			_G["TabardFrameCustomization"..i.."Middle"]:Hide()
			_G["TabardFrameCustomization"..i.."Right"]:Hide()
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."LeftButton"], "left")
			F.ReskinArrow(_G["TabardFrameCustomization"..i.."RightButton"], "right")
		end

		F.ReskinPortraitFrame(TabardFrame, true)
		F.CreateBD(TabardFrameCostFrame, .25)
		F.Reskin(TabardFrameAcceptButton)
		F.Reskin(TabardFrameCancelButton)

		-- Guild registrar frame

		GuildRegistrarFrameTop:Hide()
		GuildRegistrarFrameBottom:Hide()
		GuildRegistrarFrameMiddle:Hide()
		select(19, GuildRegistrarFrame:GetRegions()):Hide()
		select(6, GuildRegistrarFrameEditBox:GetRegions()):Hide()
		select(7, GuildRegistrarFrameEditBox:GetRegions()):Hide()

		GuildRegistrarFrameEditBox:SetHeight(20)

		F.ReskinPortraitFrame(GuildRegistrarFrame, true)
		F.CreateBD(GuildRegistrarFrameEditBox, .25)
		F.Reskin(GuildRegistrarFrameGoodbyeButton)
		F.Reskin(GuildRegistrarFramePurchaseButton)
		F.Reskin(GuildRegistrarFrameCancelButton)
		

		-- Item text

		select(18, ItemTextFrame:GetRegions()):Hide()
		InboxFrameBg:Hide()
		ItemTextScrollFrameMiddle:SetAlpha(0)
		ItemTextScrollFrameTop:SetAlpha(0)
		ItemTextScrollFrameBottom:SetAlpha(0)
		ItemTextPrevPageButton:GetRegions():Hide()
		ItemTextNextPageButton:GetRegions():Hide()
		ItemTextMaterialTopLeft:SetAlpha(0)
		ItemTextMaterialTopRight:SetAlpha(0)
		ItemTextMaterialBotLeft:SetAlpha(0)
		ItemTextMaterialBotRight:SetAlpha(0)

		F.ReskinPortraitFrame(ItemTextFrame, true)
		F.ReskinScroll(ItemTextScrollFrameScrollBar)
		F.ReskinArrow(ItemTextPrevPageButton, "left")
		F.ReskinArrow(ItemTextNextPageButton, "right")

		-- Petition frame

		select(18, PetitionFrame:GetRegions()):Hide()
		select(19, PetitionFrame:GetRegions()):Hide()
		select(23, PetitionFrame:GetRegions()):Hide()
		select(24, PetitionFrame:GetRegions()):Hide()
		PetitionFrameTop:Hide()
		PetitionFrameBottom:Hide()
		PetitionFrameMiddle:Hide()

		F.ReskinPortraitFrame(PetitionFrame, true)
		F.Reskin(PetitionFrameSignButton)
		F.Reskin(PetitionFrameRequestButton)
		F.Reskin(PetitionFrameRenameButton)
		F.Reskin(PetitionFrameCancelButton)

		-- Mac options

		if IsMacClient() then
			F.CreateBD(MacOptionsFrame)
			MacOptionsFrameHeader:SetTexture("")
			MacOptionsFrameHeader:ClearAllPoints()
			MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)

			F.CreateBD(MacOptionsFrameMovieRecording, .25)
			F.CreateBD(MacOptionsITunesRemote, .25)
			F.CreateBD(MacOptionsFrameMisc, .25)

			F.Reskin(MacOptionsButtonKeybindings)
			F.Reskin(MacOptionsButtonCompress)
			F.Reskin(MacOptionsFrameCancel)
			F.Reskin(MacOptionsFrameOkay)
			F.Reskin(MacOptionsFrameDefaults)

			F.ReskinDropDown(MacOptionsFrameResolutionDropDown)
			F.ReskinDropDown(MacOptionsFrameFramerateDropDown)
			F.ReskinDropDown(MacOptionsFrameCodecDropDown)

			for i = 1, 11 do
				F.ReskinCheck(_G["MacOptionsFrameCheckButton"..i])
			end
			F.ReskinSlider(MacOptionsFrameQualitySlider)

			MacOptionsButtonCompress:SetWidth(136)

			MacOptionsFrameCancel:SetWidth(96)
			MacOptionsFrameCancel:SetHeight(22)
			MacOptionsFrameCancel:ClearAllPoints()
			MacOptionsFrameCancel:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 107, 0)

			MacOptionsFrameOkay:SetWidth(96)
			MacOptionsFrameOkay:SetHeight(22)
			MacOptionsFrameOkay:ClearAllPoints()
			MacOptionsFrameOkay:SetPoint("LEFT", MacOptionsButtonKeybindings, "RIGHT", 5, 0)

			MacOptionsButtonKeybindings:SetWidth(96)
			MacOptionsButtonKeybindings:SetHeight(22)
			MacOptionsButtonKeybindings:ClearAllPoints()
			MacOptionsButtonKeybindings:SetPoint("LEFT", MacOptionsFrameDefaults, "RIGHT", 5, 0)

			MacOptionsFrameDefaults:SetWidth(96)
			MacOptionsFrameDefaults:SetHeight(22)
		end

		-- Micro button alerts

		local microButtons = {TalentMicroButtonAlert, CompanionsMicroButtonAlert}
			for _, button in pairs(microButtons) do
			button:DisableDrawLayer("BACKGROUND")
			button:DisableDrawLayer("BORDER")
			button.Arrow:Hide()

			F.SetBD(button)
			F.ReskinClose(button.CloseButton)
		end

		-- Cinematic popup

		CinematicFrameCloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		F.CreateBD(CinematicFrameCloseDialog)
		F.Reskin(CinematicFrameCloseDialogConfirmButton)
		F.Reskin(CinematicFrameCloseDialogResumeButton)

		-- Bonus roll

		BonusRollFrame.Background:SetAlpha(0)
		BonusRollFrame.IconBorder:Hide()
		BonusRollFrame.BlackBackgroundHoist.Background:Hide()

		BonusRollFrame.PromptFrame.Icon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(BonusRollFrame.PromptFrame.Icon)

		BonusRollFrame.PromptFrame.Timer.Bar:SetTexture(C.media.backdrop)

		F.CreateBD(BonusRollFrame)
		F.CreateBDFrame(BonusRollFrame.PromptFrame.Timer, .25)

		-- Chat config

		hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local checkBoxNameString = frame:GetName().."CheckBox"

			if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:SetPoint("TOPLEFT")
					bg:SetPoint("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					F.CreateBD(bg, .25)

					F.ReskinCheck(_G[checkBoxName.."Check"])
				end
			elseif checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate" or checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
				for index, value in ipairs(checkBoxTable) do
					local checkBoxName = checkBoxNameString..index
					local checkbox = _G[checkBoxName]

					checkbox:SetBackdrop(nil)

					local bg = CreateFrame("Frame", nil, checkbox)
					bg:SetPoint("TOPLEFT")
					bg:SetPoint("BOTTOMRIGHT", 0, 1)
					bg:SetFrameLevel(checkbox:GetFrameLevel()-1)
					F.CreateBD(bg, .25)

					F.ReskinColourSwatch(_G[checkBoxName.."ColorSwatch"])

					F.ReskinCheck(_G[checkBoxName.."Check"])

					if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
						F.ReskinCheck(_G[checkBoxName.."ColorClasses"])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable, checkBoxTemplate, subCheckBoxTemplate)
			if frame.styled then return end

			local checkBoxNameString = frame:GetName().."CheckBox"

			for index, value in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index

				F.ReskinCheck(_G[checkBoxName])

				if value.subTypes then
					local subCheckBoxNameString = checkBoxName.."_"

					for k, v in ipairs(value.subTypes) do
						F.ReskinCheck(_G[subCheckBoxNameString..k])
					end
				end
			end

			frame.styled = true
		end)

		hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable, swatchTemplate)
			if frame.styled then return end

			frame:SetBackdrop(nil)

			local nameString = frame:GetName().."Swatch"

			for index, value in ipairs(swatchTable) do
				local swatchName = nameString..index
				local swatch = _G[swatchName]

				swatch:SetBackdrop(nil)

				local bg = CreateFrame("Frame", nil, swatch)
				bg:SetPoint("TOPLEFT")
				bg:SetPoint("BOTTOMRIGHT", 0, 1)
				bg:SetFrameLevel(swatch:GetFrameLevel()-1)
				F.CreateBD(bg, .25)

				F.ReskinColourSwatch(_G[swatchName.."ColorSwatch"])
			end

			frame.styled = true
		end)

		for i = 1, 5 do
			_G["CombatConfigTab"..i.."Left"]:Hide()
			_G["CombatConfigTab"..i.."Middle"]:Hide()
			_G["CombatConfigTab"..i.."Right"]:Hide()
		end

		local line = ChatConfigFrame:CreateTexture()
		line:SetSize(1, 460)
		line:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "TOPRIGHT")
		line:SetTexture(1, 1, 1, .2)

		ChatConfigCategoryFrame:SetBackdrop(nil)
		ChatConfigBackgroundFrame:SetBackdrop(nil)
		ChatConfigCombatSettingsFilters:SetBackdrop(nil)
		CombatConfigColorsHighlighting:SetBackdrop(nil)
		CombatConfigColorsColorizeUnitName:SetBackdrop(nil)
		CombatConfigColorsColorizeSpellNames:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageNumber:SetBackdrop(nil)
		CombatConfigColorsColorizeDamageSchool:SetBackdrop(nil)
		CombatConfigColorsColorizeEntireLine:SetBackdrop(nil)

		local combatBoxes = {CombatConfigColorsHighlightingLine, CombatConfigColorsHighlightingAbility, CombatConfigColorsHighlightingDamage, CombatConfigColorsHighlightingSchool, CombatConfigColorsColorizeUnitNameCheck, CombatConfigColorsColorizeSpellNamesCheck, CombatConfigColorsColorizeSpellNamesSchoolColoring, CombatConfigColorsColorizeDamageNumberCheck, CombatConfigColorsColorizeDamageNumberSchoolColoring, CombatConfigColorsColorizeDamageSchoolCheck, CombatConfigColorsColorizeEntireLineCheck, CombatConfigFormattingShowTimeStamp, CombatConfigFormattingShowBraces, CombatConfigFormattingUnitNames, CombatConfigFormattingSpellNames, CombatConfigFormattingItemNames, CombatConfigFormattingFullText, CombatConfigSettingsShowQuickButton, CombatConfigSettingsSolo, CombatConfigSettingsParty, CombatConfigSettingsRaid}

		for _, box in next, combatBoxes do
			F.ReskinCheck(box)
		end

		local bg = CreateFrame("Frame", nil, ChatConfigCombatSettingsFilters)
		bg:SetPoint("TOPLEFT", 3, 0)
		bg:SetPoint("BOTTOMRIGHT", 0, 1)
		bg:SetFrameLevel(ChatConfigCombatSettingsFilters:GetFrameLevel()-1)
		F.CreateBD(bg, .25)

		F.Reskin(CombatLogDefaultButton)
		F.Reskin(ChatConfigCombatSettingsFiltersCopyFilterButton)
		F.Reskin(ChatConfigCombatSettingsFiltersAddFilterButton)
		F.Reskin(ChatConfigCombatSettingsFiltersDeleteButton)
		F.Reskin(CombatConfigSettingsSaveButton)
		F.ReskinArrow(ChatConfigMoveFilterUpButton, "up")
		F.ReskinArrow(ChatConfigMoveFilterDownButton, "down")
		F.ReskinInput(CombatConfigSettingsNameEditBox)
		F.ReskinRadio(CombatConfigColorsColorizeEntireLineBySource)
		F.ReskinRadio(CombatConfigColorsColorizeEntireLineByTarget)
		F.ReskinColourSwatch(CombatConfigColorsColorizeSpellNamesColorSwatch)
		F.ReskinColourSwatch(CombatConfigColorsColorizeDamageNumberColorSwatch)

		ChatConfigMoveFilterUpButton:SetSize(28, 28)
		ChatConfigMoveFilterDownButton:SetSize(28, 28)

		ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)
		ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)
		ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, 0)
		ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)

		-- Level up display

		LevelUpDisplaySide:HookScript("OnShow", function(self)
			for i = 1, #self.unlockList do
				local f = _G["LevelUpDisplaySideUnlockFrame"..i]

				if not f.restyled then
					f.icon:SetTexCoord(.08, .92, .08, .92)
					F.CreateBG(f.icon)
				end
			end
		end)

		-- Movie Frame

		MovieFrame.CloseDialog:HookScript("OnShow", function(self)
			self:SetScale(UIParent:GetScale())
		end)

		F.CreateBD(MovieFrame.CloseDialog)
		F.Reskin(MovieFrame.CloseDialog.ConfirmButton)
		F.Reskin(MovieFrame.CloseDialog.ResumeButton)

		-- Pet battle queue popup

		F.CreateBD(PetBattleQueueReadyFrame)
		F.CreateBG(PetBattleQueueReadyFrame.Art)
		F.Reskin(PetBattleQueueReadyFrame.AcceptButton)
		F.Reskin(PetBattleQueueReadyFrame.DeclineButton)

		-- PVP Ready Dialog

		local PVPReadyDialog = PVPReadyDialog

		PVPReadyDialogBackground:Hide()
		PVPReadyDialogBottomArt:Hide()
		PVPReadyDialogFiligree:Hide()

		PVPReadyDialogRoleIconTexture:SetTexture(C.media.roleIcons)

		do
			local left = PVPReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", 9, -7)
			left:SetPoint("BOTTOMLEFT", 9, 10)

			local right = PVPReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", -8, -7)
			right:SetPoint("BOTTOMRIGHT", -8, 10)

			local top = PVPReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", 9, -7)
			top:SetPoint("TOPRIGHT", -8, -7)

			local bottom = PVPReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", 9, 10)
			bottom:SetPoint("BOTTOMRIGHT", -8, 10)
		end

		F.CreateBD(PVPReadyDialog)
		PVPReadyDialog.SetBackdrop = F.dummy

		F.Reskin(PVPReadyDialog.enterButton)
		F.Reskin(PVPReadyDialog.leaveButton)
		F.ReskinClose(PVPReadyDialogCloseButton)

		-- [[LFG Frame]]
		local function styleRewardButton(button)
		local buttonName = button:GetName()

		local icon = _G[buttonName.."IconTexture"]
		local cta = _G[buttonName.."ShortageBorder"]
		local count = _G[buttonName.."Count"]
		local na = _G[buttonName.."NameFrame"]

		F.CreateBG(icon)
		icon:SetTexCoord(.08, .92, .08, .92)
		icon:SetDrawLayer("OVERLAY")
		count:SetDrawLayer("OVERLAY")
		na:SetTexture(0, 0, 0, .25)
		na:SetSize(118, 39)

		if cta then
			cta:SetAlpha(0)
		end

		button.bg2 = CreateFrame("Frame", nil, button)
		button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
		button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
		F.CreateBD(button.bg2, 0)
	end

	hooksecurefunc("LFDQueueFrameRandom_UpdateFrame", function()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				local icon = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."IconTexture"]
				local cta = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."ShortageBorder"]
				local count = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."Count"]
				local na = _G["LFDQueueFrameRandomScrollFrameChildFrameItem"..i.."NameFrame"]

				F.CreateBG(icon)
				icon:SetTexCoord(.08, .92, .08, .92)
				icon:SetDrawLayer("OVERLAY")
				count:SetDrawLayer("OVERLAY")
				na:SetTexture(0, 0, 0, .25)
				na:SetSize(118, 39)
				cta:SetAlpha(0)

				button.bg2 = CreateFrame("Frame", nil, button)
				button.bg2:SetPoint("TOPLEFT", na, "TOPLEFT", 10, 0)
				button.bg2:SetPoint("BOTTOMRIGHT", na, "BOTTOMRIGHT")
				F.CreateBD(button.bg2, 0)

				button.styled = true
			end
		end
	end)

	hooksecurefunc("ScenarioQueueFrameRandom_UpdateFrame", function()
		for i = 1, 2 do
			local button = _G["ScenarioQueueFrameRandomScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)
	hooksecurefunc("RaidFinderQueueFrameRewards_UpdateFrame", function()
		for i = 1, LFD_MAX_REWARDS do
			local button = _G["RaidFinderQueueFrameScrollFrameChildFrameItem"..i]

			if button and not button.styled then
				styleRewardButton(button)
				button.styled = true
			end
		end
	end)

	styleRewardButton(LFDQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(ScenarioQueueFrameRandomScrollFrameChildFrame.MoneyReward)
	styleRewardButton(RaidFinderQueueFrameScrollFrameChildFrame.MoneyReward)

	LFGDungeonReadyDialogBackground:Hide()
	LFGDungeonReadyDialogBottomArt:Hide()
	LFGDungeonReadyDialogFiligree:Hide()

	LFGDungeonReadyDialogRoleIconTexture:SetTexture(C.media.roleIcons)
	LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexture(C.media.roleIcons)
	LFGDungeonReadyDialogRoleIconLeaderIcon:SetTexCoord(0, 0.296875, 0.015625, 0.2875)

	local leaderBg = F.CreateBG(LFGDungeonReadyDialogRoleIconLeaderIcon)
	leaderBg:SetDrawLayer("ARTWORK", 2)
	leaderBg:SetPoint("TOPLEFT", LFGDungeonReadyDialogRoleIconLeaderIcon, 2, 0)
	leaderBg:SetPoint("BOTTOMRIGHT", LFGDungeonReadyDialogRoleIconLeaderIcon, -3, 4)

	hooksecurefunc("LFGDungeonReadyPopup_Update", function()
		leaderBg:SetShown(LFGDungeonReadyDialogRoleIconLeaderIcon:IsShown())
	end)

	do
		local left = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(C.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", 9, -7)
		left:SetPoint("BOTTOMLEFT", 9, 10)

		local right = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(C.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", -8, -7)
		right:SetPoint("BOTTOMRIGHT", -8, 10)

		local top = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(C.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", 9, -7)
		top:SetPoint("TOPRIGHT", -8, -7)

		local bottom = LFGDungeonReadyDialogRoleIcon:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(C.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", 9, 10)
		bottom:SetPoint("BOTTOMRIGHT", -8, 10)
	end

	hooksecurefunc("LFGDungeonReadyDialogReward_SetMisc", function(button)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		button.texture:SetTexture("Interface\\Icons\\inv_misc_coin_02")
	end)

	hooksecurefunc("LFGDungeonReadyDialogReward_SetReward", function(button, dungeonID, rewardIndex, rewardType, rewardArg)
		if not button.styled then
			local border = _G[button:GetName().."Border"]

			button.texture:SetTexCoord(.08, .92, .08, .92)

			border:SetTexture(0, 0, 0)
			border:SetDrawLayer("BACKGROUND")
			border:SetPoint("TOPLEFT", button.texture, -1, 1)
			border:SetPoint("BOTTOMRIGHT", button.texture, 1, -1)

			button.styled = true
		end

		local name, texturePath, quantity
		if rewardType == "reward" then
			name, texturePath, quantity = GetLFGDungeonRewardInfo(dungeonID, rewardIndex);
		elseif rewardType == "shortage" then
			name, texturePath, quantity = GetLFGDungeonShortageRewardInfo(dungeonID, rewardArg, rewardIndex);
		end
		if texturePath then
			button.texture:SetTexture(texturePath)
		end
	end)

	F.CreateBD(LFGDungeonReadyDialog)
	LFGDungeonReadyDialog.SetBackdrop = F.dummy
	F.CreateBD(LFGInvitePopup)
	F.CreateBD(LFGDungeonReadyStatus)

	F.Reskin(LFGDungeonReadyDialogEnterDungeonButton)
	F.Reskin(LFGDungeonReadyDialogLeaveQueueButton)
	F.Reskin(LFGInvitePopupAcceptButton)
	F.Reskin(LFGInvitePopupDeclineButton)
	F.ReskinClose(LFGDungeonReadyDialogCloseButton)
	F.ReskinClose(LFGDungeonReadyStatusCloseButton)

	for _, roleButton in pairs({LFDQueueFrameRoleButtonTank, LFDQueueFrameRoleButtonHealer, LFDQueueFrameRoleButtonDPS, LFDQueueFrameRoleButtonLeader, LFRQueueFrameRoleButtonTank, LFRQueueFrameRoleButtonHealer, LFRQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonTank, RaidFinderQueueFrameRoleButtonHealer, RaidFinderQueueFrameRoleButtonDPS, RaidFinderQueueFrameRoleButtonLeader}) do
		
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		for i = 1, 2 do
			local left = roleButton:CreateTexture()
			left:SetDrawLayer("OVERLAY", i)
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleButton, 6, -5)
			left:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			roleButton["leftLine"..i] = left

			local right = roleButton:CreateTexture()
			right:SetDrawLayer("OVERLAY", i)
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleButton, -6, -5)
			right:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["rightLine"..i] = right

			local top = roleButton:CreateTexture()
			top:SetDrawLayer("OVERLAY", i)
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleButton, 6, -5)
			top:SetPoint("TOPRIGHT", roleButton, -6, -5)
			roleButton["topLine"..i] = top

			local bottom = roleButton:CreateTexture()
			bottom:SetDrawLayer("OVERLAY", i)
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleButton, 6, 7)
			bottom:SetPoint("BOTTOMRIGHT", roleButton, -6, 7)
			roleButton["bottomLine"..i] = bottom
		end

		roleButton.leftLine2:Hide()
		roleButton.rightLine2:Hide()
		roleButton.topLine2:Hide()
		roleButton.bottomLine2:Hide()

		local shortageBorder = roleButton.shortageBorder
		if shortageBorder then
			local icon = roleButton.incentiveIcon

			shortageBorder:SetTexture("")

			icon.border:SetTexture(0, 0, 0)
			icon.border:SetDrawLayer("BACKGROUND")
			icon.border:SetPoint("TOPLEFT", icon.texture, -1, 1)
			icon.border:SetPoint("BOTTOMRIGHT", icon.texture, 1, -1)

			icon:SetPoint("BOTTOMRIGHT", 3, -3)
			icon:SetSize(14, 14)
			icon.texture:SetSize(14, 14)
			icon.texture:SetTexCoord(.12, .88, .12, .88)
		end

		F.ReskinCheck(roleButton.checkButton)
	end

	for _, roleButton in pairs({LFDRoleCheckPopupRoleButtonTank, LFDRoleCheckPopupRoleButtonHealer, LFDRoleCheckPopupRoleButtonDPS, LFGInvitePopupRoleButtonTank, LFGInvitePopupRoleButtonHealer, LFGInvitePopupRoleButtonDPS}) do
		roleButton.cover:SetTexture(C.media.roleIcons)
		roleButton:SetNormalTexture(C.media.roleIcons)

		roleButton.checkButton:SetFrameLevel(roleButton:GetFrameLevel() + 2)

		local left = roleButton:CreateTexture(nil, "OVERLAY")
		left:SetWidth(1)
		left:SetTexture(C.media.backdrop)
		left:SetVertexColor(0, 0, 0)
		left:SetPoint("TOPLEFT", roleButton, 9, -7)
		left:SetPoint("BOTTOMLEFT", roleButton, 9, 11)

		local right = roleButton:CreateTexture(nil, "OVERLAY")
		right:SetWidth(1)
		right:SetTexture(C.media.backdrop)
		right:SetVertexColor(0, 0, 0)
		right:SetPoint("TOPRIGHT", roleButton, -9, -7)
		right:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

		local top = roleButton:CreateTexture(nil, "OVERLAY")
		top:SetHeight(1)
		top:SetTexture(C.media.backdrop)
		top:SetVertexColor(0, 0, 0)
		top:SetPoint("TOPLEFT", roleButton, 9, -7)
		top:SetPoint("TOPRIGHT", roleButton, -9, -7)

		local bottom = roleButton:CreateTexture(nil, "OVERLAY")
		bottom:SetHeight(1)
		bottom:SetTexture(C.media.backdrop)
		bottom:SetVertexColor(0, 0, 0)
		bottom:SetPoint("BOTTOMLEFT", roleButton, 9, 11)
		bottom:SetPoint("BOTTOMRIGHT", roleButton, -9, 11)

		F.ReskinCheck(roleButton.checkButton)
	end

	do
		local roleButtons = {LFGDungeonReadyStatusGroupedTank, LFGDungeonReadyStatusGroupedHealer, LFGDungeonReadyStatusGroupedDamager, LFGDungeonReadyStatusRolelessReady}

		for i = 1, 5 do
			tinsert(roleButtons, _G["LFGDungeonReadyStatusIndividualPlayer"..i])
		end

		for _, roleButton in pairs(roleButtons) do
			roleButton.texture:SetTexture(C.media.roleIcons)
			roleButton.statusIcon:SetDrawLayer("OVERLAY", 2)

			local left = roleButton:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", 7, -6)
			left:SetPoint("BOTTOMLEFT", 7, 8)

			local right = roleButton:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", -7, -6)
			right:SetPoint("BOTTOMRIGHT", -7, 8)

			local top = roleButton:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", 7, -6)
			top:SetPoint("TOPRIGHT", -7, -6)

			local bottom = roleButton:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", 7, 8)
			bottom:SetPoint("BOTTOMRIGHT", -7, 8)
		end
	end

	LFGDungeonReadyStatusRolelessReady.texture:SetTexCoord(0.5234375, 0.78750, 0, 0.25875)

	hooksecurefunc("LFG_SetRoleIconIncentive", function(roleButton, incentiveIndex)
		if incentiveIndex then
			local tex
			if incentiveIndex == LFG_ROLE_SHORTAGE_PLENTIFUL then
				tex = "Interface\\Icons\\INV_Misc_Coin_19"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_UNCOMMON then
				tex = "Interface\\Icons\\INV_Misc_Coin_18"
			elseif incentiveIndex == LFG_ROLE_SHORTAGE_RARE then
				tex = "Interface\\Icons\\INV_Misc_Coin_17"
			end
			roleButton.incentiveIcon.texture:SetTexture(tex)
			roleButton.leftLine2:Show()
			roleButton.rightLine2:Show()
			roleButton.topLine2:Show()
			roleButton.bottomLine2:Show()
		else
			roleButton.leftLine2:Hide()
			roleButton.rightLine2:Hide()
			roleButton.topLine2:Hide()
			roleButton.bottomLine2:Hide()
		end
	end)

	hooksecurefunc("LFG_PermanentlyDisableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(.5, .45, .03)
			button.rightLine2:SetVertexColor(.5, .45, .03)
			button.topLine2:SetVertexColor(.5, .45, .03)
			button.bottomLine2:SetVertexColor(.5, .45, .03)
		end
	end)

	hooksecurefunc("LFG_DisableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(.5, .45, .03)
			button.rightLine2:SetVertexColor(.5, .45, .03)
			button.topLine2:SetVertexColor(.5, .45, .03)
			button.bottomLine2:SetVertexColor(.5, .45, .03)
		end
	end)

	hooksecurefunc("LFG_EnableRoleButton", function(button)
		if button.shortageBorder then
			button.leftLine2:SetVertexColor(1, .9, .06)
			button.rightLine2:SetVertexColor(1, .9, .06)
			button.topLine2:SetVertexColor(1, .9, .06)
			button.bottomLine2:SetVertexColor(1, .9, .06)
		end
	end)

		-- [[ Hide regions ]]

		local bglayers = {"LFDParentFrame", "LFDParentFrameInset", "WhoFrameColumnHeader1", "WhoFrameColumnHeader2", "WhoFrameColumnHeader3", "WhoFrameColumnHeader4", "RaidInfoInstanceLabel", "RaidInfoIDLabel", "CharacterFrameInsetRight", "LFRQueueFrame", "LFRBrowseFrame", "HelpFrameMainInset", "CharacterModelFrame", "HelpFrame", "HelpFrameLeftInset", "EquipmentFlyoutFrameButtons", "VideoOptionsFrameCategoryFrame", "InterfaceOptionsFrameCategories", "InterfaceOptionsFrameAddOns", "RaidParentFrame"}
		for i = 1, #bglayers do
			_G[bglayers[i]]:DisableDrawLayer("BACKGROUND")
		end
		local borderlayers = {"WhoFrameListInset", "WhoFrameEditBoxInset", "ChannelFrameLeftInset", "ChannelFrameRightInset", "LFDParentFrame", "LFDParentFrameInset", "CharacterFrameInsetRight", "HelpFrame", "HelpFrameLeftInset", "HelpFrameMainInset", "CharacterModelFrame", "VideoOptionsFramePanelContainer", "InterfaceOptionsFramePanelContainer", "RaidParentFrame", "RaidParentFrameInset", "RaidFinderFrameRoleInset", "LFRQueueFrameRoleInset", "LFRQueueFrameListInset", "LFRQueueFrameCommentInset"}
		for i = 1, #borderlayers do
			_G[borderlayers[i]]:DisableDrawLayer("BORDER")
		end
		local overlayers = {"LFDParentFrame", "CharacterModelFrame"}
		for i = 1, #overlayers do
			_G[overlayers[i]]:DisableDrawLayer("OVERLAY")
		end
		for i = 1, 6 do
			for j = 1, 3 do
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()):Hide()
				select(i, _G["FriendsTabHeaderTab"..j]:GetRegions()).Show = F.dummy
			end
			select(i, ScrollOfResurrectionFrameNoteFrame:GetRegions()):Hide()
		end
		EquipmentFlyoutFrameButtons:DisableDrawLayer("ARTWORK")
		OpenStationeryBackgroundLeft:Hide()
		OpenStationeryBackgroundRight:Hide()
		SendStationeryBackgroundLeft:Hide()
		SendStationeryBackgroundRight:Hide()
		DressUpFramePortrait:Hide()
		DressUpBackgroundTopLeft:Hide()
		DressUpBackgroundTopRight:Hide()
		DressUpBackgroundBotLeft:Hide()
		DressUpBackgroundBotRight:Hide()
		for i = 1, 4 do
			select(i, GearManagerDialogPopup:GetRegions()):Hide()
			select(i, SideDressUpFrame:GetRegions()):Hide()
		end
		StackSplitFrame:GetRegions():Hide()
		RaidInfoDetailFooter:Hide()
		RaidInfoDetailHeader:Hide()
		RaidInfoDetailCorner:Hide()
		RaidInfoFrameHeader:Hide()
		for i = 1, 9 do
			select(i, FriendsFriendsNoteFrame:GetRegions()):Hide()
			select(i, AddFriendNoteFrame:GetRegions()):Hide()
			select(i, ReportPlayerNameDialogCommentFrame:GetRegions()):Hide()
			select(i, ReportCheatingDialogCommentFrame:GetRegions()):Hide()

		end
		HelpFrameHeader:Hide()
		ReadyCheckPortrait:SetAlpha(0)
		select(2, ReadyCheckListenerFrame:GetRegions()):Hide()
		HelpFrameLeftInsetBg:Hide()
		LFDQueueFrameBackground:Hide()
		select(3, HelpFrameReportBug:GetChildren()):Hide()
		select(3, HelpFrameSubmitSuggestion:GetChildren()):Hide()
		select(4, HelpFrameTicket:GetChildren()):Hide()
		HelpFrameKnowledgebaseStoneTex:Hide()
		HelpFrameKnowledgebaseNavBarOverlay:Hide()
		GhostFrameLeft:Hide()
		GhostFrameRight:Hide()
		GhostFrameMiddle:Hide()
		for i = 3, 6 do
			select(i, GhostFrame:GetRegions()):Hide()
		end
		PaperDollSidebarTabs:GetRegions():Hide()
		select(2, PaperDollSidebarTabs:GetRegions()):Hide()
		select(6, PaperDollEquipmentManagerPaneEquipSet:GetRegions()):Hide()
		select(5, HelpFrameGM_Response:GetChildren()):Hide()
		select(6, HelpFrameGM_Response:GetChildren()):Hide()
		HelpFrameKnowledgebaseNavBarHomeButtonLeft:Hide()
		TokenFramePopupCorner:Hide()
		GearManagerDialogPopupScrollFrame:GetRegions():Hide()
		select(2, GearManagerDialogPopupScrollFrame:GetRegions()):Hide()
		for i = 1, 10 do
			select(i, GuildInviteFrame:GetRegions()):Hide()
		end
		CharacterFrameExpandButton:GetNormalTexture():SetAlpha(0)
		CharacterFrameExpandButton:GetPushedTexture():SetAlpha(0)
		InboxPrevPageButton:GetRegions():Hide()
		InboxNextPageButton:GetRegions():Hide()
		MerchantPrevPageButton:GetRegions():Hide()
		MerchantNextPageButton:GetRegions():Hide()
		select(2, MerchantPrevPageButton:GetRegions()):Hide()
		select(2, MerchantNextPageButton:GetRegions()):Hide()
		LFDQueueFrameRandomScrollFrameScrollBackground:Hide()
		ChannelFrameDaughterFrameCorner:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundTopLeft:Hide()
		LFDQueueFrameSpecificListScrollFrameScrollBackgroundBottomRight:Hide()
		for i = 1, MAX_DISPLAY_CHANNEL_BUTTONS do
			_G["ChannelButton"..i]:SetNormalTexture("")
		end
		CharacterStatsPaneTop:Hide()
		CharacterStatsPaneBottom:Hide()
		hooksecurefunc("PaperDollFrame_CollapseStatCategory", function(categoryFrame)
			categoryFrame.BgMinimized:Hide()
		end)
		hooksecurefunc("PaperDollFrame_ExpandStatCategory", function(categoryFrame)
			categoryFrame.BgTop:Hide()
			categoryFrame.BgMiddle:Hide()
			categoryFrame.BgBottom:Hide()
		end)
		local titles = false
		hooksecurefunc("PaperDollTitlesPane_Update", function()
			if titles == false then
				for i = 1, 17 do
					_G["PaperDollTitlesPaneButton"..i]:DisableDrawLayer("BACKGROUND")
				end
				titles = true
			end
		end)
		MerchantNameText:SetDrawLayer("ARTWORK")
		SendScrollBarBackgroundTop:Hide()
		select(4, SendMailScrollFrame:GetRegions()):Hide()
		for i = 1, 7 do
			_G["LFRBrowseFrameColumnHeader"..i]:DisableDrawLayer("BACKGROUND")
		end
		HelpFrameKnowledgebaseTopTileStreaks:Hide()
		for i = 2, 5 do
			select(i, DressUpFrame:GetRegions()):Hide()
		end
		ChannelFrameDaughterFrameTitlebar:Hide()
		OpenScrollBarBackgroundTop:Hide()
		select(2, OpenMailScrollFrame:GetRegions()):Hide()
		HelpFrameKnowledgebaseNavBar:GetRegions():Hide()
		WhoListScrollFrame:GetRegions():Hide()
		select(2, WhoListScrollFrame:GetRegions()):Hide()
		select(2, GuildChallengeAlertFrame:GetRegions()):Hide()
		InterfaceOptionsFrameTab1TabSpacer:SetAlpha(0)
		for i = 1, 2 do
			_G["InterfaceOptionsFrameTab"..i.."Left"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Middle"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."Right"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
			_G["InterfaceOptionsFrameTab2TabSpacer"..i]:SetAlpha(0)
		end
		ChannelRosterScrollFrameTop:SetAlpha(0)
		ChannelRosterScrollFrameBottom:SetAlpha(0)
		FriendsFrameFriendsScrollFrameTop:Hide()
		FriendsFrameFriendsScrollFrameMiddle:Hide()
		FriendsFrameFriendsScrollFrameBottom:Hide()
		WhoFrameListInsetBg:Hide()
		WhoFrameEditBoxInsetBg:Hide()
		ChannelFrameLeftInsetBg:Hide()
		ChannelFrameRightInsetBg:Hide()
		RaidFinderQueueFrameBackground:Hide()
		RaidParentFrameInsetBg:Hide()
		RaidFinderFrameRoleInsetBg:Hide()
		RaidFinderFrameRoleBackground:Hide()
		RaidParentFramePortraitFrame:Hide()
		RaidParentFramePortrait:Hide()
		RaidParentFrameTopBorder:Hide()
		RaidParentFrameTopRightCorner:Hide()
		LFRQueueFrameRoleInsetBg:Hide()
		LFRQueueFrameListInsetBg:Hide()
		LFRQueueFrameCommentInsetBg:Hide()
		select(5, SideDressUpModelCloseButton:GetRegions()):Hide()
		IgnoreListFrameTop:Hide()
		IgnoreListFrameMiddle:Hide()
		IgnoreListFrameBottom:Hide()
		PendingListFrameTop:Hide()
		PendingListFrameMiddle:Hide()
		PendingListFrameBottom:Hide()
		ScrollOfResurrectionSelectionFrameBackground:Hide()

		ReadyCheckFrame:HookScript("OnShow", function(self) if UnitIsUnit("player", self.initiator) then self:Hide() end end)

		-- [[ Text colour functions ]]

		NORMAL_QUEST_DISPLAY = "|cffffffff%s|r"
		TRIVIAL_QUEST_DISPLAY = "|cffffffff%s (low level)|r"

		GameFontBlackMedium:SetTextColor(1, 1, 1)
		QuestFont:SetTextColor(1, 1, 1)
		MailFont_Large:SetTextColor(1, 1, 1)
		MailFont_Large:SetShadowColor(0, 0, 0)
		MailFont_Large:SetShadowOffset(1, -1)
		MailTextFontNormal:SetTextColor(1, 1, 1)
		MailTextFontNormal:SetShadowOffset(1, -1)
		MailTextFontNormal:SetShadowColor(0, 0, 0)
		InvoiceTextFontNormal:SetTextColor(1, 1, 1)
		InvoiceTextFontSmall:SetTextColor(1, 1, 1)
		SpellBookPageText:SetTextColor(.8, .8, .8)
		QuestProgressRequiredItemsText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetShadowColor(0, 0, 0)
		QuestProgressTitleText:SetShadowColor(0, 0, 0)
		QuestInfoTitleHeader:SetShadowColor(0, 0, 0)
		AvailableServicesText:SetTextColor(1, 1, 1)
		AvailableServicesText:SetShadowColor(0, 0, 0)
		PetitionFrameCharterTitle:SetTextColor(1, 1, 1)
		PetitionFrameCharterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMasterTitle:SetTextColor(1, 1, 1)
		PetitionFrameMasterTitle:SetShadowColor(0, 0, 0)
		PetitionFrameMemberTitle:SetTextColor(1, 1, 1)
		PetitionFrameMemberTitle:SetShadowColor(0, 0, 0)

		QuestInfoTitleHeader:SetTextColor(1, 1, 1)
		QuestInfoTitleHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetTextColor(1, 1, 1)
		QuestInfoDescriptionHeader.SetTextColor = F.dummy
		QuestInfoDescriptionHeader:SetShadowColor(0, 0, 0)
		QuestInfoObjectivesHeader:SetTextColor(1, 1, 1)
		QuestInfoObjectivesHeader.SetTextColor = F.dummy
		QuestInfoObjectivesHeader:SetShadowColor(0, 0, 0)
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoDescriptionText.SetTextColor = F.dummy
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText.SetTextColor = F.dummy
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoGroupSize.SetTextColor = F.dummy
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		QuestInfoRewardText.SetTextColor = F.dummy
		QuestProgressTitleText:SetTextColor(1, 1, 1)
		QuestProgressTitleText.SetTextColor = F.dummy
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressText.SetTextColor = F.dummy
		ItemTextPageText:SetTextColor(1, 1, 1)
		ItemTextPageText.SetTextColor = F.dummy
		GreetingText:SetTextColor(1, 1, 1)
		GreetingText.SetTextColor = F.dummy
		AvailableQuestsText:SetTextColor(1, 1, 1)
		AvailableQuestsText.SetTextColor = F.dummy
		AvailableQuestsText:SetShadowColor(0, 0, 0)
		QuestInfoSpellObjectiveLearnLabel:SetTextColor(1, 1, 1)
		QuestInfoSpellObjectiveLearnLabel.SetTextColor = F.dummy
		CurrentQuestsText:SetTextColor(1, 1, 1)
		CurrentQuestsText.SetTextColor = F.dummy
		CurrentQuestsText:SetShadowColor(0, 0, 0)
		CoreAbilityFont:SetTextColor(1, 1, 1)
		SystemFont_Large:SetTextColor(1, 1, 1)

		hooksecurefunc("UpdateProfessionButton", function(self)
			self.spellString:SetTextColor(1, 1, 1);
			self.subSpellString:SetTextColor(1, 1, 1)
		end)

		hooksecurefunc("PaperDollFrame_SetLevel", function()
			local primaryTalentTree = GetSpecialization()
			local classDisplayName, class = UnitClass("player")
			local classColor = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or C.classcolours[class]
			local classColorString = format("ff%.2x%.2x%.2x", classColor.r * 255, classColor.g * 255, classColor.b * 255)
			local specName, _

			if primaryTalentTree then
				_, specName = GetSpecializationInfo(primaryTalentTree, nil, nil, nil, UnitSex("player"))
			end

			if specName and specName ~= "" then
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL, UnitLevel("player"), classColorString, specName, classDisplayName)
			else
				CharacterLevelText:SetFormattedText(PLAYER_LEVEL_NO_SPEC, UnitLevel("player"), classColorString, classDisplayName)
			end
		end)

		-- [[ Change positions ]]

		ChatConfigFrameDefaultButton:SetWidth(125)
		ChatConfigFrameDefaultButton:SetPoint("TOPLEFT", ChatConfigCategoryFrame, "BOTTOMLEFT", 0, -4)
		ChatConfigFrameOkayButton:SetPoint("TOPRIGHT", ChatConfigBackgroundFrame, "BOTTOMRIGHT", 0, -4)
		PaperDollEquipmentManagerPaneEquipSet:SetWidth(PaperDollEquipmentManagerPaneEquipSet:GetWidth()-1)
		PaperDollEquipmentManagerPaneSaveSet:SetPoint("LEFT", PaperDollEquipmentManagerPaneEquipSet, "RIGHT", 1, 0)
		GearManagerDialogPopup:SetPoint("LEFT", PaperDollFrame, "RIGHT", 1, 0)
		DressUpFrameResetButton:SetPoint("RIGHT", DressUpFrameCancelButton, "LEFT", -1, 0)
		SendMailMailButton:SetPoint("RIGHT", SendMailCancelButton, "LEFT", -1, 0)
		OpenMailDeleteButton:SetPoint("RIGHT", OpenMailCancelButton, "LEFT", -1, 0)
		OpenMailReplyButton:SetPoint("RIGHT", OpenMailDeleteButton, "LEFT", -1, 0)
		HelpFrameReportBugScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameReportBugScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameSubmitSuggestionScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameSubmitSuggestionScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameTicketScrollFrameScrollBar:SetPoint("TOPLEFT", HelpFrameTicketScrollFrame, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame1ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame1, "TOPRIGHT", 1, -16)
		HelpFrameGM_ResponseScrollFrame2ScrollBar:SetPoint("TOPLEFT", HelpFrameGM_ResponseScrollFrame2, "TOPRIGHT", 1, -16)
		RaidInfoFrame:SetPoint("TOPLEFT", RaidFrame, "TOPRIGHT", 1, -28)
		TokenFramePopup:SetPoint("TOPLEFT", TokenFrame, "TOPRIGHT", 1, -28)
		CharacterFrameExpandButton:SetPoint("BOTTOMRIGHT", CharacterFrameInset, "BOTTOMRIGHT", -14, 6)
		TabardCharacterModelRotateRightButton:SetPoint("TOPLEFT", TabardCharacterModelRotateLeftButton, "TOPRIGHT", 1, 0)
		LFDQueueFrameSpecificListScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameSpecificListScrollFrameScrollBar, "BOTTOM", 0, 2)
		LFDQueueFrameRandomScrollFrameScrollBarScrollDownButton:SetPoint("TOP", LFDQueueFrameRandomScrollFrameScrollBar, "BOTTOM", 0, 2)
		SendMailMoneySilver:SetPoint("LEFT", SendMailMoneyGold, "RIGHT", 1, 0)
		SendMailMoneyCopper:SetPoint("LEFT", SendMailMoneySilver, "RIGHT", 1, 0)
		WhoFrameWhoButton:SetPoint("RIGHT", WhoFrameAddFriendButton, "LEFT", -1, 0)
		WhoFrameAddFriendButton:SetPoint("RIGHT", WhoFrameGroupInviteButton, "LEFT", -1, 0)
		FriendsFrameTitleText:SetPoint("TOP", FriendsFrame, "TOP", 0, -8)
		VideoOptionsFrameOkay:SetPoint("BOTTOMRIGHT", VideoOptionsFrameCancel, "BOTTOMLEFT", -1, 0)
		InterfaceOptionsFrameOkay:SetPoint("BOTTOMRIGHT", InterfaceOptionsFrameCancel, "BOTTOMLEFT", -1, 0)

		-- [[ Tabs ]]
		for i = 1, 5 do
			F.ReskinTab(_G["SpellBookFrameTabButton"..i])
		end

		for i = 1, 4 do
			F.ReskinTab(_G["FriendsFrameTab"..i])
			if _G["CharacterFrameTab"..i] then
				F.ReskinTab(_G["CharacterFrameTab"..i])
			end
		end

		for i = 1, 2 do
			F.ReskinTab(_G["MerchantFrameTab"..i])
			F.ReskinTab(_G["MailFrameTab"..i])
		end

		-- [[ Buttons ]]

		local buttons = {"VideoOptionsFrameOkay", "GameMenuButtonQulightUI", "OpenAllButton2", "OpenAllButton", "VideoOptionsFrameCancel", "VideoOptionsFrameDefaults", "VideoOptionsFrameApply", "AudioOptionsFrameOkay", "AudioOptionsFrameCancel", "AudioOptionsFrameDefaults", "InterfaceOptionsFrameDefaults", "InterfaceOptionsFrameOkay", "InterfaceOptionsFrameCancel", "ChatConfigFrameOkayButton", "ChatConfigFrameDefaultButton", "DressUpFrameCancelButton", "DressUpFrameResetButton", "WhoFrameWhoButton", "WhoFrameAddFriendButton", "WhoFrameGroupInviteButton", "SendMailMailButton", "SendMailCancelButton", "OpenMailReplyButton", "OpenMailDeleteButton", "OpenMailCancelButton", "OpenMailReportSpamButton", "ChannelFrameNewButton", "RaidFrameRaidInfoButton", "RaidFrameConvertToRaidButton", "GearManagerDialogPopupOkay", "GearManagerDialogPopupCancel", "StackSplitOkayButton", "StackSplitCancelButton", "GameMenuButtonHelp", "GameMenuButtonWhatsNew", "GameMenuButtonStore", "GameMenuButtonOptions", "GameMenuButtonUIOptions", "GameMenuButtonKeybindings", "GameMenuButtonMacros", "GameMenuButtonAddons", "GameMenuButtonLogout", "GameMenuButtonQuit", "GameMenuButtonContinue", "GameMenuButtonMacOptions", "LFDQueueFrameFindGroupButton", "AddFriendEntryFrameAcceptButton", "AddFriendEntryFrameCancelButton", "FriendsFriendsSendRequestButton", "FriendsFriendsCloseButton", "ColorPickerOkayButton", "ColorPickerCancelButton", "GuildInviteFrameJoinButton", "GuildInviteFrameDeclineButton", "FriendsFramePendingButton1AcceptButton", "FriendsFramePendingButton1DeclineButton", "RaidInfoExtendButton", "RaidInfoCancelButton", "PaperDollEquipmentManagerPaneEquipSet", "PaperDollEquipmentManagerPaneSaveSet", "HelpFrameAccountSecurityOpenTicket", "HelpFrameCharacterStuckStuck", "HelpFrameOpenTicketHelpTopIssues", "HelpFrameOpenTicketHelpOpenTicket", "ReadyCheckFrameYesButton", "ReadyCheckFrameNoButton", "HelpFrameTicketSubmit", "HelpFrameTicketCancel", "HelpFrameKnowledgebaseSearchButton", "GhostFrame", "HelpFrameGM_ResponseNeedMoreHelp", "HelpFrameGM_ResponseCancel", "GMChatOpenLog", "HelpFrameKnowledgebaseNavBarHomeButton", "AddFriendInfoFrameContinueButton", "LFDQueueFramePartyBackfillBackfillButton", "LFDQueueFramePartyBackfillNoBackfillButton", "ChannelFrameDaughterFrameOkayButton", "ChannelFrameDaughterFrameCancelButton", "PendingListInfoFrameContinueButton", "LFDQueueFrameNoLFDWhileLFRLeaveQueueButton", "InterfaceOptionsHelpPanelResetTutorials", "RaidFinderFrameFindRaidButton", "RaidFinderQueueFrameIneligibleFrameLeaveQueueButton", "SideDressUpModelResetButton", "RaidFinderQueueFramePartyBackfillBackfillButton", "RaidFinderQueueFramePartyBackfillNoBackfillButton", "ScrollOfResurrectionSelectionFrameAcceptButton", "ScrollOfResurrectionSelectionFrameCancelButton", "ScrollOfResurrectionFrameAcceptButton", "ScrollOfResurrectionFrameCancelButton", "HelpFrameReportBugSubmit", "HelpFrameSubmitSuggestionSubmit", "ReportPlayerNameDialogReportButton", "ReportPlayerNameDialogCancelButton", "ReportCheatingDialogReportButton", "ReportCheatingDialogCancelButton", "HelpFrameOpenTicketHelpItemRestoration"}
		for i = 1, #buttons do
		local reskinbutton = _G[buttons[i]]
			if reskinbutton then
				F.Reskin(reskinbutton)
			else
				print("Aurora: "..buttons[i].." was not found.")
			end
		end

		if IsAddOnLoaded("ACP") then F.Reskin(GameMenuButtonAddOns) end

		local closebuttons = {"HelpFrameCloseButton", "RaidInfoCloseButton", "ItemRefCloseButton", "TokenFramePopupCloseButton", "ChannelFrameDaughterFrameDetailCloseButton", "RaidParentFrameCloseButton", "SideDressUpModelCloseButton"}
		for i = 1, #closebuttons do
			local closebutton = _G[closebuttons[i]]
			F.ReskinClose(closebutton)
		end

		F.ReskinClose(DressUpFrameCloseButton, "TOPRIGHT", DressUpFrame, "TOPRIGHT", -38, -16)
	end
end)


local function styleCore()
	local firstInfo = true
	hooksecurefunc(DBM.InfoFrame, "Show", function()
		if firstInfo then
			DBMInfoFrame:SetBackdrop(nil)
			local bd = CreateFrame("Frame", nil, DBMInfoFrame)
			bd:SetPoint("TOPLEFT")
			bd:SetPoint("BOTTOMRIGHT")
			bd:SetFrameLevel(DBMInfoFrame:GetFrameLevel()-1)
			F.CreateBD(bd)
			F.CreateSD(bd)
			firstInfo = false
		end
	end)

	local count = 1

	local styleBar = function()
		local bar = _G["DBM_BossHealth_Bar_"..count]

		while bar do
			if not bar.styled then
				local name = bar:GetName()
				local sb = _G[name.."Bar"]
				local text = _G[name.."BarName"]
				local timer = _G[name.."BarTimer"]

				_G[name.."BarBackground"]:Hide()
				_G[name.."BarBorder"]:SetNormalTexture("")

				sb:SetStatusBarTexture(C.media.backdrop)

				F.CreateBDFrame(sb)

				bar.styled = true
			end

			count = count + 1
			bar = _G["DBM_BossHealth_Bar_"..count]
		end
	end

	hooksecurefunc(DBM.BossHealth, "AddBoss", styleBar)
	hooksecurefunc(DBM.BossHealth, "UpdateSettings", styleBar)
--[[
	hooksecurefunc(DBM, "ShowUpdateReminder", function()


		-- no name or anything
		-- reverse loop because it's most likely to be somewhere at the end
		for i = UIParent:GetNumChildren(), 1, -1 do
			local frame = select(i, UIParent:GetChildren())

			local editBox = frame:GetChildren()
			if editBox and editBox:GetObjectType() == "EditBox" and editBox:GetText() == "http://www.deadlybossmods.com" and not frame.styled then
				F.CreateBD(frame)
		
				select(6, editBox:GetRegions()):Hide()
				select(7, editBox:GetRegions()):Hide()
				select(8, editBox:GetRegions()):Hide()

				local bg = F.CreateBDFrame(editBox, .25)
				bg:SetPoint("TOPLEFT", -2, -6)
				bg:SetPoint("BOTTOMRIGHT", 2, 8)

				F.Reskin(select(2, frame:GetChildren()))

				frame.styled = true
			end
		end
	end)
--]]	
end

local function styleGUI()
	DBM_GUI_OptionsFrameHeader:SetTexture(nil)
	DBM_GUI_OptionsFramePanelContainer:SetBackdrop(nil)
	DBM_GUI_OptionsFrameBossMods:DisableDrawLayer("BACKGROUND")
	DBM_GUI_OptionsFrameDBMOptions:DisableDrawLayer("BACKGROUND")

	for i = 1, 2 do
		_G["DBM_GUI_OptionsFrameTab"..i.."Left"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Middle"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."Right"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."LeftDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."MiddleDisabled"]:SetAlpha(0)
		_G["DBM_GUI_OptionsFrameTab"..i.."RightDisabled"]:SetAlpha(0)
	end

	local count = 1

	local function styleDBM()
		local option = _G["DBM_GUI_Option_"..count]
		while option do
			local objType = option:GetObjectType()
			if objType == "CheckButton" then
				F.ReskinCheck(option)
			elseif objType == "Slider" then
				F.ReskinSlider(option)
			elseif objType == "EditBox" then
				F.ReskinInput(option)
			elseif option:GetName():find("DropDown") then
				F.ReskinDropDown(option)
			elseif objType == "Button" then
				F.Reskin(option)
			elseif objType == "Frame" then
				option:SetBackdrop(nil)
			end

			count = count + 1
			option = _G["DBM_GUI_Option_"..count]
			if not option then
				option = _G["DBM_GUI_DropDown"..count]
			end
		end
	end

	DBM:RegisterOnGuiLoadCallback(function()
		styleDBM()
		hooksecurefunc(DBM_GUI, "UpdateModList", styleDBM)
		DBM_GUI_OptionsFrameBossMods:HookScript("OnShow", styleDBM)
	end)

	hooksecurefunc(DBM_GUI_OptionsFrame, "DisplayButton", function(button, element)
		-- bit of a hack, can't get the API to work
		local pushed = element.toggle:GetPushedTexture():GetTexture()

		if not element.styled then
			F.ReskinExpandOrCollapse(element.toggle)
			element.toggle:GetPushedTexture():SetAlpha(0)

			element.styled = true
		end

		element.toggle.plus:SetShown(pushed and pushed:find("Plus"))
	end)

	F.CreateBD(DBM_GUI_OptionsFrame)
	F.CreateSD(DBM_GUI_OptionsFrame)
	F.Reskin(DBM_GUI_OptionsFrameOkay)
	F.Reskin(DBM_GUI_OptionsFrameWebsiteButton)
	F.ReskinScroll(DBM_GUI_OptionsFramePanelContainerFOVScrollBar)
end

if IsAddOnLoaded("DBM-Core") then
	styleCore()
end

local init = CreateFrame("Frame")
init:RegisterEvent("ADDON_LOADED")
init:SetScript("OnEvent", function(self, _, addon)
	if addon == "DBM-Core" then -- in case we load it on demand
		styleCore()
	elseif addon == "DBM-GUI" then -- GUI can't load before core
		styleGUI()

		self:UnregisterEvent("ADDON_LOADED")
		init = nil
	end
end)

local function Kill(object)
	object.Show = dummy
	object:Hide()
end
local function KillTex(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				Kill(region)
			else
				region:SetTexture(nil)
			end
		end
	end		
end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	
	local b = CreateFrame("Frame", nil, f)
	b:SetPoint("TOPLEFT", -2, 2)
	b:SetPoint("BOTTOMRIGHT", 2, -2)
	F.CreateBD(b)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end
local function SkinCheckBox(frame)
	KillTex(frame)
	CreateBackdrop(frame)
	frame.backdrop:SetPoint("TOPLEFT", 4, -4)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)
	
	if frame.SetCheckedTexture then
		frame:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
	end
	
	frame:SetDisabledTexture("Interface\\Buttons\\UI-CheckBox-Check-Disabled")
end

local function SkinCloseButton(f, SetPoint)
	for i=1, f:GetNumRegions() do
		local region = select(i, f:GetRegions())
		if region:GetObjectType() == "Texture" then
			region:SetDesaturated(1)
		end
	end	
	
	if SetPoint then
		f:SetPoint("TOPRIGHT", SetPoint, "TOPRIGHT", -4, -4)
	end
end


-----------------------------------------------------------------------------------------------------------------------------------------
local WorldMapFrame = WorldMapFrame
	local BorderFrame = WorldMapFrame.BorderFrame

	WorldMapFrame.UIElementsFrame.CloseQuestPanelButton:GetRegions():Hide()
	WorldMapFrame.UIElementsFrame.OpenQuestPanelButton:GetRegions():Hide()
	BorderFrame.Bg:Hide()
	select(2, BorderFrame:GetRegions()):Hide()
	BorderFrame.portrait:SetTexture("")
	BorderFrame.portraitFrame:SetTexture("")
	for i = 5, 7 do
		select(i, BorderFrame:GetRegions()):SetAlpha(0)
	end
	BorderFrame.TopTileStreaks:SetTexture("")
	for i = 10, 14 do
		select(i, BorderFrame:GetRegions()):Hide()
	end
	BorderFrame.ButtonFrameEdge:Hide()
	BorderFrame.InsetBorderTop:Hide()
	BorderFrame.Inset.Bg:Hide()
	BorderFrame.Inset:DisableDrawLayer("BORDER")

	F.SetBD(BorderFrame, 1, 0, -3, 2)
	F.ReskinClose(BorderFrame.CloseButton)
	F.ReskinArrow(WorldMapFrame.UIElementsFrame.CloseQuestPanelButton, "left")
	F.ReskinArrow(WorldMapFrame.UIElementsFrame.OpenQuestPanelButton, "right")
	F.ReskinDropDown(WorldMapLevelDropDown)

	BorderFrame.CloseButton:SetPoint("TOPRIGHT", -9, -6)

	WorldMapLevelDropDown:SetPoint("TOPLEFT", -14, 2)

	-- [[ Size up / down buttons ]]

	for _, buttonName in pairs{"WorldMapFrameSizeUpButton", "WorldMapFrameSizeDownButton"} do
		local button = _G[buttonName]

		button:SetSize(17, 17)
		button:ClearAllPoints()
		button:SetPoint("RIGHT", BorderFrame.CloseButton, "LEFT", -1, 0)

		F.Reskin(button)

		local function colourArrow(f)
			if f:IsEnabled() then
				for _, pixel in pairs(f.pixels) do
					pixel:SetVertexColor(r, g, b)
				end
			end
		end

		local function clearArrow(f)
			for _, pixel in pairs(f.pixels) do
				pixel:SetVertexColor(1, 1, 1)
			end
		end

		button.pixels = {}

		for i = 1, 8 do
			local tex = button:CreateTexture()
			tex:SetTexture(1, 1, 1)
			tex:SetSize(1, 1)
			tex:SetPoint("BOTTOMLEFT", 3+i, 3+i)
			tinsert(button.pixels, tex)
		end

		local hline = button:CreateTexture()
		hline:SetTexture(1, 1, 1)
		hline:SetSize(7, 1)
		tinsert(button.pixels, hline)

		local vline = button:CreateTexture()
		vline:SetTexture(1, 1, 1)
		vline:SetSize(1, 7)
		tinsert(button.pixels, vline)

		if buttonName == "WorldMapFrameSizeUpButton" then
			hline:SetPoint("TOP", 1, -4)
			vline:SetPoint("RIGHT", -4, 1)
		else
			hline:SetPoint("BOTTOM", 1, 4)
			vline:SetPoint("LEFT", 4, 1)
		end

		button:SetScript("OnEnter", colourArrow)
		button:SetScript("OnLeave", clearArrow)
	end

	-- [[ Misc ]]

	WorldMapFrameTutorialButton.Ring:Hide()
	WorldMapFrameTutorialButton:SetPoint("TOPLEFT", WorldMapFrame, "TOPLEFT", -12, 12)

	do
		local topLine = WorldMapFrame.UIElementsFrame:CreateTexture()
		topLine:SetTexture(0, 0, 0)
		topLine:SetHeight(1)
		topLine:SetPoint("TOPLEFT", 0, 1)
		topLine:SetPoint("TOPRIGHT", 1, 1)

		local rightLine = WorldMapFrame.UIElementsFrame:CreateTexture()
		rightLine:SetTexture(0, 0, 0)
		rightLine:SetWidth(1)
		rightLine:SetPoint("BOTTOMRIGHT", 1, 0)
		rightLine:SetPoint("TOPRIGHT", 1, 1)
	end

	-- [[ Tracking options ]]

	local TrackingOptions = WorldMapFrame.UIElementsFrame.TrackingOptionsButton

	TrackingOptions:GetRegions():Hide()
	TrackingOptions.Background:Hide()
	TrackingOptions.IconOverlay:SetTexture("")
	TrackingOptions.Button.Border:Hide()




-----------------------------------------------------------------------------------------------------------------------------------------

-- World Map
CreateBackdrop(WorldMapFrame)
F.CreateSD(WorldMapFrame)
WorldMapDetailFrame.backdrop = CreateFrame("Frame", nil, WorldMapFrame)
F.CreateBD(WorldMapDetailFrame.backdrop)
WorldMapDetailFrame.backdrop:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -2, 2)
WorldMapDetailFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 2, -2)
WorldMapDetailFrame.backdrop:SetFrameLevel(WorldMapDetailFrame:GetFrameLevel() - 2)


SkinCloseButton(WorldMapFrameCloseButton)
SkinCloseButton(WorldMapFrameSizeDownButton)
SkinCloseButton(WorldMapFrameSizeUpButton)
									
F.ReskinDropDown(WorldMapLevelDropDown)
--Mini
local function SmallSkin()
	if InCombatLockdown() then return; end

		WorldMapFrameSizeUpButton:Show()
		WorldMapFrameSizeDownButton:Hide()	
end
--[[
	WorldMapLevelDropDown:ClearAllPoints()
	WorldMapLevelDropDown:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -17, 27)

	WorldMapFrame.backdrop:ClearAllPoints()
	WorldMapFrame.backdrop:SetPoint("TOPLEFT", 2, 2)
	WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", 2, -2)
end
--]]

			
--Large

local function LargeSkin()
	if not InCombatLockdown() then
		WorldMapFrame:SetParent(E.UIParent)
		WorldMapFrame:EnableKeyboard(false)
		WorldMapFrame:SetScale(1)
		WorldMapFrame:EnableMouse(true)
	
	if WorldMapFrame:GetAttribute('UIPanelLayout-area') ~= 'center' then
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
	end
	
	if WorldMapFrame:GetAttribute('UIPanelLayout-allowOtherPanels') ~= true then
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)	
	end

		WorldMapFrameSizeUpButton:Hide()
		WorldMapFrameSizeDownButton:Show()	

		WorldMapFrame:ClearAllPoints()
		WorldMapFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
		WorldMapFrame:SetSize(1002, 668)
end

F.CreateBD(WorldMapFrame.backdrop)
F.CreateSD(WorldMapFrame.backdrop)

local function QuestSkin()
	if not InCombatLockdown() then
		WorldMapFrame:SetParent(UIParent)
		WorldMapFrame:EnableMouse(false)
		WorldMapFrame:EnableKeyboard(false)
		SetUIPanelAttribute(WorldMapFrame, "area", "center");
		SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
	end
				
	WorldMapFrame.backdrop:ClearAllPoints()
	WorldMapFrame.backdrop:SetPoint("TOPLEFT", WorldMapDetailFrame, "TOPLEFT", -25, 70)
	WorldMapFrame.backdrop:SetPoint("BOTTOMRIGHT", WorldMapDetailFrame, "BOTTOMRIGHT", 325, -235)  
				
	if not WorldMapQuestDetailScrollFrame.backdrop then
		CreateBackdrop(WorldMapQuestDetailScrollFrame)
		WorldMapQuestDetailScrollFrame.backdrop:SetPoint("TOPLEFT", -22, 2)
		WorldMapQuestDetailScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 23, -4)
	end
				
	if not WorldMapQuestRewardScrollFrame.backdrop then
		CreateBackdrop(WorldMapQuestRewardScrollFrame)
		WorldMapQuestRewardScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 22, -4)				
	end
				
	if not WorldMapQuestScrollFrame.backdrop then
		CreateBackdrop(WorldMapQuestScrollFrame)
		WorldMapQuestScrollFrame.backdrop:SetPoint("TOPLEFT", 0, 2)
		WorldMapQuestScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 24, -3)				
	end
end			
			
local function FixSkin()
	KillTex(WorldMapFrame)
	if WORLDMAP_SETTINGS.size == WORLDMAP_FULLMAP_SIZE then
		LargeSkin()
	elseif WORLDMAP_SETTINGS.size == WORLDMAP_WINDOWED_SIZE then
		SmallSkin()
	end
	
	if not InCombatLockdown() then
		WorldMapFrame:SetScale(1)
		WorldMapFrameSizeDownButton:Show()
		WorldMapFrame:SetFrameLevel(10)
	else
		WorldMapFrameSizeDownButton:Disable()
		WorldMapFrameSizeUpButton:Disable()
	end	
				
	WorldMapFrameAreaLabel:SetFont(Qulight["media"].font, 50, "OUTLINE")
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.90, 0.8294, 0.6407)	
				
	WorldMapFrameAreaDescription:SetFont(Qulight["media"].font, 40, "OUTLINE")
	WorldMapFrameAreaDescription:SetShadowOffset(2, -2)	
				
	WorldMapZoneInfo:SetFont(Qulight["media"].font, 27, "OUTLINE")
	WorldMapZoneInfo:SetShadowOffset(2, -2)		
end
			
WorldMapFrame:HookScript("OnShow", FixSkin)
hooksecurefunc("WorldMap_ToggleSizeUp", LargeSkin)
hooksecurefunc("WorldMap_ToggleSizeDown", FixSkin)
			
WorldMapFrame:RegisterEvent("PLAYER_LOGIN")
WorldMapFrame:HookScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		if not GetCVarBool("miniWorldMap") then
			ToggleFrame(WorldMapFrame)				
			ToggleFrame(WorldMapFrame)
		end
	end
end)

local Delay = CreateFrame("Frame")
Delay:RegisterEvent("PLAYER_ENTERING_WORLD")
Delay:SetScript("OnEvent", function()
	Delay:UnregisterEvent("PLAYER_ENTERING_WORLD")

		local tooltips = {PetBattlePrimaryAbilityTooltip, PetBattlePrimaryUnitTooltip, FloatingBattlePetTooltip, BattlePetTooltip, FloatingPetBattleAbilityTooltip}
		for _, f in pairs(tooltips) do
			f:DisableDrawLayer("BACKGROUND")
			local bg = CreateFrame("Frame", nil, f)
			bg:SetAllPoints()
			bg:SetFrameLevel(0)
			F.CreateBD(bg)
		end

		PetBattlePrimaryUnitTooltip.Delimiter:SetTexture(0, 0, 0)
		PetBattlePrimaryUnitTooltip.Delimiter:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter1:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter1:SetTexture(0, 0, 0)
		PetBattlePrimaryAbilityTooltip.Delimiter2:SetHeight(1)
		PetBattlePrimaryAbilityTooltip.Delimiter2:SetTexture(0, 0, 0)
		FloatingPetBattleAbilityTooltip.Delimiter1:SetHeight(1)
		FloatingPetBattleAbilityTooltip.Delimiter1:SetTexture(0, 0, 0)
		FloatingPetBattleAbilityTooltip.Delimiter2:SetHeight(1)
		FloatingPetBattleAbilityTooltip.Delimiter2:SetTexture(0, 0, 0)
		FloatingBattlePetTooltip.Delimiter:SetTexture(0, 0, 0)
		FloatingBattlePetTooltip.Delimiter:SetHeight(1)
		F.ReskinClose(FloatingBattlePetTooltip.CloseButton)
		F.ReskinClose(FloatingPetBattleAbilityTooltip.CloseButton)
	
	local bubbleHook = CreateFrame("Frame")

		local function styleBubble(frame)
			for i = 1, frame:GetNumRegions() do
				local region = select(i, frame:GetRegions())
				if region:GetObjectType() == "Texture" then
					region:SetTexture(nil)
				end
			end

			frame:SetBackdrop({
				bgFile = C.media.backdrop,
				edgeFile = C.media.backdrop,
				edgeSize = UIParent:GetScale(),
			})
			frame:SetBackdropColor(.05,.05,.05, alpha)
			frame:SetBackdropBorderColor(0, 0, 0)
		end

		local function isChatBubble(frame)
			if frame:GetName() then return end
			if not frame:GetRegions() then return end
			return frame:GetRegions():GetTexture() == [[Interface\Tooltips\ChatBubble-Background]]
		end

		local last = 0
		local numKids = 0

		bubbleHook:SetScript("OnUpdate", function(self, elapsed)
			last = last + elapsed
			if last > .1 then
				last = 0
				local newNumKids = WorldFrame:GetNumChildren()
				if newNumKids ~= numKids then
					for i=numKids + 1, newNumKids do
						local frame = select(i, WorldFrame:GetChildren())

						if isChatBubble(frame) then
							styleBubble(frame)
						end
					end
					numKids = newNumKids
				end
			end
		end)
end)

local function StripTextures(object, kill)
	for i = 1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				Kill(region)
			else
				region:SetTexture(nil)
			end
		end
	end
end

local IconBackdrop = CreateFrame("Frame", nil, LossOfControlFrame)
CreateStyle(IconBackdrop, 2)
IconBackdrop:ClearAllPoints()
IconBackdrop:SetPoint("TOPLEFT", LossOfControlFrame.Icon, -2, 2)
IconBackdrop:SetPoint("BOTTOMRIGHT", LossOfControlFrame.Icon, 2, -2)
IconBackdrop:SetFrameLevel(LossOfControlFrame:GetFrameLevel() - 1)

StripTextures(LossOfControlFrame)
LossOfControlFrame.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
LossOfControlFrame.AbilityName:ClearAllPoints()

hooksecurefunc("LossOfControlFrame_SetUpDisplay", function(self)
	self.Icon:ClearAllPoints()
	self.Icon:SetPoint("CENTER", self, "CENTER", 0, 0)

	self.AbilityName:ClearAllPoints()
	self.AbilityName:SetPoint("BOTTOM", self, 0, -28)
	self.AbilityName.scrollTime = nil

	self.TimeLeft.NumberText:ClearAllPoints()
	self.TimeLeft.NumberText:SetPoint("BOTTOM", self, 4, -58)
	self.TimeLeft.NumberText.scrollTime = nil

	self.TimeLeft.SecondsText:ClearAllPoints()
	self.TimeLeft.SecondsText:SetPoint("BOTTOM", self, 0, -80)
	self.TimeLeft.SecondsText.scrollTime = nil

	if self.Anim:IsPlaying() then
		self.Anim:Stop()
	end
end)

----------------------------------------------------------------------------------------
--	Professions tabs on tradeskill frame(ProfessionTabs by Beoko)
----------------------------------------------------------------------------------------
local IsCurrentSpell = IsCurrentSpell
local format = string.format
local next = next
local ranks = PROFESSION_RANKS
local tabs, spells = {}, {}

local handler = CreateFrame("Frame")
handler:SetScript("OnEvent", function(self, event) self[event](self, event) end)
handler:RegisterEvent("TRADE_SKILL_SHOW")
handler:RegisterEvent("TRADE_SKILL_CLOSE")
handler:RegisterEvent("TRADE_SHOW")
handler:RegisterEvent("SKILL_LINES_CHANGED")
handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")

local defaults = {
	-- Primary Professions
	[171] = {true, false},	-- Alchemy
	[164] = {true, false},	-- Blacksmithing
	[333] = {true, true},	-- Enchanting
	[202] = {true, false},	-- Engineering
	[182] = {false, false},	-- Herbalism
	[773] = {true, true},	-- Inscription
	[755] = {true, true},	-- Jewelcrafting
	[165] = {true, false},	-- Leatherworking
	[186] = {true, false},	-- Mining
	[393] = {false, false},	-- Skinning
	[197] = {true, false},	-- Tailoring

	-- Secondary Professions
	[794] = {true, false},	-- Archaeology
	[185] = {true, true},	-- Cooking
	[129] = {true, false},	-- First Aid
	[356] = {false, false},	-- Fishing
}

if class == "DEATHKNIGHT" then spells[#spells + 1] = 53428 end	-- Runeforging
if class == "ROGUE" then spells[#spells + 1] = 1804 end			-- Pick Lock

local function UpdateSelectedTabs(object)
	if not handler:IsEventRegistered("CURRENT_SPELL_CAST_CHANGED") then
		handler:RegisterEvent("CURRENT_SPELL_CAST_CHANGED")
	end

	for index = 1, #tabs[object] do
		local tab = tabs[object][index]
		tab:SetChecked(IsCurrentSpell(tab.name))
	end
end

local function ResetTabs(object)
	for index = 1, #tabs[object] do
		tabs[object][index]:Hide()
	end

	tabs[object].index = 0
end

local function UpdateTab(object, name, rank, texture)
	local index = tabs[object].index + 1
	local tab = tabs[object][index] or CreateFrame("CheckButton", "ProTabs"..tabs[object].index, object, "SpellBookSkillLineTabTemplate SecureActionButtonTemplate")

	tab:ClearAllPoints()

	tab:SetPoint("TOPLEFT", object, "TOPRIGHT", 5, (-44 * index) + 43)

	tab:DisableDrawLayer("BACKGROUND")
	tab:SetNormalTexture(texture)
	tab:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)

	local F, C = unpack(Aurora)
	tab:SetCheckedTexture(C.media.checked)
	tab:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
	tab:GetHighlightTexture():SetAllPoints(tab:GetNormalTexture())
	F.CreateBG(tab)
	F.CreateSD(tab)

	tab:SetAttribute("type", "spell")
	tab:SetAttribute("spell", name)
	tab:Show()

	tab.name = name
	tab.tooltip = rank and rank ~= "" and format("%s (%s)", name, rank) or name

	tabs[object][index] = tabs[object][index] or tab
	tabs[object].index = tabs[object].index + 1
end

local function GetProfessionRank(currentSkill)
	if currentSkill <= 74 then
		return APPRENTICE
	end
	
	for index = #ranks, 1, -1 do
		local requiredSkill, title = ranks[index][1], ranks[index][2]

		if currentSkill >= requiredSkill then
			return title
		end
	end
end

local function HandleProfession(object, professionID)
	if professionID then
		local _, _, currentSkill, _, numAbilities, offset, skillID = GetProfessionInfo(professionID)

		if defaults[skillID] then
			for index = 1, numAbilities do
				if defaults[skillID][index] then
					local name = GetSpellBookItemName(offset + index, "profession")
					local rank = GetProfessionRank(currentSkill)
					local texture = GetSpellBookItemTexture(offset + index, "profession")

					if name and rank and texture then
						UpdateTab(object, name, rank, texture)
					end
				end
			end
		end
	end
end

local function HandleTabs(object)
	tabs[object] = tabs[object] or {}

	if InCombatLockdown() then
		handler:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		local firstProfession, secondProfession, archaeology, fishing, cooking, firstAid = GetProfessions()

		ResetTabs(object)

		HandleProfession(object, firstProfession)
		HandleProfession(object, secondProfession)
		HandleProfession(object, archaeology)
		HandleProfession(object, fishing)
		HandleProfession(object, cooking)
		HandleProfession(object, firstAid)

		for index = 1, #spells do
			if IsSpellKnown(spells[index]) then
				local name, rank, texture = GetSpellInfo(spells[index])
				UpdateTab(object, name, rank, texture)
			end
		end
	end

	UpdateSelectedTabs(object)
end

function handler:TRADE_SKILL_SHOW(event)
	local owner = ATSWFrame or MRTSkillFrame or SkilletFrame or TradeSkillFrame

	if IsAddOnLoaded("TradeSkillDW") and owner == TradeSkillFrame then
		self:UnregisterEvent(event)
	else
		HandleTabs(owner)
		self[event] = function() for object in next, tabs do UpdateSelectedTabs(object) end end
	end
end

function handler:TRADE_SKILL_CLOSE(event)
	for object in next, tabs do
		if object:IsShown() then
			UpdateSelectedTabs(object)
		end
	end
end

function handler:TRADE_SHOW(event)
	local owner = TradeFrame

	HandleTabs(owner)
	self[event] = function() UpdateSelectedTabs(owner) end
end

function handler:PLAYER_REGEN_ENABLED(event)
	self:UnregisterEvent(event)

	for object in next, tabs do HandleTabs(object) end
end

function handler:SKILL_LINES_CHANGED()
	for object in next, tabs do HandleTabs(object) end
end

function handler:CURRENT_SPELL_CAST_CHANGED(event)
	local numShown = 0

	for object in next, tabs do
		if object:IsShown() then
			numShown = numShown + 1
			UpdateSelectedTabs(object)
		end
	end

	if numShown == 0 then self:UnregisterEvent(event) end
end




----------------------------------------------------------------------------------------
--	PvP/PvE tabs on own frame(SocialTabs by Califpornia)
----------------------------------------------------------------------------------------
local hookAtLoad = {"PVEFrame", "RaidBrowserFrame"}
local SocialTabs = CreateFrame("Frame")
local TabRefArray = {}
local VisibleFrames = {}

local function HideOtherFrames(fname)
	if IsControlKeyDown() then return end
	for k, v in pairs(VisibleFrames) do
		if k ~= fname and v then
			HideUIPanel(_G[k])
		end
	end
end

local function SetTabCheckedState(fname, isChecked)
	for k, v in pairs(TabRefArray) do
		if v then TabRefArray[k][fname]:SetChecked(isChecked) end
	end
end

local function Tab_OnClick(self)
	if self.ToggleFrame == "PVPUIFrame" then
		PVP_LoadUI()
	end
	local frame = _G[self.ToggleFrame]
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		if self.ToggleFrame == "PVEFrame" then
			ToggleLFDParentFrame()
		else
			ShowUIPanel(frame)
		end
	end
end

local function SkinTab(f, t)
	f:Show()
	
		StripTextures(f)
		f:SetNormalTexture(t)
		f:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
		local F, C = unpack(Aurora)
		f:SetCheckedTexture(C.media.checked)
		F.CreateBG(f)
		F.CreateSD(f)
		f:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
		f:GetHighlightTexture():SetAllPoints(f:GetNormalTexture())
end

local function STHookFrame(fname)
	local frame = _G[fname]
	local prevtab
	local frametabs = {}

	-- PvP tab
	frametabs["PVPUIFrame"] = CreateFrame("CheckButton", "PVPSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["PVPUIFrame"], "Interface\\BattlefieldFrame\\UI-Battlefield-Icon")

	frametabs["PVPUIFrame"]:SetPoint("TOPLEFT", frame, "TOPRIGHT", 5, -35)
	
	frametabs["PVPUIFrame"].tooltip = PLAYER_V_PLAYER
	frametabs["PVPUIFrame"].ToggleFrame = "PVPUIFrame"
	frametabs["PVPUIFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["PVPUIFrame"]

	-- PvE tab
	frametabs["PVEFrame"] = CreateFrame("CheckButton", "LFDSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["PVEFrame"], "Interface\\Icons\\INV_Helmet_08")
	frametabs["PVEFrame"]:SetPoint("TOPLEFT", prevtab, "BOTTOMLEFT", 0, -15)
	frametabs["PVEFrame"].tooltip = LOOKING_FOR_DUNGEON
	frametabs["PVEFrame"].ToggleFrame = "PVEFrame"
	frametabs["PVEFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["PVEFrame"]

	-- Raid Browser tab
	frametabs["RaidBrowserFrame"] = CreateFrame("CheckButton", "LFRSideTab", frame, "SpellBookSkillLineTabTemplate")
	SkinTab(frametabs["RaidBrowserFrame"], "Interface\\LFGFrame\\UI-LFR-PORTRAIT")
	frametabs["RaidBrowserFrame"]:SetPoint("TOPLEFT", prevtab, "BOTTOMLEFT", 0, -15)
	frametabs["RaidBrowserFrame"].tooltip = LOOKING_FOR_RAID
	frametabs["RaidBrowserFrame"].ToggleFrame = "RaidBrowserFrame"
	frametabs["RaidBrowserFrame"]:SetScript("OnClick", Tab_OnClick)
	prevtab = frametabs["RaidBrowserFrame"]

	if fname == "RaidBrowserFrame" then
		LFRParentFrameSideTab1:SetPoint("TOPLEFT", frametabs["PVEFrame"], "BOTTOMLEFT", 0, -15)
	end

	TabRefArray[fname] = frametabs

	frame:HookScript("OnShow", function()
		HideOtherFrames(fname)
		VisibleFrames[fname] = true
		SetTabCheckedState(fname, true)
	end)

	frame:HookScript("OnHide", function()
		VisibleFrames[fname] = false
		SetTabCheckedState(fname, false)
	end)
end
end