local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales
-- move durability frame.

hooksecurefunc(DurabilityFrame,"SetPoint",function(self,_,parent)
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
        self:ClearAllPoints()
		self:Point("TOP", UIParent, "TOP", 0, -100)
    end
end)