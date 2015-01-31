
if not Qulight["actionbar"].enable == true then return end

local bar = QuBar7
bar:SetAlpha(1)
MultiBarBottomRight:SetParent(bar)

for i= 1, 12 do
	local b = _G["MultiBarBottomRightButton"..i]
	local b2 = _G["MultiBarBottomRightButton"..i-1]
	b:RegisterForClicks("LeftButtonDown", "RightButtonUp")
	b:SetSize(buttonsize, buttonsize)
	b:ClearAllPoints()
	b:SetFrameStrata("BACKGROUND")
	b:SetFrameLevel(15)
	--[[默认设置
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, buttonspacing,-buttonspacing)
	else
		b:SetPoint("LEFT", b2, "RIGHT", buttonspacing, 0)
	end
	]]
	if i == 1 then
		b:SetPoint("TOPLEFT", bar, buttonspacing,-buttonspacing)
	elseif i == 7 then
		b:SetPoint("TOPLEFT", "MultiBarBottomRightButton1", "BOTTOMLEFT", 0, -buttonspacing)
	else
		b:SetPoint("LEFT", b2, "RIGHT", buttonspacing, 0)
	end
end
