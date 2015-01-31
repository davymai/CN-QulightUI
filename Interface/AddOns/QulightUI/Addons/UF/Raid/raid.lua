
RaidBuffs = {
	DRUID = {
		{774, "TOPRIGHT", {0.8, 0.4, 0.8}},					-- Rejuvenation
		{8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}},				-- Regrowth
		{33763, "TOPLEFT", {0.4, 0.8, 0.2}},				-- Lifebloom
		{48438, "BOTTOMRIGHT", {0.8, 0.4, 0}},				-- Wild Growth
		{102342, "LEFT", {0.45, 0.3, 0.2}, true},			-- Ironbark
		{155777, "RIGHT", {0.4, 0.9, 0.4}},				-- Rejuvenation (Germination)
	},
	MONK = {
		{119611, "TOPRIGHT", {0.2, 0.7, 0.7}},				-- Renewing Mist
		{132120, "TOPLEFT", {0.4, 0.8, 0.2}},			-- Enveloping Mist
		{124081, "BOTTOMRIGHT", {0.7, 0.4, 0}},				-- Zen Sphere
		{116849, "LEFT", {0.81, 0.85, 0.1}, true},			-- Life Cocoon
	},
	PALADIN = {
		{53563, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Beacon of Light
		{20925, "BOTTOMLEFT", {0.9, 0.9, 0.1}},				-- Sacred Shield
		{114163, "BOTTOMLEFT", {0.9, 0.6, 0.4}},			-- Eternal Flame
		{157007, "TOPLEFT", {1, 0.5, 0.2}},				-- Beacon of Insight
		{1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true},			-- Hand of Protection
		{1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true},		-- Hand of Freedom
		{1038, "BOTTOMRIGHT", {0.93, 0.75, 0}, true},		-- Hand of Salvation
		{6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true},		-- Hand of Sacrifice
		{114039, "BOTTOMRIGHT", {0.4, 0.6, 0.8}, true},		-- Hand of Purity
	},
	PRIEST = {
		{6788, "TOPRIGHT", {1, 0, 0}, true},				-- Weakened Soul
		{41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}},			-- Prayer of Mending
		{139, "BOTTOMLEFT", {0.4, 0.7, 0.2}}, 				-- Renew
		{17, "TOPLEFT", {0.81, 0.85, 0.1}, true},			-- Power Word: Shield
		{33206, "LEFT", {0.89, 0.1, 0.1}, true},			-- Pain Suppression
		{47788, "LEFT", {0.86, 0.52, 0}, true},				-- Guardian Spirit
	},
	SHAMAN = {
		{61295, "TOPRIGHT", {0.7, 0.3, 0.7}},				-- Riptide
		{974, "BOTTOMLEFT", {0.2, 0.7, 0.2}, true},			-- Earth Shield
	},
	HUNTER = {
		{35079, "TOPRIGHT", {0.2, 0.2, 1}},					-- Misdirection
	},
	MAGE = {
		{111264, "TOPRIGHT", {0.2, 0.2, 1}},				-- Ice Ward
	},
	ROGUE = {
		{57933, "TOPRIGHT", {0.89, 0.1, 0.1}},				-- Tricks of the Trade
	},
	WARLOCK = {
		{20707, "TOPRIGHT", {0.7, 0.32, 0.75}},				-- Soulstone
	},
	WARRIOR = {
		{114030, "TOPLEFT", {0.2, 0.2, 1}},					-- Vigilance
		{3411, "TOPRIGHT", {0.89, 0.1, 0.1}},				-- Intervene
	},
	ALL = {
		{23333, "LEFT", {1, 0, 0}, true}, 					-- Warsong flag, Horde
		{23335, "LEFT", {0, 0, 1}, true},					-- Warsong flag, Alliance
		{34976, "LEFT", {1, 0, 0}, true}, 					-- Netherstorm Flag
	},
}

RaidBuffsIgnore = {
	[65148] = true,		-- Sacred Shield (Proc)
}

local function SpellName(id)
	local name = select(1, GetSpellInfo(id))
	return name
end

RaidDebuffs = {
-----------------------------------------------------------------
-- Draenor
-----------------------------------------------------------------
-- Blackrock Foundry
	-- Beastlord Darmac
	-- Flamebender Ka'graz
	-- Gruul the Subjugated
	-- Blast Furnace
	-- Hans'gar and Franzok
	-- Iron Maidens
	-- Kromog
	-- Operator Thogar
	-- Oregorger
	-- Warlord Blackhand
-- Highmaul
	-- The Butcher
	[SpellName(156152)] = 3,	-- Gushing Wounds
	[SpellName(156147)] = 3,	-- The Cleaver
	-- Kargath Bladefist
	[SpellName(159178)] = 3,	-- Open Wounds (Tank switch)
	[SpellName(159113)] = 3,	-- Impale (DoT)
	-- Twin Ogron
	[SpellName(155569)] = 3,	-- Injured (DoT)
	[SpellName(167200)] = 3,	-- Arcane Wound (DoT)
	-- Ko'ragh
	[SpellName(161242)] = 3,	-- Caustic Energy (DoT)
	[SpellName(162184)] = 3,	-- Expel Magic: Shadow
	-- Tectus
	[SpellName(162892)] = 3,	-- Petrification
	-- Brackenspore
	[SpellName(163241)] = 3,	-- Rot (Stacks)
	-- Imperator Mar'gok
	[SpellName(158605)] = 3,	-- Mark of Chaos
	[SpellName(164176)] = 3,	-- Mark of Chaos: Displacement
	[SpellName(164178)] = 3,	-- Mark of Chaos: Fortification
	[SpellName(164191)] = 3,	-- Mark of Chaos: Replication
	[SpellName(157763)] = 3,	-- Fixate
	[SpellName(158553)] = 3,	-- Crush Armor (Stacks)
-----------------------------------------------------------------
-- Pandaria
-----------------------------------------------------------------
-- Siege of Orgrimmar
	-- Immerseus
	[SpellName(143436)] = 2,	-- Corrosive Blast (Tank switch)
	[SpellName(143459)] = 3,	-- Sha Residue
	[SpellName(143579)] = 3,
	-- The Fallen Protectors
	[SpellName(143434)] = 4,	-- Shadow Word: Bane (Dispel)
	[SpellName(143198)] = 3,	-- Garrote (DoT)
	[SpellName(143962)] = 3,        -- Àääñêèé óäàð
	[SpellName(143842)] = 5,	-- Mark of Anguish
	[SpellName(147383)] = 3,	-- Debilitation
	[SpellName(143424)] = 3,        -- Îæîã Øà
	-- Norushen
	[SpellName(146124)] = 3,	-- Self Doubt (Tank switch)
	[SpellName(144514)] = 4,	-- Lingering Corruption (Dispel)
	-- Sha of Pride
	[SpellName(144358)] = 3,	-- Wounded Pride (Tank switch)
	[SpellName(144351)] = 4,	-- Mark of Arrogance (Dispel)
	[SpellName(146594)] = 3,	-- Gift of the Titans
	[SpellName(147207)] = 2,	-- Weakened Resolve (Heroic)
	-- Galakras
	[SpellName(147029)] = 3,	-- Flames of Galakrond (DoT)
	[SpellName(146765)] = 3,	-- Flame Arrows (DoT)
	[SpellName(146902)] = 4,	-- Poison-Tipped Blades (Poison stacks)
	-- Iron Juggernaut
	[SpellName(144467)] = 4,	-- Ignite Armor (Tank stacks)
	[SpellName(144459)] = 3,	-- Laser Burn (DoT)
	-- Kor'kron Dark Shaman
	[SpellName(144215)] = 2,	-- Froststorm Strike (Tank stacks)
	[SpellName(144089)] = 3,	-- Toxic Mist (DoT)
	[SpellName(144330)] = 3,	-- Iron Prison (Heroic)
	-- General Nazgrim
	[SpellName(143494)] = 3,	-- Sundering Blow (Tank stacks)
	[SpellName(143638)] = 3,	-- Bonecracker (DoT)
	[SpellName(143431)] = 4,	-- Magistrike (Dispel)
	[SpellName(143480)] = 3,	-- Assassin's Mark (Fixate)
	-- Malkorok
	[SpellName(142990)] = 3,	-- Fatal Strike (Tank stacks)
	[SpellName(142864)] = 3,	-- Ancient Barrier
	[SpellName(142865)] = 3,	-- Strong Ancient Barrier
	[SpellName(142913)] = 4,	-- Displaced Energy (Dispel)
	-- Spoils of Pandaria
	[SpellName(145218)] = 3,	-- Harden Flesh (Dispel)
	[SpellName(146235)] = 3,	-- Breath of Fire (Dispel)
	-- Thok the Bloodthirsty
	[SpellName(143766)] = 3,	-- Panic (Tank stacks)
	[SpellName(143780)] = 3,	-- Acid Breath (Tank stacks)
	[SpellName(143773)] = 3,	-- Freezing Breath (Tank Stacks)
	[SpellName(143800)] = 3,	-- Icy Blood (Random Stacks)
	[SpellName(143767)] = 3,	-- Scorching Breath (Tank Stacks)
	[SpellName(143791)] = 4,	-- Corrosive Blood (Dispel)
	-- Siegecrafter Blackfuse
	[SpellName(143385)] = 3,	-- Electrostatic Charge (Tank stacks)
	[SpellName(144236)] = 3,	-- Pattern Recognition
	-- Paragons of the Klaxxi
	[SpellName(142929)] = 3,	-- Tenderizing Strikes (Tank stacks)
	[SpellName(143275)] = 3,	-- Hewn (Tank stacks)
	[SpellName(143279)] = 3,	-- Genetic Alteration (Tank stacks)
	[SpellName(143974)] = 3,	-- Shield Bash (Tank stun)
	[SpellName(142948)] = 3,	-- Aim
	-- Garrosh Hellscream
	[SpellName(145183)] = 3,	-- Gripping Despair (Tank stacks)
	[SpellName(145195)] = 3,	-- Empowered Gripping Despair (Tank stacks)
	[SpellName(145065)] = 3,	-- Touch of Y'Shaarj
	[SpellName(145171)] = 3,	-- Empowered Touch of Y'Shaarj

 	-- Other
	[SpellName(87023)] = 4,		-- Cauterize
 	[SpellName(94794)] = 4,		-- Rocket Fuel Leak
	[SpellName(116888)] = 4,	-- Shroud of Purgatory
	[SpellName(121175)] = 2,	-- Orb of Power

-- Throne of Thunder
	-- Jin'rokh the Breaker
	[SpellName(137162)] = 4,	-- Static Burst (Tank switch)
	[SpellName(138349)] = 3,	-- Static Wound (Tank stacks)
	[SpellName(137371)] = 4,	-- Thundering Throw (Tank stun)
	[SpellName(138732)] = 3,	-- Ionization (Heroic - Dispel)
	[SpellName(137422)] = 3,	-- Focused Lightning (Fixated - Kiting)
	-- Horridon
	[SpellName(136767)] = 3,	-- Triple Puncture (Tank stacks)
	[SpellName(136708)] = 4,	-- Stone Gaze (Stun - Dispel)
	[SpellName(136654)] = 3,	-- Rending Charge (DoT)
	[SpellName(136719)] = 3,	-- Blazing Sunlight (Dispel)
	[SpellName(136587)] = 3,	-- Venom Bolt Volley (Dispel)
	[SpellName(136710)] = 3,	-- Deadly Plague (Dispel)
	[SpellName(136512)] = 3,	-- Hex of Confusion (Dispel)
	-- Council of Elders
	[SpellName(136903)] = 3,	-- Frigid Assault (Tank stacks)
	[SpellName(136922)] = 3,	-- Frostbite (DoT)
	[SpellName(136992)] = 3,	-- Biting Cold (DoT)
	[SpellName(136857)] = 4,	-- Entrapped (Dispel)
	[SpellName(137359)] = 3,	-- Marked Soul (Fixated - Kiting)
	[SpellName(137641)] = 3,	-- Soul Fragment (Heroic)
	-- Tortos
	[SpellName(136753)] = 3,	-- Slashing Talons (Tank DoT)
	[SpellName(137633)] = 3,	-- Crystal Shell (Heroic)
	[SpellName(140701)] = 4,	-- Crystal Shell: Full Capacity! (Heroic)
	-- Megaera
	[SpellName(137731)] = 3,	-- Ignite Flesh (Tank stacks)
	[SpellName(139843)] = 3,	-- Arctic Freeze (Tank stacks)
	[SpellName(139840)] = 3,	-- Rot Armor (Tank stacks)
	[SpellName(134391)] = 4,	-- Cinder (DoT - Dispell)
	[SpellName(139857)] = 4,	-- Torrent of Ice (Fixated - Kiting)
	[SpellName(140179)] = 4,	-- Suppression (Heroic - Dispell)
	-- Ji-Kun
	[SpellName(134366)] = 4,	-- Talon Rake (Tank stacks)
	[SpellName(140092)] = 3,	-- Infected Talons (Tank DoT)
	[SpellName(134256)] = 3,	-- Slimed (DoT)
	-- Durumu the Forgotten
	[SpellName(133768)] = 4,	-- Arterial Cut (Tank DoT)
	[SpellName(133767)] = 3,	-- Serious Wound (Tank stacks)
	[SpellName(133798)] = 3,	-- Life Drain (Stun)
	[SpellName(133597)] = 3,	-- Dark Parasite (Heroic - Dispel)
	-- Primordius
	[SpellName(136050)] = 3,	-- Malformed Blood (Tank stacks)
	[SpellName(136228)] = 4,	-- Volatile Pathogen (DoT)
	-- Dark Animus
	[SpellName(138569)] = 4,	-- Explosive Slam (Tank stacks)
	[SpellName(138609)] = 4,	-- Matter Swap (Dispel)
	[SpellName(138659)] = 3,	-- Touch of the Animus (DoT)
	-- Iron Qon
	[SpellName(134691)] = 3,	-- Impale (Tank stacks)
	[SpellName(136192)] = 4,	-- Lightning Storm (Stun)
	[SpellName(136193)] = 3,	-- Arcing Lightning
	-- Twin Consorts
	[SpellName(137408)] = 3,	-- Fan of Flames (Tank stacks)
	[SpellName(136722)] = 3,	-- Slumber Spores (Dispel)
	[SpellName(137341)] = 3,	-- Beast of Nightmares (Fixate)
	[SpellName(137360)] = 3,	-- Corrupted Healing (Healer stacks)
	-- Lei Shen
	[SpellName(135000)] = 3,	-- Decapitate (Tank only)
	[SpellName(136478)] = 3,	-- Fusion Slash (Tank only)
	[SpellName(136914)] = 3,	-- Electrical Shock (Tank staks)
	[SpellName(135695)] = 3,	-- Static Shock (Damage Split)
	[SpellName(136295)] = 3,	-- Overcharged
	[SpellName(139011)] = 3,	-- Helm of Command (Heroic)
	-- Ra-den
	[SpellName(138297)] = 3,	-- Unstable Vita
	[SpellName(138329)] = 3,	-- Unleashed Anima
	[SpellName(138372)] = 4,	-- Vita Sensitivity
-- Terrace of Endless Spring
	-- Protectors of the Endless
	[SpellName(117519)] = 3,	-- Touch of Sha
	[SpellName(117436)] = 4,	-- Lightning Prison
	-- Tsulong
	[SpellName(122752)] = 3,	-- Shadow Breath
	[SpellName(123011)] = 3,	-- Terrorize
	[SpellName(122777)] = 3,	-- Nightmares
	[SpellName(123036)] = 3,	-- Fright
	-- Lei Shi
	[SpellName(123121)] = 3,	-- Spray
	[SpellName(123705)] = 3,	-- Scary Fog
	-- Sha of Fear
	[SpellName(119086)] = 3,	-- Penetrating Bolt
	[SpellName(120669)] = 3,	-- Naked and Afraid
	[SpellName(120629)] = 3,	-- Huddle in Terror
-- Heart of Fear
	-- Imperial Vizier Zor'lok
	[SpellName(122761)] = 3,	-- Exhale
	[SpellName(122740)] = 3,	-- Convert
	-- Blade Lord Ta'yak
	[SpellName(123180)] = 3,	-- Wind Step
	[SpellName(123474)] = 3,	-- Overwhelming Assault
	-- Garalon
	[SpellName(122835)] = 3,	-- Pheromones
	[SpellName(123081)] = 4,	-- Pungency
	-- Wind Lord Mel'jarak
	[SpellName(129078)] = 4,	-- Amber Prison
	[SpellName(122055)] = 3,	-- Residue
	[SpellName(122064)] = 3,	-- Corrosive Resin
	[SpellName(123963)] = 4,	-- Kor'thik Strike
	-- Amber-Shaper Un'sok
	[SpellName(121949)] = 3,	-- Parasitic Growth
	[SpellName(122370)] = 3,	-- Reshape Life
	-- Grand Empress Shek'zeer
	[SpellName(123707)] = 3,	-- Eyes of the Empress
	[SpellName(123713)] = 3,	-- Servant of the Empress
	[SpellName(123788)] = 3,	-- Cry of Terror
	[SpellName(124849)] = 3,	-- Consuming Terror
	[SpellName(124863)] = 3,	-- Visions of Demise
-- Mogu'shan Vaults
	-- The Stone Guard
	[SpellName(125206)] = 3,	-- Rend Flesh
	[SpellName(130395)] = 3,	-- Jasper Chains
	[SpellName(116281)] = 3,	-- Cobalt Mine Blast
	-- Feng the Accursed
	[SpellName(131788)] = 3,	-- Lightning Lash
	[SpellName(116942)] = 3,	-- Flaming Spear
	[SpellName(131790)] = 3,	-- Arcane Shock
	[SpellName(131792)] = 3,	-- Shadowburn
	[SpellName(116374)] = 4,	-- Lightning Charge
	[SpellName(116784)] = 3,	-- Wildfire Spark
	[SpellName(116417)] = 3,	-- Arcane Resonance
	-- Gara'jal the Spiritbinder
	[SpellName(122151)] = 4,	-- Voodoo Doll
	[SpellName(116161)] = 3,	-- Crossed Over
	[SpellName(117723)] = 3,	-- Frail Soul
	-- The Spirit Kings
	[SpellName(117708)] = 3,	-- Maddening Shout
	[SpellName(118303)] = 3,	-- Fixate
	[SpellName(118048)] = 3,	-- Pillaged
	[SpellName(118135)] = 3,	-- Pinned Down
	[SpellName(118163)] = 3,	-- Robbed Blind
	-- Elegon
	[SpellName(117878)] = 3,	-- Overcharged
	[SpellName(117949)] = 3,	-- Closed Circuit
	[SpellName(132222)] = 3,	-- Destabilizing Energies
	-- Will of the Emperor
	[SpellName(116835)] = 3,	-- Devastating Arc
	[SpellName(116778)] = 3,	-- Focused Defense
	[SpellName(116525)] = 3,	-- Focused Assault
-- Sha of Anger
	[SpellName(119626)] = 3,	-- Aggressive Behavior
-----------------------------------------------------------------
-- PvP
-----------------------------------------------------------------
	-- Death Knight
	[SpellName(115001)] = 3,	-- Remorseless Winter
	[SpellName(108194)] = 3,	-- Asphyxiate
	[SpellName(47476)] = 3,		-- Strangulate
	[SpellName(91800)] = 3,		-- Gnaw (Ghoul)
	[SpellName(91797)] = 3,		-- Monstrous Blow (Mutated Ghoul)
	-- Druid
	[SpellName(33786)] = 3,		-- Cyclone
	[SpellName(339)] = 2,		-- Entangling Roots
	[SpellName(78675)] = 3,		-- Solar Beam
	-- Hunter
	[SpellName(3355)] = 3,		-- Freezing Trap
	[SpellName(117526)] = 3,	-- Binding Shot
	[SpellName(19386)] = 3,		-- Wyvern Sting
	-- Mage
	[SpellName(31661)] = 3,		-- Dragon's Breath
	[SpellName(82691)] = 3,		-- Ring of Frost
	[SpellName(44572)] = 3,		-- Deep Freeze
	[SpellName(61305)] = 3,		-- Polymorph
	[SpellName(102051)] = 3,	-- Frostjaw
	[SpellName(122)] = 2,		-- Frost Nova
	[SpellName(111340)] = 2,	-- Ice Ward
	-- Monk
	[SpellName(115078)] = 3,	-- Paralysis
	[SpellName(119381)] = 3,	-- Leg Sweep
	-- Paladin
	[SpellName(20066)] = 3,		-- Repentance
	[SpellName(853)] = 3,		-- Hammer of Justice
	[SpellName(105593)] = 3,	-- Fist of Justice
	[SpellName(105421)] = 3,	-- Blinding Light
	-- Priest
	[SpellName(605)] = 3,		-- Dominate Mind
	[SpellName(8122)] = 3,		-- Psychic Scream
	[SpellName(64044)] = 3,		-- Psychic Horror
	[SpellName(15487)] = 3,		-- Silence
	--[SpellName(6788)] = 3,		-- Silence
	-- Rogue
	[SpellName(6770)] = 3,		-- Sap
	[SpellName(2094)] = 3,		-- Blind
	[SpellName(1776)] = 3,		-- Gouge
	-- Shaman
	[SpellName(51514)] = 3,		-- Hex
	[SpellName(118905)] = 3,	-- Static Charge
	[SpellName(63685)] = 2,		-- Freeze
	-- Warlock
	[SpellName(118699)] = 3,	-- Fear
	[SpellName(6789)] = 3,		-- Mortal Coil
	[SpellName(5484)] = 3,		-- Howl of Terror
	[SpellName(6358)] = 3,		-- Seduction (Succubus)
	[SpellName(115268)] = 3,	-- Mesmerize (Shivarra)
	[SpellName(30283)] = 3,		-- Shadowfury
	-- Warrior
	[SpellName(46968)] = 3,		-- Shockwave
	[SpellName(132169)] = 3,	-- Storm Bolt
}

RaidDebuffsReverse = {
	--[spellID] = true,			-- Spell name
}

RaidDebuffsIgnore = {
	[138309] = true,			-- Slimed
}


SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", string.upper, 1)
	if unit == "Targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(nil, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif self.unit:match("party") then
		ToggleDropDownMenu(nil, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	else
		FriendsDropDown.unit = self.unit
		FriendsDropDown.id = self.id
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
		ToggleDropDownMenu(nil, nil, FriendsDropDown, "cursor")
	end
end

PostUpdateRaidHealth = function(health, unit, min, max)
	local self = health:GetParent()
	local power = self.Power
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5".."Offline".."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5".."Dead".."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5".."Ghost".."|r")
		end
	else
		local r, g, b
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and Qulight.raidframes.own_color ~= true then
			local c = oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(r * mu, g * mu, b * mu)
			end
		end
		if Qulight.raidframes.bar_color_value == true and not (UnitIsTapped(unit) and not UnitIsTappedByPlayer(unit)) then
			if Qulight.raidframes.own_color == true then
				r, g, b = 0.4, 0.4, 0.4
			else
				r, g, b = health:GetStatusBarColor()
			end
			--local newr, newg, newb = oUF.ColorGradient(min, max, 1, 0, 0, 1, 1, 0, r, g, b)

			health:SetStatusBarColor(newr, newg, newb)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
			end
		end
		if min ~= max then
			--r, g, b = oUF.ColorGradient(min, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if self:GetParent():GetName():match("oUF_PartyDPS") then
				if Qulight.raidframes.color_value == true then
					health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", ShortValue(min), r * 255, g * 255, b * 255, floor(min / max * 100))
				else
					health.value:SetFormattedText("|cffffffff%s - %d%%|r", ShortValue(min), floor(min / max * 100))
				end
			else
				if Qulight.raidframes.color_value == true then
					if Qulight.raidframes.deficit_health == true then
						health.value:SetText("|cffffffff".."-"..ShortValue(max - min))
					else
						health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(min / max * 100))
					end
				else
					if Qulight.raidframes.deficit_health == true then
						health.value:SetText("|cffffffff".."-"..ShortValue(max - min))
					else
						health.value:SetFormattedText("|cffffffff%d%%|r", floor(min / max * 100))
					end
				end
			end
		else
			if Qulight.raidframes.color_value == true then
				health.value:SetText("|cff559655"..ShortValue(max).."|r")
			else
				health.value:SetText("|cffffffff"..ShortValue(max).."|r")
			end
		end
		if Qulight.raidframes.alpha_health == true then
			if min / max > 0.95 then
				health:SetAlpha(0.6)
				power:SetAlpha(0.6)
			else
				health:SetAlpha(1)
				power:SetAlpha(1)
			end
		end
		if min == 0 and self:GetParent().ResurrectIcon then
			self:GetParent().ResurrectIcon:SetAlpha(1)
		elseif self:GetParent().ResurrectIcon or (self:GetParent().ResurrectIcon and min == max) then
			self:GetParent().ResurrectIcon:SetAlpha(0)
		end
	end
end

local fs = function(parent, layer, font, fontsiz, outline, r, g, b, justify)
    local string = parent:CreateFontString(nil, layer)
    string:SetFont(font, fontsiz, outline)
    string:SetShadowOffset(1, 1)
    string:SetTextColor(r, g, b)
    if justify then
        string:SetJustifyH(justify)
    end
    return string
end

UpdateThreat = function(self, event, unit)
	if self.unit ~= unit then return end
	local threat = UnitThreatSituation(self.unit)
	if threat and threat > 1 then
		r, g, b = GetThreatStatusColor(threat)
	end
end

local CountOffSets = {
	TOPLEFT = {9, 0},
	TOPRIGHT = {-8, 0},
	BOTTOMLEFT = {9, 0},
	BOTTOMRIGHT = {-8, 0},
	LEFT = {9, 0},
	RIGHT = {-8, 0},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

CreateAuraWatchIcon = function(self, icon)
	CreateStyle(icon, 2)
	icon.icon:SetPoint("TOPLEFT", icon, 1, -1)
	icon.icon:SetPoint("BOTTOMRIGHT", icon, -1, 1)
	icon.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon.icon:SetDrawLayer("ARTWORK")
	if icon.cd then
		icon.cd:SetReverse(true)
	end
	icon.overlay:SetTexture()
end

CreateAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 0, 0)
	auras:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
	auras.icons = {}
	auras.PostCreateIcon = CreateAuraWatchIcon

	if not Qulight.raidframes.show_timer then
		auras.hideCooldown = true
	end

	local buffs = {}

	if RaidBuffs["ALL"] then
		for key, value in pairs(RaidBuffs["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if RaidBuffs[myclass] then
		for key, value in pairs(RaidBuffs[myclass]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon.strictMatching = spell[5]
			icon:SetWidth(10)
			icon:SetHeight(10)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(Qulight["media"].blank)
			if spell[3] then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = SetFontString(icon, Qulight["media"].pxfont, Qulight["raidframes"].fontsize, Qulight["raidframes"].outline)
			count:SetPoint("CENTER", unpack(CountOffSets[spell[2]]))
			icon.count = count

			auras.icons[spell[1]] = icon
		end
	end

	self.AuraWatch = auras
end

----------------------------------------------------------------------------------------
--	UnitFrames based on oUF_Caellian(by Caellian)
----------------------------------------------------------------------------------------
local _, ns = ...
local oUF = ns.oUF

-- Frame size
local unit_width = Qulight.raidframes.width
local unit_height = Qulight.raidframes.height

-- Create layout
local function Shared(self, unit)
	local unit = (self:GetParent():GetName():match("oUF_Party")) and "party"
	or (self:GetParent():GetName():match("oUF_Raid")) and "raid"

	-- Set our own colors
	self.colors = oUF_colors

	-- Register click
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	-- Menu
	self.menu = SpawnMenu

	-- Backdrop for every units
	CreateStyle(self, 4)

	-- Health bar
	self.Health = CreateFrame("StatusBar", nil, self)
	self.Health:SetPoint("TOPLEFT")
	self.Health:SetPoint("TOPRIGHT")
	if (self:GetAttribute("unitsuffix") == "pet" or self:GetAttribute("unitsuffix") == "target") then
		self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 3)
		self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 3)
	else
		self.Health:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
		self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
	end
	self.Health:SetStatusBarTexture(Qulight.media.texture)
	self.Health.PostUpdate = function(health, unit)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
			health:SetValue(0)
		end
	end

	if Qulight.raidframes.vertical_health == true then
		self.Health:SetOrientation("VERTICAL")
	end

	self.Health.PostUpdate = function(health, unit)
		if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
			health:SetValue(0)
		end
	end
	self.Health.frequentUpdates = true
	if Qulight.raidframes.own_color == true then
		self.Health.colorDisconnected = false
		self.Health.colorReaction = false
		self.Health.colorClass = false
		self.Health:SetStatusBarColor(0.1, 0.1, 0.1)
	else
		self.Health.colorDisconnected = true
		self.Health.colorReaction = true
		self.Health.colorClass = true
	end
	
	-- Health bar background
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints(self.Health)
	self.Health.bg:SetTexture(Qulight.media.texture)
	
	if Qulight.raidframes.own_color == true then
		self.Health.bg:SetVertexColor(0.5, 0.5, 0.5, 1)
	else
		self.Health.bg.multiplier = 0.2
	end

	-- Names
	self.Info = SetFontString(self.Health, Qulight["media"].font, 10, Qulight["raidframes"].outline)
	if (self:GetAttribute("unitsuffix") == "pet" or self:GetAttribute("unitsuffix") == "target") and unit ~= "tank" then
		self.Info:SetPoint("TOP", self.Health, "TOP", 0, -2)
	else
		self.Info:SetPoint("TOP", self.Health, "TOP", 0, -2)
	end
	self:Tag(self.Info, "[GetNameColor][nameshort]")
	if Qulight.raidframes.hp_value == true then
		if not (self:GetAttribute("unitsuffix") == "pet" or (self:GetAttribute("unitsuffix") == "target" and unit ~= "tank")) then
			self.Health.value = SetFontString(self.Health, Qulight["media"].pxfont, 10, Qulight["raidframes"].outline)
			self.Health.value:SetPoint("BOTTOM", self.Health, "BOTTOM", 0, 7)
			self.Health.value:SetTextColor(1, 1, 1)
		end	
		self.Health.PostUpdate = PostUpdateRaidHealth	
	end
	
	
	if not (self:GetAttribute("unitsuffix") == "pet" or (self:GetAttribute("unitsuffix") == "target" and unit ~= "tank")) then
		if Qulight.raidframes.power == true then
		-- Power bar
		self.Power = CreateFrame("StatusBar", nil, self)
		self.Power:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 3, 3)
		self.Power:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -3, 3)
		self.Power:SetPoint("TOP", self, "BOTTOM", 0, 6)
		self.Power:SetStatusBarTexture(Qulight.media.texture)
		self.Power:SetFrameStrata("MEDIUM")
		CreateStyle(self.Power, 2)
		self.Power:SetWidth(unit_width)

		self.Power.PostUpdate = function(power, unit)
			if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
				power:SetValue(0)
			end
		end
		
		self.Power:SetFrameLevel(10)
		self.Power.frequentUpdates = true
		self.Power.colorDisconnected = true
		if Qulight.raidframes.own_color == true then
			self.Power.colorClass = true
		else
			self.Power.colorPower = true
		end

		-- Power bar background
		self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
		self.Power.bg:SetAllPoints(self.Power)
		self.Power.bg:SetTexture(Qulight.media.texture)
		self.Power.bg:SetAlpha(1)
		self.Power.bg.multiplier = 0.2
		end
	end		
	
	-- Agro border
	if Qulight.raidframes.aggro_border == true then
		table.insert(self.__elements, UpdateThreat)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	end

	-- Raid marks
	if Qulight.raidframes.icons_raid_mark == true then
		self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
		self.RaidIcon:SetSize(15, 15)
		self.RaidIcon:SetTexture("Interface\\AddOns\\QulightUI\\Root\\Media\\raidicons")	
		self.RaidIcon:SetPoint("BOTTOM", self.Health, 0, 6)
	end

	-- LFD role icons
	if Qulight.raidframes.icons_role == true and not (self:GetAttribute("unitsuffix") == "target") then
        local lfd = fs(self.Health, "OVERLAY", fontsymbol, 10, OUTLINE, 1, 1, 1)
		lfd:SetPoint("TOPRIGHT", self.Health, 0, -3)
		lfd:SetJustifyH"LEFT"
	    self:Tag(lfd, '[LFD]')
	end

	-- Ready check icons
	if Qulight.raidframes.icons_ready_check == true and not (self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "targettarget") then
		self.ReadyCheck = self.Health:CreateTexture(nil, "OVERLAY")
		self.ReadyCheck:SetSize(12, 12)
		self.ReadyCheck:SetPoint("BOTTOMRIGHT", self.Health, 2, 5)
	end

	-- Leader/Assistant/ML icons
	if Qulight.raidframes.icons_leader == true and not (self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "targettarget") then
		-- Leader icon
		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetSize(12, 12)
		self.Leader:SetPoint("TOPLEFT", self.Health, -3, 8)

		-- Assistant icon
		self.Assistant = self.Health:CreateTexture(nil, "OVERLAY")
		self.Assistant:SetSize(12, 12)
		self.Assistant:SetPoint("TOPLEFT", self.Health, -3, 8)

		-- Master looter icon
		self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
		self.MasterLooter:SetSize(12, 12)
		self.MasterLooter:SetPoint("TOPRIGHT", self.Health, 3, 8)
	end

	-- Resurrect icon
	self.ResurrectIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.ResurrectIcon:SetSize(13, 13)
	self.ResurrectIcon:SetPoint("BOTTOMRIGHT", self.Health, 2, -7)

	-- Debuff highlight
	if not (self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "targettarget") then
		self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
		self.DebuffHighlight:SetAllPoints(self.Health)
		self.DebuffHighlight:SetTexture([=[Interface\AddOns\QulightUI\Root\Media\white.tga]=])
		self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
		self.DebuffHighlight:SetBlendMode("ADD")
		self.DebuffHighlightAlpha = 1
		self.DebuffHighlightFilter = true
	end

	-- Incoming heal text/bar
	if Qulight.raidframes.plugins_healcomm == true then
		local mhpb = CreateFrame("StatusBar", nil, self.Health)
		if Qulight.raidframes.vertical_health == true then
			mhpb:SetOrientation("VERTICAL")
			mhpb:SetPoint("BOTTOM", self.Health:GetStatusBarTexture(), "TOP", 0, 0)
			mhpb:SetHeight(unit_height)
		else
			mhpb:SetPoint("TOPLEFT", self.Health:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			mhpb:SetPoint("BOTTOMLEFT", self.Health:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		end
		mhpb:SetWidth(unit_width)
		mhpb:SetStatusBarTexture(Qulight.media.texture)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.2)

		local ohpb = CreateFrame("StatusBar", nil, self.Health)
		if Qulight.raidframes.vertical_health == true then
			ohpb:SetOrientation("VERTICAL")
			ohpb:SetPoint("BOTTOM", mhpb:GetStatusBarTexture(), "TOP", 0, 0)
			ohpb:SetHeight(unit_height)
		else
			ohpb:SetPoint("TOPLEFT", mhpb:GetStatusBarTexture(), "TOPRIGHT", 0, 0)
			ohpb:SetPoint("BOTTOMLEFT", mhpb:GetStatusBarTexture(), "BOTTOMRIGHT", 0, 0)
		end
		ohpb:SetWidth(unit_width)
		ohpb:SetStatusBarTexture(Qulight.media.texture)
		ohpb:SetStatusBarColor(0, 1, 0, 0.2)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end

	-- Range alpha
	if Qulight.raidframes.show_range == true and not (self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "targettarget") then
		self.Range = {insideAlpha = 1, outsideAlpha = Qulight.raidframes.range_alpha}
	end

	-- Smooth bars
	if Qulight.raidframes.plugins_smooth_bar == true then
		self.Health.Smooth = true
		if not (self:GetAttribute("unitsuffix") == "pet" or self:GetAttribute("unitsuffix") == "target") then
		end
	end

	if Qulight.raidframes.plugins_aura_watch == true and not (self:GetAttribute("unitsuffix") == "pet" or self:GetAttribute("unitsuffix") == "target" or self:GetAttribute("unitsuffix") == "targettarget") then
		-- Classbuffs
		CreateAuraWatch(self, unit)

		-- Raid debuffs
		self.RaidDebuffs = CreateFrame("Frame", nil, self)
		self.RaidDebuffs:SetHeight(28)
		self.RaidDebuffs:SetWidth(28)
		self.RaidDebuffs:SetPoint("CENTER", self, 0, 1)
		self.RaidDebuffs:SetFrameStrata("MEDIUM")
		self.RaidDebuffs:SetFrameLevel(10)
		CreateStyle(self.RaidDebuffs, 2)

		self.RaidDebuffs.icon = self.RaidDebuffs:CreateTexture(nil, "BORDER")
		self.RaidDebuffs.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		self.RaidDebuffs.icon:SetPoint("TOPLEFT", 2, -2)
		self.RaidDebuffs.icon:SetPoint("BOTTOMRIGHT", -2, 2)

		if Qulight.raidframes.plugins_aura_watch_timer == true then
			self.RaidDebuffs.time = SetFontString(self.RaidDebuffs, Qulight["media"].pxfont, Qulight["raidframes"].fontsize, Qulight["raidframes"].outline)
			self.RaidDebuffs.time:SetPoint("CENTER", 1, 1)
			self.RaidDebuffs.time:SetTextColor(1, 1, 1)
		end

		self.RaidDebuffs.count = SetFontString(self.RaidDebuffs, Qulight["media"].pxfont, Qulight["raidframes"].fontsize, Qulight["raidframes"].outline)
		self.RaidDebuffs.count:SetPoint("BOTTOMRIGHT", self.RaidDebuffs, "BOTTOMRIGHT", 3, -1)
		self.RaidDebuffs.count:SetTextColor(1, 1, 1)

		if Qulight.raidframes.show_spiral == true then
			self.RaidDebuffs.cd = CreateFrame("Cooldown", nil, self.RaidDebuffs, "CooldownFrameTemplate")
			self.RaidDebuffs.cd:SetPoint("TOPLEFT", 2, -2)
			self.RaidDebuffs.cd:SetPoint("BOTTOMRIGHT", -2, 2)
			self.RaidDebuffs.cd:SetReverse(true)
			self.RaidDebuffs.cd:SetDrawEdge(false)
			self.RaidDebuffs.cd.noOCC = true
			self.RaidDebuffs.parent = CreateFrame("Frame", nil, self.RaidDebuffs)
			self.RaidDebuffs.parent:SetFrameLevel(self.RaidDebuffs.cd:GetFrameLevel() + 1)
			if Qulight.raidframes.plugins_aura_watch_timer == true then
				self.RaidDebuffs.time:SetParent(self.RaidDebuffs.parent)
			end
			self.RaidDebuffs.count:SetParent(self.RaidDebuffs.parent)
		end

		self.RaidDebuffs.ShowDispellableDebuff = Qulight.raidframes.plugins_debuffhighlight_icon
		self.RaidDebuffs.FilterDispellableDebuff = true
		self.RaidDebuffs.MatchBySpellName = true
		self.RaidDebuffs.Debuffs = RaidDebuffs
	end

	return self
end

oUF:Factory(function(self)
CompactRaidFrameManager:UnregisterAllEvents()
	CompactRaidFrameManager.Show = dummy
	CompactRaidFrameManager:Hide()

	CompactRaidFrameContainer:UnregisterAllEvents()
	CompactRaidFrameContainer.Show = dummy
	CompactRaidFrameContainer:Hide()
	oUF:RegisterStyle("QulightRaid", Shared)
	oUF:SetActiveStyle("QulightRaid")
	if Qulight.raidframes.show_party == true then
		-- Party
		local party = self:SpawnHeader("oUF_Party", nil, "custom [@raid6,exists][petbattle] hide;show",
			"oUF-initialConfigFunction", [[
				local header = self:GetParent()
				self:SetWidth(header:GetAttribute("initial-width"))
				self:SetHeight(header:GetAttribute("initial-height"))
			]],
			"initial-width", unit_width,
			"initial-height", unit_height,
			"showSolo", Qulight.raidframes.solo_mode,
			"showPlayer", Qulight.raidframes.player_in_party,
			"showParty", true,
			"showRaid", true,
			"xOffset", 5,
			"point", "LEFT"
		)
		if Qulight.raidframes.player_in_party == true then
			party:SetPoint("TOPLEFT", Anchorraid, Qulight.raidframes.party_heal)
		else
			party:SetPoint(Qulight.raidframes.party_heal[1], Qulight.raidframes.party_heal[2], Qulight.raidframes.party_heal[3], Qulight.raidframes.party_heal[4] + 32, Qulight.raidframes.party_heal[5])
		end

	end

	if Qulight.raidframes.show_raid == true then
		if Qulight.raidframes.raid_groups_vertical then
			-- Raid vertical
			local raid = {}
			for i = 1, Qulight.raidframes.raid_groups do
				local raidgroup = self:SpawnHeader("oUF_RaidHeal"..i, nil, "custom [@raid6,exists][petbattle] show;hide",
					"oUF-initialConfigFunction", [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute("initial-width"))
						self:SetHeight(header:GetAttribute("initial-height"))
					]],
					"initial-width", unit_width,
					"initial-height", unit_height,
					"showRaid", true,
					"yOffset", -5,
					"point", "TOPLEFT",
					"groupFilter", tostring(i),
					"maxColumns", 5,
					"unitsPerColumn", 1,
					"columnSpacing", 5,
					"columnAnchorPoint", "TOP"
				)
				if i == 1 then
					raidgroup:SetPoint("TOPLEFT", Anchorraid, Qulight.raidframes.raid_heal)
				else
					raidgroup:SetPoint("TOPLEFT", raid[i-1], "TOPRIGHT", 5, 0)
				end
				raid[i] = raidgroup
			end
		else
			-- Raid horizontal
			local raid = {}
			for i = 1, Qulight.raidframes.raid_groups do
				local raidgroup = self:SpawnHeader("oUF_RaidHeal"..i, nil, "custom [@raid6,exists][petbattle] show;hide",
					"oUF-initialConfigFunction", [[
						local header = self:GetParent()
						self:SetWidth(header:GetAttribute("initial-width"))
						self:SetHeight(header:GetAttribute("initial-height"))
					]],
					"initial-width", unit_width,
					"initial-height", unit_height,
					"showRaid", true,
					"groupFilter", tostring(i),
					"point", "LEFT",
					"yOffset", -5,
					"maxColumns", 5,
					"unitsPerColumn", 1,
					"columnSpacing", 5,
					"columnAnchorPoint", "LEFT"
				)
				if i == 1 then
					raidgroup:SetPoint("TOPLEFT", Anchorraid, Qulight.raidframes.raid_heal)
				else
					raidgroup:SetPoint("TOPLEFT", raid[i-1], "BOTTOMLEFT", 0, -5)
				end
				raid[i] = raidgroup
			end
		end

	end
end)