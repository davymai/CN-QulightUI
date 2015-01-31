local M,L = unpack(select(2,...))

local pairs = pairs
local _G = _G

-- null function
M.null = function() end

-- destroy function
M.kill = function(self,donthide,point)
	if not self then return end
	if self.UnregisterAllEvents then self:UnregisterAllEvents() end
	if self.SetPoint and not(point) then self.SetPoint = M.null end
	if self.Show then self.Show = M.null end
	if not donthide then self:Hide() end
	if self.Hide then self.Hide = M.null end
end

--Check nils
M.check_nil = function(var,x)
	if var == nil then 
		if x == nil then x = true end
		return x
	else
		return var 
	end
end

--Worgen!!!
M.fixworgen = function(self)
	local model = self:GetModel()
	if not model then self:SetCamera(0) return end
	if not model.find then self:SetCamera(0) return end
	if not model:find("worgenmale") then self:SetCamera(0) return end
	self:SetCamera(1)
end

--destroy self textures
M.un_custom_regions = function(self,start,stop)
	for i=start,stop do
		local x = select(i,self:GetRegions())
		if x.SetTexture then
			x:SetTexture(nil)
		end
	end
end

local find = string.find
M.untex = function(self,force)
	if not self then return end
	local a = self:GetNumRegions()
	if not a or a == 0 then return end
	for i=1,a do
			local x = select(i,self:GetRegions())
			if x.SetTexture and not(x:GetName() and find(x:GetName(),"Icon")) then
				x:SetTexture(nil)
				--x.SetTexture = M.null
				--x.Show = M.null
				x:Hide()
				
			elseif x.SetFont and not force then
				x:SetText(nil)
				--x.SetText = M.null
				x:Hide()
			end
			-- if x.SetFont and force then
				-- print(i)
			-- end
	end
end

local _enter = function(self)
	self.bg:backcolor(self.bg.r,self.bg.g,self.bg.b,.8)
end
local _leave = function(self)
	self.bg:backcolor(0,0,0)
end
local __enter = function(self)
	self:backcolor(self.r,self.g,self.b,.8)
	if self.text then 
		self.text:SetTextColor(self.r,self.g,self.b)
	end	
end
local __leave = function(self)
	self:backcolor(0,0,0)
	if self.text then 
		self.text:SetTextColor(1,1,1)
	end	
end
M.enterleave = function(self,r,g,b,button)
	if not self.bg or button then 
		self:HookScript("OnEnter",__enter)
		self:HookScript("OnLeave",__leave)
		self.r = r or 1
		self.g = g or 1
		self.b = b or 1
	else
		self:HookScript("OnEnter",_enter)
		self:HookScript("OnLeave",_leave)
		self.bg.r = r or 1
		self.bg.g = g or 1
		self.bg.b = b or 1
	end
end

local tex_scroll = function(self)
	if self.bg then return end
	M.untex(self)
	local x = M.frame(self,self:GetFrameLevel(),self:GetFrameStrata())
	x:points()
	self.bg = x
	M.enterleave(self,1,1,1)
end
	
M.unscroll = function(frame)
	local name = frame:GetName()
	local _G = _G
	if _G[name.."BG"] then _G[name.."BG"]:SetTexture(nil) end
	if _G[name.."Track"] then _G[name.."Track"]:SetTexture(nil) end
	if _G[name.."Top"] then
		_G[name.."Top"]:SetTexture(nil)
		_G[name.."Bottom"]:SetTexture(nil)
		_G[name.."Middle"]:SetTexture(nil)
	end
	if _G[name.."ScrollDownButton"] then
		tex_scroll(_G[name.."ScrollDownButton"])
	end
	if _G[name.."ScrollUpButton"] then
		tex_scroll(_G[name.."ScrollUpButton"])
	end
	if frame:GetThumbTexture() then
			frame:GetThumbTexture():SetTexture(nil)
			if not frame.bg then
				frame.bg = M.frame(frame,frame:GetFrameLevel(),frame:GetFrameStrata())
				frame.bg:points(frame:GetThumbTexture())
				M.enterleave(frame,1,1,1)
			end
	end	
end

-- DropDownMenuTemplate
local menuFrame = CreateFrame("Frame", "DerpyDownMenu", UIParent, "UIDropDownMenuTemplate")
M.menuframe = menuFrame

-- Get iLvL
do
	local flo = math.floor
	local GetInventorySlotInfo = GetInventorySlotInfo
	local GetItemInfo = GetItemInfo
	local SlotName = {
			"Head","Neck","Shoulder","Back","Chest",
			"Wrist","Hands","Waist","Legs","Feet",
			"Finger0","Finger1","Trinket0","Trinket1",
			"MainHand","SecondaryHand","Ranged","Ammo"}
	M.iLVL = function(unit)
		local total,item = 0,0
		for i=1, #SlotName do
			local slot = GetInventoryItemLink(unit,GetInventorySlotInfo(SlotName[i].."Slot"))
			if( slot ~= nil ) then
				item = item + 1
				total = total + select(4,GetItemInfo(slot ))
			end
		end
		if item > 0 then
			return " - |cffeeee22iLvL: "..flo(total/item).."|r"
		else
			return ""
		end
	end
end