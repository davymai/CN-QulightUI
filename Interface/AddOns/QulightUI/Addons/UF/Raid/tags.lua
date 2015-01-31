local _, ns = ...
local oUF = ns.oUF or oUF
assert(oUF, "oUF_q was unable to locate oUF install.")

utf8sub = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

local foo = {""}
local spellcache = setmetatable({}, 
{__index=function(t,id) 
	local a = {GetSpellInfo(id)} 

	if GetSpellInfo(id) then
	    t[id] = a
	    return a
	end

	--print("Invalid spell ID: ", id)
        t[id] = foo
	return foo
end
})

local function GetSpellInfo(a)
    return unpack(spellcache[a])
end

local GetTime = GetTime

local numberize = function(val)
    if (val >= 1e6) then
        return ("%.1fm"):format(val / 1e6)
    elseif (val >= 1e3) then
        return ("%.1fk"):format(val / 1e3)
    else
        return ("%d"):format(val)
    end
end
ns.numberize = numberize

local x = "M"

local getTime = function(expirationTime)
    local expire = (expirationTime-GetTime())
    local timeleft = numberize(expire)
    if expire > 0.5 then
        return ("|cffffff00"..timeleft.."|r")
    end
end

local function hex(r, g, b)
	if r then
		if (type(r) == 'table') then
			if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
		end
		return ('|cff%02x%02x%02x'):format(r * 255, g * 255, b * 255)
	end
end

oUF.Tags["Threat"] = function(unit)
	local tanking, status, percent = UnitDetailedThreatSituation("player", "target")
	if percent and percent > 0 then
		return ("%s%d%%|r"):format(Hex(GetThreatStatusColor(status)), percent)
	end
end
oUF.Tags.Events["Threat"] = "UNIT_THREAT_LIST_UPDATE"

oUF.Tags["DiffColor"] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if level < 1 then
		r, g, b = 0.69, 0.31, 0.31
	else
		local DiffColor = UnitLevel("target") - UnitLevel("player")
		if DiffColor >= 5 then
			r, g, b = 0.69, 0.31, 0.31
		elseif DiffColor >= 3 then
			r, g, b = 0.71, 0.43, 0.27
		elseif DiffColor >= -2 then
			r, g, b = 0.84, 0.75, 0.65
		elseif -DiffColor <= GetQuestGreenRange() then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end
oUF.Tags.Events["DiffColor"] = "UNIT_LEVEL"

oUF.Tags["PetNameColor"] = function(unit)
	return string.format("|cff%02x%02x%02x", color.r * 255, color.g * 255, color.b * 255)
end
oUF.Tags.Events["PetNameColor"] = "UNIT_POWER"

oUF.Tags.Methods['GetNameColor'] = function(u, r)
	local _, class = UnitClass(u)
	local reaction = UnitReaction(u, "player")
	
	if UnitIsDead(u) or UnitIsGhost(u) or not UnitIsConnected(u) then
		return "|cffA0A0A0"
	elseif (UnitIsTapped(u) and not UnitIsTappedByPlayer(u)) then
		return hex(oUF.colors.tapped)
	elseif (UnitIsPlayer(u)) then
		return hex(oUF.colors.class[class])
	elseif reaction then
		return hex(oUF.colors.reaction[reaction])
	else
		return hex(1, 1, 1)
	end
end
oUF.Tags.Events['GetNameColor'] = 'UNIT_REACTION UNIT_HEALTH UNIT_HAPPINESS'

oUF.Tags["NameArena"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 4, false)
end
oUF.Tags.Events["NameArena"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameShort"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 8, false)
end
oUF.Tags.Events["NameShort"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameMedium"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 11, true)
end
oUF.Tags.Events["NameMedium"] = "UNIT_NAME_UPDATE"

oUF.Tags["NameLong"] = function(unit)
	local name = UnitName(unit)
	return utf8sub(name, 18, true)
end
oUF.Tags.Events["NameLong"] = "UNIT_NAME_UPDATE"

oUF.Tags["LFD"] = function(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "HEALER" then
		return "|cff8AFF30[H]|r"
	elseif role == "TANK" then
		return "|cffFFF130[T]|r"
	elseif role == "DAMAGER" then
		return "|cffFF6161[D]|r"
	end
end
oUF.Tags.Events["LFD"] = "PLAYER_ROLES_ASSIGNED GROUP_ROSTER_UPDATE"

oUF.Tags["AltPower"] = function(unit)
	local min = UnitPower(unit, ALTERNATE_POWER_INDEX)
	local max = UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
	if max > 0 and not UnitIsDeadOrGhost(unit) then
		return ("%s%%"):format(math.floor(min / max * 100 + 0.5))
	end
end
oUF.Tags.Events["AltPower"] = "UNIT_POWER"

oUF.Tags["IncHeal"] = function(unit)
	local incheal = UnitGetIncomingHeals(unit) or 0
	local player = UnitGetIncomingHeals(unit, "player") or 0
	incheal = incheal - player
	if incheal > 0 then
		return "|cff00FF00+"..ShortValue(incheal).."|r"
	end
end
oUF.Tags.Events["IncHeal"] = "UNIT_HEAL_PREDICTION"

if class == "DRUID" then
	for i = 1, 3 do
		oUF.Tags["WM"..i] = function(unit)
			local _, _, _, dur = GetTotemInfo(i)
			if dur > 0 then
				return "|cffFF2222_|r"
			end
		end
		oUF.Tags.Events["WM"..i] = "PLAYER_TOTEM_UPDATE"
		oUF.UnitlessTagEvents.PLAYER_TOTEM_UPDATE = true
	end
end

if Tclass == "WARLOCK" then
	oUF.Tags["DemonicFury"] = function(unit)
		local min = UnitPower("player", SPELL_POWER_DEMONIC_FURY)
		local max = UnitPowerMax("player", SPELL_POWER_DEMONIC_FURY)
		if T.CheckSpec(2) and max > 0 then
			return ("%s%%"):format(math.floor(min / max * 100 + 0.5))
		end
	end
	oUF.Tags.Events["DemonicFury"] = "UNIT_POWER PLAYER_TALENT_UPDATE"
end