local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local LSM = LibStub("LibSharedMedia-3.0")
if LSM == nil then return end

T.UnpackColors = function(color)
	if not color.r then color.r = 0 end
	if not color.g then color.g = 0 end
	if not color.b then color.b = 0 end
	
	if color.a then
		return color.r, color.g, color.b, color.a
	else
		return color.r, color.g, color.b
	end
end

----------------------------------------------------------------
-- DO NOT EDIT ANYTHING BELOW
----------------------------------------------------------------


-- convert back so gui config can function properly
C["media"].font = LSM:Fetch("font", C["media"].font)
C["media"].uffont = LSM:Fetch("font", C["media"].uffont)
C["media"].dmgfont = LSM:Fetch("font", C["media"].dmgfont)
C["media"].cfont = LSM:Fetch("font", C["media"].cfont)
C["media"].dfont = LSM:Fetch("font", C["media"].dfont)

C["media"].normTex = LSM:Fetch("statusbar", C["media"].normTex)
C["media"].glowTex = LSM:Fetch("border", C["media"].glowTex)
C["media"].blank = LSM:Fetch("background", C["media"].blank)

C["media"].whisper = LSM:Fetch("sound", C["media"].whisper)
C["media"].warning = LSM:Fetch("sound", C["media"].warning)

C["classtimer"].buffcolor = {T.UnpackColors(C["classtimer"].buffcolor)}
C["classtimer"].debuffcolor = {T.UnpackColors(C["classtimer"].debuffcolor)}
C["classtimer"].proccolor = {T.UnpackColors(C["classtimer"].proccolor)}

C["classtimer"].gen_font = LSM:Fetch("font", C["classtimer"].gen_font)
C["classtimer"].stack_font = LSM:Fetch("font", C["classtimer"].stack_font)
