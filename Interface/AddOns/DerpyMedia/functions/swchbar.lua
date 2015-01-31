-- M.makevarbar( PARENT, WIDTH, MINIMUM, MAXIMUM, TABLE, VARNAME(IN TABLE), NAME, LAYMOD) -- returns bar
local M = unpack(select(2,...))
local colors = M.media.button

local setbg = function(frame,r,g,b,a)
	frame:SetBackdrop(M.bg)
	frame:SetBackdropColor(r,g,b,a)
	frame:SetBackdropBorderColor(r,g,b,a)
end

local setbar_value = function(self)
	local mm = self.end_modif
	local mods = self.act*((self.value[self.var]-mm)/(self.max))+2
	if mods > 7 and mods <= self.act then
		self:SetWidth(mods)
	elseif mods > self.act then
		self:SetWidth(self.act)
	else
		self:SetWidth(6)
	end
	self.text:SetText(((self.value[self.var])*self.lay_mod)..self.suff)
	if self.function_ then self.function_() end
end

local __fin = function(self) self.pa:Hide() end
local anim = function(self,off)
	self.in_s = self:CreateAnimationGroup("IN")
	self.in_s.a = self.in_s:CreateAnimation("Translation")
	self.in_s.a:SetOffset(-off,0)
	self.in_s.a:SetDuration(0)
	self.in_s.a:SetOrder(1)
	self.in_s.c = self.in_s:CreateAnimation("ALPHA")
	self.in_s.c:SetChange(-1)
	self.in_s.c:SetOrder(1)
	self.in_s.c:SetDuration(0)
	self.in_s.b = self.in_s:CreateAnimation("Translation")
	self.in_s.b:SetOffset(off,0)
	self.in_s.b:SetDuration(.4)
	self.in_s.b:SetOrder(2)
	self.in_s.b:SetSmoothing("OUT")
	self.in_s.d = self.in_s:CreateAnimation("ALPHA")
	self.in_s.d:SetChange(1)
	self.in_s.d:SetOrder(2)
	self.in_s.d:SetDuration(.4)
	self.in_s_ = self:CreateAnimationGroup("OUT")
	self.in_s_.a = self.in_s_:CreateAnimation("Translation")
	self.in_s_.a:SetOffset(off,0)
	self.in_s_.a:SetDuration(.4)
	self.in_s_.a:SetOrder(1)
	self.in_s_.c = self.in_s_:CreateAnimation("ALPHA")
	self.in_s_.c:SetChange(-1)
	self.in_s_.c:SetOrder(1)
	self.in_s_.c:SetDuration(.4)
	self.in_s_.pa = self
	self.in_s_:SetScript("OnFinished",__fin)
end

local reset_var = function(self,c)
	local mm = self.end_modif
	self.value[self.var] = self.value[self.var] + c
	if self.value[self.var] > self.max + mm then
		self.value[self.var] = self.max + mm
	elseif self.value[self.var] < self.min + mm then
		self.value[self.var] = self.min + mm
	end
	setbar_value(self)
end

local bar_holder_enter = function(self)
	if self.focused == true then return end
	self.focused = true 
	self.mainbar.text:SetText((self.mainbar.value[self.mainbar.var]*self.mainbar.lay_mod)..self.mainbar.suff)
	self.l.in_s_:Stop()
	self.r.in_s_:Stop()
	self.r:Show()
	self.l:Show()
	self.l.in_s:Play()
	self.r.in_s:Play()
end

local bt_enter = function(self) 
	self.text:SetTextColor(0,1,1)
	bar_holder_enter(self:GetParent():GetParent())
end

local GetMouseFocus = GetMouseFocus	
local bar_holder_leave = function(self)
	local _t = GetMouseFocus()
	if _t then
		if _t == self then return end
		if _t:GetParent() then 
			if _t:GetParent():GetParent() then 
				if _t:GetParent():GetParent() == self then return end
			end
		end
	end
	self.focused = false
	self.mainbar.text:SetText(self.name_)
	self.l.in_s:Stop()
	self.r.in_s:Stop()
	self.l.in_s_:Play()
	self.r.in_s_:Play()
end

local bt_leave = function(self) 
	self.text:SetTextColor(1,1,1) 
	bar_holder_leave(self:GetParent():GetParent())
end

local bt_up = function(self) self.tsg:Hide() end

local bt_on_updater = function(sel,t)
		sel.N = sel.N - t
	if sel.N > 0 then return end
		sel.N = sel.mult
		sel.mod = sel.mod + 1
	if sel.mod == 10 then
		sel.mult = .08
	elseif sel.mod == 30 then
		sel.mult = .03
	end
	reset_var(sel.self_,sel._c)
end

local bt_down = function(button)
	reset_var(button.tsg.self_,button.tsg._c)
	button.tsg.N = .7
	button.tsg.mod = 2
	button.tsg.mult = .2
	button.tsg:Show()
end

local mk_button = function(self,ts,c,point,x,y,rpoint,cor)
	local parent = self:GetParent()
	local button = CreateFrame("Frame",nil,parent)
	button:EnableMouse(true)
	button.tsg = CreateFrame('Frame',nil,button)
	button.tsg.self_ = self
	button.tsg:Hide()
	button.tsg._c = c
	button:SetSize(22,16)
	button:SetPoint(point,parent,rpoint,x,y)
	local text = button:CreateFontString(nil,"OVERLAY")
	text:SetFont(M["media"].font_s,28)
	text:SetText(ts)
	text:SetPoint("CENTER",cor+.3,-.3)
	button.text = text
	button:SetScript("OnEnter",bt_enter)
	button:SetScript("OnLeave",bt_leave)
	button:SetScript("OnMouseUp",bt_up)
	button.tsg:SetScript("OnUpdate",bt_on_updater)
	button:SetScript("OnMouseDown",bt_down)
	anim(text,30*c)
	text:Hide()
	return text
end

M.makevarbar = function(parent,sizex,min,max,table_,var,name,lay_mod,suff)
	local bar_holder = CreateFrame("Frame",nil,parent)
	local level = parent:GetFrameLevel()+3
	sizex = sizex + 20
	bar_holder:SetFrameLevel(level)
	bar_holder:SetSize(sizex,34)
	
	local bar_backdrop = CreateFrame("Frame",nil,bar_holder)
		bar_backdrop:SetPoint("BOTTOMLEFT",26,8)
		bar_backdrop:SetPoint("BOTTOMRIGHT",-26,8)
		bar_backdrop:SetHeight(11)
	setbg(bar_backdrop,unpack(colors[3]))
	local main = CreateFrame("Frame",nil,bar_backdrop)
		main:SetPoint("BOTTOMLEFT")
		main:SetPoint("TOPLEFT")
		main:SetFrameLevel(level+3)
	setbg(main,unpack(colors[4]))
	bar_holder.mainbar = main
	
	the_text = M.setfont_lang(main,14,nil,nil,"CENTER")
	the_text:SetPoint("BOTTOM",bar_backdrop,"TOP",.3,-1)
	main.text = the_text
	
	local end_modif = 0
	if min <0 then
		end_modif = min
		min = 0
		max = max - end_modif
	end
	
	main.lay_mod = lay_mod or 1
	main.max = max
	main.min = min
	main.end_modif = end_modif
	main.act = sizex - 52
	main.value = table_
	main.var = var
	main.suff = suff or ""
	setbar_value(main)
	the_text:SetText(name)
	
	bar_holder.name_ = name
	bar_holder.focused = false
	bar_holder.l = mk_button(main,"<",-1,"RIGHT",4,0,"LEFT",1)
	bar_holder.r = mk_button(main,">",1,"LEFT",-3.5,0,"RIGHT",-1)
	bar_holder:EnableMouse(true)
	bar_holder:SetScript("OnEnter",bar_holder_enter)
	bar_holder:SetScript("OnLeave",bar_holder_leave)
	return bar_holder
end
