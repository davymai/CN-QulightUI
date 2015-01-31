if not Qulight["loot"].lootframe == true then return end

local L = {
	fish = "Fishy loot",
	empty = "Empty slot",
}
local addon = CreateFrame("Button", "Butsu")
local title = addon:CreateFontString(nil, "OVERLAY")

local iconSize = 30
local frameScale = 1

local sq, ss, sn

local OnEnter = function(self)
	local slot = self:GetID()
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:SetLootItem(slot)
	CursorUpdate(self)

	self.drop:Show()
	self.drop:SetVertexColor(1, 1, 0)
end

local OnLeave = function(self)
	if self.quality then
		if(self.quality > 1) then
			local color = ITEM_QUALITY_COLORS[self.quality]
			self.drop:SetVertexColor(color.r, color.g, color.b)
		else
			self.drop:Hide()
		end
	end

	GameTooltip:Hide()
	ResetCursor()
end

local OnClick = function(self)
	if not self:GetID() then return end
	
	if(IsModifiedClick()) then
		HandleModifiedItemClick(GetLootSlotLink(self:GetID()))
	else
		ss = self:GetID()
		sq = self.quality
		sn = self.name:GetText()
		st = self.icon:GetTexture()
		
		-- master looter
		LootFrame.selectedLootButton = self:GetName()
		LootFrame.selectedSlot = ss
		LootFrame.selectedQuality = sq
		LootFrame.selectedItemName = sn
		LootFrame.selectedTexture = st

		LootSlot(ss)
	end
end

local OnUpdate = function(self)
	if(GameTooltip:IsOwned(self)) then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetLootItem(self:GetID())
		CursorOnUpdate(self)
	end
end

media = {
	["backdrop1"] = Qulight["media"].texture,
	["backdrop"] =  Qulight["media"].texture,
	["checked"] = "Interface\\AddOns\\Aurora\\CheckButtonHilight",
	["glow"] = "Interface\\AddOns\\Aurora\\glow",
}

dummy = function() end

CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = media.backdrop, 
		edgeFile = media.backdrop, 
		edgeSize = 1, 
	})
	f:SetBackdropColor(.05,.05,.05, a or alpha)
	f:SetBackdropBorderColor(0, 0, 0)
end
local createSlot = function(id)
	local iconsize = iconSize
	local frame = CreateFrame("Button", 'ButsuSlot'..id, addon)
	frame:SetPoint("LEFT", 8, 0)
	frame:SetPoint("RIGHT", -8, 0)
	frame:SetHeight(30)
	frame:SetID(id)
	CreateBD(frame)
	
	frame:RegisterForClicks("LeftButtonUp", "RightButtonUp")

	frame:SetScript("OnEnter", OnEnter)
	frame:SetScript("OnLeave", OnLeave)
	frame:SetScript("OnClick", OnClick)
	frame:SetScript("OnUpdate", OnUpdate)

	local iconFrame = CreateFrame("Frame", nil, frame)
	iconFrame:SetHeight(30)
	iconFrame:SetWidth(30)
	iconFrame:ClearAllPoints()
	iconFrame:SetPoint("RIGHT", frame)
	CreateBD(iconFrame)
	
	local icon = iconFrame:CreateTexture(nil, "ARTWORK")
	icon:SetAlpha(1)
	icon:SetTexCoord(.07, .93, .07, .93)
	icon:SetPoint("TOPLEFT", 1, -1)
	icon:SetPoint("BOTTOMRIGHT", -1, 1)
	frame.icon = icon

	local count = iconFrame:CreateFontString(nil, "OVERLAY")
	count:ClearAllPoints()
	count:SetJustifyH"RIGHT"
	count:SetPoint("BOTTOMRIGHT", iconFrame, -1, 2)
	count:SetFont(Qulight["media"].font, 10, "OUTLINE")
	count:SetText(1)
	frame.count = count

	local name = frame:CreateFontString(nil, "OVERLAY")
	name:SetJustifyH"LEFT"
	name:ClearAllPoints()
	name:SetPoint("LEFT", frame, 2, 0)
	name:SetPoint("RIGHT", icon, "LEFT")
	name:SetNonSpaceWrap(true)
	name:SetFont(Qulight["media"].font, 10, "OUTLINE")
	frame.name = name

	local drop = frame:CreateTexture(nil, "ARTWORK")
	drop:SetTexture"Interface\\QuestFrame\\UI-QuestLogTitleHighlight"

	drop:SetPoint("LEFT", icon, "RIGHT", 0, 0)
	drop:SetPoint("RIGHT", frame)
	drop:SetAllPoints(frame)
	drop:SetAlpha(.3)
	frame.drop = drop

	addon.slots[id] = frame
	return frame
end

local anchorSlots = function(self)
	local iconsize = iconSize
	local shownSlots = 0
	for i=1, #self.slots do
		local frame = self.slots[i]
		if(frame:IsShown()) then
			shownSlots = shownSlots + 1

			-- We don't have to worry about the previous slots as they're already hidden.
			frame:SetPoint("TOP", addon, 4, (-8 + iconsize) - (shownSlots * iconsize))
		end
	end

	self:SetHeight(math.max(shownSlots * iconsize + 16, 20))
end

title:SetFont(Qulight["media"].font, 10, "OUTLINE")
title:SetPoint("TOP", addon, "TOP", 0, 15)

addon:SetScript("OnMouseDown", function(self) if(IsAltKeyDown()) then self:StartMoving() end end)
addon:SetScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)
addon:SetScript("OnHide", function(self)
	StaticPopup_Hide"CONFIRM_LOOT_DISTRIBUTION"
	CloseLoot()
end)
addon:SetMovable(true)
addon:RegisterForClicks"anyup"

addon:SetParent(UIParent)
addon:SetUserPlaced(true)
addon:SetPoint("TOPLEFT", 0, -104)

CreateStyle(addon, 2)

addon:SetWidth(256)
addon:SetHeight(60)
addon:SetBackdropColor(.05,.05,.05,0)

addon:SetClampedToScreen(true)
addon:SetClampRectInsets(0, 0, 14, 0)
addon:SetHitRectInsets(0, 0, -14, 0)
addon:SetFrameStrata"HIGH"
addon:SetToplevel(true)

addon.slots = {}
addon.LOOT_OPENED = function(self, event, autoloot)
	self:Show()

	if(not self:IsShown()) then
		CloseLoot(not autoLoot)
	end

	local items = GetNumLootItems()

	if(IsFishingLoot()) then
		title:SetText(L.loot_fish)
	elseif(not UnitIsFriend("player", "target") and UnitIsDead"target") then
		title:SetText(UnitName"target")
	else
		title:SetText(LOOT)
	end

	-- Blizzard uses strings here
	if(GetCVar("lootUnderMouse") == "1") then
		local x, y = GetCursorPosition()
		x = x / self:GetEffectiveScale()
		y = y / self:GetEffectiveScale()

		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x - 40, y + 20)
		self:GetCenter()
		self:Raise()
	else
		self:ClearAllPoints()
		self:SetUserPlaced(false)
		self:SetPoint("TOPLEFT", 0, -104)		
	end

	local m, w, t = 0, 0, title:GetStringWidth()
	if(items > 0) then
		for i=1, items do
			local slot = addon.slots[i] or createSlot(i)
			local texture, item, quantity, quality, locked = GetLootSlotInfo(i)
			
			if texture then
				local color = ITEM_QUALITY_COLORS[quality]

				if texture and texture:find('INV_Misc_Coin') then
					item = item:gsub("\n", ", ")
				end

				if(quantity > 1) then
					slot.count:SetText(quantity)
					slot.count:Show()
				else
					slot.count:Hide()
				end

				if(quality > 1) then
					slot.drop:SetVertexColor(color.r, color.g, color.b)
					slot.drop:Show()
				else
					slot.drop:Hide()
				end

				slot.quality = quality
				slot.name:SetText(item)
				slot.name:SetTextColor(color.r, color.g, color.b)
				slot.icon:SetTexture(texture)

				m = math.max(m, quality)
				w = math.max(w, slot.name:GetStringWidth())

				slot:Enable()
				slot:Show()
			end
		end
	else
		local slot = addon.slots[1] or createSlot(1)
		local color = ITEM_QUALITY_COLORS[0]

		slot.name:SetText(L.loot_empty)
		slot.name:SetTextColor(color.r, color.g, color.b)
		slot.icon:SetTexture[[Interface\Icons\INV_Misc_Herb_AncientLichen]]

		items = 1
		w = math.max(w, slot.name:GetStringWidth())

		slot.count:Hide()
		slot.drop:Hide()
		slot:Disable()
		slot:Show()
	end
	anchorSlots(self)

	w = w + 60
	t = t + 5

	local color = ITEM_QUALITY_COLORS[m]
	self:SetBackdropBorderColor(color.r, color.g, color.b, .8)
	self:SetWidth(math.max(w, t))
end

addon.LOOT_SLOT_CLEARED = function(self, event, slot)
	if(not self:IsShown()) then return end

	addon.slots[slot]:Hide()
	anchorSlots(self)
end

addon.LOOT_CLOSED = function(self)
	StaticPopup_Hide"LOOT_BIND"
	self:Hide()

	for _, v in pairs(self.slots) do
		v:Hide()
	end
end

addon.OPEN_MASTER_LOOT_LIST = function(self)
	ToggleDropDownMenu(nil, nil, GroupLootDropDown, addon.slots[ss], 0, 0)
end

addon.UPDATE_MASTER_LOOT_LIST = function(self)
	UIDropDownMenu_Refresh(GroupLootDropDown)
end

addon.ADDON_LOADED = function(self, event, addon)
	if(addon == "Butsu") then
		db = setmetatable({}, {__index = defaults})

		self:SetScale(frameScale)

		-- clean up.
		self[event] = nil
		self:UnregisterEvent(event)
	end
end

addon:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)

addon:RegisterEvent"LOOT_OPENED"
addon:RegisterEvent"LOOT_SLOT_CLEARED"
addon:RegisterEvent"LOOT_CLOSED"
addon:RegisterEvent"OPEN_MASTER_LOOT_LIST"
addon:RegisterEvent"UPDATE_MASTER_LOOT_LIST"
addon:RegisterEvent"ADDON_LOADED"
addon:Hide()

-- Fuzz
LootFrame:UnregisterAllEvents()
table.insert(UISpecialFrames, "Butsu")

local hexColors = {}
for k, v in pairs(RAID_CLASS_COLORS) do
	hexColors[k] = "|c"..v.colorStr
end
hexColors["UNKNOWN"] = string.format("|cff%02x%02x%02x", 0.6 * 255, 0.6 * 255, 0.6 * 255)

if CUSTOM_CLASS_COLORS then
	local function update()
		for k, v in pairs(CUSTOM_CLASS_COLORS) do
			hexColors[k] = "|c"..v.colorStr
		end
	end
	CUSTOM_CLASS_COLORS:RegisterCallback(update)
	update()
end

local playerName = UnitName("player")
local classesInRaid = {}
local players, player_indices = {}, {}
local randoms = {}
local wipe = table.wipe

local function MasterLoot_RequestRoll(frame)
	DoMasterLootRoll(frame.value)
end

local function MasterLoot_GiveLoot(frame)
	MasterLooterFrame.slot = LootFrame.selectedSlot
	MasterLooterFrame.candidateId = frame.value
	if LootFrame.selectedQuality >= MASTER_LOOT_THREHOLD then
		StaticPopup_Show("CONFIRM_LOOT_DISTRIBUTION", ITEM_QUALITY_COLORS[LootFrame.selectedQuality].hex..LootFrame.selectedItemName..FONT_COLOR_CODE_CLOSE, frame:GetText() or UNKNOWN, "LootWindow")
	else
		GiveMasterLoot(LootFrame.selectedSlot, frame.value)
	end
	CloseDropDownMenus()
end

