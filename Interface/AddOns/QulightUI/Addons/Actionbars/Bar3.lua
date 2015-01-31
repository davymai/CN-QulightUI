if not Qulight["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomRight as bar #3 
---------------------------------------------------------------------------

local bar = QuBar3
MultiBarBottomRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
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