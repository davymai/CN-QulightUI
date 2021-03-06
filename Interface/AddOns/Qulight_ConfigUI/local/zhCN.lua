﻿if GetLocale() == "zhCN" then

-- general
	QulightL.option_general = "综合"
	QulightL.option_general_uiscale = "界面自动缩放"
	QulightL.option_general_multisample = "多重采样保护(清除1px边框)"
	QulightL.option_general_customuiscale = "界面缩放(如果关闭了界面自动缩放)"
	QulightL.option_general_AutoRepair = "自动修理物品"
	QulightL.option_general_AutoGreed = "自动贪婪"
	QulightL.option_general_AutoDisenchant = "自动分解"
	QulightL.option_general_AutoAcceptInvite = "使用自动接受邀请(好友或公会会员)"
	QulightL.option_general_BlizzardsErrorFrameHiding = "隐藏屏幕中间红字错误显示"
	QulightL.option_general_topbottompanel = "顶部/底部装饰面板"
	QulightL.option_general_autoinvite = "自动邀请"
	QulightL.option_general_centerpanel = "左/右属性统计信息"

	-- Unitframes
	QulightL.option_unitframes = "单位框体"
	QulightL.option_unitframes_enable = "启用单位框体"
 	QulightL.option_unitframes_HealFrames = "治疗者模式"
	QulightL.option_unitframes_showIndicators = "治疗者模式下显示Buffs指示"
	QulightL.option_unitframes_showAuraWatch = "在角落显示Buffs"
	QulightL.option_unitframes_ShowParty = "显示小队(以团队模式显示5人小队)"
	QulightL.option_unitframes_ShowRaid = "显示团队框架"
	QulightL.option_unitframes_RaidShowSolo = "单人模式也显示团队框架"
	QulightL.option_unitframes_RaidShowAllGroups = "显示全部团队队伍(当团队超过25人队友)"
	QulightL.option_unitframes_enableDebuffHighlight = "启用团队模式Debuff高亮显示"
	QulightL.option_unitframes_showRaidDebuffs = "启用团队单位上重要Debuff显示"
	QulightL.option_unitframes_showtot = "显示目标的目标"
	QulightL.option_unitframes_showpet = "显示宠物头像"
	QulightL.option_unitframes_showfocus = "显示焦点头像"
	QulightL.option_unitframes_showfocustarget = "显示焦点的目标"
	QulightL.option_unitframes_showBossFrames = "首领头像"
	QulightL.option_unitframes_TotemBars = "显示图腾条"
	QulightL.option_unitframes_MTFrames = "显示MT头像"
	QulightL.option_unitframes_ArenaFrames = "显示竞技场头像"
	QulightL.option_unitframes_Reputationbar = "显示声望条"
	QulightL.option_unitframes_Experiencebar = "显示经验条"
	QulightL.option_unitframes_showPlayerAuras = "使用玩家头像自带Buff/Debuff代替Blizzard的默认Buff/Debuff"
	QulightL.option_unitframes_ThreatBar = "显示仇恨条"
	QulightL.option_unitframes_showPortrait = "显示玩家/目标的3D头像"
	QulightL.option_unitframes_showRunebar = "显示死亡骑士符文"
	QulightL.option_unitframes_showHolybar = "显示圣骑士的圣能"
	QulightL.option_unitframes_showEclipsebar = "显示德鲁伊平衡天赋的日月精华"
	QulightL.option_unitframes_showShardbar = "显示术士的灵魂碎片"
	QulightL.option_unitframes_RCheckIcon = "显示团队准备就绪图标"
	QulightL.option_unitframes_Castbars = "使用头像自带施法条"
	QulightL.option_unitframes_showLFDIcons = "显示地下城职责图标"
    QulightL.option_unitframes_HealthcolorClass = "使用生命条职业着色"
	QulightL.option_unitframes_Powercolor = "使用能量条职业着色"
	QulightL.option_unitframes_showPartyFrames	 = "显示小队框架"
	QulightL.option_unitframes_bigcastbar = "使用大施法条"
	QulightL.option_unitframes_widthbigcastbar = "大施法条宽度"
	QulightL.option_unitframes_heightbigcastbar = "大施法条高度"

	--raidframes
	QulightL.option_raidframes = "团队框体"
	-- Main
	QulightL.option_raidframes_aggro_border = "仇恨边框"
	QulightL.option_raidframes_deficit_health = "团队生命值亏减模式"
	QulightL.option_raidframes_power = "显示能量条"
	QulightL.option_raidframes_vertical_health = "垂直显示框体生命值"
	QulightL.option_raidframes_alpha_health = "满血隐藏"
	QulightL.option_raidframes_show_range = "开启距离透明度变化"
	QulightL.option_raidframes_range_alpha = "超出距离透明显示"
	QulightL.option_raidframes_hp_value = "法力值文字"
	QulightL.option_raidframes_width = "小框体宽度"
	QulightL.option_raidframes_height = "小框体高度"
	QulightL.option_raidframes_show_party = "显示小队"
	QulightL.option_raidframes_show_raid = "显示团队 "
	QulightL.option_raidframes_solo_mode = "总是显示自己"
	QulightL.option_raidframes_player_in_party = "小队显示自己"
	QulightL.option_raidframes_raid_groups = "显示队伍数量"
	QulightL.option_raidframes_raid_groups_vertical = "竖向排列队伍 (仅治疗模式)"
	QulightL.option_raidframes_icons_role = "在框体中显示角色图标"
	QulightL.option_raidframes_icons_raid_mark = "团队标记"
	QulightL.option_raidframes_icons_ready_check = "显示团队准备就绪图标"
	QulightL.option_raidframes_icons_leader = "团队队长,助理,拾取图标"
	QulightL.option_raidframes_plugins_debuffhighlight_icon = "高亮DeBuff+图标"
	QulightL.option_raidframes_plugins_aura_watch = "团队Debuff图标"
	QulightL.option_raidframes_plugins_aura_watch_timer = "团队debuff图标中显示计时"
	QulightL.option_raidframes_plugins_healcomm = "即将受到的治疗"
	QulightL.option_raidframes_plugins_auto_resurrection = "中键点击救人 (Clique 插件开启时无效)"
	QulightL.option_raidframes_own_color = "褪色模式(启用自定义颜色) "
	QulightL.option_raidframes_fontsize = "文字大小"
   	QulightL.option_raidframes_fontsizeEdge = "Add Font size"
 	QulightL.option_raidframes_outline = "文字样式"
	QulightL.option_raidframes_bar_color_value = "以目前剩余血量着色"
	QulightL.option_raidframes_color_value = "生命/法力值以职业颜色着色 "
	QulightL.option_raidframes_plugins_smooth_bar = "平滑条"
	QulightL.option_raidframes_show_timer = "在图标上显示冷却计时"
	QulightL.option_raidframes_show_spiral = "漩涡冷却样式 "
	QulightL.option_raidframes_debuff_color_type = "法术类型着色DeBuffs"

	--media
	QulightL.option_media = "素材"
	QulightL.option_media_font = "Qulight UI 主要字体"
	QulightL.option_media_pxfont = "Qulight UI 像素字体"
	QulightL.option_media_fontsize = "字体大小 "
	QulightL.option_media_bordercolor = "边框颜色"
	QulightL.option_media_backdropcolor = "背景颜色"
	QulightL.option_media_texture = "材质"
	QulightL.option_media_blank = "背景材质"
	--bags
	QulightL.option_bags = "背包"
	QulightL.option_bags_Enable = "启用背包整合"
	QulightL.option_bags_BagBars = "启用背包面板"
	--datatext
	QulightL.option_datatext = "数据栏信息"
	QulightL.option_datatext_Durability = "耐久度 位置(数字为0时则为不显示)"
	QulightL.option_datatext_System = "延迟/帧数 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Gold = "金钱 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Guild = "公会 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Friends = "好友 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Bags = "背包 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Wowtime = "时间 位置(数字为0时则为不显示)"
	QulightL.option_datatext_Togglemenu = "菜单切换"
	QulightL.option_datatext_specswitcher = "天赋切换位置(数字为0时则为不显示)"
	QulightL.option_datatext_Time24 = "使用24小时制"
	QulightL.option_datatext_Localtime = "使用本地时间代替服务器时间"
	QulightL.option_datatext_classcolor = "数据栏文字职业着色"
	QulightL.option_datatext_color = "如果信息条文本职业着色失败，则点击选择: "
	QulightL.option_datatext_power = "攻击强度/法术强度 位置(数字为0时则为不显示)"
	QulightL.option_datatext_mastery = "精通 位置(数字为0时则为不显示)"
	QulightL.option_datatext_haste = "急速 位置(数字为0时则为不显示)"
	QulightL.option_datatext_crit = "暴击 位置(数字为0时则为不显示)"
	QulightL.option_datatext_dps = "DPS 位置(数字为0时则为不显示)"
	QulightL.option_datatext_hps = "HPS 位置(数字为0时则为不显示)"
	QulightL.option_bags_bankcolumns = "The number of cells in the row"
	QulightL.option_bags_buttonsize = "Cell Size"
	QulightL.option_bags_buttonspace = "Space Between Cells"
	--loot
	QulightL.option_loot = "拾取/ROLL"
	QulightL.option_loot_lootframe = "使用拾取美化"
	QulightL.option_loot_rolllootframe = "使用ROLL点美化"
	QulightL.option_loot_position = "拾取位置显示"
	--misk
	QulightL.option_enable = "启用"
	QulightL.option_armory_link = "Enable Armory Link (Then dont work Maintank and aimer)"
	QulightL.option_addonmanager = "插件管理器"
	QulightL.option_togglemenu = "Toggle menu"
	QulightL.option_togglemenu_buttonwidth = "按钮宽度"
	QulightL.option_togglemenu_buttonheight = "按钮高度"
	QulightL.option_togglemenu_classcolor = "边框职业着色"
	QulightL.option_classtimer = "Class Timer"
	QulightL.option_cooldown = "冷却计时"
	QulightL.option_skinframe = "Skinframe"
	QulightL.option_filger = "Filger"
	QulightL.option_Threatbar = "仇恨条"
	--chat
	QulightL.option_chat = "聊天窗口"
	QulightL.option_chat_enable = "启用"
	QulightL.option_chat_chatbar= "使用Chat Bar"
	QulightL.option_chat_chatframewidth = "聊天框宽度"
	QulightL.option_chat_chatframeheight = "聊天框高度"
	QulightL.option_chat_editboxwidth = "输入栏宽度"
	QulightL.option_chat_editboxheight = "输入栏高度"
	QulightL.option_chat_tabtextcolor = "标签文本职业着色"
	QulightL.option_chat_ChatFrame = "聊天框架"
    --buffs
	QulightL.option_buffs = "Buffs/Debuffs"
	QulightL.option_buffs_enable = "启用"
	QulightL.option_buffs_iconsize = "Buffs大小"
	QulightL.option_buffs_iconsizede = "Debuffs大小"
	QulightL.option_buffs_timefontsize = "Buffs时间字体大小"
	QulightL.option_buffs_countfontsize = "Buffs层数字体大小"
	QulightL.option_buffs_spacing = "Buffs间隔"
	QulightL.option_buffs_debuffspacing = "Debuffs间隔"
	QulightL.option_buffs_timeYoffset = "时间沿Y轴偏移"
	QulightL.option_buffs_BUFFS_PER_ROW = "每行Buffs数量"
	QulightL.option_buffs_BUFFpos = "Buffs位置"
	QulightL.option_buffs_DEBUFFpos = "Debuffs位置"
	--addonskinning
	QulightL.option_addonsskins = "插件皮肤"
	QulightL.option_addonsskins_DBM = "DBM"
	QulightL.option_addonsskins_PallyPower = "PallyPower"
	QulightL.option_addonsskins_Skada = "Skada"
	QulightL.option_addonsskins_Recount = "Recount"
	QulightL.option_addonsskins_Omen = "Omen"
	QulightL.option_addonsskins_KLE = "KLE"
	QulightL.option_addonsskins_Quartz = "Quartz"
	QulightL.option_addonsskins_Bigwigs = "Bigwigs"
	QulightL.option_addonsskins_DXE = "DXE"
	QulightL.option_addonsskins_Aurora = "Aurora"
	QulightL.option_addonsskins_CoolLine = "CoolLine"
	--nameplates
	QulightL.option_nameplates = "姓名板"
	QulightL.option_nameplates_enable  = "启用姓名板"
	QulightL.option_nameplates_showlevel = "显示等级"
	QulightL.option_nameplates_width = "姓名板默认宽度"
	QulightL.option_nameplates_showhealth = "显示姓名板上血量的具体数值(这将会增加姓名版的大小)"
	QulightL.option_nameplates_enhance_threat = "在姓名板生命条上显示你当前目标的仇恨颜色"
	QulightL.option_nameplates_combat = "仅战斗中显示姓名板."
	QulightL.option_nameplates_good_color = "仇恨|cff00ff00安全|r颜色"
	QulightL.option_nameplates_near_color = "仇恨|cfffff100中性|r颜色"
	QulightL.option_nameplates_bad_color = "仇恨|cffff0000危险|r颜色"
	QulightL.option_nameplates_goodtransitioncolor = "当获得/丢失仇恨时此颜色将会显示, 如果是坦克会显示获得仇恨, 如果是 输出/治疗 会显示失去仇恨"
	QulightL.option_nameplates_badtransitioncolor = "当获得/丢失仇恨时此颜色将会显示, 如果是坦克会显示失去仇恨, 如果是 输出/治疗 会显示获得仇恨"
	QulightL.option_nameplates_trackccauras = "在姓名板上检测你和其他友好玩家所释放的Debuff"
	QulightL.option_nameplates_height = "姓名板默认高度"
	QulightL.option_nameplatesad_height = "目标姓名板高度"
	QulightL.option_nameplatesad_width = "目标姓名板宽度"
	QulightL.option_nameplates_show_castbar_name = "施法名称"
	QulightL.option_nameplates_health_value = "显示血量文字"
	QulightL.option_nameplates_name_abbrev = "显示姓名缩写"
	QulightL.option_nameplates_healer_icon = "显示治疗者图标"
	QulightL.option_nameplates_class_icon = "显示职业图标"
	QulightL.option_nameplates_track_auras = "显示ebuffs"
	QulightL.option_nameplates_auras_size = "Debuffs 大小"

	QulightL.option_Minimap = "小地图"
	QulightL.option_Minimapenable = "启用"
	QulightL.option_Minimapminimapsize = "小地图大小"
	QulightL.option_Map = "大地图"
	QulightL.option_mapenable = "启用"

	QulightL.option_raidmarker = "标记栏"
	QulightL.option_markbarenable = "使用标记栏"


	-- tooltip
	QulightL.option_tooltip = "信息提示"
	QulightL.option_tooltip_enable = "使用信息提示"
	QulightL.option_tooltip_hidecombat = "战斗隐藏信息提示"
	QulightL.option_tooltip_hidebuttons = "隐藏动作条上信息提示"
	QulightL.option_tooltip_hideuf = "隐藏头像上的信息提示"
	QulightL.option_tooltip_cursor = "信息提示跟随鼠标"
	QulightL.option_tooltip_itemlevel = "显示目标装备等级"
	QulightL.option_tooltip_spellid = "显示物品ID"
	QulightL.option_tooltip_talents = "显示目标天赋"
	QulightL.option_tooltip_title = "关闭信息提示标题"

	-- action bar
	QulightL.option_actionbar = "动作条"
	QulightL.option_actionbar_enable = "启用动作条插件"
	QulightL.option_actionbar_hotkey = "在按键中显示快捷键"
	QulightL.option_actionbar_macrotext = "显示宏名称"
	QulightL.option_actionbar_hideSTANCE = "隐藏姿态栏"
	QulightL.option_actionbar_bottomrows = "主要动作条(1-3)"
	QulightL.option_actionbar_rightbars = "右边动作条 (0-3)"
	QulightL.option_actionbar_splitbar = "将右侧动作条分割排布到主动作条两侧"
	QulightL.option_actionbar_buttonsize = "主动作条按键大小"
	QulightL.option_actionbar_buttonspacing = "主动作条按键间隔"
	QulightL.option_actionbar_petbuttonsize = "宠物动作条按键大小"
	QulightL.option_actionbar_petbuttonspacing = "宠物动作条按键间隔"
	QulightL.option_actionbar_swaptopbottombar = "转换上下动作条位置"
	QulightL.option_actionbar_verticalshapeshift = "垂直显示姿态条"
	QulightL.option_actionbar_microbar = "迷你系统栏"
	QulightL.option_actionbar_mousemicro = "鼠标指向迷你系统栏"
	QulightL.option_actionbar_showgrid = "始终显示动作条"
	QulightL.option_actionbar_mainbarWidth = "主要动作条按键数量(1-12)"
	QulightL.option_actionbar_ownshdbar = "当暗影之舞时使用一个空的动作条来替代盗贼的潜行动作条（仅盗贼）"
	QulightL.option_actionbar_lowversion = "低版本动作条"
	QulightL.option_actionbar_sidebarWidth = "侧边动作条按键数量(1-6), 启用这个选项需要取消勾选低版本动作条"

	QulightL.option_misk = "其他"
	QulightL.option_raidutility = "团队实用工具"
	QulightL.option_BuffReminderRaidBuffs = "团队Buff提醒"
	QulightL.option_Reminder = "单独时Buffs提醒"
	QulightL.option_CooldownFlash = "当技能冷却完毕时在屏幕中间闪烁该技能图标"
	QulightL.option_interrupts = "开启打断通报 /say"
	QulightL.option_AutoScreen = "自动成就截图"

    QulightL.option_reset = "重置"
	QulightL.option_apply = "应用"
	QulightL.option_close = "关闭"
	QulightL.option_setsavedsetttings = "指定角色设置"
	QulightL.option_resetchar = "你确定要重置角色的设置为默认设置吗?"
	QulightL.option_resetall = "是否重置所有设置为默认设置吗?"
	QulightL.option_perchar = "你确定要启用或者关闭'指定角色设置'吗?"
	QulightL.option_makeselection = "在你继续设置之前你必须要做出一个选择."

	QulightL.option_bottombars = "Bottom bars:"
	QulightL.option_rightbars = "右侧动作条(关闭时伤害统计框架开启)"
	QulightL.option_nameplates_showlevel = "显示等级"
	QulightL.option_raidcooldowns = "团队冷却"
	QulightL.option_DamagebarWidth = "伤害统计框架宽度(1-12)"
	QulightL.option_Damagebar = "伤害统计框架"
	QulightL.option_sidebars = "侧边动作条"

	--infotext
	_G["Heal Per Second: "] = "每秒治疗: "
	_G["Damage Per Second: "] = "每秒伤害: "
	_G["Mastery: "] = "精通: "
	_G["Haste: "] = "急速: "
	_G["Crit: "] = "暴击: "
	_G["Attack Power"] = "攻击强度"
	_G["RAP"] = "攻击强度"
	_G["Spell Power"] = "法术强度"
	_G["No Talents:"] = "无天赋"
	_G["Talents:|r "] = "天赋:|r"
	--bags
	_G["Bags: "] = "背包: "
	_G["Bags"] = "背包"
	_G["Total:"] = "总空格:"
	_G["Used:"] = "已使用:"

	--guild
	_G["Guild"] = "公会"
	_G["No Guild"] = "无公会"
	_G["Online"] = "在线"
	_G['AFK'] = '离开'
	_G['DND'] = '忙碌'
	--friend
	_G["Friends"] = "好友"
	_G["Friends list"] = "好友列表"
	_G["Battle.NET"] = "战网"
	_G["|cffff0000[AFK]|r"] = "|cffff0000[离开]|r"
	_G["|cffE7E716[DND]|r"] = "|cffE7E716[忙碌]|r"
	--systeminfo
	_G["Total Memory Usage:"] = "总内存占用:"
	_G["Local Time: "] = "本地时间: "
	_G["Server Time: "] = "服务器时间: "
	_G["Time to"] = "|cffE7E716计时 |r"
	_G["Fr"] = "来自"
end