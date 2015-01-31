if not Qulight["misk"].CooldownFlash == true then return end


local lib = LibStub("LibCooldown")
if not lib then error("CooldownFlash requires LibCooldown") return end

local filter = {
	["pet"] = "all",
	["item"] = {
		[6948] = true, -- hearthstone
	},
	["spell"] = {
	},
}
local shadows = {
	edgeFile = "Interface\\AddOns\\QulightUI\\media\\Other\\glowTex", 
	edgeSize = 4,
	insets = { left = 3, right = 3, top = 3, bottom = 3 }
}

Anchorflash = CreateFrame("Frame","Move_flash_icon",UIParent)
Anchorflash:SetPoint("CENTER", UIParent, 0, 80) 
CreateAnchor(Anchorflash, "Move flash icon", 80, 80)

local flash = CreateFrame("Frame", nil, UIParent)
flash.icon = flash:CreateTexture(nil, "OVERLAY")
flash:SetScript("OnEvent", function()
	local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/GetCVar("uiScale")
	local function scale(x) return mult*math.floor(x+.5) end
	flash:SetPoint("CENTER", Anchorflash)
	flash:SetSize(scale(80),scale(80))
	flash:SetBackdrop({
	  bgFile = [[Interface\AddOns\QulightUI\Root\Media\solid]], 
	  edgeFile = [[Interface\AddOns\QulightUI\Root\Media\solid]], 
	  tile = false, tileSize = 0, edgeSize = mult, 
	  insets = { left = -mult, right = -mult, top = -mult, bottom = -mult}
	})
	flash:SetBackdropColor(.06,.06,.06,0)
	flash:SetBackdropBorderColor(.15,.15,.15,0)
	flash.icon:SetPoint("TOPLEFT", scale(2), scale(-2))
	flash.icon:SetPoint("BOTTOMRIGHT", scale(-2), scale(2))
	flash.icon:SetTexCoord(.08, .92, .08, .92)
	flash:Hide()
	flash:SetScript("OnUpdate", function(self, e)
		flash.e = flash.e + e
		if flash.e > .75 then
			flash:Hide()
		elseif flash.e < .25 then
			flash:SetAlpha(flash.e*4)
		elseif flash.e > .5 then
			flash:SetAlpha(1-(flash.e%.5)*4)
		end
	end)
	CreateStyle(flash, 2)
	flash:UnregisterEvent("PLAYER_ENTERING_WORLD")
	flash:SetScript("OnEvent", nil)
end)
flash:RegisterEvent("PLAYER_ENTERING_WORLD")

lib:RegisterCallback("stop", function(id, class)
	if filter[class]=="all" or filter[class][id] then return end
	flash.icon:SetTexture(class=="item" and GetItemIcon(id) or select(3, GetSpellInfo(id)))
	flash.e = 0
	flash:Show()
end)
