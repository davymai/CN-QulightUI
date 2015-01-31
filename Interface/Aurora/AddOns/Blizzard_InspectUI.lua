local F, C = unpack(select(2, ...))

C.modules["Blizzard_InspectUI"] = function()
		InspectModelFrame:DisableDrawLayer("OVERLAY")

		InspectTalentFrame:GetRegions():Hide()
		select(2, InspectTalentFrame:GetRegions()):Hide()
		InspectGuildFrameBG:Hide()
		for i = 1, 5 do
			select(i, InspectModelFrame:GetRegions()):Hide()
		end

		-- Character

		select(10, InspectMainHandSlot:GetRegions()):Hide()

		local slots = {
			"Head", "Neck", "Shoulder", "Shirt", "Chest", "Waist", "Legs", "Feet", "Wrist",
			"Hands", "Finger0", "Finger1", "Trinket0", "Trinket1", "Back", "MainHand",
			"SecondaryHand", "Tabard",
		}

		for i = 1, #slots do
			local slot = _G["Inspect"..slots[i].."Slot"]
			local border = slot.IconBorder

			_G["Inspect"..slots[i].."SlotFrame"]:Hide()

			slot:SetNormalTexture("")
			slot:SetPushedTexture("")

			border:SetTexture(C.media.backdrop)
			border:SetPoint("TOPLEFT", -1, 1)
			border:SetPoint("BOTTOMRIGHT", 1, -1)
			border:SetDrawLayer("BACKGROUND")

			slot.icon:SetTexCoord(.08, .92, .08, .92)
		end

		hooksecurefunc("InspectPaperDollItemSlotButton_Update", function(button)
		button.icon:SetShown(button.hasItem)
		end)


		-- PvP

		InspectPVPFrame.BG:Hide()

		for i = 1, 3 do
			local div = InspectPVPFrame["Div"..i]

			div:SetTexture(1, 1, 1, .2)
			div:SetHeight(1)
		end

		-- Talents

		local inspectSpec = InspectTalentFrame.InspectSpec

		inspectSpec.ring:Hide()

		for i = 1, 7 do
			local row = InspectTalentFrame.InspectTalents["tier"..i]
			for j = 1, 3 do
				local bu = row["talent"..j]

				bu.Slot:Hide()
				bu.border:SetTexture("")

				bu.icon:SetDrawLayer("ARTWORK")
				bu.icon:SetTexCoord(.08, .92, .08, .92)

				F.CreateBG(bu.icon)
			end
		end

		inspectSpec.specIcon:SetTexCoord(.08, .92, .08, .92)
		F.CreateBG(inspectSpec.specIcon)

		local function updateIcon(self)
			local spec = nil
			if INSPECTED_UNIT ~= nil then
				spec = GetInspectSpecialization(INSPECTED_UNIT)
			end
			if spec ~= nil and spec > 0 then
				local role1 = GetSpecializationRoleByID(spec)
				if role1 ~= nil then
					local _, _, _, icon = GetSpecializationInfoByID(spec)
					self.specIcon:SetTexture(icon)
				end
			end
		end

		inspectSpec:HookScript("OnShow", updateIcon)
		InspectTalentFrame:HookScript("OnEvent", function(self, event, unit)
			if not InspectFrame:IsShown() then return end
			if event == "INSPECT_READY" and InspectFrame.unit and UnitGUID(InspectFrame.unit) == unit then
				updateIcon(self.InspectSpec)
			end
		end)

		local roleIcon = inspectSpec.roleIcon

		roleIcon:SetTexture(C.media.roleIcons)

		do
			local left = inspectSpec:CreateTexture(nil, "OVERLAY")
			left:SetWidth(1)
			left:SetTexture(C.media.backdrop)
			left:SetVertexColor(0, 0, 0)
			left:SetPoint("TOPLEFT", roleIcon, 2, -2)
			left:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)

			local right = inspectSpec:CreateTexture(nil, "OVERLAY")
			right:SetWidth(1)
			right:SetTexture(C.media.backdrop)
			right:SetVertexColor(0, 0, 0)
			right:SetPoint("TOPRIGHT", roleIcon, -2, -2)
			right:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)

			local top = inspectSpec:CreateTexture(nil, "OVERLAY")
			top:SetHeight(1)
			top:SetTexture(C.media.backdrop)
			top:SetVertexColor(0, 0, 0)
			top:SetPoint("TOPLEFT", roleIcon, 2, -2)
			top:SetPoint("TOPRIGHT", roleIcon, -2, -2)

			local bottom = inspectSpec:CreateTexture(nil, "OVERLAY")
			bottom:SetHeight(1)
			bottom:SetTexture(C.media.backdrop)
			bottom:SetVertexColor(0, 0, 0)
			bottom:SetPoint("BOTTOMLEFT", roleIcon, 2, 2)
			bottom:SetPoint("BOTTOMRIGHT", roleIcon, -2, 2)
		end

		local function updateGlyph(self, clear)
			local id = self:GetID()
			local talentGroup = PlayerTalentFrame and PlayerTalentFrame.talentGroup
			local enabled, glyphType, glyphTooltipIndex, glyphSpell, iconFilename = GetGlyphSocketInfo(id, talentGroup, true, INSPECTED_UNIT);

			if not glyphType then return end

			if enabled and glyphSpell and not clear then
				if iconFilename then
					self.glyph:SetTexture(iconFilename)
				else
					self.glyph:SetTexture("Interface\\Spellbook\\UI-Glyph-Rune1")
				end
			end
		end

		hooksecurefunc("InspectGlyphFrameGlyph_UpdateSlot", updateGlyph)

		for i = 1, 6 do
			local glyph = InspectTalentFrame.InspectGlyphs["Glyph"..i]

			glyph:HookScript("OnShow", updateGlyph)

			glyph.ring:Hide()

			glyph.glyph:SetDrawLayer("ARTWORK")
			glyph.glyph:SetTexCoord(.08, .92, .08, .92)
			F.CreateBDFrame(glyph.glyph, .25)
		end

		for i = 1, 4 do
			local tab = _G["InspectFrameTab"..i]
			F.ReskinTab(tab)
			if i ~= 1 then
				tab:SetPoint("LEFT", _G["InspectFrameTab"..i-1], "RIGHT", -15, 0)
			end
		end

		F.ReskinPortraitFrame(InspectFrame, true)
end

----------------------------------------------------------------------------------------
--	Item level on slot buttons in Character/InspectFrame 		
----------------------------------------------------------------------------------------
local time = 3
local slots = {
	"HeadSlot", "NeckSlot", "ShoulderSlot", "BackSlot", "ChestSlot", "ShirtSlot", "TabardSlot",
	"WristSlot", "MainHandSlot", "SecondaryHandSlot", "HandsSlot", "WaistSlot",
	"LegsSlot", "FeetSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot"
}

local upgrades = {
	["1"] = 8, ["373"] = 4, ["374"] = 8, ["375"] = 4, ["376"] = 4, ["377"] = 4,
	["379"] = 4, ["380"] = 4, ["446"] = 4, ["447"] = 8, ["452"] = 8, ["454"] = 4,
	["455"] = 8, ["457"] = 8, ["459"] = 4, ["460"] = 8, ["461"] = 12, ["462"] = 16,
	["466"] = 4, ["467"] = 8, ["469"] = 4, ["470"] = 8, ["471"] = 12, ["472"] = 16,
	["477"] = 4, ["478"] = 8, ["480"] = 8, ["492"] = 4, ["493"] = 8, ["495"] = 4,
	["496"] = 8, ["497"] = 12, ["498"] = 16, ["504"] = 12, ["505"] = 16, ["506"] = 20,
	["507"] = 24
}

local function CreateButtonsText(frame)
	for _, slot in pairs(slots) do
		local button = _G[frame..slot]
		button.t = button:CreateFontString(nil, "OVERLAY", "SystemFont_Outline_Small")
		button.t:SetFont(Qulight["media"].font, 9, "OUTLINE")
		button.t:SetPoint("TOP", button, "TOP", 0, -2)
		button.t:SetText("")
	end
end

local function UpdateButtonsText(frame)
	if frame == "Inspect" and not InspectFrame:IsShown() then return end

	for _, slot in pairs(slots) do
		local id = GetInventorySlotInfo(slot)
		local item
		local text = _G[frame..slot].t

		if frame == "Inspect" then
			item = GetInventoryItemLink("target", id)
		else
			item = GetInventoryItemLink("player", id)
		end

		if slot == "ShirtSlot" or slot == "TabardSlot" then
			text:SetText("")
		elseif item then
			local oldilevel = text:GetText()
			local _, _, heirloom, ilevel = GetItemInfo(item)
			local upgrade = item:match("item:%d+:%d+:%d+:%d+:%d+:%d+:%-?%d+:%-?%d+:%d+:(%d+)")

			if ilevel then
				if ilevel ~= oldilevel then
					if heirloom == 7 then
						text:SetText("")
					else
						if upgrades[upgrade] == nil then upgrades[upgrade] = 0 end
						if upgrades[upgrade] > 0 then
							text:SetText("|cffffd200"..ilevel + upgrades[upgrade])
						else
							text:SetText("|cFFFFFF00"..ilevel + upgrades[upgrade])
						end
					end
				end
			else
				text:SetText("")
			end
		else
			text:SetText("")
		end
	end
end

local OnEvent = CreateFrame("Frame")
OnEvent:RegisterEvent("PLAYER_LOGIN")
OnEvent:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
OnEvent:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_LOGIN" then
		CreateButtonsText("Character")
		UpdateButtonsText("Character")
		self:UnregisterEvent("PLAYER_LOGIN")
	elseif event == "PLAYER_TARGET_CHANGED" or event == "INSPECT_READY" then
		UpdateButtonsText("Inspect")
	else
		UpdateButtonsText("Character")
	end
end)
OnEvent:SetScript("OnUpdate", function(self, elapsed)
	time = time + elapsed
	if time >= 3 then
		if InspectFrame and InspectFrame:IsShown() then
			UpdateButtonsText("Inspect")
		else
			UpdateButtonsText("Character")
		end
	end
end)

local OnLoad = CreateFrame("Frame")
OnLoad:RegisterEvent("ADDON_LOADED")
OnLoad:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		CreateButtonsText("Inspect")
		InspectFrame:HookScript("OnShow", function(self) UpdateButtonsText("Inspect") end)
		OnEvent:RegisterEvent("PLAYER_TARGET_CHANGED")
		OnEvent:RegisterEvent("INSPECT_READY")
		self:UnregisterEvent("ADDON_LOADED")
	end
end)