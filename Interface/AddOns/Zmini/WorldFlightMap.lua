local FlightmapCoordinates = { -- semi-accurate sizes for the different flight maps, these were manually calculated
	[1] = { -- Kalimdor
		left = 10970,
		top = 12470,
		width = 24340,
		
	},
	
	[2] = { -- eastern kingdoms
		left = 12246.47,
		top = 12257.98,
		width = 28800.54,
	},
	
	[3] = { -- outland
		left = 10677.96,
		top = 6415.94,
		width = 12287.77,
	},
	
	[4] = { -- northrend
		left = 8395.19,
		top = 11630.96,
		width = 15199.39,
	},
	
	[6] = { -- pandaria
		left = 6770,
		top = 7461,
		width = 11892,
	},
	
	[7] = { -- Draenor
		left = 10118.8,
		top = 11625.1,
		bottom = -4771,
		width = 16396.2,
	}
}

local TAXI_OPEN = false

TaxiFrame:UnregisterAllEvents() -- we should probably undo this if we're in an area that isn't supported somehow

local f = CreateFrame('Frame', 'WorldFlightMapFrame', WorldMapButton)
f:SetAllPoints()
f:SetFrameStrata('HIGH')
f:SetFrameLevel(100)

f:SetScript('OnEvent', function(self, event, ...) return self[event] and self[event](self, ...) end)

local function TaxiNodeOnClick(self)
	TakeTaxiNode(self:GetID())
end

local lines = {}
local function CreateLine()
	local line = f:CreateTexture(nil, "BACKGROUND")
	line:SetVertexColor(0,0.8,1)
	line:SetNonBlocking(true)
	line:SetTexture("Interface\\TaxiFrame\\UI-Taxi-Line")
	tinsert(lines, line)
	return line
end

local function GetLine()
	for i,line in ipairs(lines) do
		if not line:IsShown() then return line end
	end
	return CreateLine()
end

local function DrawLine(x1,y1,x2,y2,r,g,b,a)
	local line = GetLine()
	DrawRouteLine(line, "WorldMapButton", x1*1002, -y1*668, x2*1002, -y2*668, 32, 'TOPLEFT')
	line:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
	line:Show()
	return line
end


local function GetMapSize()
	local _, left, top, right, bottom = GetCurrentMapZone()
	local floorNum, dright, dbottom, dleft, dtop = GetCurrentMapDungeonLevel()
	if DungeonUsesTerrainMap() then floorNum = floorNum - 1 end
	if floorNum > 0 then left, top, right, bottom = dleft, dtop, dright, dbottom end
	
	if left and left ~= right then
		local width, height = left - right, top - bottom
		return left, top, right, bottom, width, height, format('%d.%d', GetCurrentMapAreaID(), floorNum)
	end
end


local taxiNodePositions = {}
-- Draw all flightpaths within one hop of current location
local function DrawOneHopLines()
	local line;
	local sX, sY, dX, dY;
	local w = TAXI_MAP_WIDTH;
	local h = TAXI_MAP_HEIGHT;
	local numNodes = NumTaxiNodes();
	local numLines = 0;
	local numSingleHops = 0;
	
	local left, top, right, bottom, width, height = GetMapSize()
	for i = 1, #taxiNodePositions do
		local node = taxiNodePositions[i]
		if GetNumRoutes(i) == 1 and node.type ~= 'NONE' then
			numSingleHops = numSingleHops + 1
			local slot = TaxiGetNodeSlot(i, 1, true);
			sX = (left - taxiNodePositions[slot].x) / width;
			sY = (top - taxiNodePositions[slot].y) / height;
			slot = TaxiGetNodeSlot(i, 1, false);
			dX = (left - taxiNodePositions[slot].x) / width;
			dY = (top - taxiNodePositions[slot].y) / height;
			DrawLine(sX, sY, dX, dY)
			--DrawLine(0.573, 0.6377, 0.5
		end
	end
	if ( numSingleHops == 0 ) then
		UIErrorsFrame:AddMessage(ERR_TAXINOPATHS, 1.0, 0.1, 0.1, 1.0);
		CloseTaxiMap()
	end
end

local function TaxiNodeOnButtonEnter(button) 
	local index = button:GetID();
	GameTooltip:SetOwner(button, "ANCHOR_RIGHT");
	GameTooltip:AddLine(TaxiNodeName(index), nil, nil, nil, true);
	
	-- Setup variables
	local numRoutes = GetNumRoutes(index);
	local line;
	local sX, sY, dX, dY;
	local w = TAXI_MAP_WIDTH;
	local h = TAXI_MAP_HEIGHT;
	
	for i = 1, #lines do
		lines[i]:Hide()
	end
	
	local type = TaxiNodeGetType(index);
	if ( type == "REACHABLE" ) then
		SetTooltipMoney(GameTooltip, TaxiNodeCost(button:GetID()));
		TaxiNodeSetCurrent(index);
		
		local left, top, right, bottom, width, height, mapID = GetMapSize()
		for i = 1, numRoutes do
			local slot = TaxiGetNodeSlot(index, i, true);
			sX = (left - taxiNodePositions[slot].x) / width;
			sY = (top - taxiNodePositions[slot].y) / height;
			slot = TaxiGetNodeSlot(index, i, false);
			dX = (left - taxiNodePositions[slot].x) / width;
			dY = (top - taxiNodePositions[slot].y) / height;
			DrawLine(sX, sY, dX, dY)
		end
	elseif ( type == "CURRENT" ) then
		GameTooltip:AddLine(TAXINODEYOUAREHERE, 1.0, 1.0, 1.0, true);
		DrawOneHopLines();
	end

	GameTooltip:Show();
end


local function BounceAnimation(self) -- SetLooping('BOUNCE') is producing broken animations, so we're just simulating what it's supposed to do
	local tx, parent, bounce = self.tx, self.parent, self.bounce
	tx:ClearAllPoints()
	if self.up then
		tx:SetPoint('BOTTOM', parent, 'TOP', 0, 10)
		bounce:SetSmoothing('OUT')
	else
		tx:SetPoint('BOTTOM', parent, 'TOP')
		bounce:SetSmoothing('IN')
	end
	bounce:SetOffset(0, self.up and -10 or 10)
	self.up = not self.up
	self:Play()
end
--group:SetLooping('REPEAT')
--group:Play()

local TaxiButtons = {}
local function CreateButton(i)
	local button = CreateFrame("Button", nil, f)
	button:SetSize(16, 16)
	button:SetHighlightTexture([[Interface\TaxiFrame\UI-Taxi-Icon-Highlight]])
	
	local highlight = button:GetHighlightTexture()
	highlight:ClearAllPoints()
	highlight:SetPoint('CENTER')
	highlight:SetSize(32, 32)
	
	local i = i or (#TaxiButtons + 1)
	button:SetScript('OnClick', TaxiNodeOnClick)
	button:SetID(i)
	TaxiButtons[i] = button
	
	button:SetScript('OnEnter', TaxiNodeOnButtonEnter)
	button:SetScript('OnLeave', function() GameTooltip:Hide() end)
	
	local tx = button:CreateTexture(nil, 'OVERLAY')
	tx:SetPoint('BOTTOM', button, 'TOP')
	tx:SetSize(32, 32)
	tx:SetTexture('interface/minimap/minimap-deadarrow')
	tx:SetTexCoord(0, 1, 1, 0)
	
	local duration = 0.75
	local group = tx:CreateAnimationGroup()
	group.tx = tx
	
	local bounce = group:CreateAnimation('Translation')
	bounce:SetOffset(0, 10)
	bounce:SetDuration(0.5)
	bounce:SetSmoothing('IN')
	group.bounce = bounce
	
	group.up = true
	
	group:SetScript('OnFinished', BounceAnimation)
	group.parent = button
	button.arrow = tx
	group:Play()
	return button
end

local function GetButton(i)
	return TaxiButtons[i] or CreateButton(i)
end

local ContinentMaps = {GetMapContinents()}
for i = #ContinentMaps, 2, -2 do tremove(ContinentMaps, i) end

local CurrentContinent = -1
local textures = {}
local CurrentMap
function f:WORLD_MAP_UPDATE()
	if not TAXI_OPEN then return self:UnregisterEvent('WORLD_MAP_UPDATE') end
	local continentID = GetCurrentMapContinent() == CurrentContinent and CurrentContinent or -1
	local continent = FlightmapCoordinates[continentID]
	local left, top, right, bottom, width, height, mapID = GetMapSize()
	
	if mapID ~= CurrentMap or not mapID then
		for i = 1, #lines do -- only hide lines if the map has changed to a new map when this event fired
			lines[i]:Hide()
		end
		CurrentMap = mapID
	end
	
	if not continent then -- clear any buttons
		for i = 1, #TaxiButtons do
			TaxiButtons[i]:Hide()
		end
		return
	end
	
	local showArrows = ContinentMaps[continentID] and GetCurrentMapAreaID() ~= ContinentMaps[continentID] -- only show arrows on zone maps
	
	local j = 1
	for i = 1, #taxiNodePositions do
		local node = taxiNodePositions[i]
		if node.type ~= 'NONE' then
			local mx, my = (left - node.x) / width, (top - node.y) / height
			local button = GetButton(j)
			button:ClearAllPoints()
			button:SetPoint('CENTER', f, 'TOPLEFT', mx * 1002, my * -668)
			button:SetNormalTexture(TaxiButtonTypes[node.type].file)
			button:SetID(i)
			
			button.arrow:SetShown(showArrows)
			
			button:Show()
			
			
			j = j + 1
		end
	end

	for i = j, #TaxiButtons do -- hide extra buttons
		TaxiButtons[i]:Hide()
	end
	
	if not showArrows then
		DrawOneHopLines()
	end
end

function f:TAXIMAP_OPENED()
	TAXI_OPEN = true
	if not WorldMapFrame:IsShown() then
		ToggleWorldMap()
	end
	SetMapToCurrentZone()
	local continentID = GetCurrentMapContinent()
	local continent = FlightmapCoordinates[continentID]
	if continent then
		CurrentContinent = continentID
		wipe(taxiNodePositions)
		for i = 1, NumTaxiNodes() do
			local type = TaxiNodeGetType(i)
			local name = TaxiNodeName(i)
			local x, y = TaxiNodePosition(i)
			local wx, wy = continent.left - continent.width * x, (continent.top - continent.width) + continent.width * y
			taxiNodePositions[i] = {type = type, name = name, x = wx, y = wy}
		end
		
		self:RegisterEvent('WORLD_MAP_UPDATE')
		SetMapZoom(continentID)
		
		f:Show()
	end
end
f:RegisterEvent('TAXIMAP_OPENED')

function f:TAXIMAP_CLOSED()
	TAXI_OPEN = false
	CurrentContinent = -1
	self:UnregisterEvent('WORLD_MAP_UPDATE')
	f:Hide()
	if WorldMapFrame:IsShown() then
		ToggleWorldMap()
	end
end
f:RegisterEvent('TAXIMAP_CLOSED')

local timer = CreateFrame('Frame')
timer:Hide()

local TimeSince = 0
timer:SetScript('OnUpdate', function(self, elapsed) -- delayed close for the map frame
	TimeSince = TimeSince + elapsed
	if TimeSince >= 0.2 then
		self:Hide()
		if not WorldMapFrame:IsVisible() then
			CloseTaxiMap()
		end
	end
end)

WorldMapFrame:HookScript('OnHide', function() -- stop interaction with the flight master after a small timeout
	-- seems to trigger when switching between windowed and fullscreen mode
	TimeSince = 0
	timer:Show()
end)