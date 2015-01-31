local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	f:UnregisterEvent("PLAYER_ENTERING_WORLD")
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.ReskinScroll(BaudErrorFrameListScrollBoxScrollBarScrollBar)
		F.ReskinScroll(BaudErrorFrameDetailScrollFrameScrollBar)
	end
	if IsAddOnLoaded("NDui") then
		local B = unpack(NDui)
		B.CreateNF(BaudErrorFrame)
		B.CreateSD(BaudErrorFrame, 1, 4)
		local BG2 = CreateFrame("Frame", nil, BaudErrorFrame)
		BG2:SetPoint("CENTER", BaudErrorFrame, "CENTER", 0, -82)
		B.CreateNF(BG2, 0.4, BaudErrorFrameEditBox:GetWidth() + 60, BaudErrorFrameEditBox:GetHeight() + 15)
		B.CreateNF(BaudErrorFrameClearButton)
		B.CreateBC(BaudErrorFrameClearButton)
		B.CreateNF(BaudErrorFrameCloseButton)
		B.CreateBC(BaudErrorFrameCloseButton)
		B.CreateNF(BaudErrorFrameReloadUIButton)
		B.CreateBC(BaudErrorFrameReloadUIButton)
	end
end)