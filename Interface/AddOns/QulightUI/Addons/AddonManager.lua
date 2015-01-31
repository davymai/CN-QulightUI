if not Qulight["misk"].addonmanager == true then return end
local F, C = unpack(select(2, ...))
local loadf = CreateFrame("frame", "aLoadFrame", UIParent)
loadf:SetWidth(300)
loadf:SetHeight(450)
loadf:SetPoint("CENTER")
loadf:EnableMouse(true)
loadf:SetMovable(true)
loadf:SetUserPlaced(true)
loadf:SetClampedToScreen(true)
loadf:SetScript("OnMouseDown", function(self) self:StartMoving() end)
loadf:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
loadf:SetFrameStrata("DIALOG")
tinsert(UISpecialFrames, "aLoadFrame")


local RLButton = function(text,parent)
	local result = CreateFrame("Button", "btn_"..parent:GetName(), parent, "UIPanelButtonTemplate")
	result:SetText(text)
	return result
end

local CloseButton = function(text,parent)
	local result = CreateFrame("Button", "btn2_"..parent:GetName(), parent, "UIPanelButtonTemplate")
	result:SetText(text)
	return result
end

loadf:Hide()
loadf:SetScript("OnHide", function(self) end)

loadf:SetResizable(true)
local resize = CreateFrame("button", "resizebut", loadf)
loadf:SetBackdropColor(.05,.05,.05,0)
CreateStyle(loadf, 2)
loadf:SetMinResize(264, 400)
loadf:SetMaxResize(800, 800)
resize:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -6, 6)
resize:SetWidth(13)
resize:SetHeight(13)
resize:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Up")
resize:SetHighlightTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Highlight")
resize:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIM-SizeGrabber-Down")

resize:SetScript("OnMouseDown", function(self)   
   loadf:StartSizing()
end)

resize:SetScript("OnMouseUp", function(self)
   loadf:StopMovingOrSizing()
end)

local title = loadf:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("TOPLEFT", 10, -8)
title:SetText(qColor.."AddOn Manager")

local scrollf = CreateFrame("ScrollFrame", "aload_Scroll", loadf, "UIPanelScrollFrameTemplate")
local mainf = CreateFrame("frame", "aloadmainf", scrollf)

F.ReskinScroll(aload_ScrollScrollBar)

scrollf:SetPoint("TOPLEFT", loadf, "TOPLEFT", 10, -30)
scrollf:SetPoint("BOTTOMRIGHT", loadf, "BOTTOMRIGHT", -28, 40)
scrollf:SetScrollChild(mainf)

local reloadb = RLButton(SAVE, loadf)
reloadb:SetWidth(105)
reloadb:SetHeight(20)
reloadb:SetPoint("BOTTOMRIGHT", loadf, "BOTTOM", -2, 9)
reloadb:SetScript("OnClick", function() ReloadUI() end)

local closeb = CloseButton(CLOSE, loadf)
closeb:SetWidth(105)
closeb:SetHeight(20)
closeb:SetPoint("TOPLEFT" , reloadb, "TOPRIGHT", 4, 0)
closeb:SetScript("OnClick", function() loadf:Hide() end)

local makeList = function()
	local self = mainf
	F.CreateBD(scrollf, 0)
    self:SetPoint("TOPLEFT")
    self:SetWidth(scrollf:GetWidth())
    self:SetHeight(scrollf:GetHeight())
	self.addons = {}
	for i=1, GetNumAddOns() do
		self.addons[i] = select(1, GetAddOnInfo(i))
	end
	table.sort(self.addons)

	local oldb

	for i,v in pairs(self.addons) do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(v)

		if name then
			local bf = _G[v.."_cbf"] or CreateFrame("CheckButton", v.."_cbf", self, "OptionsCheckButtonTemplate")
			bf:EnableMouse(true)
			bf.title = title.."|n"
			if notes then bf.title = bf.title.."|cffffffff"..notes.."|r|n" end
			if (GetAddOnDependencies(v)) then
				bf.title = "|cffff4400Dependencies: |r"
				for i=1, select("#", GetAddOnDependencies(v)) do
					bf.title = bf.title..select(i,GetAddOnDependencies(v))
					if (i>1) then bf.title=bf.title..", " end
				end
				bf.title = bf.title.."|r"
			end
				
			if i==1 then
				bf:SetPoint("TOPLEFT",self, "TOPLEFT", 10, -10)
			else
				bf:SetPoint("TOP", oldb, "BOTTOM", 0, 6)
			end
	
			bf:SetScript("OnEnter", function(self)
				GameTooltip:ClearLines()
				GameTooltip:SetOwner(self, ANCHOR_TOPRIGHT)
				GameTooltip:AddLine(self.title)
				GameTooltip:Show()
			end)
			
			bf:SetScript("OnLeave", function(self)
				GameTooltip:Hide()
			end)
			
			bf:SetScript("OnClick", function()
				local _, _, _, enabled = GetAddOnInfo(name)
				if enabled then
					DisableAddOn(name)
				else
					EnableAddOn(name)
				end
			end)
			bf:SetChecked(enabled)
			
			_G[v.."_cbfText"]:SetText(title) 
			F.ReskinCheck(bf)
			oldb = bf
		end
	end
end

makeList()

-- Slash command
SLASH_ALOAD1 = "/aload"
SLASH_ALOAD2 = "/פהשפג"
SlashCmdList.ALOAD = function(msg)
   loadf:Show()
end

local showb = CreateFrame("Button", "GameMenuButtonAddonManager", GameMenuFrame, "GameMenuButtonTemplate")
showb:SetText(ADDONS)
showb:SetPoint("TOP", "GameMenuFrame", "TOP", 0, -47)

GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + showb:GetHeight())
GameMenuButtonUIOptions:SetPoint("TOP", showb, "BOTTOM", 0, -1)

GameMenuButtonHelp:ClearAllPoints()
GameMenuButtonHelp:SetPoint("TOP", "GameMenuFrame", "TOP", 0, -69)
	
GameMenuButtonStore:ClearAllPoints()
GameMenuButtonStore:SetPoint("TOP", "GameMenuFrame", "TOP", 0, -91)
	
GameMenuButtonContinue:ClearAllPoints()
	
showb:SetScript("OnClick", function()
	HideUIPanel(GameMenuFrame)
	loadf:Show()
end)