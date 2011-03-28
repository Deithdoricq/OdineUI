local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local LSM = LibStub("LibSharedMedia-3.0")
if LSM == nil then return end

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
