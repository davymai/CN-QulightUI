if Qulight["datatext"].classcolor == true then
	local classcolor = RAID_CLASS_COLORS[myclass]
	Qulight["datatext"].color = {classcolor.r,classcolor.g,classcolor.b,1}
end

LeftDatatexts = {}
function PP(p, obj)
	if p == 1 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("LEFT", DataLeftPanel, "LEFT", 10, 0)
	elseif p == 2 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("CENTER", DataLeftPanel, "CENTER", -40, 0)
	elseif p == 3 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataLeftPanel, "RIGHT", -110, 0)
	elseif p == 4 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataLeftPanel,"RIGHT", -10, 0)
	elseif p == 5 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("LEFT", DataRightPanel,"LEFT", 10, 0)
	elseif p == 6 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("CENTER", DataRightPanel,"CENTER", -40, 0)
	elseif p == 7 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataRightPanel,"RIGHT", -90, 0)
	elseif p == 8 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("RIGHT", DataRightPanel,"RIGHT", -10, 0)
	elseif p == 9 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 10, -20)
	elseif p == 10 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 100, -20)
	elseif p == 11 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 190, -20)
	elseif p == 12 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 260, -20)
	elseif p == 13 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 350, -20)
	elseif p == 14 then
		obj:SetHeight(DataLeftPanel:GetHeight())
		obj:SetPoint("BOTTOMLEFT", DataLeftPanel,"BOTTOMLEFT", 440, -20)
	end
end