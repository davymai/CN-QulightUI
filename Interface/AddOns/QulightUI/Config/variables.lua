Qulight = { }

_, myclass = UnitClass("player") 
local myPlayerName  = UnitName("player")
resolution = GetCurrentResolution()
getscreenresolution = select(resolution, GetScreenResolutions())
version = GetAddOnMetadata("QulightUI", "Version")
dummy = function() return end
client = GetLocale() 
incombat = UnitAffectingCombat("player")
patch = GetBuildInfo()
level = UnitLevel("player")
local myPlayerRealm = GetRealmName()