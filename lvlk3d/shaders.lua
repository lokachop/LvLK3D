LvLK3D = LvLK3D or {}
LvLK3D.ShaderRegistry = {}
LvLK3D.CurrShader = nil

local _baseVsh = "lvlk3d/shader/generic.vert"
local _baseOnRender = function(obj, shader)
    shader:send("mdlRotationMatrix", obj.mat_rot)
    shader:send("mdlTranslationMatrix", obj.mat_transscl)

    --shader:send("mdlMatrix", obj.mat_mdl)
    shader:send("viewMatrix", LvLK3D.CamMatrix_Rot * LvLK3D.CamMatrix_Trans)
    shader:send("projectionMatrix", LvLK3D.CamMatrix_Proj)
    shader:send("sunDir", LvLK3D.SunDir)

    shader:send("doShading", (obj["SHADING"] == true) and true or false)
    shader:send("normInvert", (obj["NORM_INVERT"] == true) and true or false)
end


function LvLK3D.NewShader(name, fsh, vsh, onRender)
    if not name then
        return
    end


    local shader = love.graphics.newShader(fsh, vsh or _baseVsh)
    LvLK3D.ShaderRegistry[name] = {
        ["shader"] = shader,
        ["onRender"] = onRender or _baseOnRender,
    }
end

function LvLK3D.GetShader(name)
    return LvLK3D.ShaderRegistry[name]
end

LvLK3D.NewShader("base", "lvlk3d/shader/generic.frag", "lvlk3d/shader/generic.vert")
function LvLK3D.SetShader(name)
    LvLK3D.CurrShader = LvLK3D.ShaderRegistry[name]

    if not LvLK3D.CurrShader then
        error("Attempt to set invalid shader!")
    end
end


LvLK3D.SetShader("base")
