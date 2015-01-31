local Postmaster = { -- List of sender names to delete mail from
 	-- Lost item guy (54441)
	['Thaumaturge Vashreen'] = true, -- English
	['Thaumaturg Vashreen'] = true, -- German
	['Taumaturgo Vahsreen'] = true, -- Spanish
	['Thaumaturge Vashreen'] = true, -- French
	['Taumaturgo Vashreen'] = true, -- Italian / Portuguese?
	['Чудотворец Вашрин'] = true, -- Russian
	['魔术师瓦西里恩'] = true, -- Simplified Chinese
	
	-- The Postmaster (34337)
	['The Postmaster'] = true, -- English
	['Der Postmeister'] = true, -- German
	['El Jefe de correos'] = true, -- Spanish
	['Le maître de poste'] = true, -- French
	['Il Postino'] = true, -- Italian
	['O Chefe do Correio'] = true, -- Portuguese
	['Почтальон'] = true, -- Russian
	['邮政长'] = true, -- Simplified Chinese
}

local UniqueCache = {} -- store items so we don't have to re-check their tooltips
local ITEM_UNIQUE_MULTIPLE, ITEM_UNIQUE = ITEM_UNIQUE_MULTIPLE:gsub('%(%%d%)', '%%((%%d+)%%)'), ITEM_UNIQUE
local ScanTip = CreateFrame('GameTooltip', 'PostmasterGeneralTooltip', nil, 'GameTooltipTemplate')
local function GetUnique(itemLink) -- returns whether an item is unique
	if itemLink then
		if UniqueCache[itemLink] then -- return stored result
			return UniqueCache[itemLink]
		end
		ScanTip:SetOwner(UIParent, 'ANCHOR_NONE')
		ScanTip:SetHyperlink(itemLink)
		local numLines = ScanTip:NumLines()
		for i = 1, numLines do
			local line = _G['PostmasterGeneralTooltipTextLeft' .. i]
			if line then
				local text = line:GetText() or ''
				local quantity = text:match(ITEM_UNIQUE_MULTIPLE)
				if text == ITEM_UNIQUE or quantity then
					UniqueCache[itemLink] = (quantity or 1) + 0
					return UniqueCache[itemLink]
				end
			end
		end
		if numLines > 0 then
			UniqueCache[itemLink] = false
		--else -- not ready for scanning but return something anyway
		-- I think I'm going to let it attempt to loot unique items the first time you
		-- see them instead of outright ignoring them, in case you do have room for it
		-- This will create a message about not being able to carry any more of the item
		-- but I think that's better than never looting any unique items
		--	return -1
		end
	end
end

local function HasSpaceFor(itemLink, itemCount) -- check if there are any free slots or less-than-complete stacks of an item in your inventory
	local stackSize = select(8, GetItemInfo(itemLink)) -- seems to return info even if the item's tooltip can't be loaded
	if not stackSize or GetUnique(itemLink) then return false end -- bail if item is unique or not cached
	
	if not itemCount then itemCount = 1 end
	if itemCount < stackSize then -- look for partial stacks of the same item
		for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				local texture, containerCount, locked, quality, readable, lootable, containerLink = GetContainerItemInfo(bag, slot)
				if not locked and containerLink == itemLink and containerCount + itemCount <= stackSize then
					return true
				end
			end
		end
	end
	
	local itemFamily = GetItemFamily(itemLink)
	for i = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		local freeSlots, bagFamily = GetContainerNumFreeSlots(i)
		if (bagFamily == 0 or ( itemFamily and bit.band(itemFamily, bagFamily) > 0 )) and freeSlots > 0 then
			return true
		end
	end
	return false
end

local function GetInventoryCount() -- returns how many items we have in our bags total
	local total = 0
	for bag = BACKPACK_CONTAINER, NUM_BAG_SLOTS do
		for slot = 1, GetContainerNumSlots(bag) do
			local _, count = GetContainerItemInfo(bag, slot)
			if count then
				total = total + count
			end
		end
	end
	return total
end


local button = CreateFrame('Button', 'PostmasterGeneralButton', InboxFrame, 'UIPanelButtonTemplate')
button:SetPoint('TOPRIGHT', -70, -1)
button:SetText(AUTO_LOOT_DEFAULT_TEXT)
button:SetWidth(button:GetFontString():GetWidth() + 20)
button:SetHeight(19)

local f = CreateFrame('Frame')
f:Hide()

local timesince = 0
local initialGold, initialItems, initialMail = 0, 0, 0
f:SetScript('OnUpdate', function(self, elapsed)
	timesince = timesince + elapsed
	if timesince >= 0.1 then -- scan while mailframe is open
		local didSomething = false
		for i = GetInboxNumItems(), 1, -1 do
			local packageIcon, stationeryIcon, sender, subject, money, CODAmount, daysLeft, hasItem, wasRead, wasReturned, textCreated, canReply, isGM = GetInboxHeaderInfo(i)
			if Postmaster[sender] then -- AutoLootMailItem(i) -- same as shift-clicking the mail icon
				if not wasRead then -- it doesn't seem to mark the message as read if we don't do this, even if we delete it
					GetInboxText(i)
				end
				
				if money and money > 0 then
					TakeInboxMoney(i)
					didSomething = true
				end
				
				if hasItem then
					for j = 1, ATTACHMENTS_MAX_RECEIVE do
						local name, texture, count, quality, canUse = GetInboxItem(i, j)
						local itemLink = GetInboxItemLink(i, j)
						if itemLink and HasSpaceFor(itemLink, count) then
							TakeInboxItem(i, j)
							didSomething = true
						end
					end
				elseif InboxItemCanDelete(i) then
					DeleteInboxItem(i)
					didSomething = true
				end
			end
		end
		if not didSomething then -- disable if we haven't tried to do something
			self:Hide()
		end
		timesince = 0
	end
end)

f:SetScript('OnShow', function() -- started scanning
	button:Disable()
	local _, totalMailItems = GetInboxNumItems()
	initialGold, initialItems, initialMail = GetMoney(), GetInventoryCount(), totalMailItems
end)

f:SetScript('OnHide', function() -- finished scanning
	local _, totalMailItems = GetInboxNumItems()
	local goldCount, itemCount, mailCount = GetMoney() - initialGold, GetInventoryCount() - initialItems, initialMail - totalMailItems
	if goldCount > 0 and itemCount > 0 then
		print(format('|cffff6666PostmasterGeneral|r: Looted %d items and %s', itemCount, GetCoinTextureString(goldCount)))
	elseif goldCount > 0 then
		print(format('|cffff6666PostmasterGeneral|r: Looted %s', GetCoinTextureString(goldCount)))
	elseif itemCount > 0 then
		print(format('|cffff6666PostmasterGeneral|r: Looted %d items', itemCount))
	end
	
	--if mailCount > 0 then
	--	print(format('|cffff6666PostmasterGeneral|r: Deleted %d empty mail', mailCount))
	--end

	button:Enable()
end)

button:SetScript('OnClick', function(self) -- begin scanning
	f:Show()
end)