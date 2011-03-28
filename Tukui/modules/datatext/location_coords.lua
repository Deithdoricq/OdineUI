local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

----- [[    Location    ]] -----

local location = CreateFrame("Frame", "TukuiLocation", UIParent)
location:CreatePanel("Default", 60, 20, "TOP", UIParent, "TOP", 0, -7)
location:SetFrameLevel(2)

local locationtext  = location:CreateFontString(nil, "LOW")
locationtext:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
locationtext:SetPoint("CENTER", location)
 
local function OnEvent(self, event)
	local loc = GetMinimapZoneText()
	local pvpType, isFFA, zonePVPStatus = GetZonePVPInfo()

	if (pvpType == "sanctuary") then
		loc = "|cff69C9EF"..loc.."|r" -- light blue
	elseif (pvpType == "friendly") then
		loc = "|cff00ff00"..loc.."|r" -- green
	elseif (pvpType == "contested") then
		loc = "|cffffff00"..loc.."|r" -- yellow
	elseif (pvpType == "hostile" or pvpType == "combat" or pvpType == "arena" or not pvpType) then
		loc = "|cffff0000"..loc.."|r" -- red
	else
		loc = loc -- white
	end

	locationtext:SetText(loc)
	location:SetWidth(locationtext:GetWidth() + 24)
end

location:RegisterEvent("PLAYER_ENTERING_WORLD")
location:RegisterEvent("ZONE_CHANGED_NEW_AREA")
location:RegisterEvent("ZONE_CHANGED")
location:RegisterEvent("ZONE_CHANGED_INDOORS")
location:HookScript("OnEvent", OnEvent)


----- [[    Coords    ]] -----

local xcoords = CreateFrame("Frame", "TukuiXCoordsPanel", UIParent)
xcoords:CreatePanel("Default", 35, 20, "RIGHT", location, "LEFT", -5, 0)
xcoords:SetFrameLevel(2)

local ycoords = CreateFrame("Frame", "TukuiYCoordsPanel", UIParent)
ycoords:CreatePanel("Default", 35, 20, "LEFT", location, "RIGHT", 5, 0)
ycoords:SetFrameLevel(2)

local xcoordstext = xcoords:CreateFontString(nil, "OVERLAY")
xcoordstext:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
xcoordstext:SetPoint("CENTER", xcoords, "CENTER", 1, 0)

local ycoordstext  = ycoords:CreateFontString(nil, "OVERLAY")
ycoordstext:SetFont(C["media"].dfont, C["datatext"].fsize, "OUTLINE")
ycoordstext:SetPoint("CENTER", ycoords, "CENTER", 1, 0)

local ela,go = 0,false

local Update = function(self,t)
	ela = ela - t
	if ela > 0 then return end
	local x,y = GetPlayerMapPosition("player")
	local xt,yt
	x = math.floor(100 * x)
	y = math.floor(100 * y)
	if x == 0 and y == 0 then
		xcoordstext:SetText("")
		ycoordstext:SetText("")
		
		xcoords:SetAlpha(0)
		ycoords:SetAlpha(0)
	else
		if x < 10 then
			xt = "0"..x
		else
			xt = x
		end
		if y < 10 then
			yt = "0"..y
		else
			yt = y
		end
		xcoordstext:SetText(xt)
		ycoordstext:SetText(yt)
		
		xcoords:SetAlpha(1)
		ycoords:SetAlpha(1)
		xcoords:SetWidth(xcoordstext:GetWidth() + 20)
		ycoords:SetWidth(ycoordstext:GetWidth() + 20)
	end
	ela = .2
end
xcoords:HookScript("OnUpdate", Update)
