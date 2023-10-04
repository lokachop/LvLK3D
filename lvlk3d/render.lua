LvLK3D = LvLK3D or {}
-- TODO render meshes

local function renderObject(obj, shaderOverride)
    local shader = shaderOverride or LvLK3D.CurrShader
    local shaderObj = shader.shader

    love.graphics.setShader(shaderObj)
    shader.onRender(obj, shaderObj)

    local oCol = obj.col
    love.graphics.setColor(oCol[1], oCol[2], oCol[3])
    love.graphics.draw(obj.mesh)

    love.graphics.setShader()
end

local shadowShader = LvLK3D.GetShader("shadowvolume")
local shadowShaderObj = shadowShader.shader

local shadowShaderCap = LvLK3D.GetShader("shadowcap")
local shadowShaderCapObj = shadowShaderCap.shader


local function renderShadowed(obj, lpos, shOverride)
    obj.SHADOW_LIGHT_POS = lpos

    love.graphics.setDepthMode("gequal", false)
    love.graphics.stencil(function()
        -- cap
        love.graphics.setShader(shadowShaderCapObj)
        love.graphics.setColor(0, 1, 0.5)
        obj.SHADOW_INVERT = false
        obj.CAP_FLIP = true
        shadowShaderCap.onRender(obj, shadowShaderCapObj)
        love.graphics.draw(obj.meshShadowCaps)


        -- volume
        love.graphics.setShader(shadowShaderObj)
        obj.SHADOW_INVERT = false
        shadowShader.onRender(obj, shadowShaderObj)
        love.graphics.setColor(0, 1, 0)
        love.graphics.draw(obj.meshShadow)
    end, "increment", 0, true)


    love.graphics.stencil(function()
        -- cap
        love.graphics.setShader(shadowShaderCapObj)
        love.graphics.setColor(1, 0, 0.5)
        obj.SHADOW_INVERT = true
        obj.CAP_FLIP = true
        shadowShaderCap.onRender(obj, shadowShaderCapObj)
        love.graphics.draw(obj.meshShadowCaps)


        -- volume
        love.graphics.setShader(shadowShaderObj)
        obj.SHADOW_INVERT = true
        shadowShader.onRender(obj, shadowShaderObj)
        love.graphics.setColor(1, 0, 0)
        love.graphics.draw(obj.meshShadow)
    end, "decrement", 0, true)





    love.graphics.setShader()
    LvLK3D.SetShader("base")

    love.graphics.setDepthMode("lequal", true)
    renderObject(obj, shOverride)
end


local depthWriteShader = LvLK3D.GetShader("depthwrite")
local lightingShader = LvLK3D.GetShader("lit")

local function renderActiveUniverseLit()
    local _renderShadowed = {}
    for k, v in pairs(LvLK3D.CurrUniv["objects"]) do
        renderObject(v, depthWriteShader)

        if v.SHADOW_VOLUME then
            _renderShadowed[#_renderShadowed + 1] = v
        end
    end

    -- now we loop thru each light

    love.graphics.setBlendMode("add")
    for k, v in pairs(LvLK3D.CurrUniv["lights"]) do
        love.graphics.clear(false, true, false)
        for i = 1, #_renderShadowed do
            renderShadowed(_renderShadowed[i], v.pos, depthWriteShader)
        end

        love.graphics.setDepthMode("lequal", true)
        love.graphics.setStencilTest("equal", 0)
            for k2, v2 in pairs(LvLK3D.CurrUniv["objects"]) do
                v2["LIT_LIGHT_POS"] = v.pos
                v2["LIT_LIGHT_COL"] = v.col
                v2["LIT_LIGHT_INT"] = v.intensity

                renderObject(v2, lightingShader)
            end
        love.graphics.setStencilTest()
    end


    love.graphics.setBlendMode("alpha")



    --for k, v in ipairs(_renderShadowed) do
    --    renderShadowed(v)
    --end

    --love.graphics.setStencilTest("greater", 0)
    --    love.graphics.setColor(0, 0, 0, 0.75)
    --    love.graphics.rectangle("fill", 0, 0, love.graphics.getDimensions())
    --love.graphics.setStencilTest()
end


local function renderActiveUniverseNonLit()
    local _renderShadowed = {}
    for k, v in pairs(LvLK3D.CurrUniv["objects"]) do
        love.graphics.setDepthMode("lequal", true)
        renderObject(v)
    end

end



function LvLK3D.RenderActiveUniverse()
    love.graphics.setCanvas({LvLK3D.CurrRT, depth = true, stencil = true})


        if LvLK3D.CurrUniv["lightCount"] > 0 then
            renderActiveUniverseLit()
        else
            renderActiveUniverseNonLit()
        end
    love.graphics.setCanvas()
end

