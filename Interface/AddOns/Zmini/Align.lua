local blank = {bgFile="interface\\buttons\\white8x8"}
local index = GetCurrentResolution()
local resolution = select(index, GetScreenResolutions())
local x,y = strsplit("x", resolution)
local sWidth, sHeight, space;
local linesR = {}
local linesL = {}
local linesT = {}
local linesB = {}
r1 = CreateFrame("Frame","AlignY",UIParent)
r1:SetBackdrop(blank)
r1:SetBackdropColor(1,0,0,1)
--r1:SetSize(2,y)
r1:SetWidth(2);
r1:SetPoint("TOP",UIParent);
r1:SetPoint("BOTTOM",UIParent);
--r1:SetPoint("CENTER",UIParent)
table.insert(linesR,r1)
table.insert(linesL,r1)
local r2 = CreateFrame("Frame","AlignX",r1)
r2:SetBackdrop(blank)
r2:SetBackdropColor(1,0,0,1)
--r2:SetSize(x,2)
r2:SetHeight(2);
r2:SetPoint("LEFT",UIParent);
r2:SetPoint("RIGHT",UIParent);
--r2:SetPoint("CENTER",UIParent)
table.insert(linesT,r2)
table.insert(linesB,r2)
r1:Hide()
function lineUpdate(space)
	sWidth = UIParent:GetWidth();
	sHeight = UIParent:GetHeight();
	local numLinesX = (sWidth/space)
	for k,v in pairs(linesR) do
		if not v:GetName() then
			v:Hide();
		end
	end
	for k,v in pairs(linesL) do
		if not v:GetName() then
			v:Hide();
		end
	end
	for k,v in pairs(linesT) do
		if not v:GetName() then
			v:Hide();
		end
	end
	for k,v in pairs(linesB) do
		if not v:GetName() then
			v:Hide();
		end
	end
	for i = 1,numLinesX do
		if not (linesR[i]) then
			local lR = r1:CreateTexture(nil,"OVERLAY")
			lR:SetWidth(1);
			lR:SetTexture(0,0,0,0.5)
			lR:SetPoint("TOP",UIParent,"TOP",space*(i-1),0);
			lR:SetPoint("BOTTOM",UIParent,"BOTTOM",space*(i-1),0);
			table.insert(linesR, lR)
		else
			if (i~=1) then
				linesR[i]:SetPoint("TOP",UIParent,"TOP",space*(i-1),0);
				linesR[i]:SetPoint("BOTTOM",UIParent,"BOTTOM",space*(i-1),0);
				linesR[i]:Show();
			end
		end
		if not (linesL[i]) then
			local lL = r1:CreateTexture(nil,"OVERLAY")
			lL:SetWidth(1);
			lL:SetTexture(0,0,0,0.5)
			lL:SetPoint("TOP",UIParent,"TOP",-space*(i-1),0);
			lL:SetPoint("BOTTOM",UIParent,"BOTTOM",-space*(i-1),0);
			table.insert(linesL, lL)
		else
			if (i~=1) then
				linesL[i]:SetPoint("TOP",UIParent,"TOP",-space*(i-1),0);
				linesL[i]:SetPoint("BOTTOM",UIParent,"BOTTOM",-space*(i-1),0);
				linesL[i]:Show();
			end
		end
	end
	local numLinesY = (sHeight/space)
	for j = 1,numLinesY do
		if not (linesT[j]) then
			local lT = r2:CreateTexture(nil,"OVERLAY")
			lT:SetHeight(1);
			lT:SetTexture(0,0,0,0.5)
			lT:SetPoint("LEFT",UIParent,"LEFT",0,space*(j-1));
			lT:SetPoint("RIGHT",UIParent,"RIGHT",0,space*(j-1));
			table.insert(linesT, lT)
		else
			if (j~=1) then
				linesT[j]:SetPoint("LEFT",UIParent,"LEFT",0,space*(j-1));
				linesT[j]:SetPoint("RIGHT",UIParent,"RIGHT",0,space*(j-1));
				linesT[j]:Show();
			end
		end
		if not (linesB[j]) then
			local lB = r2:CreateTexture(nil,"OVERLAY")
			lB:SetHeight(1);
			lB:SetTexture(0,0,0,0.5)
			lB:SetPoint("LEFT",UIParent,"LEFT",0,-space*(j-1));
			lB:SetPoint("RIGHT",UIParent,"RIGHT",0,-space*(j-1));
			table.insert(linesB, lB)
		else
			if (j~=1) then
				linesB[j]:SetPoint("LEFT",UIParent,"LEFT",0,-space*(j-1));
				linesB[j]:SetPoint("RIGHT",UIParent,"RIGHT",0,-space*(j-1));
				linesB[j]:Show();
			end
		end
	end
end
lineUpdate(20)
SLASH_Align1 = '/Align'
SLASH_Align2 = '/align'
SLASH_Align3 = '/wal'
function SlashCmdList.Align(msg, editbox)
	if (msg) and (type(tonumber(msg))=="number") then
		if (tonumber(msg)<=4) then 
			print("|cffe1a500w|cff69ccf0Align|r: Please enter a number at least 5 or larger.")
		else
			if not (r1:IsShown()) then
				r1:Show()
			end
			lineUpdate(tonumber(msg))
		end
	else
		if not(r1:IsShown()) then
			r1:Show()
		else
			r1:Hide()
		end
	end
end