local SLOTIDS = {}
for _, slot in pairs({"Head", "Shoulder", "Chest", "Waist", "Legs", "Feet", "Wrist", "Hands", "MainHand", "SecondaryHand"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end

local function RYGColorGradient(perc)
	local relperc = perc*2 % 1
	if perc <= 0 then       return           1,       0, 0
	elseif perc < 0.5 then  return           1, relperc, 0
	elseif perc == 0.5 then return           1,       1, 0
	elseif perc < 1.0 then  return 1 - relperc,       1, 0
	else                    return           0,       1, 0 end
end

local CreateNF = function(f, a, w, h)
	f:SetSize(w or f:GetWidth(), h or f:GetHeight())
	f:SetBackdrop({
		bgFile = "Interface\\AddOns\\Zmini\\normTex.tga",
		edgeFile = "Interface\\AddOns\\Zmini\\glowTex.blp",
		edgeSize = 1,
		insets = {left=1, right=1, top=1, bottom=1} })
	f:SetBackdropColor(0, 0, 0, a or 0.5)
	f:SetBackdropBorderColor(0, 0, 0, 0.25)
end

local CreateFS = function(parent, size, justify)
    local f = parent:CreateFontString(nil, "OVERLAY")
	f:SetFont(Qulight["media"].pxfont, 13, 'THINOUTLINE')
    if(justify) then f:SetJustifyH(justify) end
    return f
end
local fontstrings = setmetatable({}, {
	__index = function(t,i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		local fstr = CreateFS(gslot)
		fstr:SetPoint("BOTTOM", gslot, "BOTTOM", 2, 1)
		t[i] = fstr
		return fstr
	end,
})

local onEvent = function()
	for slot, id in pairs(SLOTIDS) do
		local v1, v2 = GetInventoryItemDurability(id)

		if v1 and v2 and v2 ~= 0 then
			local str = fontstrings[slot]
			str:SetTextColor(RYGColorGradient(v1/v2))
			str:SetText(string.format("%d%%", v1/v2*100))
		else
			local str = rawget(fontstrings, slot)
			if str then str:SetText(nil) end
		end
	end
end

-- Durability informing
local dur = CreateFrame("Frame")
dur:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
CreateNF(dur, 0.25, 135, 25)
dur.Text = dur:CreateFontString(nil, "OVERLAY")
dur.Text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
dur.Text:SetPoint("CENTER", dur)

dur:RegisterEvent("PLAYER_ENTERING_WORLD")
dur:RegisterEvent("UPDATE_INVENTORY_DURABILITY")
dur:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	onEvent()

	if InCombatLockdown() then return end
	for slot, id in pairs(SLOTIDS) do
		local cur, max = GetInventoryItemDurability(id)
		if cur then
			local value = cur/max
			if value < 0.2 then
				dur:Show()
				dur.Text:SetText("|cff70C0F5".."装备耐久度低于20%！")
			else
				dur:Hide()
			end
		else
			dur:Hide()
		end
	end
end)
dur:SetScript("OnMouseUp", function()
	dur:Hide()
end)