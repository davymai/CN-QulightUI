if not tao_l then
	tao_l = {}
end

if GetLocale() == "enUS" then
	tao_l["Stagger"] = "Stagger"
	tao_l["Light Stagger"] = "Light Stagger"
	tao_l["Moderate Stagger"] = "Moderate Stagger"
	tao_l["Heavy Stagger"] = "Heavy Stagger"

elseif GetLocale() == "frFR" then
	tao_l["Stagger"] = "Report"
	tao_l["Light Stagger"] = "Report mineur"
	tao_l["Moderate Stagger"] = "Report mod�r�"
	tao_l["Heavy Stagger"] = "Report majeur"

elseif GetLocale() == "itIT" then
	tao_l["Stagger"] = "Noncuranza"
	tao_l["Light Stagger"] = "Noncuranza Parziale"
	tao_l["Moderate Stagger"] = "Noncuranza Moderata"
	tao_l["Heavy Stagger"] = "Noncuranza Totale"

elseif GetLocale() == "deDE" then
	tao_l["Stagger"] = "Staffelung"
	tao_l["Light Stagger"] = "Leichte Staffelung"
	tao_l["Moderate Stagger"] = "Moderate Staffelung"
	tao_l["Heavy Stagger"] = "Schwere Staffelung"

elseif GetLocale() == "zhCN" then
	tao_l["Stagger"] = "醉拳"
	tao_l["Light Stagger"] = "轻度醉拳"
	tao_l["Moderate Stagger"] = "中度醉拳"
	tao_l["Heavy Stagger"] = "重度醉拳"

elseif GetLocale() == "ruRU" then
	tao_l["Stagger"] = "Пошатывание"
	tao_l["Light Stagger"] = "Легкое пошатывание"
	tao_l["Moderate Stagger"] = "Умеренное пошатывание"
	tao_l["Heavy Stagger"] = "Сильное пошатывание"

else
	tao_l["Stagger"] = "Stagger"
	tao_l["Light Stagger"] = "Light Stagger"
	tao_l["Moderate Stagger"] = "Moderate Stagger"
	tao_l["Heavy Stagger"] = "Heavy Stagger"
end	
