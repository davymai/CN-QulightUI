local _, MCF = ...

MCF.Bars = { "Action", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight", "MultiBarLeft" }

MCF.UpdateCooldowns = function()
	--print("Updating")

	for i=1,#MCF.Bars do
		for j=1,12 do
			local button = _G[MCF.Bars[i].."Button"..j]
			ActionButton_UpdateCooldown(button)
		end
	end
end

hooksecurefunc(WorldMapFrame, "Hide", MCF.UpdateCooldowns);