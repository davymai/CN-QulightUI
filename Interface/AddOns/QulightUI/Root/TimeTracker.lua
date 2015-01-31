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
	CreateShadow(bar.backdrop)
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
load:SetScript("OnEvent", SkinBlizzTimer)