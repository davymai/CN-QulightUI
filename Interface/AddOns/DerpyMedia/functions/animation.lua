-- animation not ready yet
local M = unpack(select(2,...))

M.anim_alpha = function(a,name,ord,t,ch)
	local x = a:CreateAnimation("ALPHA")
	x:SetChange(ch)
	x:SetDuration(t)
	x:SetOrder(ord)
	a[name] = x
end

M.anim_trans = function(a,name,ord,t,sm,ox,oy)
	local x = a:CreateAnimation("Translation")
	x:SetDuration(t)
	x:SetOrder(ord)
	x:SetSmoothing(sm or "NONE")
	if ox and oy then
		M.addafter(function() 
			x:SetOffset(ox*M.scale,oy*M.scale)
		end)
	end
	a[name] = x
end

M.set_anim  = function (self,k,x,y)
	self.anim = self:CreateAnimationGroup("Move_In")
	M.anim_trans(self.anim,"in_a",1,0,nil,x,y)
	M.anim_trans(self.anim,"in_b",2,.3,"OUT",-x,-y)
	self.anim_o = self:CreateAnimationGroup("Move_Out")
	M.anim_trans(self.anim_o,"b",1,.3,"IN",x,y)
	if k then self.anim_o:SetScript("OnFinished",function() self:Hide() end) end
end

local UIFrameFadeOut = UIFrameFadeOut
local UIFrameFadeIn = UIFrameFadeIn
local InCombatLockdown = InCombatLockdown

local OnUpdate = function(self)
	if self.parent:GetAlpha() == 0 then 
		if InCombatLockdown() and self.lock then return end
		self:Hide()
		self.hiding = false
		self.parent:hide()
	end
end

local to_hide = function(self)
	if self.hiding == true then return end
	if self:GetAlpha() == 0 then self:hide() return end
	UIFrameFadeOut(self,self.time,self.state_alpha,0)
	self.hiding = true
	self.pl_watch_frame:Show()
end

local to_show = function(self)
	if self:IsShown() and not(self.hiding) then return end 
	if self.showing then return end
	self.hiding = false
	self.pl_watch_frame:Hide()
	UIFrameFadeIn(self,self.time,0,self.state_alpha)
end

M.make_plav = function(self,time,lock,alpha)
	if self.pl_watch_frame then return end
	self.pl_watch_frame = CreateFrame("Frame",nil,self)
	self.pl_watch_frame:Hide()
	self.pl_watch_frame.lock = lock
	self.pl_watch_frame.parent = self
	self.state_alpha = alpha or self:GetAlpha()
	self.hide = self.Hide
	self.time = time
	self.Hide = to_hide
	self.show = to_show
	self.pl_watch_frame:SetScript("OnUpdate",OnUpdate)
end

local smooth = function(mode,x,y,z)
	return mode == true and 1 or max((10 + abs(x - y)) / (88.88888 * z), .2) * 1.1
end

M.simple_move = function(self,t)
	self.pos = self.pos + t * self.speed * smooth(self.smode,self.limit,self.pos,.5)
	self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.pos or self.alt or 0,not(self.hor) and self.pos or self.alt or 0)
	if self.pos * self.mod >= self.limit * self.mod then
		self:SetPoint(self.point_1,self.parent,self.point_2,self.hor and self.limit or self.alt or  0,not(self.hor) and self.limit or self.alt or 0)
		self.pos = self.limit
		self:SetScript("OnUpdate",nil)
		if self.finish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

M.simple_width = function(self,t)
	self.wpos = self.wpos + t * self.wspeed * smooth(self.smode,self.wlimit,self.wpos,1)
	self:SetWidth(self.wpos)
	if self.wpos * self.wmod >= self.wlimit * self.wmod then
		self:SetWidth(self.wlimit)
		self.wpos = self.wlimit
		self:SetScript("OnUpdate",nil)
		if self.wfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end

M.simple_height = function(self,t)
	self.hpos = self.hpos + t * self.hspeed * smooth(self.smode,self.hlimit,self.hpos,1)
	self:SetHeight(self.hpos)
	if self.hpos * self.hmod >= self.hlimit * self.hmod then
		self:SetHeight(self.hlimit)
		self.hpos = self.hlimit
		self:SetScript("OnUpdate",nil)
		if self.hfinish_hide then
			self:Hide()
		end
		if self.finish_function then
			self:finish_function()
		end
	end
end