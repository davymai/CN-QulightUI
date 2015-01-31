local SetPushed
local DB
local _

local TEXT_BUTTONS = {
	["playerStatus"] = {
		name = "Players",
		x = -205,
		y = -26
	},
	["guildStatus"] = {
		name = "Guild",
		x = -145,
		y = -26
	},
	["tradeskill"] = {
		name = "Profs",
		x = -85,
		y = -26
	},
	["achievement"] = {
		name = "Achieve",
		x = -25,
		y = -26
	},
	["weeklyxp"] = {
		name = "Week XP",
		x = -145,
		y = -44
	},
	["totalxp"] = {
		name = "All XP",
		x = -85,
		y = -44
	},
	["reputation"] = {
		name = "Rep",
		x = -25,
		y = -44
	}
}

local ICON_BUTTONS = {
	["playerStatus"] = {
		name = PLAYER_STATUS,
		texture = "Interface\\WorldStateFrame\\ICONS-CLASSES",
		coord = CLASS_BUTTONS[select(2,UnitClass("player"))],
		x = -196,
		y = -4
	},
	["guildStatus"] = {
		name = GUILD_STATUS,
		texture = "Interface\\COMMON\\icon-"..strlower(UnitFactionGroup("player")),
		coord = {0.25,0.75,0.2,0.8},
		x = -168,
		y = -4
	},
	["tradeskill"] = {
		name = TRADE_SKILLS,
		texture = "Interface\\SPELLBOOK\\Spellbook-Icon",
		coord = {0.1,0.9,-0.05,1.05},
		x = -140,
		y = -4
	},
	["achievement"] = {
		name = ACHIEVEMENT_POINTS,
		texture = "Interface\\ICONS\\Achievement_Quests_Completed_06",
		x = -112,
		y = -4
	},
	["weeklyxp"] = {
		name = GUILD_XP_WEEKLY,
		texture = "Interface\\ICONS\\ACHIEVEMENT_GUILDPERK_FASTTRACK",
		x = -84,
		y = -4
	},
	["totalxp"] = {
		name = GUILD_XP_TOTAL,
		texture = "Interface\\ICONS\\ACHIEVEMENT_GUILDPERK_FASTTRACK_RANK2",
		x = -56,
		y = -4
	},
	["reputation"] = {
		name = GUILD_REPUTATION,
		texture = "Interface\\ICONS\\Achievement_Reputation_01",
		x = -28,
		y = -4
	}
}

local SETTINGS = {
	["TEXT"] = {
		prefix = "GRB_TEXT_",
		buttons = TEXT_BUTTONS,
		template = "UIMenuButtonStretchTemplate",
	},
	["ICON"] = {
		prefix = "GRB_ICON_",
		buttons = ICON_BUTTONS,
		template = "MainMenuBarMicroButton",
	}
}

local function BuildButtons()
	if not GRB_DB then GRB_DB = {MODE = "ICON"}	end; DB = GRB_DB;
	SetPushed = function(cvar)
		SetCVar("guildRosterView", cvar)
		for a,b in pairs(SETTINGS) do
			for k,v in pairs(b.buttons) do
				local button = _G[b.prefix..k]
				if button then
					if DB.MODE == a then -- Check mode match
						if k == cvar then -- Button matches cvar
							GuildRosterViewDropdown_OnClick(button) -- Execute Click
							if DB.MODE == "TEXT" then
								button:LockHighlight()
							elseif DB.MODE == "ICON" then
								button.Flash.flasher:Play()
								button:SetButtonState("PUSHED", 1)
								SetDesaturation(_G[button:GetName().."_Overlay"], nil)
							end
						else 
							if DB.MODE == "TEXT" then
								button:UnlockHighlight()
							elseif DB.MODE == "ICON" then
								if button.Flash.flasher:IsPlaying() then
									button.Flash.flasher:Stop()
								end
								button:SetButtonState("NORMAL")
								SetDesaturation(_G[button:GetName().."_Overlay"], 1)
							end
						end
						button:Show() -- Show button if hidden
					else -- Hides button if doesn't match mode
						button:Hide()
					end
				end
			end
		end
	end
	
	for a,b in pairs(SETTINGS) do
		for k,v in pairs(b.buttons) do
			local button = CreateFrame("Button",b.prefix..k,GuildRosterFrame,b.template)
			button:SetPoint("TOPRIGHT",GuildRosterFrame,"TOPRIGHT",v.x,v.y)
			button.value = k -- Required for blizzard function to work.
			button:SetScript("OnClick",function(self,button)
				SetPushed(k)
				PlaySound("SPELLBOOKCHANGEPAGE")				
			end)
			
			if a == "TEXT" then
				
				button:SetSize(60,18)
				button:SetText(v.name)
				
			elseif a == "ICON" then
				button.text = k
				button:SetScript("OnEnter",function()
					GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
					GameTooltip:AddLine(v.name);
					GameTooltip:Show();
				end)
				
				button:SetScript("OnLeave",function()
					GameTooltip:Hide();
				end)
				
				button:SetNormalTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Up");
				button:SetPushedTexture("Interface\\Buttons\\UI-MicroButtonCharacter-Down");
				button:SetHighlightTexture("Interface\\Buttons\\UI-MicroButton-Hilight");
				button.overlay = button:CreateTexture(b.prefix..k.."_Overlay","OVERLAY")
				button.overlay:SetSize(18,25)
				button.overlay:SetPoint("TOP",button,"TOP",0,-28)
				button.overlay:SetTexture(v.texture or nil)
				button.overlay:SetTexCoord(unpack(v.coord or {0.1,0.9,0.1,0.9}))
				button.Flash.flasher = button.Flash:CreateAnimationGroup()
				local fade1 = button.Flash.flasher:CreateAnimation("Alpha")
				fade1:SetDuration(0.5)
				fade1:SetChange(1)
				fade1:SetOrder(1)
				local fade2 = button.Flash.flasher:CreateAnimation("Alpha")
				fade2:SetDuration(0.5)
				fade2:SetChange(-1)
				fade2:SetOrder(2)
				button.Flash:SetAlpha(0)
				button.Flash:Show()
			end			
		end
	end
	
end

local function SlashHandler(arg)
	if not GRB_DB then GRB_DB = {MODE = "ICON"}	end; DB = GRB_DB;
	arg = strupper(arg)
	if arg == "TEXT" or arg == "ICON" then
		if not IsAddOnLoaded("Blizzard_GuildUI") then ToggleGuildFrame() end -- Makes sure the frame has loaded at least once before executing.
		DB.MODE = arg
		print("GRB - "..LIGHTYELLOW_FONT_COLOR_CODE.."Mode set to: '"..arg.."'.|r")
		SetPushed(GetCVar("guildRosterView") or "playerStatus")
	else
		print("GRB - "..LIGHTYELLOW_FONT_COLOR_CODE.."Available commands are '/grb' 'text' or 'icon'.|r")
	end
end

SLASH_GRB1 = "/grb"
SlashCmdList["GRB"] = SlashHandler

local f = CreateFrame("frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self,event,...)
	local arg1, arg2 = ...
	if event == "ADDON_LOADED" and arg1 == "Blizzard_GuildUI" then
		self:UnregisterEvent("ADDON_LOADED")
		GuildRosterViewDropdown:Hide()
		if not GRB_DB then GRB_DB = {MODE = "ICON"}	end; DB = GRB_DB;
		BuildButtons()
		SetPushed("playerStatus")
	end
end)