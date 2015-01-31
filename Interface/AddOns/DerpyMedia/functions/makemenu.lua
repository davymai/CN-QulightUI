local M,L = unpack(select(2,...))

local colors_ = M["media"].button
local unpack = unpack
local setbutton = function(target,ison,parent)
	local button = CreateFrame ("Frame",nil,parent)
	button:SetFrameLevel(32)
	button:SetFrameStrata("HIGH")
	button:SetBackdrop(M.bg)
	if target == true and ison == true then
		button:SetBackdropColor(unpack(colors_[2]))
		button:SetBackdropBorderColor(unpack(colors_[2]))
	elseif not target and not ison then
		button:SetBackdropColor(unpack(colors_[1]))
		button:SetBackdropBorderColor(unpack(colors_[1]))
	else
		button:SetBackdropColor(unpack(colors_[3]))
		button:SetBackdropBorderColor(unpack(colors_[3]))
	end
	button:SetWidth(35)
	button:SetHeight(11)
	return button
end

local swch = function (self,ison,alternative)
	local target
	if ison == true then
		self:SetBackdropColor(unpack(colors_[2]))
		self:SetBackdropBorderColor(unpack(colors_[2]))
		target = true
	else
		self:SetBackdropColor(unpack(colors_[1]))
		self:SetBackdropBorderColor(unpack(colors_[1]))
		target = false
	end
	alternative:SetBackdropColor(unpack(colors_[3]))
	alternative:SetBackdropBorderColor(unpack(colors_[3]))
	return target
end

local _t1 = function(self) self.r[self.s] = swch(self,true,self.b) end
local _t2 = function(self) self.r[self.s] = swch(self,false,self.a) end

local makebuttons = function(parent,r,s)
	local a = setbutton(r[s],true,parent)
	local b = setbutton(r[s],false,parent)
	a.r = r; b.r = r; a.s = s;
	a.b = b; b.a = a; b.s = s;
	a:SetScript("OnMouseDown",_t1)
	b:SetScript("OnMouseDown",_t2)
	b:SetPoint("RIGHT",a,"LEFT",-4,0)
	return a,b
end

local setmenutext = function(t,frame)
	local text = M.setfont_lang(frame)
	text:SetText(t)
	return text
end

M.tweaks_mvn = function(frame,swtable,nametable,aboffset,cost_offset)
	local b1,b2 = {}
	local i = 1
	local lasttext
	local cost_offset = cost_offset or 0
	for y,name in pairs(swtable) do
		if nametable[y] then
			b1[i],point_t = makebuttons (frame,swtable,y)
			local a = setmenutext(nametable[y],frame)
			if i == 1 then
				b1[i]:SetPoint("TOPRIGHT",frame,-18,-aboffset)
				a:SetPoint("TOPLEFT",frame,18,-aboffset + 1.8)
			else
				b1[i]:SetPoint("TOPRIGHT",b1[i-1],"BOTTOMRIGHT",0,-3+cost_offset)
				a:SetPoint("TOPLEFT",lasttext,"BOTTOMLEFT",0,-1+cost_offset)
			end
			a:SetPoint("RIGHT",point_t,"LEFT",-4,0)
			lasttext = a
			i = i + 1
		end
	end
	return i
end
