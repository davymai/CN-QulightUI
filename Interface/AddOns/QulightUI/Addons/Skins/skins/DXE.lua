if not Mod_AddonSkins or not IsAddOnLoaded("DXE") or not Qulight["addonskins"].DXE then return end
local DXE = DXE
local _G = getfenv(0)

local function kill(frame)
	if frame.dead then return end
	frame:Hide()
	frame:HookScript("OnShow",frame.Hide)
	frame.dead = true
end

local dummy = dummy or function() end

local movers = {
	"DXEAlertsCenterStackAnchor",
	"DXEAlertsWarningStackAnchor",
	"DXEDistributorStackAnchor",
	"DXEAlertsTopStackAnchor",
	"DXEArrowsAnchor1",
	"DXEArrowsAnchor2",
	"DXEArrowsAnchor3",
}

local c = {}
function SkinRWIcon(addon, text, r, g, b, _, _, _, _, _, icon)
	if not E[r] then E[r] = {} end
	if not E[r][g] then E[r][g] = {} end
	if not E[r][g][b] then E[r][g][b] = {r = r, g = g, b = b} end
	if icon then text = "|T"..icon..":16:16:-3:0:256:256:20:235:20:235|t"..text end
	RaidNotice_AddMessage(RaidWarningFrame, text, E[r][g][b])
end

Mod_AddonSkins:RegisterSkin("DXE",function(Skin, skin, Layout, layout, config)
	--[[ Kill DXE's skinning ]]
	DXE.NotifyBarTextureChanged = dummy
	DXE.NotifyBorderChanged = dummy
	DXE.NotifyBorderColorChanged = dummy
	DXE.NotifyBorderEdgeSizeChanged = dummy
	DXE.NotifyBackgroundTextureChanged = dummy
	DXE.NotifyBackgroundInsetChanged = dummy
	DXE.NotifyBackgroundColorChanged = dummy
	--[[ Hook Window Creation ]]
	DXE.CreateWindow_ = DXE.CreateWindow
	DXE.CreateWindow = function(self, name, width, height)
		local win = self:CreateWindow_(name, width, height)
		skin:SkinBackgroundFrame(win)
		return win
	end
	-- Skin the pane
	skin:SkinFrame(DXE.Pane)
	-- Hook Health frames (Skin & spacing)
	DXE.LayoutHealthWatchers_ = DXE.LayoutHealthWatchers
	DXE.LayoutHealthWatchers = function(self)
		self.db.profile.Pane.BarSpacing = 2
		self:LayoutHealthWatchers_()
		for i,hw in ipairs(self.HW) do
			if hw:IsShown() then
				skin:SkinFrame(hw)
				kill(hw.border)
				hw.healthbar:SetStatusBarTexture(config.barTexture)
			end
		end
	end
	DXE.Alerts.RefreshBars_ = DXE.Alerts.RefreshBars
	DXE.Alerts.RefreshBars = function(self)
		if self.refreshing then return end
		self.refreshing = true
		self.db.profile.BarSpacing = 0
		self.db.profile.IconXOffset = 0
		self:RefreshBars_()
		local i = 1
		-- This wastes so much CPU, Please DXE, give us a reference to the bar pool!
		while _G["DXEAlertBar"..i] do
			local bar = _G["DXEAlertBar"..i]
			bar:SetScale(1)
			-- F U SCALE!
			bar.SetScale = dummy
			skin:SkinDXEBar(bar)
			i = i + 1
		end
		self.refreshing = false
	end
	
	DXE.Alerts.Dropdown_ = DXE.Alerts.Dropdown
	DXE.Alerts.Dropdown = function(self,...)
		self:Dropdown_(...)
		self:RefreshBars()
	end
	
	DXE.Alerts.CenterPopup_ = DXE.Alerts.CenterPopup
	DXE.Alerts.CenterPopup = function(self,...)
		self:CenterPopup_(...)
		self:RefreshBars()
	end
	
	DXE.Alerts.Simple_ = DXE.Alerts.Simple
	DXE.Alerts.Simple = function(self,...)
		self:Simple_(...)
		self:RefreshBars()
	end
	
	-- Force some updates
	DXE:LayoutHealthWatchers()
	DXE.Alerts:RefreshBars()
	DXE.Pane.border:Hide()

	for i=1, #movers do
		if _G[movers[i]] then
			CreateStyle(_G[movers[i]], 2)
		end
	end	

	local sink = LibStub:GetLibrary("LibSink-2.0")
	if sink and sink.handlers and sink.handlers.RaidWarning then
		sink.handlers.RaidWarning = SkinRWIcon
	end	
	
	function Skin:SkinDXEBar(bar)
		-- The main bar
		self:SkinBackgroundFrame(bar)
		bar.bg:SetTexture(nil)
		kill(bar.border)
		bar.statusbar:SetStatusBarTexture(config.barTexture)
		bar.statusbar:ClearAllPoints()
		bar.statusbar:SetPoint("TOPLEFT",config.borderWidth, -config.borderWidth)
		bar.statusbar:SetPoint("BOTTOMRIGHT",-config.borderWidth, config.borderWidth)
		-- Right Icon
		self:SkinBackgroundFrame(bar.righticon)
		kill(bar.righticon.border)
		bar.righticon.t:SetTexCoord(unpack(config.buttonZoom))
		bar.righticon.t:ClearAllPoints()
		bar.righticon.t:SetPoint("TOPLEFT",config.borderWidth, -config.borderWidth)
		bar.righticon.t:SetPoint("BOTTOMRIGHT",-config.borderWidth, config.borderWidth)
		bar.righticon.t:SetDrawLayer("ARTWORK")
		-- Left Icon
		self:SkinBackgroundFrame(bar.lefticon)
		kill(bar.lefticon.border)
		bar.lefticon.t:SetTexCoord(unpack(config.buttonZoom))
		bar.lefticon.t:ClearAllPoints()
		bar.lefticon.t:SetPoint("TOPLEFT",config.borderWidth, -config.borderWidth)
		bar.lefticon.t:SetPoint("BOTTOMRIGHT",-config.borderWidth, config.borderWidth)
		bar.lefticon.t:SetDrawLayer("ARTWORK")
	end
	DXE.Pane.timer.left:SetFont(Qulight["media"].font, 16)
	DXE.Pane.timer.right:SetFont(Qulight["media"].font, 10)
	-- Force some updates
	DXE:LayoutHealthWatchers()
	DXE.Alerts:RefreshBars()
	kill(DXE.Pane.border)
end)