if not Qulight["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local bar = QuBar2
MultiBarBottomLeft:SetParent(bar)

-- setup the bar
for i=1, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton"..i-1]
	b:RegisterForClicks("LeftButtonDown", "RightButtonUp")
	b:SetSize(buttonsize, buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, buttonspacing, -buttonspacing)
	else
		b:SetPoint("LEFT", b2, "RIGHT", buttonspacing, 0)
	end
end

for i=7, 12 do
	local b = _G["MultiBarBottomLeftButton"..i]
	local b2 = _G["MultiBarBottomLeftButton1"]
	b:SetFrameLevel(b2:GetFrameLevel() - 2)
end


