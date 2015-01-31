local myPlayerRealm = GetRealmName()
local myPlayerName  = UnitName("player")

local ALLOWED_GROUPS = {
	["general"]=1,
	["unitframes"]=1,
	--["media"]=1,
	["actionbar"]=1,
	["chatt"]=1,
	["buffdebuff"]=1,
	["addonskins"]=1,
	["datatext"]=1,
	["nameplate"]=1,
	["minimapp"]=1,
	["raidframes"]=1,
	["tooltip"]=1,
	["bags"]=1,
	["loot"]=1,
	["cooldown"]=1,
	["misk"]=1,
}

--List of "Table Names" that we do not want to show in the config
local TableFilter = {
}

local function Local(o)
-- general
	if o == "QulightConfigUIgeneral" then o = QulightL.option_general end
	if o == "QulightConfigUIgeneralAutoScale" then o = QulightL.option_general_uiscale end
	if o == "QulightConfigUIgeneralMultisampleProtect" then o = QulightL.option_general_multisample end
	if o == "QulightConfigUIgeneralUiScale" then o = QulightL.option_general_customuiscale end
	if o == "QulightConfigUIgeneralAutoRepair" then o = QulightL.option_general_AutoRepair end
	if o == "QulightConfigUIgeneralAutoGreed" then o = QulightL.option_general_AutoGreed end
	if o == "QulightConfigUIgeneralAutoDisenchant" then o = QulightL.option_general_AutoDisenchant end
	if o == "QulightConfigUIgeneralAutoDeclineDuels" then o = QulightL.option_general_AutoDeclineDuels end
	if o == "QulightConfigUIgeneralAutoRelease" then o = QulightL.option_general_AutoRelease end
	if o == "QulightConfigUIgeneralBlizzardsErrorFrameHiding" then o = QulightL.option_general_BlizzardsErrorFrameHiding end
	if o == "QulightConfigUIgeneraltopbottompanel" then o = QulightL.option_general_topbottompanel end
	if o == "QulightConfigUIgeneralautoinvite" then o = QulightL.option_general_autoinvite end
	if o == "QulightConfigUIgeneralcenterpanel" then o = QulightL.option_general_centerpanel end

	-- Unitframes
	if o == "QulightConfigUIunitframes" then o = QulightL.option_unitframes end
	if o == "QulightConfigUIunitframesenable" then o = QulightL.option_unitframes_enable end
 	if o == "QulightConfigUIunitframesHealFrames" then o = QulightL.option_unitframes_HealFrames end
	if o == "QulightConfigUIunitframesshowIndicators" then o = QulightL.option_unitframes_showIndicators end
	if o == "QulightConfigUIunitframesshowAuraWatch" then o = QulightL.option_unitframes_showAuraWatch end
	if o == "QulightConfigUIunitframesShowParty" then o = QulightL.option_unitframes_ShowParty end
	if o == "QulightConfigUIunitframesShowRaid" then o = QulightL.option_unitframes_ShowRaid end
	if o == "QulightConfigUIunitframesRaidShowSolo" then o = QulightL.option_unitframes_RaidShowSolo end
	if o == "QulightConfigUIunitframesRaidShowAllGroups" then o = QulightL.option_unitframes_RaidShowAllGroups end
	if o == "QulightConfigUIunitframesenableDebuffHighlight" then o = QulightL.option_unitframes_enableDebuffHighlight end
	if o == "QulightConfigUIunitframesshowRaidDebuffs" then o = QulightL.option_unitframes_showRaidDebuffs end
	if o == "QulightConfigUIunitframesshowtot" then o = QulightL.option_unitframes_showtot end
	if o == "QulightConfigUIunitframesshowpet" then o = QulightL.option_unitframes_showpet end
	if o == "QulightConfigUIunitframesshowfocus" then o = QulightL.option_unitframes_showfocus end
	if o == "QulightConfigUIunitframesshowfocustarget" then o = QulightL.option_unitframes_showfocustarget end
	if o == "QulightConfigUIunitframesshowBossFrames" then o = QulightL.option_unitframes_showBossFrames end
	if o == "QulightConfigUIunitframesTotemBars" then o = QulightL.option_unitframes_TotemBars end
	if o == "QulightConfigUIunitframesMTFrames" then o = QulightL.option_unitframes_MTFrames end
	if o == "QulightConfigUIunitframesArenaFrames" then o = QulightL.option_unitframes_ArenaFrames end
	if o == "QulightConfigUIunitframesReputationbar" then o = QulightL.option_unitframes_Reputationbar end
	if o == "QulightConfigUIunitframesExperiencebar" then o = QulightL.option_unitframes_Experiencebar end
	if o == "QulightConfigUIunitframesshowPlayerAuras" then o = QulightL.option_unitframes_showPlayerAuras end
	if o == "QulightConfigUIunitframesshowPortrait" then o = QulightL.option_unitframes_showPortrait end
	if o == "QulightConfigUIunitframesshowRunebar" then o = QulightL.option_unitframes_showRunebar end
	if o == "QulightConfigUIunitframesshowHolybar" then o = QulightL.option_unitframes_showHolybar end
	if o == "QulightConfigUIunitframesshowEclipsebar" then o = QulightL.option_unitframes_showEclipsebar end
	if o == "QulightConfigUIunitframesshowShardbar" then o = QulightL.option_unitframes_showShardbar end
	if o == "QulightConfigUIunitframesRCheckIcon" then o = QulightL.option_unitframes_RCheckIcon end
	if o == "QulightConfigUIunitframesCastbars" then o = QulightL.option_unitframes_Castbars end
	if o == "QulightConfigUIunitframesshowLFDIcons" then o = QulightL.option_unitframes_showLFDIcons end
	if o == "QulightConfigUIunitframesshowPartyFrames" then o = QulightL.option_unitframes_showPartyFrames end
	if o == "QulightConfigUIunitframesHealthcolorClass" then o = QulightL.option_unitframes_HealthcolorClass end
	if o == "QulightConfigUIunitframesPowercolor" then o = QulightL.option_unitframes_Powercolor end
	if o == "QulightConfigUIunitframesbigcastbar" then o = QulightL.option_unitframes_bigcastbar end
	if o == "QulightConfigUIunitframeswidthbigcastbar" then o = QulightL.option_unitframes_widthbigcastbar end
	if o == "QulightConfigUIunitframesheightbigcastbar" then o = QulightL.option_unitframes_heightbigcastbar end

	--raidframes
	if o == "QulightConfigUIraidframes" then o = QulightL.option_raidframes end

	-- Main
	if o == "QulightConfigUIraidframesaggro_border" then o = QulightL.option_raidframes_aggro_border end
	if o == "QulightConfigUIraidframesdeficit_health" then o = QulightL.option_raidframes_deficit_health end
	if o == "QulightConfigUIraidframespower" then o = QulightL.option_raidframes_power end
	if o == "QulightConfigUIraidframesvertical_health" then o = QulightL.option_raidframes_vertical_health end
	if o == "QulightConfigUIraidframesalpha_health" then o = QulightL.option_raidframes_alpha_health end
	if o == "QulightConfigUIraidframesshow_range" then o = QulightL.option_raidframes_show_range end
	if o == "QulightConfigUIraidframesrange_alpha" then o = QulightL.option_raidframes_range_alpha end
	if o == "QulightConfigUIraidframeshp_value" then o = QulightL.option_raidframes_hp_value end
	if o == "QulightConfigUIraidframeswidth" then o = QulightL.option_raidframes_width end
	if o == "QulightConfigUIraidframesheight" then o = QulightL.option_raidframes_height end

	-- Frames
	if o == "QulightConfigUIraidframesshow_party" then o = QulightL.option_raidframes_show_party end
	if o == "QulightConfigUIraidframesshow_raid" then o = QulightL.option_raidframes_show_raid end
	if o == "QulightConfigUIraidframessolo_mode" then o = QulightL.option_raidframes_solo_mode end
	if o == "QulightConfigUIraidframesplayer_in_party" then o = QulightL.option_raidframes_player_in_party end
	if o == "QulightConfigUIraidframesraid_groups" then o = QulightL.option_raidframes_raid_groups end
	if o == "QulightConfigUIraidframesraid_groups_vertical" then o = QulightL.option_raidframes_raid_groups_vertical end
	if o == "QulightConfigUIraidframesparty_heal" then o = QulightL.option_raidframes_party_heal end
	if o == "QulightConfigUIraidframesraid_heal" then o = QulightL.option_raidframes_raid_heal end

	-- Icons
	if o == "QulightConfigUIraidframesicons_role" then o = QulightL.option_raidframes_icons_role end
	if o == "QulightConfigUIraidframesicons_raid_mark" then o = QulightL.option_raidframes_icons_raid_mark end
	if o == "QulightConfigUIraidframesicons_ready_check" then o = QulightL.option_raidframes_icons_ready_check end
	if o == "QulightConfigUIraidframesicons_leader" then o = QulightL.option_raidframes_icons_leader end
	-- Plugins
	if o == "QulightConfigUIraidframesplugins_debuffhighlight_icon" then o = QulightL.option_raidframes_plugins_debuffhighlight_icon end
	if o == "QulightConfigUIraidframesplugins_aura_watch" then o = QulightL.option_raidframes_plugins_aura_watch end
	if o == "QulightConfigUIraidframesplugins_aura_watch_timer" then o = QulightL.option_raidframes_plugins_aura_watch_timer end
	if o == "QulightConfigUIraidframesplugins_healcomm" then o = QulightL.option_raidframes_plugins_healcomm end
	if o == "QulightConfigUIraidframesplugins_auto_resurrection" then o = QulightL.option_raidframes_plugins_auto_resurrection end

	if o == "QulightConfigUIraidframesown_color" then o = QulightL.option_raidframes_own_color end
	if o == "QulightConfigUIraidframesfontsize" then o = QulightL.option_raidframes_fontsize end
    if o == "QulightConfigUIraidframesfontsizeEdge" then o = QulightL.option_raidframes_fontsizeEdge end
    if o == "QulightConfigUIraidframesoutline" then o = QulightL.option_raidframes_outline end
	if o == "QulightConfigUIraidframesbar_color_value" then o = QulightL.option_raidframes_bar_color_value end
	if o == "QulightConfigUIraidframescolor_value" then o = QulightL.option_raidframes_color_value end
	if o == "QulightConfigUIraidframesplugins_smooth_bar" then o = QulightL.option_raidframes_plugins_smooth_bar end
	if o == "QulightConfigUIraidframesshow_timer" then o = QulightL.option_raidframes_show_timer end
	if o == "QulightConfigUIraidframesshow_spiral" then o = QulightL.option_raidframes_show_spiral end
	if o == "QulightConfigUIraidframesdebuff_color_type" then o = QulightL.option_raidframes_debuff_color_type end

	--media
	if o == "QulightConfigUImedia" then o = QulightL.option_media end
	if o == "QulightConfigUImediafont" then o = QulightL.option_media_font end
	if o == "QulightConfigUImediapxfont" then o = QulightL.option_media_pxfont end
	if o == "QulightConfigUImediafontsize" then o = QulightL.option_media_fontsize end
	if o == "QulightConfigUImediabordercolor" then o = QulightL.option_media_bordercolor end
	if o == "QulightConfigUImediabackdropcolor" then o = QulightL.option_media_backdropcolor end
	if o == "QulightConfigUImediatexture" then o = QulightL.option_media_texture end
	if o == "QulightConfigUImediablank" then o = QulightL.option_media_blank end
	--bags
	if o == "QulightConfigUIbags" then o = QulightL.option_bags end
	if o == "QulightConfigUIbagsEnable" then o = QulightL.option_bags_Enable end
	if o == "QulightConfigUIbagsBagBars" then o = QulightL.option_bags_BagBars end
	if o == "QulightConfigUIbagsbankcolumns" then o = QulightL.option_bags_bankcolumns end
	if o == "QulightConfigUIbagsbuttonsize" then o = QulightL.option_bags_buttonsize end
	if o == "QulightConfigUIbagsbuttonspace" then o = QulightL.option_bags_buttonspace end
	--datatext
	if o == "QulightConfigUIdatatext" then o = QulightL.option_datatext end
	if o == "QulightConfigUIdatatextDurability" then o = QulightL.option_datatext_Durability end
	if o == "QulightConfigUIdatatextSystem" then o = QulightL.option_datatext_System end
	if o == "QulightConfigUIdatatextGold" then o = QulightL.option_datatext_Gold end
	if o == "QulightConfigUIdatatextGuild" then o = QulightL.option_datatext_Guild end
	if o == "QulightConfigUIdatatextFriends" then o = QulightL.option_datatext_Friends end
	if o == "QulightConfigUIdatatextBags" then o = QulightL.option_datatext_Bags end
	if o == "QulightConfigUIdatatextWowtime" then o = QulightL.option_datatext_Wowtime end
	if o == "QulightConfigUIdatatexttogglemenu" then o = QulightL.option_datatext_Togglemenu end
	if o == "QulightConfigUIdatatextspecswitcher" then o = QulightL.option_datatext_specswitcher end
	if o == "QulightConfigUIdatatextTime24" then o = QulightL.option_datatext_Time24 end
	if o == "QulightConfigUIdatatextLocaltime" then o = QulightL.option_datatext_Localtime end
	if o == "QulightConfigUIdatatextclasscolor" then o = QulightL.option_datatext_classcolor end
	if o == "QulightConfigUIdatatextcolor" then o = QulightL.option_datatext_color end
	if o == "QulightConfigUIdatatextpower" then o = QulightL.option_datatext_power end
	if o == "QulightConfigUIdatatextmastery" then o = QulightL.option_datatext_mastery end
	if o == "QulightConfigUIdatatexthaste" then o = QulightL.option_datatext_haste end
	if o == "QulightConfigUIdatatextcrit" then o = QulightL.option_datatext_crit end
	if o == "QulightConfigUIdatatextdps" then o = QulightL.option_datatext_dps end
	if o == "QulightConfigUIdatatexthps" then o = QulightL.option_datatext_hps end

	--loot
	if o == "QulightConfigUIloot" then o = QulightL.option_loot end
	if o == "QulightConfigUIlootlootframe" then o = QulightL.option_loot_lootframe end
	if o == "QulightConfigUIlootrolllootframe" then o = QulightL.option_loot_rolllootframe end

	if o == "QulightConfigUIcooldown" then o = QulightL.option_cooldown end
	if o == "QulightConfigUIcooldownenable" then o = QulightL.option_enable end
	if o == "QulightConfigUIskinframe" then o = QulightL.option_skinframe end
	if o == "QulightConfigUIskinframeenable" then o = QulightL.option_enable end

	--chat
	if o == "QulightConfigUIchatt" then o = QulightL.option_chat end
	if o == "QulightConfigUIchattenable" then o = QulightL.option_chat_enable end
	if o == "QulightConfigUIchattchatbar" then o = QulightL.option_chat_chatbar end
	if o == "QulightConfigUIchattchatframewidth" then o = QulightL.option_chat_chatframewidth end
	if o == "QulightConfigUIchattchatframeheight" then o = QulightL.option_chat_chatframeheight end
	if o == "QulightConfigUIchatteditboxwidth" then o = QulightL.option_chat_editboxwidth end
	if o == "QulightConfigUIchatteditboxheight" then o = QulightL.option_chat_editboxheight end
	if o == "QulightConfigUIchatttabtextcolor" then o = QulightL.option_chat_tabtextcolor end
	--buffdebuff
	if o == "QulightConfigUIbuffdebuff" then o = QulightL.option_buffs end
	if o == "QulightConfigUIbuffdebuffenable" then o = QulightL.option_buffs_enable end
	if o == "QulightConfigUIbuffdebufficonsize" then o = QulightL.option_buffs_iconsize end
	if o == "QulightConfigUIbuffdebufficonsizede" then o = QulightL.option_buffs_iconsizede end
	if o == "QulightConfigUIbuffdebufftimefontsize" then o = QulightL.option_buffs_timefontsize end
	if o == "QulightConfigUIbuffdebuffcountfontsize" then o = QulightL.option_buffs_countfontsize end
	if o == "QulightConfigUIbuffdebuffspacing" then o = QulightL.option_buffs_spacing end
	if o == "QulightConfigUIbuffdebuffdebuffspacing" then o = QulightL.option_buffs_debuffspacing end
	if o == "QulightConfigUIbuffdebufftimeYoffset" then o = QulightL.option_buffs_timeYoffset end
	if o == "QulightConfigUIbuffdebuffBUFFS_PER_ROW" then o = QulightL.option_buffs_BUFFS_PER_ROW end

	if o == "QulightConfigUItooltip" then o = QulightL.option_tooltip end
	if o == "QulightConfigUItooltipenable" then o = QulightL.option_tooltip_enable end
	if o == "QulightConfigUItooltiphidecombat" then o = QulightL.option_tooltip_hidecombat end
	if o == "QulightConfigUItooltiphidebuttons" then o = QulightL.option_tooltip_hidebuttons end
	if o == "QulightConfigUItooltiphideuf" then o = QulightL.option_tooltip_hideuf end
	if o == "QulightConfigUItooltipcursor" then o = QulightL.option_tooltip_cursor end
	if o == "QulightConfigUItooltiptitle" then o = QulightL.option_tooltip_title end

	if o == "QulightConfigUItooltipitemlevel" then o = QulightL.option_tooltip_itemlevel end
	if o == "QulightConfigUItooltipspellid" then o = QulightL.option_tooltip_spellid end

	--addonskinning
	if o == "QulightConfigUIaddonskins" then o = QulightL.option_addonsskins end
	if o == "QulightConfigUIaddonskinsDBM" then o = QulightL.option_addonsskins_DBM end
	if o == "QulightConfigUIaddonskinsPallyPower" then o = QulightL.option_addonsskins_PallyPower end
	if o == "QulightConfigUIaddonskinsSkada" then o = QulightL.option_addonsskins_Skada end
	if o == "QulightConfigUIaddonskinsRecount" then o = QulightL.option_addonsskins_Recount end
	if o == "QulightConfigUIaddonskinsOmen" then o = QulightL.option_addonsskins_Omen end
	if o == "QulightConfigUIaddonskinsKLE" then o = QulightL.option_addonsskins_KLE end
	if o == "QulightConfigUIaddonskinsQuartz" then o = QulightL.option_addonsskins_Quartz end
	if o == "QulightConfigUIaddonskinsBigwigs" then o = QulightL.option_addonsskins_Bigwigs end
	if o == "QulightConfigUIaddonskinsDXE" then o = QulightL.option_addonsskins_DXE end
	if o == "QulightConfigUIaddonskinsAurora" then o = QulightL.option_addonsskins_Aurora end
	if o == "QulightConfigUIaddonskinsCoolLine" then o = QulightL.option_addonsskins_CoolLine end
	--nameplates
	if o == "QulightConfigUInameplate" then o = QulightL.option_nameplates end
	if o == "QulightConfigUInameplateenable" then o = QulightL.option_nameplates_enable end
	if o == "QulightConfigUInameplatecombat" then o = QulightL.option_nameplates_combat end
	if o == "QulightConfigUInameplatehealth_value" then o = QulightL.option_nameplates_health_value end
	if o == "QulightConfigUInameplateshow_castbar_name" then o = QulightL.option_nameplates_show_castbar_name end
	if o == "QulightConfigUInameplateenhance_threat" then o = QulightL.option_nameplates_enhance_threat end
	if o == "QulightConfigUInameplateclass_icons" then o = QulightL.option_nameplates_class_icon end

	if o == "QulightConfigUInameplatewidth" then o = QulightL.option_nameplates_width end
	if o == "QulightConfigUInameplatead_width" then o = QulightL.option_nameplatesad_width end
	if o == "QulightConfigUInameplateheight" then o = QulightL.option_nameplates_height end
	if o == "QulightConfigUInameplatead_height" then o = QulightL.option_nameplatesad_height end
	if o == "QulightConfigUInameplateshowhealth" then o = QulightL.option_nameplates_showhealth end

	if o == "QulightConfigUInameplatetrackccauras" then o = QulightL.option_nameplates_trackccauras end
	if o == "QulightConfigUInameplateshowlevel" then o = QulightL.option_nameplates_showlevel end
	if o == "QulightConfigUInameplateaurasize" then o = QulightL.option_nameplates_aurasize end



	if o == "QulightConfigUInameplatename_abbrev" then o = QulightL.option_nameplates_name_abbrev end
	if o == "QulightConfigUInameplatehealer_icon" then o = QulightL.option_nameplates_healer_icon end

	if o == "QulightConfigUInameplatetrack_auras" then o = QulightL.option_nameplates_track_auras end
	if o == "QulightConfigUInameplateauras_size" then o = QulightL.option_nameplates_auras_size end
	if o == "QulightConfigUInameplategood_color" then o = QulightL.option_nameplates_good_color end
	if o == "QulightConfigUInameplatenear_color" then o = QulightL.option_nameplates_near_color end
	if o == "QulightConfigUInameplatebad_color" then o = QulightL.option_nameplates_bad_color end


	if o == "QulightConfigUIminimapp" then o = QulightL.option_Minimap end
	if o == "QulightConfigUIminimappenable" then o = QulightL.option_Minimapenable end
	if o == "QulightConfigUIminimappsize" then o = QulightL.option_Minimapminimapsize end
	if o == "QulightConfigUImap" then o = QulightL.option_Map end
	if o == "QulightConfigUImapenable" then o = QulightL.option_mapenable end

	if o == "QulightConfigUIactionbar" then o = QulightL.option_actionbar end
	if o == "QulightConfigUIactionbarenable" then o = QulightL.option_actionbar_enable end
	if o == "QulightConfigUIactionbarhotkey" then o = QulightL.option_actionbar_hotkey end
	if o == "QulightConfigUIactionbarmacrotext" then o = QulightL.option_actionbar_macrotext end
	if o == "QulightConfigUIactionbarhideSTANCE" then o = QulightL.option_actionbar_hideSTANCE end
	if o == "QulightConfigUIactionbarbuttonsize" then o = QulightL.option_actionbar_buttonsize end
	if o == "QulightConfigUIactionbarbuttonspacing" then o = QulightL.option_actionbar_buttonspacing end
	if o == "QulightConfigUIactionbarpetbuttonsize" then o = QulightL.option_actionbar_petbuttonsize end
	if o == "QulightConfigUIactionbarpetbuttonspacing" then o = QulightL.option_actionbar_petbuttonspacing end
	if o == "QulightConfigUIactionbarshowgrid" then o = QulightL.option_actionbar_showgrid end

	if o == "QulightConfigUIactionbarmainbarWidth" then o = QulightL.option_actionbar_mainbarWidth end
	if o == "QulightConfigUIactionbarownshdbar" then o = QulightL.option_actionbar_ownshdbar end
	if o == "QulightConfigUIactionbarlowversion" then o = QulightL.option_actionbar_lowversion end
	if o == "QulightConfigUIactionbarsidebarWidth" then o = QulightL.option_actionbar_sidebarWidth end

	if o == "QulightConfigUImisk" then o = QulightL.option_misk end
	if o == "QulightConfigUImiskarmory_link" then o = QulightL.option_armory_link end
	if o == "QulightConfigUImiskaddonmanager" then o = QulightL.option_addonmanager end
	if o == "QulightConfigUImiskclasstimer" then o = QulightL.option_classtimer end
	if o == "QulightConfigUImiskfilger" then o = QulightL.option_filger end
	if o == "QulightConfigUImiskraidutility" then o = QulightL.option_raidutility end
	if o == "QulightConfigUImiskBuffReminderRaidBuffs" then o = QulightL.option_BuffReminderRaidBuffs end
	if o == "QulightConfigUImiskReminder" then o = QulightL.option_Reminder end
	if o == "QulightConfigUImiskCooldownFlash" then o = QulightL.option_CooldownFlash end
	if o == "QulightConfigUImiskraidcooldowns" then o = QulightL.option_raidcooldowns end
	if o == "QulightConfigUImiskAutoScreen" then o = QulightL.option_AutoScreen end
	if o == "QulightConfigUImiskraidmarker" then o = QulightL.option_raidmarker end
	if o == "QulightConfigUImiskThreatbar" then o = QulightL.option_Threatbar end
	Qulight.option = o
end
classcolours = {
	["HUNTER"] = { r = 0.58, g = 0.86, b = 0.49 },
	["WARLOCK"] = { r = 0.6, g = 0.47, b = 0.85 },
	["PALADIN"] = { r = 1, g = 0.22, b = 0.52 },
	["PRIEST"] = { r = 0.8, g = 0.87, b = .9 },
	["MAGE"] = { r = 0, g = 0.76, b = 1 },
	["MONK"] = {r = 0.0, g = 1.00 , b = 0.59},
	["ROGUE"] = { r = 1, g = 0.91, b = 0.2 },
	["DRUID"] = { r = 1, g = 0.49, b = 0.04 },
	["SHAMAN"] = { r = 0, g = 0.6, b = 0.6 };
	["WARRIOR"] = { r = 0.9, g = 0.65, b = 0.45 },
	["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23 },
}
local _, class = UnitClass("player")

if CUSTOM_CLASS_COLORS then
	classcolours = CUSTOM_CLASS_COLORS
end

local r, g, b = classcolours[class].r, classcolours[class].g, classcolours[class].b

media = {
	["backdrop"] = "Interface\\AddOns\\QulightUI\\Root\\Media\\statusbar4",
	["gradient"] = "Interface\\Addons\\QulightUI\\Root\\Media\\gradient",
	["arrowUp"] = "Interface\\Addons\\QulightUI\\Root\\Media\\arrow-up-active",
	["arrowDown"] = "Interface\\Addons\\QulightUI\\Root\\Media\\arrow-down-active",
}

frames = {}

CreateBD = function(f)
	f:SetBackdrop({
		bgFile = media.backdrop,
		edgeFile = media.backdrop,
		edgeSize = 1,
	})
	f:SetBackdropColor(.05,.05,.05, 1)
	f:SetBackdropBorderColor(0, 0, 0)
	if not a then tinsert(frames, f) end
end

CreateGradient = function(f)
	local tex = f:CreateTexture(nil, "BORDER")
	tex:SetPoint("TOPLEFT", 1, -1)
	tex:SetPoint("BOTTOMRIGHT", -1, 1)
	tex:SetTexture(media.backdrop)
	tex:SetVertexColor(0.11, 0.11, 0.11, 1)

	return tex
end

ReskinCheck = function(f)
	f:SetNormalTexture("")
	f:SetPushedTexture("")
	f:SetHighlightTexture(media.backdrop)
	local hl = f:GetHighlightTexture()
	hl:SetPoint("TOPLEFT", 5, -5)
	hl:SetPoint("BOTTOMRIGHT", -5, 5)
	hl:SetVertexColor(r, g, b, .2)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetPoint("TOPLEFT", 4, -4)
	bd:SetPoint("BOTTOMRIGHT", -4, 4)
	bd:SetFrameLevel(f:GetFrameLevel()-1)
	CreateBD(bd, 0)

	local tex = CreateGradient(f)
	tex:SetPoint("TOPLEFT", 5, -5)
	tex:SetPoint("BOTTOMRIGHT", -5, 5)

	local ch = f:GetCheckedTexture()
	ch:SetDesaturated(true)
	ch:SetVertexColor(r, g, b)
end
local function colourButton(f)
	if not f:IsEnabled() then return end

	if useButtonGradientColour then
		f:SetBackdropColor(r, g, b, .3)
	else
		f.tex:SetVertexColor(r / 4, g / 4, b / 4)
	end
	f:SetBackdropBorderColor(0, 0, 0)
end

local function clearButton(f)
	if useButtonGradientColour then
		f:SetBackdropColor(0, 0, 0, 0)
	else
		f.tex:SetVertexColor(0.11, 0.11, 0.11, 1)
	end
	f:SetBackdropBorderColor(0, 0, 0)
end

Reskin = function(f, noHighlight)
	f:SetNormalTexture("")
	f:SetHighlightTexture("")
	f:SetPushedTexture("")
	f:SetDisabledTexture("")

	if f.Left then f.Left:SetAlpha(0) end
	if f.Middle then f.Middle:SetAlpha(0) end
	if f.Right then f.Right:SetAlpha(0) end
	if f.LeftSeparator then f.LeftSeparator:Hide() end
	if f.RightSeparator then f.RightSeparator:Hide() end

	CreateBD(f, .0)

	f.tex = CreateGradient(f)

	if not noHighlight then
		f:HookScript("OnEnter", colourButton)
 		f:HookScript("OnLeave", clearButton)
	end
end

local function colourScroll(f)
	if f:IsEnabled() then
		f.tex:SetVertexColor(r, g, b)
	end
end

local function clearScroll(f)
	f.tex:SetVertexColor(1, 1, 1)
end

ReskinScroll = function(f)
	local frame = f:GetName()

	if _G[frame.."Track"] then _G[frame.."Track"]:Hide() end
	if _G[frame.."BG"] then _G[frame.."BG"]:Hide() end
	if _G[frame.."Top"] then _G[frame.."Top"]:Hide() end
	if _G[frame.."Middle"] then _G[frame.."Middle"]:Hide() end
	if _G[frame.."Bottom"] then _G[frame.."Bottom"]:Hide() end

	local bu = _G[frame.."ThumbTexture"]
	bu:SetAlpha(0)
	bu:SetWidth(17)

	bu.bg = CreateFrame("Frame", nil, f)
	bu.bg:SetPoint("TOPLEFT", bu, 0, -2)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, 0, 4)
	CreateBD(bu.bg, 0)

	local tex = CreateGradient(f)
	tex:SetPoint("TOPLEFT", bu.bg, 1, -1)
	tex:SetPoint("BOTTOMRIGHT", bu.bg, -1, 1)

	local up = _G[frame.."ScrollUpButton"]
	local down = _G[frame.."ScrollDownButton"]

	up:SetWidth(17)
	down:SetWidth(17)

	Reskin(up, true)
	Reskin(down, true)

	up:SetDisabledTexture(media.backdrop)
	local dis1 = up:GetDisabledTexture()
	dis1:SetVertexColor(0, 0, 0, .4)
	dis1:SetDrawLayer("OVERLAY")

	down:SetDisabledTexture(media.backdrop)
	local dis2 = down:GetDisabledTexture()
	dis2:SetVertexColor(0, 0, 0, .4)
	dis2:SetDrawLayer("OVERLAY")

	local uptex = up:CreateTexture(nil, "ARTWORK")
	uptex:SetTexture(media.arrowUp)
	uptex:SetSize(8, 8)
	uptex:SetPoint("CENTER")
	uptex:SetVertexColor(1, 1, 1)
	up.tex = uptex

	local downtex = down:CreateTexture(nil, "ARTWORK")
	downtex:SetTexture(media.arrowDown)
	downtex:SetSize(8, 8)
	downtex:SetPoint("CENTER")
	downtex:SetVertexColor(1, 1, 1)
	down.tex = downtex

	up:HookScript("OnEnter", colourScroll)
	up:HookScript("OnLeave", clearScroll)
	down:HookScript("OnEnter", colourScroll)
	down:HookScript("OnLeave", clearScroll)
end

local NewButton = function(text,parent)

	local result = CreateFrame("Button", nil, parent)
	local label = result:CreateFontString(nil,"OVERLAY",nil)
	label:SetFont(Qulight["media"].font, 10, "OUTLINE")
	label:SetText(text)
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)

	return result
end

StaticPopupDialogs["PERCHAR"] = {
	text = QulightL.option_perchar,
	OnAccept = function()
		if QulightConfigAllCharacters:GetChecked() then
			QulightConfigAll[myPlayerRealm][myPlayerName] = true
		else
			QulightConfigAll[myPlayerRealm][myPlayerName] = false
		end
		ReloadUI()
	end,
	OnCancel = function()
		QulightConfigCover:Hide()
		if QulightConfigAllCharacters:GetChecked() then
			QulightConfigAllCharacters:SetChecked(false)
		else
			QulightConfigAllCharacters:SetChecked(true)
		end
	end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_PERCHAR"] = {
	text = QulightL.option_resetchar,
	OnAccept = function()
		QulightConfig = QulightConfigSettings
		ReloadUI()
	end,
	OnCancel = function() if QulightConfigUI and QulightConfigUI:IsShown() then QulightConfigCover:Hide() end end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["RESET_ALL"] = {
	text = QulightL.option_resetall,
	OnAccept = function()
		QulightConfigSettings = nil
		QulightConfig = nil
		ReloadUI()
	end,
	OnCancel = function() QulightConfigCover:Hide() end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
}

-- We wanna make sure we have all needed tables when we try add values
local function SetValue(group,option,value)
	--Determine if we should be copying our default settings to our player settings, this only happens if we're not using player settings by default
	local mergesettings
	if QulightConfig == QulightConfigSettings then
		mergesettings = true
	else
		mergesettings = false
	end

	if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
		if not QulightConfig then QulightConfig = {} end
		if not QulightConfig[group] then QulightConfig[group] = {} end
		QulightConfig[group][option] = value
	else
		--Set PerChar settings to the same as our settings if theres no per char settings
		if mergesettings == true then
			if not QulightConfig then QulightConfig = {} end
			if not QulightConfig[group] then QulightConfig[group] = {} end
			QulightConfig[group][option] = value
		end

		if not QulightConfigSettings then QulightConfigSettings = {} end
		if not QulightConfigSettings[group] then QulightConfigSettings[group] = {} end
		QulightConfigSettings[group][option] = value
	end
end

local VISIBLE_GROUP = nil
local function ShowGroup(group)

	if(VISIBLE_GROUP) then
		_G["QulightConfigUI"..VISIBLE_GROUP]:Hide()
	end
	if _G["QulightConfigUI"..group] then
		local o = "QulightConfigUI"..group
		Local(o)
		_G["QulightConfigUITitle"]:SetText(Qulight.option)
		local height = _G["QulightConfigUI"..group]:GetHeight()
		_G["QulightConfigUI"..group]:Show()
		local scrollamntmax = 305
		local scrollamntmin = scrollamntmax - 10
		local max = height > scrollamntmax and height-scrollamntmin or 1

		if max == 1 then
			_G["QulightConfigUIGroupSlider"]:SetValue(1)
			_G["QulightConfigUIGroupSlider"]:Hide()
		else
			_G["QulightConfigUIGroupSlider"]:SetMinMaxValues(0, max)
			_G["QulightConfigUIGroupSlider"]:Show()
			_G["QulightConfigUIGroupSlider"]:SetValue(1)
		end
		_G["QulightConfigUIGroup"]:SetScrollChild(_G["QulightConfigUI"..group])

		local x
		if QulightConfigUIGroupSlider:IsShown() then
			_G["QulightConfigUIGroup"]:EnableMouseWheel(true)
			_G["QulightConfigUIGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if QulightConfigUIGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["QulightConfigUIGroupSlider"]:GetValue()
						_G["QulightConfigUIGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["QulightConfigUIGroupSlider"]:GetValue()
						_G["QulightConfigUIGroupSlider"]:SetValue(x - 30)
					end
				end
			end)
		else
			_G["QulightConfigUIGroup"]:EnableMouseWheel(false)
		end
		VISIBLE_GROUP = group
	end
end

function CreateQulightConfigUI()

	if QulightConfigUI then
		ShowGroup("general")
		QulightConfigUI:Show()
		return
	end

	-- MAIN FRAME
	local QulightConfigUI = CreateFrame("Frame","QulightConfigUI",UIParent)
	QulightConfigUI:SetPoint("CENTER", UIParent, "CENTER", 90, 90)
	QulightConfigUI:SetWidth(600)
	QulightConfigUI:SetHeight(400)
	QulightConfigUI:SetFrameStrata("DIALOG")
	QulightConfigUI:SetFrameLevel(0)

	-- TITLE 2
	local QulightConfigUITitleBox = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	QulightConfigUITitleBox:SetWidth(620)
	QulightConfigUITitleBox:SetHeight(30)
	QulightConfigUITitleBox:SetPoint("TOPLEFT", -10, 42)
	CreateBD(QulightConfigUITitleBox, 0)

	local title = QulightConfigUITitleBox:CreateFontString("QulightConfigUITitle", "OVERLAY")
	title:SetFont(Qulight["media"].font, 12)
	title:SetPoint("LEFT", QulightConfigUITitleBox, "LEFT", 4, 0)

	local qulightlolpro = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	qulightlolpro:SetWidth(150)
	qulightlolpro:SetHeight(30)
	qulightlolpro:SetPoint("TOPLEFT", -165, 42)
	CreateBD(qulightlolpro, 0)

	local qulightlolprotitle = qulightlolpro:CreateFontString("qulightlolpro", "OVERLAY")
	qulightlolprotitle:SetFont(Qulight["media"].font, 18)
	qulightlolprotitle:SetText("Qulight UI")
	qulightlolprotitle:SetPoint("CENTER")

	local QulightConfigUIBG = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	QulightConfigUIBG:SetPoint("TOPLEFT", -10, 10)
	QulightConfigUIBG:SetPoint("BOTTOMRIGHT", 10, -10)
	CreateBD(QulightConfigUIBG, 0)

	-- BACKGROUND
	local BackgroundQulightConfigUI = CreateFrame("Frame", "QulightConfigUI",QulightConfigUI)
	BackgroundQulightConfigUI:SetPoint("TOPLEFT", qulightlolpro, "TOPLEFT", -5, 5)
	BackgroundQulightConfigUI:SetWidth(785)
	BackgroundQulightConfigUI:SetHeight(490)
	BackgroundQulightConfigUI:SetFrameLevel(0)
	CreateStyle(BackgroundQulightConfigUI, 2)

	-- GROUP SELECTION ( LEFT SIDE )
	local groups = CreateFrame("ScrollFrame", "QulightCatagoryGroup", QulightConfigUI)
	groups:SetPoint("TOPLEFT",-155,0)
	groups:SetWidth(130)
	groups:SetHeight(400)

	local groupsBG = CreateFrame("Frame","QulightConfigUI",QulightConfigUI)
	groupsBG:SetPoint("TOPLEFT", groups, -10, 10)
	groupsBG:SetPoint("BOTTOMRIGHT", groups, 10, -10)
	CreateBD(groupsBG, 0)

	--This is our frame we will use to prevent clicking on the config, before you choose a popup window
	local QulightConfigCover = CreateFrame("Frame", "QulightConfigCover", QulightConfigUI)
	QulightConfigCover:SetPoint("TOPLEFT", QulightCatagoryGroup, "TOPLEFT")
	QulightConfigCover:SetPoint("BOTTOMRIGHT", QulightConfigUI, "BOTTOMRIGHT")
	QulightConfigCover:SetFrameLevel(QulightConfigUI:GetFrameLevel() + 20)
	QulightConfigCover:EnableMouse(true)
	QulightConfigCover:SetScript("OnMouseDown", function(self) print(QulightL.option_makeselection) end)
	QulightConfigCover:Hide()

	local slider = CreateFrame("Slider", "QulightConfigUICatagorySlider", groups)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(18)
	slider:SetHeight(400)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self,value) groups:SetVerticalScroll(value) end)
	local r,g,b,a = .15,.15,.15,0
	slider:SetBackdropColor(r,g,b,0.2)
	local child = CreateFrame("Frame",nil,groups)
	child:SetPoint("TOPLEFT")
	local offset=5
	for group in pairs(ALLOWED_GROUPS) do
		local o = "QulightConfigUI"..group
		Local(o)
		local button = NewButton(Qulight.option, child)
		button:SetHeight(14)
		button:SetWidth(110)
		button:SetPoint("TOPLEFT", 5,-(offset))
		button:SetScript("OnClick", function(self) ShowGroup(group) end)
		offset=offset+16
	end
	child:SetWidth(110)
	child:SetHeight(offset)
	slider:SetValue(1)
	groups:SetScrollChild(child)

	local x
	_G["QulightCatagoryGroup"]:EnableMouseWheel(true)
	_G["QulightCatagoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
		if _G["QulightConfigUICatagorySlider"]:IsShown() then
			if delta == -1 then
				x = _G["QulightConfigUICatagorySlider"]:GetValue()
				_G["QulightConfigUICatagorySlider"]:SetValue(x + 10)
			elseif delta == 1 then
				x = _G["QulightConfigUICatagorySlider"]:GetValue()
				_G["QulightConfigUICatagorySlider"]:SetValue(x - 20)
			end
		end
	end)
	-- GROUP SCROLLFRAME ( RIGHT SIDE)
	local group = CreateFrame("ScrollFrame", "QulightConfigUIGroup", QulightConfigUI)
	group:SetPoint("TOPLEFT",0,5)
	group:SetWidth(600)
	group:SetHeight(400)

	local slider = CreateFrame("Slider", "QulightConfigUIGroupSlider", group)
	slider:SetPoint("TOPRIGHT",0,0)
	slider:SetWidth(18)
	slider:SetHeight(400)

	local r,g,b,a = .15,.15,.15,0
	slider:SetBackdropColor(r,g,b,0.2)
	slider:SetScript("OnValueChanged", function(self,value) group:SetVerticalScroll(value) end)

	for group in pairs(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame","QulightConfigUI"..group,QulightConfigUIGroup)
		frame:SetPoint("TOPLEFT")
		frame:SetWidth(290)

		local offset=5

		if type(Qulight[group]) ~= "table" then error(group.." GroupName not found in config table.") return end
		for option,value in pairs(Qulight[group]) do

			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "QulightConfigUI"..group..option, frame, "InterfaceOptionsCheckButtonTemplate")
				local o = "QulightConfigUI"..group..option
				Local(o)
				_G["QulightConfigUI"..group..option.."Text"]:SetText(Qulight.option)
				_G["QulightConfigUI"..group..option.."Text"]:SetFont(Qulight["media"].font, 10)
				button:SetChecked(value)
				ReskinCheck(button)
				button:SetScript("OnClick", function(self) SetValue(group,option,(self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", 5, -(offset))
				offset = offset+20
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(Qulight["media"].font, 10)
				local o = "QulightConfigUI"..group..option
				Local(o)
				label:SetText(Qulight.option)
				label:SetWidth(370)
				label:SetHeight(18)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))

				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(250)
				editbox:SetHeight(18)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3,0,0,0)
				editbox:SetBackdrop({
					bgFile = "Interface\\Buttons\\WHITE8x8",
					tiled = false,
				})
				editbox:SetBackdropColor(0,0,0,0.5)
				editbox:SetBackdropBorderColor(0,0,0,1)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("TOPLEFT", 5, -(offset+20))
				editbox:SetText(value)
				CreateBD(editbox, 0)

				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SetWidth(editbox:GetHeight())
				CreateBD(okbutton, 0)
				okbutton:SetPoint("LEFT", editbox, "RIGHT", 2, 0)

				local oktext = okbutton:CreateFontString(nil,"OVERLAY",nil)
				oktext:SetFont(Qulight["media"].font,10)
				oktext:SetText("OK")
				oktext:SetPoint("CENTER", 1, 0)
				oktext:SetJustifyH("CENTER")
				okbutton:Hide()

				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(group,option,tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(group,option,tostring(editbox:GetText())) end)
				end
				offset = offset+45
			elseif type(value) == "table" and not TableFilter[option] then
				local label = frame:CreateFontString(nil,"OVERLAY",nil)
				label:SetFont(Qulight["media"].font,10)
				local o = "QulightConfigUI"..group..option
				Local(o)
				label:SetText(Qulight.option)
				label:SetWidth(370)
				label:SetHeight(18)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -(offset))

				local colorbutton = CreateFrame("Button", colorbuttonname, frame)
				colorbutton:SetHeight(18)
				colorbutton:SetWidth(60)
				CreateBD(colorbutton, 0)
				colorbutton:SetBackdropBorderColor(unpack(value))
				colorbutton:SetPoint("LEFT", label, "RIGHT", 2, 0)
				local colortext = colorbutton:CreateFontString(nil,"OVERLAY",nil)
				colortext:SetFont(Qulight["media"].font,10)
				colortext:SetText("Set Color")
				colortext:SetPoint("CENTER")
				colortext:SetJustifyH("CENTER")

				local function round(number, decimal)
					return (("%%.%df"):format(decimal)):format(number)
				end

				colorbutton:SetScript("OnMouseDown", function(button)
					if ColorPickerFrame:IsShown() then return end
					local oldr, oldg, oldb, olda = unpack(value)

					local function ShowColorPicker(r, g, b, a, changedCallback, sameCallback)
						HideUIPanel(ColorPickerFrame)
						ColorPickerFrame.button = button
						ColorPickerFrame:SetColorRGB(r,g,b)
						ColorPickerFrame.hasOpacity = (a ~= nil and a < 1)
						ColorPickerFrame.opacity = a
						ColorPickerFrame.previousValues = {oldr, oldg, oldb, olda}
						ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, sameCallback;
						ShowUIPanel(ColorPickerFrame)
					end

					local function ColorCallback(restore)
						-- Something change
						if restore ~= nil or button ~= ColorPickerFrame.button then return end

						local newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()

						value = { newR, newG, newB, newA }
						SetValue(group,option,(value))
						button:SetBackdropBorderColor(newR, newG, newB, newA)
					end

					local function SameColorCallback()
						value = { oldr, oldg, oldb, olda }
						SetValue(group,option,(value))
						button:SetBackdropBorderColor(oldr, oldg, oldb, olda)
					end

					ShowColorPicker(oldr, oldg, oldb, olda, ColorCallback, SameColorCallback)
				end)

				offset = offset+25
			end
		end

		frame:SetHeight(offset)
		frame:Hide()

	end

	local close = NewButton(QulightL.option_close, QulightConfigUI)
	close:SetWidth(90)
	close:SetHeight(25)
	close:SetPoint("BOTTOMRIGHT", 10, -38)
	close:SetScript("OnClick", function(self) QulightConfigUI:Hide() end)
	Reskin(close)


	local load = NewButton(QulightL.option_apply, QulightConfigUI)
	load:SetHeight(25)
	load:SetWidth(90)
	load:SetPoint("RIGHT", close, "LEFT", -15, 0)
	load:SetScript("OnClick", function(self) ReloadUI() end)
	Reskin(load)

	local reset = NewButton(QulightL.option_reset, QulightConfigUI)
	reset:SetWidth(90)
	reset:SetHeight(25)
	reset:SetPoint("RIGHT", load, "LEFT", -15, 0)
	reset:SetScript("OnClick", function(self)
		QulightConfigCover:Show()
		if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end
	end)
	Reskin(reset)

	if QulightConfigAll then
		local button = CreateFrame("CheckButton", "QulightConfigAllCharacters", QulightConfigUITitleBox, "InterfaceOptionsCheckButtonTemplate")

		button:SetScript("OnClick", function(self) StaticPopup_Show("PERCHAR") QulightConfigCover:Show() end)

		button:SetPoint("RIGHT", QulightConfigUITitleBox, "RIGHT",-3, 0)
		ReskinCheck(button)
		local label = QulightConfigAllCharacters:CreateFontString(nil,"OVERLAY",nil)
		label:SetFont(Qulight["media"].font,10)

		label:SetText(QulightL.option_setsavedsetttings)
		label:SetPoint("RIGHT", button, "LEFT")

		if QulightConfigAll[myPlayerRealm][myPlayerName] == true then
			button:SetChecked(true)
		else
			button:SetChecked(false)
		end
	end

end

local quuuu = CreateFrame("Button", "GameMenuButtonQulightUI", GameMenuFrame, "GameMenuButtonTemplate")
quuuu:SetText("Qulight UI")
quuuu:SetPoint("TOP", "GameMenuButtonAddons", "BOTTOM", 0, -1)

GameMenuFrame:HookScript("OnShow", function()
	GameMenuFrame:SetHeight(GameMenuFrame:GetHeight() + quuuu:GetHeight())
	if IsMacClient() then
		GameMenuButtonMacOptions:SetPoint("TOP", quuuu, "BOTTOM", 0, -16)
	else
		GameMenuButtonLogout:SetPoint("TOP", quuuu, "BOTTOM", 0, -16)
	end
end)

quuuu:SetScript("OnClick", function()
	HideUIPanel(GameMenuFrame)
	CreateQulightConfigUI()
end)

SlashCmdList["UICONFIG"] = CreateQulightConfigUI
SLASH_UICONFIG1 = "/config"