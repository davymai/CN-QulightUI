----------------- > Cloak / Helm toggle check boxes at PaperDollFrame

local GameTooltip = GameTooltip
local helmcb = CreateFrame("CheckButton", nil, PaperDollFrame)
helmcb:ClearAllPoints()
helmcb:SetSize(32,32)
helmcb:SetFrameLevel(10)
helmcb:SetPoint("TOPLEFT", CharacterHeadSlot, "BOTTOMRIGHT", 9, 0)
helmcb:SetScript("OnClick", function() ShowHelm(not ShowingHelm()) end)
helmcb:SetScript("OnEnter", function(self)
 	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggle helm")
end)
helmcb:SetScript("OnLeave", function() GameTooltip:Hide() end)
helmcb:SetScript("OnEvent", function() helmcb:SetChecked(ShowingHelm()) end)
helmcb:SetNormalTexture("Interface\\AddOns\\Zmini\\textureHead")
helmcb:SetPushedTexture("Interface\\AddOns\\Zmini\\textureCloak")
helmcb:SetHighlightTexture("Interface\\AddOns\\Zmini\\textureHighlight")
helmcb:SetDisabledCheckedTexture("Interface\\AddOns\\Zmini\\textureHead")
helmcb:SetCheckedTexture("Interface\\AddOns\\Zmini\\textureCloak")
helmcb:RegisterEvent("UNIT_MODEL_CHANGED")

local cloakcb = CreateFrame("CheckButton", nil, PaperDollFrame)
cloakcb:ClearAllPoints()
cloakcb:SetSize(32,32)
cloakcb:SetFrameLevel(10)
cloakcb:SetPoint("TOPLEFT", CharacterBackSlot, "BOTTOMRIGHT", 9, 0)
cloakcb:SetScript("OnClick", function() ShowCloak(not ShowingCloak()) end)
cloakcb:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetText("Toggle cloak")
end)
cloakcb:SetScript("OnLeave", function() GameTooltip:Hide() end)
cloakcb:SetScript("OnEvent", function() cloakcb:SetChecked(ShowingCloak()) end)
cloakcb:SetNormalTexture("Interface\\AddOns\\Zmini\\textureHead")
cloakcb:SetPushedTexture("Interface\\AddOns\\Zmini\\textureCloak")
cloakcb:SetHighlightTexture("Interface\\AddOns\\Zmini\\textureHighlight")
cloakcb:SetDisabledCheckedTexture("Interface\\AddOns\\Zmini\\textureHead")
cloakcb:SetCheckedTexture("Interface\\AddOns\\Zmini\\textureCloak")
cloakcb:RegisterEvent("UNIT_MODEL_CHANGED")

helmcb:SetChecked(ShowingHelm())
cloakcb:SetChecked(ShowingCloak())