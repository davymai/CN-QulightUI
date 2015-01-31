local _G =_G
-- If you're not a monk, this mod doesn't like you. This mod is kinda a jerk.
if select(2, UnitClass("player")) ~= "MONK" then return end
Tao_Options = {}
-----------------------------------------------------------------------------------------------------------------------
-- 						** Options ** 							     --
-----------------------------------------------------------------------------------------------------------------------
-- Work-in-progress

-- true or false
local showStaggerBar = false		-- Display a bar for Stagger
local showPS = true			-- Display Power Strikes Timer


-----------------------------------------------------------------------------------------------------------------------
--    Don't edit below this line unless you know what you're doing and/or promise not to complain when it breaks     --
-----------------------------------------------------------------------------------------------------------------------


Tao = CreateFrame("Frame", "Tao_Frame")

local Timers = {} 

local PlayerGUID
local PSCD = 0
local StaggerTick = 0
local StaggerTotal = 0	
local MaxHealth = 0

local StaggerB, StaggerBar, StaggerBarBG, StaggerText, PSB, PSText

local InCombat

local UPDATE_INTERVAL = 0.1
local DEFAULT_STAGGER_ICON = "INTERFACE\\ICONS\\ability_rogue_cheatdeath"
local LIGHT_STAGGER_ICON =  "INTERFACE\\ICONS\\priest_icon_chakra_green"
local MODERATE_STAGGER_ICON =  "INTERFACE\\ICONS\\priest_icon_chakra"
local HEAVY_STAGGER_ICON =  "INTERFACE\\ICONS\\priest_icon_chakra_red"
local LastUpdate = 0

-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------
local function FormatTime(time,ms)
	local min = floor(time/60)
	local sec = floor(time-(min*60))
	local msec = floor((time-(min*60+sec)) * 10)
	local out	

	--if sec < 10 then sec = "0"..sec end
	if (ms) then
		return sec.."."..msec
	else
		return sec..""
	end
	return 0
end

local function FormatHealth(hp)
	local out = ""	

	if (hp >= 10000) then
		hp = floor(hp / 1000) / 10 .. "w"
	end

	return (hp.."")
end

local function UpdateTimers()
	local cTime = GetTime()
	local t

	-- Power Strikes
	if Timers[1] and showPS then
		t = Timers[1] - cTime
		if (t <= 0) then
			Timers[1] = nil
			PSText:SetText("")
			PSB:Hide()
		else
			PSText:SetText(""..FormatTime(t+1, false))
			PSB:Show()
		end
	else 
		PSText:SetText("")
		PSB:Hide()
	end
end


local function UpdateStaggerIcon(icon)
	local hp = floor(StaggerTotal/MaxHealth * 100)

	if (StaggerTotal > 0 or (showStaggerBar and Tao_Options.locked == false)) then
		StaggerB:Show()
		StaggerBar:Show()
		StaggerBarBG:Show()
		StaggerText:Show()
	 	if hp <= 50 then StaggerBar:SetValue(hp) else StaggerBar:SetValue(50) end
		StaggerText:SetText(""..FormatHealth(StaggerTotal).." ("..hp.."%)") 

		if showStaggerBar == false then
			StaggerBar:SetStatusBarColor(0, 0, 0, 0)
		        StaggerBarBG:SetVertexColor(0, 0, 0, 0)
		else 
			if icon == LIGHT_STAGGER_ICON then
				StaggerBar:SetStatusBarColor(0, 0.4, 0, 1)
			        StaggerBarBG:SetVertexColor(0, 0.4, 0, 0.3)
			elseif icon == MODERATE_STAGGER_ICON then
				StaggerBar:SetStatusBarColor(0.7, 0.7, 0.2, 1)
			        StaggerBarBG:SetVertexColor(0.7, 0.7, 0.2, 0.3)
			elseif icon == HEAVY_STAGGER_ICON then
				StaggerBar:SetStatusBarColor(0.9, 0.2, 0.2, 1)	
			        StaggerBarBG:SetVertexColor(0.6, 0.2, 0.2, 0.3)
			else
				StaggerBar:SetStatusBarColor(1, 1, 1, 1)
			        StaggerBarBG:SetVertexColor(0, 0, 0, 0.3)
			end
		end	

	else 
		--if InCombat == false and Tao_Options.locked == true then Tao_Frame:Hide() end
		StaggerText:SetText("")
		icon = DEFAULT_STAGGER_ICON 
		StaggerBar:SetStatusBarColor(0, 0, 1, 1)
		StaggerB:Hide()
		StaggerBar:Hide()
		StaggerBarBG:Hide()
		StaggerText:Hide()
	end

	local normalStaggerTexture = StaggerB:CreateTexture(nil, "BACKGROUND")
	normalStaggerTexture:SetAllPoints(StaggerB)
	normalStaggerTexture:SetTexture(icon)
	StaggerB:SetNormalTexture(normalStaggerTexture)		
end

local function UpdateStagger()
	local 		   name, _, icon, _, _, duration, _, _, _, _, _, _, _, value2, value1 = UnitAura("player", tao_l["Light Stagger"], "", "HARMFUL")
	if (not name) then name, _, icon, _, _, duration, _, _, _, _, _, _, _, value2, value1 = UnitAura("player", tao_l["Moderate Stagger"], "", "HARMFUL") end
	if (not name) then name, _, icon, _, _, duration, _, _, _, _, _, _, _, value2, value1 = UnitAura("player", tao_l["Heavy Stagger"], "", "HARMFUL") end

	if (name and duration > 0) then
		--DEFAULT_CHAT_FRAME:AddMessage(aura_name.." - "..aura_rank.." - "..value1.." - "..value2)

		--if (value1 ~= StaggerTick) then
		StaggerTick = value1
		StaggerTotal = StaggerTick * math.floor(duration)
		--end 
		UpdateStaggerIcon(icon)

	else 
		UpdateStaggerIcon(DEFAULT_STAGGER_ICON)
		StaggerText:SetText("")
	end
end

local function SaveFramePos()
	Tao_Options.posX = Tao_Frame:GetLeft()
	Tao_Options.posY = Tao_Frame:GetTop()
end

local function OnUpdate(self, elapsed)
	LastUpdate = LastUpdate + elapsed

	if LastUpdate >= UPDATE_INTERVAL then
		UpdateTimers()
		if StaggerTotal <= 0 then UpdateStagger() end
		LastUpdate = 0
	end
end

local function LockFrames() 
	Tao_Options.locked = true
	Tao:SetMovable(false)
	Tao:EnableMouse(false)
	StaggerB:SetScript("OnMouseDown", function() end)
	StaggerB:SetScript("OnMouseUp", function() end)
	StaggerB:SetScript("OnDragStop", function() end)
	StaggerB:Hide()
	StaggerBar:Hide()
	StaggerBarBG:Hide()
	StaggerText:Hide()
	UpdateStagger()
end

local function UnlockFrames()
	Tao_Options.locked = false
	Tao_Frame:Show()
	Tao:SetMovable(true)
	Tao:EnableMouse(true)
	StaggerB:SetScript("OnMouseDown", function() Tao_Frame:StartMoving() end)
	StaggerB:SetScript("OnMouseUp", function() Tao_Frame:StopMovingOrSizing() SaveFramePos() end)
	StaggerB:SetScript("OnDragStop", function() Tao_Frame:StopMovingOrSizing() end)
	StaggerB:Show()
end

local function Init()

	MaxHealth = UnitHealthMax("player")

	Timers[0] = nil
	Timers[1] = nil
	LastUpdate = 0

	Tao:SetClampedToScreen(true)
	Tao:SetPoint("BOTTOMLEFT", Anchorplayer, "TOPLEFT", -1, 47)
	Tao:SetFrameStrata("LOW")
	Tao:SetWidth(75)
	Tao:SetHeight(24)
	Tao:SetScript("OnUpdate", OnUpdate)

	-- Stagger
	StaggerB = CreateFrame("Button", "Tao_FrameStaggerB", Tao_Frame)
	StaggerB:SetFrameLevel(Tao_Frame:GetFrameLevel()+1)
	StaggerB:SetWidth(18)
	StaggerB:SetHeight(18)
	StaggerB:ClearAllPoints()
	StaggerB:SetPoint("TOPLEFT", "Tao_Frame", "BOTTOMLEFT", 0, -1)

	local normalStaggerTexture = StaggerB:CreateTexture(nil, "PARENT")
	normalStaggerTexture:SetAllPoints(StaggerB)
	normalStaggerTexture:SetTexture("Interface\\Icons\\ability_rogue_cheatdeath")
	StaggerB:SetNormalTexture(normalStaggerTexture)

	StaggerBar = CreateFrame("StatusBar", nil, Tao_Frame)
	StaggerBar:SetStatusBarTexture("Interface\\Addons\\Tao\\staggerseg.tga")
	StaggerBar:GetStatusBarTexture():SetHorizTile(false)
	StaggerBar:SetMinMaxValues(0, 50)
	StaggerBar:SetValue(25)
	StaggerBar:SetWidth(90)
	StaggerBar:SetHeight(18)
	StaggerBar:SetPoint("LEFT",StaggerB,"RIGHT")
	StaggerBar:SetStatusBarColor(0, 0, 1, 1)

        StaggerBarBG = StaggerBar:CreateTexture(nil, "BACKGROUND")
        StaggerBarBG:SetAllPoints(StaggerBar)
        StaggerBarBG:SetTexture("Interface\\Addons\\Tao\\staggerseg.tga")
        StaggerBarBG:SetVertexColor(0, 0, 0, 0.3)

	StaggerText = StaggerBar:CreateFontString("Tao_FrameStaggerText", "OVERLAY", "GameFontHighlightSmall")
	StaggerText:SetFont("Interface\\Addons\\QulightUI\\Root\\Media\\qFont4.TTF", 14, "OUTLINE")
	StaggerText:SetPoint("LEFT", StaggerB, "RIGHT", 4, 0)
	StaggerText:SetText("")


	-- Power Strikes
	if (showPS == true) then
		PSB = CreateFrame("Button", "Tao_FramePSB", Tao_Frame)
		PSB:SetFrameLevel(Tao_Frame:GetFrameLevel()+1)
		PSB:SetWidth(12)
		PSB:SetHeight(12)
		PSB:ClearAllPoints()
		PSB:SetPoint("BOTTOMLEFT", "Tao_Frame", "BOTTOMLEFT", 0, 0)
		--PSB:SetScript("OnMouseDown", function() Tao_Frame:StartMoving() end)
		--PSB:SetScript("OnMouseUp", function() Tao_Frame:StopMovingOrSizing() SaveFramePos() end)
		--PSB:SetScript("OnDragStop", function() Tao_Frame:StopMovingOrSizing() end)
	
		local normalPSTexture = PSB:CreateTexture(nil, "PARENT")
		normalPSTexture:SetAllPoints(PSB)
		normalPSTexture:SetTexture("Interface\\Icons\\ability_monk_powerstrikes")
		--normalPSTexture:SetTexture("Interface\\Icons\\trade_engineering")
		PSB:SetNormalTexture(normalPSTexture)
	
		PSText = Tao:CreateFontString("Tao_FramePSText", "OVERLAY", "GameFontHighlightSmall")
		PSText:SetFont("Interface\\Addons\\QulightUI\\Root\\Media\\qFont4.TTF", 11, "OUTLINE")
		PSText:SetPoint("LEFT", Tao_FramePSB, "RIGHT", 4, 0)
		PSText:SetText("")	
	end

	if Tao_Options.IssueMessage == nil then Tao_Options.IssueMessage = false end
	if Tao_Options.posX then
		Tao_Frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", Tao_Options.posX, Tao_Options.posY)
	end
	if Tao_Options.locked then
		LockFrames()
	else
		Tao_Options.locked = false
		UnlockFrames()
	end

	StaggerTotal = 0
	StaggerTick = 0
	UpdateStagger()

	SlashCmdList["TAO"] = TAO_SlashHandler;
	SLASH_TAO1 = "/bmt";
	SLASH_TAO2 = "/tao";

	if (GetSpecialization() == 1) then
		--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Brewmaster spec detected. Stagger display enabled." )
		Tao_Options.stagger = true
	else 
		--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Non-brewmaster spec detected. Stagger display disabled." )			
		Tao_Options.stagger = false
	end

	UpdateTimers()
	UpdateStaggerIcon()

end
-----------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------

local function OnEvent(self, event, ...)
	local currentTime = GetTime()
	local unitID

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		--    1, 2        , 3, 4         , 5, 6, 7, 8       , 9,10,11, 12    
		local _, eventName, _, sourceGUID, _, _, _, destGUID, _, _, _, spellId = ...

		if eventName == "UNIT_DIED" and destGUID == PlayerGUID then
			StaggerTick = 0
			StaggerTotal = 0
			UpdateStaggerIcon(DEFAULT_STAGGER_ICON)
		end

		if sourceGUID ~= PlayerGUID then return end
		if eventName == "SPELL_DAMAGE" and (spellId == 100780 or spellId == 108557 or spellId == 115687 or spellId == 115693 or spellId == 115698 or spellId == 115695) then
			if Timers[1] == nil then
				Tao_Frame:Show()
				Timers[1] = (currentTime + 20)
			end
		elseif spellId == 124255 then
			--StaggerTotal = StaggerTotal - StaggerTick
			UpdateStagger()

		elseif eventName == "SPELL_CAST_SUCCESS" and spellId == 119582 then
			-- immediately clear to avoid confusion/lag
			StaggerTotal = 0
			StaggerTick = 0
			UpdateStagger()

		elseif eventName == "SPELL_AURA_APPLIED" and (spellId == 142475 or spellId == 142473 or spellId == 142474) then
			UpdateStagger()

		elseif eventName == "SPELL_AURA_REMOVED" and (spellId == 142475 or spellId == 142473 or spellId == 142474 or spellId == 124255) then
			StaggerTick = 0
			StaggerTotal = 0
			UpdateStaggerIcon(DEFAULT_STAGGER_ICON)

		--elseif eventName == "SPELL_ENERGIZE" then -- don't need this yet
		end

	elseif event == "UNIT_AURA" then
		unitID = ...
		if not (unitID == "player") then return end


	elseif event == "PLAYER_REGEN_DISABLED" then
		InCombat = true
	elseif event == "PLAYER_REGEN_ENABLED" then
		InCombat = false
		--if StaggerTotal == 0 and Tao_Options.locked == true then Tao_Frame:Hide() end
	elseif event == "UNIT_MAXHEALTH" then
		MaxHealth = UnitHealthMax("player")

	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		if (GetSpecialization() == 1) then
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Spec changed. Stagger display enabled." )
			Tao_Options.stagger = true
		else 
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Spec changed. Stagger display disabled." )			
			Tao_Options.stagger = false
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		PlayerGUID = UnitGUID("player")
		Init()
	end
end
-----------------------------------------------------------------------------------------------------------------------

Tao:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Tao:RegisterEvent("PLAYER_REGEN_DISABLED")
Tao:RegisterEvent("PLAYER_REGEN_ENABLED")
Tao:RegisterEvent("UNIT_AURA")
Tao:RegisterEvent("UNIT_POWER")
Tao:RegisterEvent("UNIT_MAXHEALTH")
Tao:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")

Tao:RegisterEvent("PLAYER_ENTERING_WORLD")
Tao:SetScript("OnEvent", OnEvent)


-----------------------------------------------------------------------------------------------------------------------
function TAO_SlashHandler(msg, editbox)
	local arg1, arg2, rest = string.split(" ", msg);
	
	if (arg1 == "lock") then
		if (Tao:IsMovable()) then
			LockFrames()
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Locked")
		else 
			UnlockFrames()
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Unlocked. Drag the Stagger Icon to move.")
		end
	elseif (arg1 == "stagger") then
		if (Tao_Options.stagger) then
			Tao_Options.stagger = false
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Stagger display disabled.")
		else 
			Tao_Options.stagger = true
			--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao|r: Stagger display enabled.")
		end
	else 
		--DEFAULT_CHAT_FRAME:AddMessage("|cff558484Tao Options:|r")
		--DEFAULT_CHAT_FRAME:AddMessage(" /tao lock  -- Lock or unlock the frames")
	end

end