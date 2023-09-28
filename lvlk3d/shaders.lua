LvLK3D = LvLK3D or {}
LvLK3D.ShaderRegistry = {}
LvLK3D.CurrShader = nil
function LvLK3D.NewShader(name, vsh, fsh)
    if not name then
        return
    end


    LvLK3D.ShaderRegistry[name] = love.graphics.newShader(fsh, vsh)
end

LvLK3D.NewShader("base", "lvlk3d/shader/generic.vert", "lvlk3d/shader/generic.frag")
function LvLK3D.SetShader(name)
    LvLK3D.CurrShader = LvLK3D.ShaderRegistry[name]

    if not LvLK3D.CurrShader then
        error("Attempt to set invalid shader!")
    end
end


LvLK3D.SetShader("base")
