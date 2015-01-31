local t = 1
local loottemp = {}
local sockets = {3, 497, 523, 563, 564, 565, 572}
local warforged = {44, 448, 499, 546, 547, 560, 561, 562, 571}

local function Announce()
local masterlooterRaidID = select(3, GetLootMethod())
if (masterlooterRaidID ~= nil and UnitName("raid"..masterlooterRaidID) == UnitName("player")) or IsLeftControlKeyDown() then
local n = 0
local check = false
local loot = GetLootInfo()

for i = 1, GetNumLootItems() do
	if GetLootSlotType(i) == 1 then
		for j = 1, t do
			if GetLootSourceInfo(i) == loottemp[j] then 
				check = true
			break
			end
		end
	end
end

t = GetNumLootItems()
if check == false or IsLeftControlKeyDown() then
	for i = 1, t do
		loot[i]["check"] = 0
		if GetLootSlotType(i) == 1 and loot[i]["quality"] >= 4 and not (bit.band(GetItemFamily(loot[i]["item"] or '') or 0, 0x0040) > 0) then
			local link = GetLootSlotLink(i)
			local ilvl = select(4, GetItemInfo(link))
			loot[i]["upgrade"] = ""
			loot[i]["bonus"] = ""
			if ilvl < 600 then
				if (ilvl == 503) or (ilvl == 516) or (ilvl == 528) or (ilvl == 541) or (ilvl == 559) or (ilvl == 572) then
					loot[i]["upgrade"] = "+"
				end
			else	
				local itemstring = string.match(link, "item[%-?%d:]+")
				local _, _, _, _, _, _, _, _, _, _, _, _, numbonuses = strsplit(":", itemstring)
				numbonuses = tonumber(numbonuses)
				if numbonuses > 0 then
					if numbonuses == 1 then	
						_, _, _, _, _, _, _, _, _, _, _, _, _, bonus[1] = strsplit(":", itemstring)
						bonus[1] = tonumber(bonus[1])
					end
					if numbonuses == 2 then
						_, _, _, _, _, _, _, _, _, _, _, _, _, _, bonus[2] = strsplit(":", itemstring)
						bonus[2] = tonumber(bonus[2])
					end
					if numbonuses == 3 then
						_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, bonus[3] = strsplit(":", itemstring)
						bonus[3] = tonumber(bonus[3])
					end
					if numbonuses == 4 then
						_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, bonus[4] = strsplit(":", itemstring)
						bonus[4] = tonumber(bonus[4])
					end
				end
				for i = 1, numbonuses do
					loot[i]["bonus"] = loot[i]["bonus"]..bonus[i]..":"
					for k = 1, #warforged do												--Warforged
						if bonus[i] == #warforged[j] then
							loot[i]["upgrade"] = ":"..ilvl
						end
					end
					if bonus[i] == 492 or 343 <= bonus[i] <= 447 then loot[i]["upgrade"] = loot[i]["upgrade"].."+"..SPELL_STAT5_NAME end	--Spirit
					if bonus[i] == 491 or 238 <= bonus[i] <= 342 then loot[i]["upgrade"] = loot[i]["upgrade"].."+"..ARMOR end		--Armor
					if 509 <= bonus[i] <= 514 then loot[i]["upgrade"] = loot[i]["upgrade"].."+"..SPELL_STAT3_NAME end			--Stamina
					for j = 1, #sockets do													--Socket
						if bonus[i] == sockets[j] then
							loot[i]["upgrade"] = loot[i]["upgrade"].." o"
						end
					end
				end
			end
			loot[i]["check"] = 1
			for k = 1, i-1 do
				if loot[k]["item"] == loot[i]["item"] and loot[k]["upgrade"] == loot[i]["upgrade"] and loot[k]["bonus"] == loot[i]["bonus"] then
					loot[i]["check"] = 0
					loot[k]["quantity"] = loot[i]["quantity"] + loot[k]["quantity"]
				end
			end
		end
	end

	for i = 1, t do
		loot[i]["item"] = GetLootSlotLink(i)
		if loot[i]["check"] == 1 then
			n = n + 1
			if loot[i]["quantity"] == 1 then
				SendChatMessage(n..". "..loot[i]["item"]..loot[i]["upgrade"], "RAID")
			else
				SendChatMessage(n..". "..loot[i]["item"].."x"..loot[i]["quantity"]..loot[i]["upgrade"], "RAID")
			end
		end
	end
end

for i = 1, t do
	loottemp[i] = GetLootSourceInfo(i)
end

end
end

local SimpleLootAnnouncer = CreateFrame("Frame")
SimpleLootAnnouncer:RegisterEvent("LOOT_OPENED")
SimpleLootAnnouncer:SetScript("OnEvent", function(self, event)
	Announce()
end)