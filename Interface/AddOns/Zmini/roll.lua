local roll = CreateFrame("Button", "rollMacro", UIParent, "SecureActionButtonTemplate")
roll:SetAttribute("type", "macro")
roll:SetAttribute("macrotext", "/roll")
roll:SetScript('OnMouseDown', function(self, button) 
      if InCombatLockdown() then return end
      if (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) and button == "RightButton" then
      DoReadyCheck()
      end    
   end)
roll:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 500, -1) -- 可自己调整位置


roll:SetSize(20,20) -- 大小
roll.t = roll:CreateTexture()
roll.t:SetAllPoints()
roll.t:SetTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")