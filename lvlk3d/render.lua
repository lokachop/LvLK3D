LvLK3D = LvLK3D or {}
-- TODO render meshes

local function renderObject(obj)
    local shader = LvLK3D.CurrShader
    local shaderObj = shader.shader

    love.graphics.setShader(shaderObj)
    shader.onRender(obj, shaderObj)

    local oCol = obj.col
    love.graphics.setColor(oCol[1], oCol[2], oCol[3])
    love.graphics.draw(obj.mesh)

    love.graphics.setShader()
end


local function renderShadowed(obj)
    obj.SHADOW_LIGHT_POS = Vector(math.cos(CurTime), 3, math.sin(CurTime))

    --renderObject(obj)

    

    --LvLK3D.SetShader("shadowvolume")
    local shader = LvLK3D.GetShader("shadowvolume")
    local shaderObj = shader.shader

    local shaderCap = LvLK3D.GetShader("shadowcap")
    local shaderCapObj = shaderCap.shader


    --local oCol = obj.col

    love.graphics.setDepthMode("gequal", false)

    --love.graphics.setDepthMode("lequal", false)
    for i = 2, 2 do
        local doS = i > 1
        local func = function()
            -- cap
            love.graphics.setShader(shaderCapObj)
            love.graphics.setColor(0, 1, 0.5)
            obj.SHADOW_INVERT = false
            obj.CAP_FLIP = true
            shaderCap.onRender(obj, shaderCapObj)
            love.graphics.draw(obj.meshShadowCaps)


            -- volume
            love.graphics.setShader(shaderObj)
            obj.SHADOW_INVERT = false
            shader.onRender(obj, shaderObj)
            love.graphics.setColor(0, 1, 0)
            love.graphics.draw(obj.meshShadow)
        end
        if doS then
            love.graphics.stencil(func, "increment", 0, true)
        else
            func()
        end

        func = function()
            -- cap
            love.graphics.setShader(shaderCapObj)
            love.graphics.setColor(1, 0, 0.5)
            obj.SHADOW_INVERT = true
            obj.CAP_FLIP = true
            shaderCap.onRender(obj, shaderCapObj)
            love.graphics.draw(obj.meshShadowCaps)


            -- volume
            love.graphics.setShader(shaderObj)
            obj.SHADOW_INVERT = true
            shader.onRender(obj, shaderObj)
            love.graphics.setColor(1, 0, 0)
            love.graphics.draw(obj.meshShadow)
        end
        if doS then
            love.graphics.stencil(func, "decrement", 0, true)
        else
            func()
        end

    end





    love.graphics.setShader()
    LvLK3D.SetShader("base")

    love.graphics.setDepthMode("lequal", true)
    renderObject(obj)
end


function LvLK3D.RenderActiveUniverse()
    love.graphics.setCanvas({LvLK3D.CurrRT, depth = true, stencil = true})

        local _renderShadowed = {}
        for k, v in pairs(LvLK3D.CurrUniv["objects"]) do

            if v.SHADOW_VOLUME then
                _renderShadowed[#_renderShadowed + 1] = v
                renderObject(v)
            else
                love.graphics.setDepthMode("lequal", true)
                renderObject(v)
            end
        end

        for k, v in ipairs(_renderShadowed) do
            renderShadowed(v)
        end


        love.graphics.setStencilTest("greater", 0)
            love.graphics.setColor(0, 0, 0, 0.75)
            love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
        love.graphics.setStencilTest()
    love.graphics.setCanvas()
end

