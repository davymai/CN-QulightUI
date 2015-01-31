local M = unpack(select(2,...))

-- Style Frame
M.style = function (myframe,nobg,off,blend)
	off = off or 3
	
	if nobg ~= true then
		if not myframe.bg then
			local bg = myframe:CreateTexture(nil,"BORDER")
			bg:SetPoint("TOPLEFT",off+1,-off-1)
			bg:SetPoint("BOTTOMRIGHT",-off-1,off+1)
			bg:SetTexture(1,1,1,1)
			bg:SetGradientAlpha("VERTICAL",unpack(M["media"].gradient))
			bg:SetBlendMode(blend or "ADD")
			myframe.bg = bg
		end
	end
	
	local left = myframe:CreateTexture(nil,"ARTWORK")
	left:SetTexture(unpack(M["media"].border))
	left:SetPoint("TOPLEFT",off,-off)
	left:SetPoint("BOTTOMLEFT",off,off)
	left:SetWidth(1)
	myframe.left = left
	
	local right = myframe:CreateTexture(nil,"ARTWORK")
	right:SetTexture(unpack(M["media"].border))
	right:SetPoint("TOPRIGHT",-off,-off)
	right:SetPoint("BOTTOMRIGHT",-off,off)
	right:SetWidth(1)
	myframe.right = right
	
	local bottom = myframe:CreateTexture(nil,"ARTWORK")
	bottom:SetTexture(unpack(M["media"].border))
	bottom:SetPoint("BOTTOMLEFT",off,off)
	bottom:SetPoint("BOTTOMRIGHT",-off,off)
	bottom:SetHeight(1)
	myframe.bottom = bottom
	
	local top = myframe:CreateTexture(nil,"ARTWORK")
	top:SetTexture(unpack(M["media"].border))
	top:SetPoint("TOPLEFT",off,-off)
	top:SetPoint("TOPRIGHT",-off,off)
	top:SetHeight(1)
	myframe.top = top
end

M.frame_points = function(self,parent)
	parent = parent or self:GetParent()
	self:SetPoint("TOPLEFT",parent,-4,4)
	self:SetPoint("BOTTOMRIGHT",parent,4,-4)
end

-- Set Frame Backdrop (st one)
M.setbackdrop = function(self)
	self:SetBackdrop(M["bg"])
	self:SetBackdropBorderColor(unpack(M["media"].shadow))
	self:SetBackdropColor(unpack(M["media"].color))
	self.backcolor = M.backcolor
	self.points = M.frame_points
end

-- Change Template
M.ChangeTemplate = function(self) M.setbackdrop(self); M.style(self); end

-- CreateFrame
local Frame_count = 0
M.frame = function(parent,level,strata,nobg,nols,off,tag)
	local myframe = CreateFrame("Frame",tag or "DerpyFrame_"..Frame_count,parent)
	if not tag then Frame_count = Frame_count + 1 end
	if nols ~= true then
		myframe:SetFrameLevel(level or 2)
		myframe:SetFrameStrata(strata or "BACKGROUND")
	end
	M.setbackdrop(myframe)
	M.style(myframe,nobg,off)
	return myframe
end

-- To change frames color
do
	local n1,n2,n3,n4 = unpack(M["media"].shadow)
	M.backcolor = function(self,r,g,b,alp,stop)
		self.top:SetTexture(r,g,b)
		self.bottom:SetTexture(r,g,b)
		self.right:SetTexture(r,g,b)
		self.left:SetTexture(r,g,b)
		if stop then return end
		if not alp then
			self:SetBackdropBorderColor(n1,n2,n3,n4)
		else
			self:SetBackdropBorderColor(r,g,b,alp)
		end
	end
end

local _p = function(self) self.r:Play() end
local _s = function(self) self.r:Stop() end
M.cirle = function(parent,dur,size,dt)
	local t = parent:CreateTexture(nil,"BORDER")
	t:SetTexture(M.media.prizvstudiu)
	t:SetSize(size or 353,size or 353)
	local x = 0
	local rotate = t:CreateAnimationGroup("lol")
	local a = rotate:CreateAnimation("Rotation")
	rotate.a = a
	a:SetDuration(dur or 120) 
	a:SetOrder(1)
	a:SetDegrees(dt or 3600)
	rotate:SetLooping("REPEAT")
	t.r = rotate
	t.play = _p
	t.stop = _s
	return t
end

local _d = function(self) self.t:play() end
local _p = function(self) self.t:stop() end
local rand_id = 0
M.cut_circle = function(parent,level,strata,size,dur,dt,noplay)
	local x = M.frame(parent,level,strata,true)
	x:SetBackdrop(M.bg_edge)
	x:backcolor(0,0,0)
	--x:points()
	local y = CreateFrame("ScrollFrame","DerpyCircle_"..rand_id,x)
	rand_id = rand_id + 1
	y:SetFrameLevel(level-1 or 1)
	y:SetPoint("TOPLEFT",x,4,-4)
	y:SetPoint("BOTTOMRIGHT",x,-4,4)
	local z = CreateFrame("Frame",nil,x)
	y:SetScrollChild(z)
	local t = M.cirle(z,dur,size,dt)
	x.t = t
	t:SetPoint("CENTER",x)
	if not noplay then
		x:SetScript("OnShow",_d)
		x:SetScript("OnHide",_p)
	end
	return x
end

local _dkfff = function(self) 
	self.bg.cross:SetVertexColor(1,.7,.2)
	self.bg:backcolor(1,.7,.2,.8)	
end
local _dsdsd = function(self) 
	self.bg.cross:SetVertexColor(1,0,0) 
	self.bg:backcolor(0,0,0)
end
M.restyle_close = function(self)
	local bg = M.frame(self:GetParent(),self:GetFrameLevel(),self:GetFrameStrata())
	bg:SetPoint("TOPLEFT",self,4,-4)
	bg:SetPoint("BOTTOMRIGHT",self,-4,4)
	self:SetAlpha(0)
	self:SetSize(32,32)
	cross = bg:CreateTexture(nil,"OVERLAY")
	cross:SetSize(16,16)
	cross:SetVertexColor(1,0,0)
	cross:SetPoint("CENTER",bg)
	cross:SetTexture(M['media'].crosstex)
	self.bg = bg; bg.cross = cross
	self:SetScript("OnLeave",_dsdsd)
	self:SetScript("OnEnter",_dkfff)
	self.SetAlpha = M.null
end
