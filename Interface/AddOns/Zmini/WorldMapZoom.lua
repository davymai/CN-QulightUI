
local f = CreateFrame ("frame", nil, UIParent)
f:RegisterEvent ("ADDON_LOADED")

f:SetScript ("OnEvent", function (self, event, addonName)

	if (event == "ADDON_LOADED" and addonName == "WorldMapZoom") then
	
		WorldMapScrollFrame:HookScript ("OnMouseWheel", function()
			local HScroll = WorldMapScrollFrame:GetHorizontalScroll()
			local VScroll = WorldMapScrollFrame:GetVerticalScroll()

			if (MantainWorldMapZoomH ~= HScroll or MantainWorldMapZoomV ~= VScroll) then
				MantainWorldMapZoomMouseX, MantainWorldMapZoomMouseY = GetCursorPosition()
			end
			MantainWorldMapZoomH = HScroll
			MantainWorldMapZoomV = VScroll
			MantainWorldMapZoomScale = WorldMapDetailFrame:GetScale();
		end)

		local MAX_ZOOM = 1.495;

		hooksecurefunc ("ToggleWorldMap", function()

			if (WorldMapFrame:IsShown()) then
			
				if ((MantainWorldMapZoomV and MantainWorldMapZoomH) and (MantainWorldMapZoomH ~= 0 or MantainWorldMapZoomV ~= 0)) then

					local last_opened = MantainWorldMapZoomLastOpened or time()
					MantainWorldMapZoomLastOpened = time()
					
					if (last_opened+60 < time()) then
						WorldMapScrollFrame_ResetZoom()
						MantainWorldMapZoomMouseX, MantainWorldMapZoomMouseY = nil, nil
						MantainWorldMapZoomH = nil
						MantainWorldMapZoomV = nil
						MantainWorldMapZoomScale = nil
						return
					end
				
					local scrollFrame = WorldMapScrollFrame;
					local oldScrollH = MantainWorldMapZoomH
					local oldScrollV = MantainWorldMapZoomV

					-- get the mouse position on the frame, with 0,0 at top left
					local cursorX, cursorY = MantainWorldMapZoomMouseX, MantainWorldMapZoomMouseY
					local relativeFrame;
					if ( WorldMapFrame_InWindowedMode() ) then
						relativeFrame = UIParent;
					else
						relativeFrame = WorldMapFrame;
					end
					local frameX = cursorX / relativeFrame:GetScale() - scrollFrame:GetLeft();
					local frameY = scrollFrame:GetTop() - cursorY / relativeFrame:GetScale();
					
					local oldScale = WorldMapDetailFrame:GetScale();
					--local newScale = oldScale + delta * 0.3;
					local newScale = MantainWorldMapZoomScale
					newScale = max(WORLDMAP_SETTINGS.size, newScale); 
					newScale = min(MAX_ZOOM, newScale);
					WorldMapDetailFrame:SetScale(newScale);
					QUEST_POI_FRAME_WIDTH = WorldMapDetailFrame:GetWidth() * newScale;
					QUEST_POI_FRAME_HEIGHT = WorldMapDetailFrame:GetHeight() * newScale;

					scrollFrame.maxX = QUEST_POI_FRAME_WIDTH - 1002 * WORLDMAP_SETTINGS.size;
					scrollFrame.maxY = QUEST_POI_FRAME_HEIGHT - 668 * WORLDMAP_SETTINGS.size;
					scrollFrame.zoomedIn = abs(WorldMapDetailFrame:GetScale() - WORLDMAP_SETTINGS.size) > 0.05;
					scrollFrame.continent = GetCurrentMapContinent();
					scrollFrame.mapID = GetCurrentMapAreaID();

					-- figure out new scroll values
					local scaleChange = newScale / oldScale;
					local newScrollH = scaleChange * ( frameX + oldScrollH ) - frameX;
					local newScrollV = scaleChange * ( frameY + oldScrollV ) - frameY;
					-- clamp scroll values
					newScrollH = min(newScrollH, scrollFrame.maxX);
					newScrollH = max(0, newScrollH);
					newScrollV = min(newScrollV, scrollFrame.maxY);
					newScrollV = max(0, newScrollV);
					
					-- set scroll values
					scrollFrame:SetHorizontalScroll(oldScrollH);
					scrollFrame:SetVerticalScroll(oldScrollV);

					WorldMapFrame_Update();
					WorldMapScrollFrame_ReanchorQuestPOIs();
					WorldMapBlobFrame_ResetHitTranslations();
					WorldMapBlobFrame_DelayedUpdateBlobs();				
					
					
				end
			else
				MantainWorldMapZoomLastOpened = time()
			end
		end)
		
	end
end)

