local csf = CreateFrame("Frame")
csf:SetScript("OnEvent", function()
SetCVar("cameraDistanceMax", 50)
SetCVar("cameraDistanceMaxFactor", 3.4)
SetCVar("consolidateBuffs", 0)
SetCVar("ShowClassColorInNameplate", 1)
SetCVar("consolidateBuffs",0)
SetCVar("buffDurations",1)

end)
csf:RegisterEvent("PLAYER_LOGIN")

----------------------------------------------------------------------------------------
-- Launcher
----------------------------------------------------------------------------------------
local function positionsetup()
	QulightDataPerChar = {}
end

local QulightOnLogon = CreateFrame("Frame")
QulightOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
QulightOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if (QulightData == nil) then QulightData = {} end
	if (QulightDataPerChar == nil) then QulightDataPerChar = {} end

		SetCVar("useUiScale", 1)
		if Qulight["general"].MultisampleProtect == true then
		end
		if Qulight["general"].UiScale > 1 then Qulight["general"].UiScale = 1 end
		if Qulight["general"].UiScale < 0.64 then Qulight["general"].UiScale = 0.64 end
		SetCVar("uiScale", Qulight["general"].UiScale)

	print(" ")
	print("欢迎使用 |cFF00A2FFQulight UI|r 汉化版")
	print(" ")
	print("|cFF00A2FFhttp://QulightUI.org |r - 官方网站;")
	print(" ")
	print("|cFF00A2FFhttp://pan.baidu.com/s/1hq06hKC |r - 最新版下载地址")
	print(" ")
	print("|cFF00A2FF/config |r - Qulight UI 设置;")
	print("|cFF00A2FF/ui |r - 修改UI框体位置.")
	print("|cFF00A2FF/ui reset |r - 恢复 UI 默认设置.")
end)
