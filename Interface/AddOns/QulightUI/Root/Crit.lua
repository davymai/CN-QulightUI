---------------------------------------------------------------------------------------
--	Killed Show on UIPerant
---------------------------------------------------------------------------------------
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")

local mssg
local tracker
local playerid

local function DecimalToHex(r,g,b)
return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

local playername = UnitName("player")
local playerclass,PLAYERCLASS = UnitClass("player")
local playerlevel = UnitLevel("Player")
local classcolor = RAID_CLASS_COLORS[PLAYERCLASS]
local r,g,b = classcolor.r,classcolor.g,classcolor.b
local classcolorhex = DecimalToHex(r,g,b)

local function CreateMsgFrame()
      mssg = CreateFrame("MessageFrame", "AfterKillMessageFrame", UIParent)
      mssg:SetPoint("LEFT", 0, 220)
      mssg:SetPoint("RIGHT", 0, 220)
      mssg:SetPoint("CENTER", 0, 220)
      mssg:SetHeight(31)
      mssg:SetInsertMode("TOP")
      mssg:SetFrameStrata("HIGH")
      mssg:SetTimeVisible(1)
      mssg:SetFadeDuration(1)
      mssg:SetFont(STANDARD_TEXT_FONT, 30, "OUTLINE")
end

local function SetUpTracker()
      tracker = CreateFrame("Frame")
      tracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
      tracker:SetScript("OnEvent", function(_, _, _, event, _, sourceGUID, sourceName, _, _, destGUID, destName, destFlags)
            if event == "PARTY_KILL" and sourceGUID==playerid then
               mssg:AddMessage("击 杀 目 标", 1, 0, 0)
               --mssg:AddMessage(classcolorhex..sourceName.."|r 击杀: "..destName, 1, 1, 1)
            end
      end)
end

EventFrame:SetScript("OnEvent", function(self, event, ...)
      if event == "PLAYER_LOGIN" then
            playerid = UnitGUID("player")
            CreateMsgFrame()
            SetUpTracker()
      end
end) 

---------------------------------------------------------------------------------------
--	团队标记/管理
---------------------------------------------------------------------------------------
local wm = CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton 

wm:SetParent("UIParent") 
wm:ClearAllPoints() 
wm:SetPoint("TOP", UIParent, "TOP", -130, -1)  --记得改这里的位置 
wm:SetSize(20, 22) 
wm:Hide() 

wm:RegisterEvent("GROUP_ROSTER_UPDATE") 
wm:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
wm:HookScript("OnEvent", function(self) 
local raid = GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > 0 
if (raid and (UnitIsGroupLeader (LE_PARTY_CATEGORY_HOME) or UnitIsGroupAssistant(LE_PARTY_CATEGORY_HOME))) or (GetNumSubgroupMembers (LE_PARTY_CATEGORY_HOME) > 0 and not raid) then 
self:Show() 
else 
self:Hide() 
end 
end) 

local wmmenuFrame = CreateFrame("Frame", "wmRightClickMenu", UIParent, "UIDropDownMenuTemplate") 
local wmmenuList = { 
    {text = "准备确认", 
    func = function() DoReadyCheck() end}, 
    {text = "角色检查", 
    func = function() InitiateRolePoll() end}, 
    {text = "转化为团队", 
    func = function() ConvertToRaid() end}, 
    {text = "转化为小队", 
    func = function() ConvertToParty() end}, 
} 

wm:SetScript('OnMouseUp', function(self, button) 
wm:StopMovingOrSizing() 
    if (button=="RightButton") then 
        EasyMenu(wmmenuList, wmmenuFrame, "cursor", -135, 0, "MENU", 2) 
    end 
end)

---------------------------------------------------------------------------------------
--	自身DEBUFF高亮显示
---------------------------------------------------------------------------------------
local function t_auras() 
   for i = 1,40 do 
   if _G["TargetFrameDebuff"..i.."Icon"] ~= nil then 
local caster = select(8,UnitDebuff("target",i)) 
   if caster == "player" then 
   _G["TargetFrameDebuff"..i.."Icon"]:SetVertexColor(1,1,1,1)  --SetAlpha(0.88) 
   else 
   _G["TargetFrameDebuff"..i.."Icon"]:SetDesaturated(1) 
      end 
   else 
      break 
   end 
      end 
end 
hooksecurefunc("TargetFrame_UpdateAuras", t_auras)

---------------------------------------------------------------------------------------
--	谁在点击小地图
---------------------------------------------------------------------------------------
local addon = CreateFrame('ScrollingMessageFrame', false, Minimap) 
addon:SetHeight(10) 
addon:SetWidth(100) 
addon:SetPoint('TOP', Minimap, 0, -15) 

addon:SetFont(STANDARD_TEXT_FONT, 12, 'OUTLINE') 
addon:SetJustifyH'CENTER' 
addon:SetJustifyV'CENTER' 
addon:SetMaxLines(1) 
addon:SetFading(true) 
addon:SetFadeDuration(3) 
addon:SetTimeVisible(5) 

addon:RegisterEvent'MINIMAP_PING' 
addon:SetScript('OnEvent', function(self, event, u) 
   local c = RAID_CLASS_COLORS[select(2,UnitClass(u))] 
   local name = UnitName(u) 
   addon:AddMessage(name, c.r, c.g, c.b) 
end)

---------------------------------------------------------------------------------------
--	任务栏自动收起/副本任务不收
---------------------------------------------------------------------------------------
local autocollapse = CreateFrame("Frame") 
autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD") 
autocollapse:SetScript("OnEvent", function(self) 
if IsInInstance() then 
ObjectiveTrackerFrame.userCollapsed = true 
ObjectiveTracker_Collapse() 
elseif IsInInstance() and not ScenarioBlocksFrame:IsVisible() then 
ObjectiveTrackerFrame.userCollapsed = nil 
ObjectiveTracker_Expand()
else
ObjectiveTrackerFrame.userCollapsed = nil 
ObjectiveTracker_Expand() 
end 
end)

---------------------------------------------------------------------------------------
--	单刷坐骑副本提示
---------------------------------------------------------------------------------------
local instList = { 
   [556] = 2,      -- 塞塔克大厅，乌鸦 
   [575] = 2,      -- 乌特加德之巅，蓝龙 
   [585] = 2,      -- 魔导师平台，白鸡 
   [603] = 4,      -- 奥杜尔，飞机头 
   [631] = 6,      -- 冰冠堡垒，无敌 
} 

local f = CreateFrame("Frame") 
f:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
f:RegisterEvent("PLAYER_DIFFICULTY_CHANGED") 
f:RegisterEvent("PLAYER_ENTERING_WORLD") 
f:SetScript("OnEvent", function() 
   local name, _, instType, diffname, _, _, _, id = GetInstanceInfo() 
   if IsInInstance() then 
      if instList[id] and instList[id] ~= instType then 
         UIErrorsFrame:AddMessage(name.."-"..diffname.." 你确定选对难度了？", 1, .1, .1) 
      end 
   end 
end)

---------------------------------------------------------------------------------------
--	右侧动作条隐藏
---------------------------------------------------------------------------------------
--[[local cfg = { 
    ["RlgithBarRight OnMouseOver"] = true, 
} 

local rightBarRight = CreateFrame("Frame","RightBarRightHold",UIParent, "SecureHandlerStateTemplate") 
      MultiBarRight:SetParent(rightBar) 
      MultiBarRightButton1:ClearAllPoints() 
      MultiBarRightButton1:SetPoint("TOPLEFT",rightBar) 

if cfg["RlgithBarRight OnMouseOver"] then 
  local function lighton(alpha) 
    if MultiBarRight:IsShown() then 
        for i=1, 12 do 
        local pb = _G["MultiBarRightButton"..i] 
            pb:SetAlpha(alpha) 
        end 
    end 
end 

    rightBarRight:EnableMouse(true) 
    rightBarRight:SetScript("OnEnter", function(self) lighton(0.5) end) 
    rightBarRight:SetScript("OnLeave", function(self) lighton(0) end) 
    for i=1, 12 do 
        local pb = _G["MultiBarRightButton"..i] 
            pb:SetAlpha(0) 
            pb:HookScript("OnEnter", function(self) lighton(0.5) end) 
            pb:HookScript("OnLeave", function(self) lighton(0) end) 
    end 
end]]--

--------------------------------------------
-- 小地图事件通报
--------------------------------------------
local an, at = ... 

  local addon = CreateFrame("Frame") 
  addon.vignettes = {} 

  local function OnEvent(self,event,id) 
    if id and not self.vignettes[id] then 
      local x, y, name, icon = C_Vignettes.GetVignetteInfoFromInstanceID(id) 
      local left, right, top, bottom = GetObjectIconTextureCoords(icon) 
      PlaySoundFile([[sound\events\scourge_horn.wav]], 'Master') 
      local str = "|TInterface\\MINIMAP\\OBJECTICONS:0:0:0:0:256:256:"..(left*256)..":"..(right*256)..":"..(top*256)..":"..(bottom*256).."|t" 
      RaidNotice_AddMessage(RaidWarningFrame, str..(name or "Unknown").."", ChatTypeInfo["RAID_WARNING"]) 
      print(str..name,"") 
      self.vignettes[id] = true 
    end 
  end 

  addon:RegisterEvent("VIGNETTE_ADDED") 
  addon:SetScript("OnEvent", OnEvent)

--------------------------------------------
-- 打断/偷取/驱散通报
--------------------------------------------
-- 模式选择 
local SoloMode = false      -- 单人模式,开启后当单独一人时会使用 说 通报... 
local WaringMode = true   -- 警报模式,开启后不管在什么队伍都会使用 说 通报... 
-- 默认信息 
function ShowSpellLink(SpellID) 
   local spellLink = GetSpellLink(SpellID or 0) or "<法术链接没有找到>" 
   DEFAULT_CHAT_FRAME:AddMessage(spellLink) 
end 
-- 主体 
local function OnEvent(self, event, ...) 
   if (event == "PLAYER_LOGIN") then 
      self:UnregisterEvent("PLAYER_LOGIN") 
      self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") 
   elseif (event == "COMBAT_LOG_EVENT_UNFILTERED") then 
      local ZoneInfo = select(2, IsInInstance()) 
      local EventType, SourceName, DestName, SpellID, ExtraskillID = select(2, ...), select(5, ...), select(9, ...), select(12, ...), select(15, ...) 
      if SourceName == UnitName("player") then 
         if EventType == "SPELL_INTERRUPT" then 
            Message = ("已打断◆%t◆：" .. GetSpellLink(ExtraskillID)) 
         elseif EventType == "SPELL_DISPEL" then 
            Message = ("已驱散◆%t◆：" .. GetSpellLink(ExtraskillID)) 
         elseif EventType == "SPELL_STOLEN" then 
            Message = ("已偷取◆%t◆：" .. GetSpellLink(ExtraskillID)) 
         end 
         if EventType == "SPELL_INTERRUPT" or EventType == "SPELL_DISPEL" or EventType == "SPELL_STOLEN" then 
            if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) and IsInInstance() then 
               if ZoneInfo == "pvp" or ZoneInfo == "raid" or ZoneInfo == "party" or ZoneInfo == nil then 
                  if WaringMode == true then 
                     SendChatMessage(Message, "SAY") 
                  else 
                     SendChatMessage(Message, "INSTANCE_CHAT") 
                  end 
               end 
            else 
               if IsInRaid() == true then 
                  if WaringMode == true then 
                     SendChatMessage(Message, "SAY") 
                  else 
                     SendChatMessage(Message, "RAID") 
                  end 
               elseif GetNumSubgroupMembers() ~= nil and GetNumSubgroupMembers() > 0 then 
                  if WaringMode == true then 
                     SendChatMessage(Message, "SAY") 
                  else 
                     SendChatMessage(Message, "PARTY") 
                  end 
               elseif ZoneInfo == "none" then 
                  if SoloMode == true then 
                     SendChatMessage(Message, "SAY") 
                  end 
               end 
            end 
         end 
      end 
   end 
end 
local Frame = CreateFrame("Frame") 
Frame:RegisterEvent("PLAYER_LOGIN") 
Frame:SetScript("OnEvent", OnEvent)

--------------------------------------------
-- 副本重置成功通报
--------------------------------------------
local success = gsub(INSTANCE_RESET_SUCCESS, "%%s", "") 
local failed = gsub(INSTANCE_RESET_FAILED, ".*%%s", "") 
local fail_offline = gsub(INSTANCE_RESET_FAILED_OFFLINE, ".*%%s", "") 
local fail_zone = gsub(INSTANCE_RESET_FAILED_ZONING, ".*%%s", "") 

local function Echo(self, event, ...) 
   local instance = ... 

   if event == "CHAT_MSG_SYSTEM" then 
      if UnitIsGroupLeader("player") and (strfind(instance, success) or strfind(instance, failed) or strfind(instance, fail_offline) or strfind(instance, fail_zone)) then 
         SendChatMessage("副本重置成功！"..instance, "PARTY") 
      end 
   end 
end 

local f = CreateFrame("Frame") 
f:RegisterEvent("CHAT_MSG_SYSTEM") 
f:SetScript("OnEvent", Echo)

--------------------------------------------
-- 不再显示XX制作
--------------------------------------------
ITEM_CREATED_BY=""

--------------------------------------------
-- 打开银行自动存材料
--------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("BANKFRAME_OPENED")
frame:SetScript("OnEvent", function(self, event, ...)
	if not BankFrameItemButton_Update_OLD then
		BankFrameItemButton_Update_OLD = BankFrameItemButton_Update
		
		BankFrameItemButton_Update = function(button)
			if BankFrameItemButton_Update_PASS == false then
				BankFrameItemButton_Update_OLD(button)
			else
				BankFrameItemButton_Update_PASS = false
			end
		end
	end
	
	BankFrameItemButton_Update_PASS = true
	DepositReagentBank()
	--print("Reagents deposited into Reagent Bank.")
end)

-------------------------------------------
-- 低血量报警
-------------------------------------------
function RunicPercent_OnLoad() 
end 
    hpframe = CreateFrame("Frame","Frame", WorldFrame) 
    hpframe:SetPoint("CENTER") 
    hpframe:SetWidth(40) 
    hpframe:SetHeight(40) 
    hpframe:Hide() 
    hpframe:SetScale(1) -- this does not effect the text size. 
    hpFrameText = hpframe:CreateFontString(nil,"ARTWORK"); 
    hpFrameText:SetFontObject(GameFontNormal); 
    hpFrameText:SetFont("Fonts\\HOOGE3.TTF", 30,"outline") 
    hpFrameText:SetTextColor(0.8,0,0,1) 
    hpFrameText:SetPoint("CENTER",UIParent,"CENTER",0,100) 
    hpframe:SetScript("OnEvent", function(self, event, arg1,arg2, ...) 
    if event == "UNIT_HEALTH" then 
        hpFrameText:SetText(format("%d",UnitHealth("player")/UnitHealthMax("player")*100).."%") 
    end 
local hp = UnitHealth("player") / UnitHealthMax("player") 
    if hp > 0.60 then 
        hpframe:Hide() 
    else 
        hpframe:Show() 
    end 
end) 
    hpframe:RegisterEvent("UNIT_HEALTH") 
    hpframe:RegisterEvent("PLAYER_ENTERING_WORLD") 
    RunicPercent_OnLoad() 

-------------------------------------------
-- 自身能量资源监控
-------------------------------------------
local _, class = UnitClass("player") 
    function RunicPercent_OnLoad() 
end 
    mpframe = CreateFrame("Frame","Frame", WorldFrame) 
    mpframe:SetPoint("CENTER") 
    mpframe:SetWidth(40) 
    mpframe:SetHeight(40) 
    mpframe:Hide() 
    FrameText = mpframe:CreateFontString(nil,"ARTWORK"); 
    FrameText:SetFontObject(GameFontNormal); 
    FrameText:SetFont("Fonts\\HOOGE3.TTF", 30,"outline") 
    FrameText:SetTextColor(1,0,0.22,1) -- 颜色 
    FrameText:SetPoint("BOTTOMRIGHT",UIParent,"CENTER",0,-129.5 ) --位置 
    mpframe:SetScript("OnEvent", function(self, event, arg1,arg2, ...) 
    if event == "UNIT_POWER" then 
        FrameText:SetText(format("%d",UnitPower("player")).."") 
    end 
local mp = UnitPower("player") / UnitPowerMax("player") 
    if mp < 1 then 
        mpframe:Show() 
    end 
    if mp == 1 then 
        mpframe:Hide() 
    end 
    if mp == 0 then 
        mpframe:Hide() 
    end 
end)
mpframe:RegisterEvent("UNIT_POWER") 
mpframe:RegisterEvent("PLAYER_ENTERING_WORLD") 
RunicPercent_OnLoad() 
    if class == "ROGUE" then 
        FrameText:SetTextColor(0.88,0.88,0.22,1)end --DZ 
    if class == "WARRIOR" then 
        FrameText:SetTextColor(195/255,0,0,1)end --ZS 
    if class == "HUNTER" then 
        FrameText:SetTextColor(195/255,99/255,49/255,1)end --LR 
    if class == "DEATHKNIGHT" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --DK 
    if class == "DRUID" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --XD 
    if class == "MAGE" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --FS 
    if class == "MONK" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --WS 
    if class == "PALADIN" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --QS 
    if class == "PRIEST" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --MS 
    if class == "SHAMAN" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --SM 
    if class == "WARLOCK" then 
        FrameText:SetTextColor(0.88,0.88,0.22,0)end --SS

-----------------------------------------------------
-- 对目标释放自身的Buff&Debuff着色，其他非玩家本身释放的Buff&Debuff都会黑白无色
-----------------------------------------------------
local function t_auras()
	for i = 1,40 do
	if _G["TargetFrameDebuff"..i.."Icon"] ~= nil then
local caster = select(8,UnitDebuff("target",i)) 
	if caster == "player" then
	_G["TargetFrameDebuff"..i.."Icon"]:SetVertexColor(1,1,1,1)  --SetAlpha(0.88)
else
	_G["TargetFrameDebuff"..i.."Icon"]:SetDesaturated(1)
end
else
break
end
end
end
hooksecurefunc("TargetFrame_UpdateAuras", t_auras)