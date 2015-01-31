local _table
local M = unpack(select(2,...))
local floor = floor
local DB 
local register = {}
local pos_list = CreateFrame("Frame",nil,UIParent)
--[[
M.addenter(function()
	if not _G.DerpyPosVars then
		_G.DerpyPosVars = {}
	end
	DB = _G.DerpyPosVars
end) ]]--

local _write = function(self)
	if not _table then print("Слишком рано!!!") return end
	if self._size_mod then
		self:_StopMovingOrSizing()
	end
	local a = {}
	local name = self.realname
	if not name then print(self,"- Имя не найдено, возврат") return end
	_table[name] = a
	local temp
	a[1],temp,a[3],a[4],a[5] = self:GetPoint()
	temp = temp or _G.UIParent
	a[2] = temp:GetName()
	a[4] = floor(a[4]+.5)
	a[5] = floor(a[5]+.5)
	if self.size_to then
		if not a[6] then return end
		a[6],a[7] = floor(self:GetWidth()+.5),floor(self:GetHeight()+.5)
	end
end

local _read = function(self,a)
	if not self then return end
	if not self.ClearAllPoints then return end
	self:ClearAllPoints()
	self:SetPoint(a[1],_G[a[2]],a[3],a[4],a[5])
	if self.size_to then 
		self:SetSize(a[6],a[7])
	end
end
--[[
M.addlast(function()
	if not DB then DB = {} end
	_table = DB
	for p,t in pairs(_table) do
		if register[p] then
			_read(register[p],t)
		elseif _G[p] then
			_read(_G[p],t)
		end
	end
end)
]]--
M.make_savepos = function(self,size,t)
	self._StopMovingOrSizing = self.StopMovingOrSizing
	self.StopMovingOrSizing = _write
	self._size_mod = true
	if t then
		self:EnableMouse(true)
	end
	self.size_to = size
end

local stop = function(self) 
	self:StopMovingOrSizing() 
	self.moved = true;
end

M.make_movable = function(self,t)
	self:SetMovable(true)
	self:SetScript("OnMouseDown",self.StartMoving)
	self._stooooop = stop
	self:SetScript("OnMouseUp",self._stooooop)
	if t then
		self:EnableMouse(true)
	end
end

M.write_pos = _write

local movers_table = {}
local cc = 1

M.tex_move = function(self,name,func)
	local t = self:CreateTexture(nil,"OVERLAY")
	t:SetAllPoints()
	t:SetTexture(0,.7,1,.7)
	local te = M.setfont(self,24)
	te:SetText(name)
	te:SetPoint("CENTER")
	te:Hide()
	t:Hide()
	
	register[self.realname] = self;
	
	self.t1 = t;
	self.t2 = te;
	self.t3 = func or M.null
	
	movers_table[cc] = self
	cc = cc + 1
end

local unlock_pos_now = function()
	for i=1, #movers_table do
		local a = movers_table[i]
		a:EnableMouse(true);
		a:Show();
		a.t1:Show();
		a.t2:Show();
	end
end

local wv = M.write_pos
local lock_pos_now = function(as)
	for i=1, #movers_table do
		local a = movers_table[i]
		a:EnableMouse(false);
		a:t3()
		a.t1:Hide();
		a.t2:Hide();
		if not as and a.moved then
			a.moved = nil; wv(a)
		end
	end
	pos_list:check_list()
end

local control_frame = M.frame(UIParent,1,"HIGH")
control_frame:SetSize(300,54)
control_frame:SetPoint("BOTTOM",0,-60)
control_frame:EnableMouse(true)

control_frame.point_1 = "BOTTOM"
control_frame.point_2 = "BOTTOM"
control_frame.pos = -60
control_frame.parent = UIParent
control_frame:Hide()

local on_update = M.simple_move
	
control_frame.show = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = 1
	self.limit = -5
	self.speed = 60
	self.finish_hide = nil
	self:Show()
	self:SetScript("OnUpdate",on_update)
end
	
control_frame.hide = function(self)
	self:SetScript("OnUpdate",nil)
	self.mod = -1
	self.limit = -60
	self.speed = -60
	self.finish_hide = true
	self:SetScript("OnUpdate",on_update)
end

local save = CreateFrame("Button","DerpySavePosButton",control_frame)
M.ChangeTemplate(save)
save:SetSize(122,40)
save:SetPoint("LEFT",control_frame,20,0)
M.enterleave(save,0,1,1,true)

local st = M.setfont(save,21)
st:SetPoint("CENTER",1,1)
st:SetText("SAVE")
save.text = st

local disc = CreateFrame("Button","DerpyDiscPosButton",control_frame)
M.ChangeTemplate(disc)
disc:SetSize(122,40)
disc:SetPoint("RIGHT",control_frame,-20,0)
M.enterleave(disc,1,0,0,true)

local st = M.setfont(disc,21)
st:SetPoint("CENTER",1,1)
st:SetText("DISCARD")
disc.text = st

local is_locked = true

M.switch_lock = function()
	if is_locked~=true then
		lock_pos_now()
		is_locked = true
		control_frame:hide()
	elseif is_locked==true then
		unlock_pos_now()
		is_locked = false
		control_frame:show()
	end
end

save:SetScript("OnClick",function()
	if is_locked == true then return end
	is_locked = true
	lock_pos_now()
	control_frame:hide()
end)

disc:SetScript("OnClick",function()
	if is_locked == true then return end
	ReloadUI()
end)

SlashCmdList.ALLEYPOSLIST = function()
	for d in pairs(DB) do
		print(d)
	end
end
SLASH_ALLEYPOSLIST1 = "/pyposlist"

SlashCmdList.ALLEYPOSRM = function(name)
	local a = DB[name]
	if a then 
		DB[name] = nil; a = nil; print(name.." - removed!")
	else
		print(name.." - not found!")
	end
end
SLASH_ALLEYPOSRM1 = "/pyposrm"

pos_list:SetWidth(380)
pos_list:SetHeight(32)
pos_list._ppso = -1
pos_list.buttons = {}

pos_list.rec = function(self)
	pos_list._ppso = pos_list._ppso + 1;
	pos_list:SetHeight(26+pos_list._ppso*26)
	return -(26*pos_list._ppso)
end

local h = true
local total = 0
local rem_enter = function(self) self:GetParent().rem:SetTextColor(1,1,1) end
local rem_leave = function(self) self:GetParent().rem:SetTextColor(1,0,0) end

local rem_click = function(self) 
	_G.DerpyPosVars[self:GetParent().ref] = nil; 
	self:Hide()
	self:GetParent().rem:SetTextColor(.3,.3,.3)
end

pos_list.gen_info = function(self)
	local x = CreateFrame("Frame",nil,self)
	x:SetSize(380,26)
	x:SetPoint("TOP",self,0,self:rec())
	x:SetBackdrop({bgFile = M.media.blank})
	
	if h then
		x:SetBackdropColor(.3,.3,.3,.2); h = false;
	else
		x:SetBackdropColor(.3,.3,.3,.4); h = true;
	end
	
	local title = M.setfont(x,15)
	title:SetPoint("LEFT",3.3,.3)
	
	local rem = M.setfont(x,15)
	rem:SetPoint("RIGHT",-4.3,.3)
	rem:SetText("REMOVE")
	rem:SetTextColor(1,0,0)
	
	x.title = title;
	x.rem = rem;
	
	local rem_bt = CreateFrame("Button",nil,x)
	rem_bt:SetAllPoints(x.rem)
	rem_bt:RegisterForClicks("AnyUp");
	rem_bt:SetScript("OnEnter",rem_enter)
	rem_bt:SetScript("OnLeave",rem_leave)
	rem_bt:SetScript("OnClick",rem_click)
	
	x.rem_bt = rem_bt
	total = total + 1
	self.buttons[total] = x;
end

pos_list.check_list = function(self)
	local a = 0;
	for t,e in pairs(_G.DerpyPosVars) do
		local _u
		for i=1,4 do if t == "xCT"..i then _u = true end end
		if not _u then
			a = a + 1;
			if not self.buttons[a] then
				pos_list:gen_info()
			end
			local s = self.buttons[a]
			s:Show()
			s.rem_bt:Show()
			s.ref = t
			s.rem:SetTextColor(1,0,0)
			s.title:SetText("|cff00ffff"..string.upper(t).."|r: "..e[1].." "..e[3].." "..e[4].." "..e[5]);
		end
	end
	if a < #self.buttons then
		for i=a+1,#self.buttons do
			self.buttons[i]:Hide()
		end
	end
end

M.pos_config_do = function()
	local frame = M.make_settings_template("MOVE SOMETHING",436,400)

	local nname = M.setfont(frame,21)
	nname:SetPoint("TOPLEFT",14,-14)
	nname:SetText("POS TABLE:")
	
	local nname = M.setfont(frame,21)
	nname:SetPoint("BOTTOMLEFT",14,14)
	nname:SetText("RELOAD UI TO FINISH REMOVAL")
	
	local pos_holder = CreateFrame("ScrollFrame", "DerpyPosHolderScroll", frame, "UIPanelScrollFrameTemplate")
	M.unscroll(_G.DerpyPosHolderScrollScrollBar)
	pos_list:SetParent(pos_holder)
	pos_holder:SetScrollChild(pos_list)
	
	pos_holder:SetPoint("TOPLEFT",14,-42)
	pos_holder:SetPoint("BOTTOMRIGHT",-30,60)

	pos_list:check_list()
	
	local lock_unlock = M.frame(frame,frame:GetFrameLevel()+1,frame:GetFrameStrata())
	lock_unlock:SetSize(140,40)
	lock_unlock:SetPoint("BOTTOMRIGHT",-3,7)
	lock_unlock.text = M.setfont(lock_unlock,18)
	lock_unlock.text:SetText("(UN)LOCK")
	lock_unlock.text:SetPoint("CENTER",.3,1)
	lock_unlock:EnableMouse(true)
	lock_unlock:SetScript("OnMouseDown",M.switch_lock)
	M.enterleave(lock_unlock,.2,1,1,true)
	
	M.pos_config_do = nil;
end