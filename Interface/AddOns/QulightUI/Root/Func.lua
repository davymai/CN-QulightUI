function UIScale()
	if Qulight["general"].AutoScale == true then
	Qulight["general"].UiScale = min(2, max(.64, 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")))
	end
end
UIScale()

local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/Qulight["general"].UiScale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end
function Scale(x) return scale(x) end
mult = mult

frames = {}

classcolours = {
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

local _, class = UnitClass("player")

if CUSTOM_CLASS_COLORS then
	classcolours = CUSTOM_CLASS_COLORS
end

local r, g, b = classcolours[class].r, classcolours[class].g, classcolours[class].b


CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = Qulight["media"].texture,
		edgeFile = Qulight["media"].texture,
		edgeSize = 1,
	})
	f:SetBackdropColor(.05,.05,.05, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(frames, f) end
end

CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(useButtonGradientColour and "Interface\\Addons\\QulightUI\\Root\\Media\\gradient" or Qulight["media"].texture)
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

Reskin = function(f, noHighlight)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	CreateBD(f, .0)

	f.tex = CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", colourButton)
 		f:HookScript("OnLeave", clearButton)
	end
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

ReskinClose = function(f, a1, p, a2, x, y)
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

	CreateBD(f, 0)

	CreateGradient(f)

	f:SetDisabledTexture(Qulight["media"].texture)
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

function CreatePanel(f, w, h, a1, p, a2, x, y)
	local _, class = UnitClass("player")
	local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
      edgeFile = "Interface\\Buttons\\WHITE8x8", 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	f:SetBackdropColor(.05,.05,.05,0)
	f:SetBackdropBorderColor(.15,.15,.15,0)
end
function SimpleBackground(f, w, h, a1, p, a2, x, y)
	local _, class = UnitClass("player")
	local r, g, b = RAID_CLASS_COLORS[class].r, RAID_CLASS_COLORS[class].g, RAID_CLASS_COLORS[class].b
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetBackdrop({
	  bgFile = Qulight["media"].texture,
      edgeFile = Qulight["media"].texture, 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = mult, right = mult, top = mult, bottom = mult}
	})
	f:SetBackdropColor(.07,.07,.07, 1)
	f:SetBackdropBorderColor(0, 0, 0, 1)
end
local style = {
	bgFile =  Qulight["media"].texture,
	edgeFile = Qulight["media"].glow, 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}
function CreateStyle(f, size, level, alpha, alphaborder) 
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(level or 0)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -size, size)
	shadow:SetPoint("BOTTOMRIGHT", size, -size)
	shadow:SetBackdrop(style)
	shadow:SetBackdropColor(.08,.08,.08, alpha or .9)
	shadow:SetBackdropBorderColor(0, 0, 0, alphaborder or 1)
	f.shadow = shadow
	return shadow
end
function frame1px(f)
	f:SetBackdrop({
		bgFile =  [=[Interface\ChatFrame\ChatFrameBackground]=],
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = mult, 
		insets = {left = -mult, right = -mult, top = -mult, bottom = -mult} 
	})
	f:SetBackdropColor(.05,.05,.05,0)
	f:SetBackdropBorderColor(.15,.15,.15,0)	
end

SetModifiedBackdrop = function(self)
	if self:GetButtonState() == "DISABLED" then return end
	self:SetBackdropBorderColor(.05,.05,.05,0)
	if self.overlay then
		self.overlay:SetVertexColor(0, 0, 0, .4)
	end
end

SetOriginalBackdrop = function(self)
	if self:GetButtonState() == "DISABLED" then return end
	self:SetBackdropBorderColor(.05,.05,.05,0)
	if self.overlay then
		self.overlay:SetVertexColor(0, 0, 0, .4)
	end
end