local M,L = unpack(select(2,...))
-- Default here:

if not L['lang_loaded'] then
	
	local _L = {
			['lang_loaded'] = true,
			['hello_world'] = "DerpyMedia: Use |cffaaaa22/py|r to show settings.",
			['close'] = "Close",
			['hide'] = "Hide",
			['back'] = "Back",
			['reload'] = "Reload",
			['stuffing'] = {
				["srch"] = "Search",
				["rclick"] = "Right-click to search.",
			},
			['derpyraid'] = {
				["rinst"] = "Press Left or Right button to\n move next or previous Raid group.", -- "\n" mean new line
				["rmemcount"] = "Total in raid:",
				["rcombat"] = "You are in combat.",
				["rgroup"] = "Raid Group ",
				["group"] = "In Party Mode",
			},
			['tweaks'] = {
				["repairtrue"] = "Repair",
				["repairfalse"] = "Not nuf money for repair",
				["repairtrue_g"] = "Guild repair",
				["repairfalse_g"] = "Not nuf money for repair, withdraw limit",
				["malinvacc"] = "Invite Accepted: ",
				["malinvde"] = "Invite Declined: ",
				["malduelde"] = "Duel Declined: ",
				["r_over"] = "Collapsing...",
			},
			['tweaks_st'] = {
				["junk"] = "SELL JUNK",
				["guild_repair"] = "GUILD REPAIR",
				["autoinv"] = "AUTO INVITE",
				["autoacceptinv"] = "ACCEPT INVITES",
				["autodeclineinv"] = "DECLINE INVITES",
				["declineduels"] = "DECLINE DUELS",
				["repair"] = "REPAIR"
			},
			['clocks'] = {
				["wgbellow1"] = {
					[1] = "", -- before BG name
					[2] = " will start in 1 minute!", -- after bg name
				},
				["wgbellow15"]= {
					[1] = "",
					[2] = " will start in 15 minutes!",
				},
				["tolbar"] = "Tol`Barad",
				["lagspring"] = "Winterspring",
				["wgtoolna"] = "Unavailable",
				["wgtoolinprogress"] = "In progress",
				["session"] = "Time played:",
				["total"] = "Played total:",
			},
			['bags'] = {
				["free"] = "Total free:",
				["gold"] = "Total money:",
				["nomore"] = "All bags are full!",
			},
			['dur'] = {
				["durtable"] = {
					[1] = {1, "Head", 1000},
					[2] = {3, "Shoulder", 1000},
					[3] = {5, "Chest", 1000},
					[4] = {6, "Waist", 1000},
					[5] = {9, "Wrist", 1000},
					[6] = {10, "Hands", 1000},
					[7] = {7, "Legs", 1000},
					[8] = {8, "Feet", 1000},
					[9] = {16, "Main Hand", 1000},
					[10] = {17, "Off Hand", 1000},
					[11] = {18, "Ranged", 1000}
				},
				["durtool"] = "Durability:",
			},
			['map'] = {
				['coord'] = "Coordinates: ",
				['cursor'] = "Cursor",
			},
			['latency'] = {
				["ping"] = "latency:", -- lower case, coz second word
				["pingval"] = " ms",
				["framerate"] = "Frame rate:",
				["framerateval"] = " fps",
				["memorytool"] = "Detail information:",
				["memorytotal"] = "Total memory used:",
				["memorymfrom"] = " mB",
				["memorykfrom"] = " kB",
				["_local"] = "Local ",
				["global"] = "Global ",
				["band"] = "Download Bandwidth:",
				["done"] = "Downloaded:",
				["mps"] = " мBps",
			},
			['avoid'] = {
				["avoid"] = "Avoidance Breakdown:",
				["miss"] = "Miss Chance:",
				["dodge"] = "Dodge Chance:",
				["parry"] = "Parry Chance:",
				["block"] = "Block Chance:",
				["honor"] = "Honor Points:",
				["сс"] = "Conquest Points:",
			},
			['raid_primochka'] = {
				["Disband"] = "Disband Raid/Group",
				["Role"] = "Role Check",
				["Tank"] = "Main Tank",
				["Assist"] = "Main Assist",
				["Ready"] = "Ready Check",
				["sure1"] = "Are you sure to disband????",
				["sure2"] = "OH MY GOD! ARE YOU REALY SURE???!!!", -- ask 2 times
			},			
	}

	for t in pairs (_L) do L[t] = _L[t]; end; wipe(_L);
end