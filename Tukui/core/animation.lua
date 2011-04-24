------------------------------------------------------------------------
-- Animation Functions (Credit AlleyCat, Hydra)
------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

T.SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

T.Flash = function(self, duration)
	if not self.anim then
		T.SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

T.StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end