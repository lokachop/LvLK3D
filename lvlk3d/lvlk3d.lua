LvLK3D = LvLK3D or {}
LvLK3D.Version = "0.1"
LvLK3D.Debug = true
LvLK3D.FilterMode = "nearest"

local relaPath = "lvlk3d/"
function LvLK3D.LoadFile(path)
    require(relaPath .. path)
end

LvLK3D.LoadFile("libs/lmat") -- make sure to load lmat first
LvLK3D.LoadFile("libs/lvec")
LvLK3D.LoadFile("libs/lang")
LvLK3D.LoadFile("libs/lknoise")



LvLK3D.SunDir = Vector(1, 2, 4):GetNormalized()

LvLK3D.LoadFile("textures")
LvLK3D.LoadFile("universes")
LvLK3D.LoadFile("rendertargets")
LvLK3D.LoadFile("models")
LvLK3D.LoadFile("basemodels")
LvLK3D.LoadFile("objects")
LvLK3D.LoadFile("shaders")
LvLK3D.LoadFile("shadowvolumes")

LvLK3D.LoadFile("camera")
LvLK3D.LoadFile("render")