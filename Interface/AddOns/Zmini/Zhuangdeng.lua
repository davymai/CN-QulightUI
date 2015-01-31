--Inspect iLevels
local F = CreateFrame('Frame')
local slot = {'Head','Neck','Shoulder','Shirt','Chest','Waist','Legs','Feet','Wrist','Hands','Finger0','Finger1','Trinket0','Trinket1','Back','MainHand','SecondaryHand','Tabard'}
local levelAdjust={
   ["000"]=00,["001"]=08,["373"]=04,["374"]=08,["375"]=04,["376"]=04,["377"]=04,["379"]=04,
   ["380"]=04,["445"]=00,["446"]=04,["447"]=08,["451"]=00,["452"]=08,["453"]=00,["454"]=04,
   ["455"]=08,["456"]=00,["457"]=08,["458"]=00,["459"]=04,["460"]=08,["461"]=12,["462"]=16,
   ["465"]=00,["466"]=04,["467"]=08,["468"]=00,["469"]=04,["470"]=08,["471"]=12,["472"]=16,
   ["491"]=00,["492"]=04,["493"]=08,["494"]=04,["495"]=08,["496"]=08,["497"]=12,["498"]=16,
   ["504"]=12,["505"]=16,["506"]=20,["507"]=24,
}
local bonus ={
   ["40"]="闪",["41"]="吸",["42"]="速",["43"]="磨",["499"]="火",["523"]="槽",["560"]="火",["561"]="火",["562"]="火",["563"]="槽",["564"]="槽",["565"]="槽",
}
local bonus1 ={
   ["566"]="英雄",["567"]="史诗",["74"]="狂野 暴击溅射",["85"]="狂野 暴击溅射",["489"]="残酷 全溅射",["163"]="曙光 急速全能",["215"]="谐律 全能精通", --525 530 里面有一个督军监制 
}

local chuajiabao ={
   ["55690"]="556",["55691"]="562",["55692"]="569",["55693"]="575", ["55694"]="", ["55695"]="", ["55696"]="", ["55697"]="",["55698"]="",["55699"]="",["556100"]="",
   ["56990"]="569",["56991"]="574",["56992"]="579",["56993"]="584", ["56994"]="", ["56995"]="", ["56996"]="", ["56997"]="",["56998"]="",["56999"]="",["569100"]="",
   ["56990"]="582",["56991"]="574",["56992"]="579",["56993"]="", ["56994"]="", ["56995"]="", ["56996"]="", ["56997"]="",["56998"]="",["56999"]="",["569100"]="",
   }


local function CreateIlvText(slotName) 
local f = _G[slotName] 
f.ilv = f:CreateFontString(nil, 'OVERLAY')
f.ilv:SetPoint('TOP', f, 'TOP', 1, 2) 
f.ilv:SetFont(Qulight["media"].pxfont, 13, 'THINOUTLINE')
f.ilv1 = f:CreateFontString(nil, 'OVERLAY') 
f.ilv1:SetPoint('BOTTOM', f, 'BOTTOM',-1 , 13) 
f.ilv1:SetFont(STANDARD_TEXT_FONT, 11, 'THINOUTLINE')
--f.ilv:SetTextColor(0,1,0.6,1) 
end 


local function GetActualItemLevel(link, baseLevel)
   local upgrade = select(1,strsplit(":", select(11,strsplit(":", string.match(link, "item[%-?%d:]+")))))
   if not upgrade then return baseLevel end
   return baseLevel + (levelAdjust[upgrade] or 0)
end

local function GetShuxing(link)
   local geshu = select(1,strsplit(":", select(13,strsplit(":", string.match(link, "item[%-?%d:]+")))))
   local bo,bos=0,""
		if tonumber(geshu) > 0 then
			for i = 1 , geshu do
			bo =select(1,strsplit(":", select(13+i,strsplit(":", string.match(link, "item[%-?%d:]+")))))
			if bonus[bo] then bos=format("%s%s%s", bos,"  ",bonus[bo]) end
			end
		end
   return format("%s",bos)
end


local function CheckItem(unit, frame)
   if unit then
      for k, v in pairs(slot) do
         local f = _G[frame..v..'Slot']
         local itemLink = GetInventoryItemLink(unit, k)
         if  itemLink then
		    local Name, _, itemQuality, baseLevel,_,itemType = GetItemInfo(itemLink) 
			if itemQuality == 7 and string.find(Name,"地狱咆哮的") == 1 then
            baseLevel = baseLevel + math.floor((620-baseLevel)/10 * (UnitLevel("player")-90)+0.5)
            f.ilv:SetText(GetActualItemLevel(itemLink, baseLevel)) 
            f.ilv:SetTextColor(GetItemQualityColor(itemQuality))
			elseif itemType and baseLevel and baseLevel > 1 then
			f.ilv:SetTextColor(GetItemQualityColor(itemQuality))
            f.ilv:SetText(GetActualItemLevel(itemLink, baseLevel))
			f.ilv1:SetTextColor(GetItemQualityColor(itemQuality))
            f.ilv1:SetText(GetShuxing(itemLink))
			else
			f.ilv:SetText()
			f.ilv1:SetText()
			end 
		 else
            f.ilv:SetText()
			f.ilv1:SetText()
         end
      end
   end
end

for _, v in pairs(slot) do CreateIlvText('Character'..v..'Slot') end

CharacterFrame:HookScript('OnShow', function(self)
CheckItem('player', 'Character')
self:RegisterEvent('PLAYER_EQUIPMENT_CHANGED')
end)

CharacterFrame:HookScript('OnHide', function(self)
self:UnregisterEvent('PLAYER_EQUIPMENT_CHANGED')
end)

CharacterFrame:HookScript('OnEvent', function(self, event)
if event ~= 'PLAYER_EQUIPMENT_CHANGED' then return end
CheckItem('player', 'Character')
end)


F:RegisterEvent('ADDON_LOADED')
F:SetScript('OnEvent', function(self, event, addon)
   if addon == 'Blizzard_InspectUI' then
      for k, v in pairs(slot) do CreateIlvText('Inspect'..v..'Slot') end
      CheckItem(_G['InspectFrame'].unit, 'Inspect')
      _G['InspectFrame']:HookScript('OnShow', function()
         CheckItem(_G['InspectFrame'].unit, 'Inspect')
         self:RegisterEvent('INSPECT_READY')
         self:RegisterEvent('UNIT_MODEL_CHANGED')
         self:RegisterEvent('PLAYER_TARGET_CHANGED')
         self:SetScript('OnEvent', function() CheckItem(_G['InspectFrame'].unit, 'Inspect') end)
      end)
      _G['InspectFrame']:HookScript('OnHide', function()
         self:UnregisterEvent('PLAYER_TARGET_CHANGED')
         self:UnregisterEvent('UNIT_MODEL_CHANGED')
         self:UnregisterEvent('INSPECT_READY')
         self:SetScript('OnEvent', nil)
      end)
      self:UnregisterEvent('ADDON_LOADED')
      self:SetScript('OnEvent', nil)
   end
end)