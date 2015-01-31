if not Skada or not Qulight["addonskins"].Skada == true then return end

local function CreateBackdrop(f, t, tex)
	if f.backdrop then return end
	
	local b = CreateFrame("Frame", nil, f)
	b:SetPoint("TOPLEFT", -2, 2)
	b:SetPoint("BOTTOMRIGHT", 2, -2)
	CreateStyle(b, 2)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end

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

local Skada = Skada
local barSpacing = 1, 1
local borderWidth = 2, 2

local barmod = Skada.displays["bar"]

local titleBG = {
	bgFile = Qulight["media"].texture,
	tile = false,
	tileSize = 0
}

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
	barmod.ApplySettings_(self, win)
	
	local skada = win.bargroup

	if win.db.enabletitle then
		skada.button:SetBackdrop(titleBG)
		skada.button:SetBackdropColor(.05,.05,.05, .9)
	end

	skada:SetTexture(Qulight["media"].texture)
	skada:SetSpacing(barSpacing)
	skada:SetFont(Qulight["media"].font, 10)
	skada:SetFrameLevel(5)
	
	skada:SetBackdrop(nil)
	if not skada.backdrop then
		CreateBackdrop(skada)
		skada.backdrop:ClearAllPoints()
		skada.backdrop:SetPoint('TOPLEFT', win.bargroup.button or win.bargroup, 'TOPLEFT', -2, 2)
		skada.backdrop:SetPoint('BOTTOMRIGHT', win.bargroup, 'BOTTOMRIGHT', 2, -2)
	end
	
	hooksecurefunc(Skada, "OpenReportWindow", function(self)
		if not self.ReportWindow.frame.reskinned then
			StripTextures(self.ReportWindow.frame)
			CreateStyle(self.ReportWindow.frame, 2)
			self.ReportWindow.frame.reskinned = true
		end
	end)
end

for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end
