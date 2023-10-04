LvLK3D = LvLK3D or {}
LvLK3D.UniverseRegistry = LvLK3D.UniverseRegistry or {}

function LvLK3D.NewUniverse(tag)
    if not tag then
        error("Attempt to make a universe without a tag!")
    end

    local univData = {
        ["objects"] = {},
        ["lights"] = {},
        ["lightCount"] = 0,
        ["tag"] = tag,
        ["worldParameteri"] = {
            ["SunDir"] = Vector(0, 0, -1)
        }
    }

    print("new universe, \"" .. tag .. "\"")
    LvLK3D.UniverseRegistry[tag] = univData

    return LvLK3D.UniverseRegistry[tag]
end

LvLK3D.BaseUniv = LvLK3D.NewUniverse("LvLK3D_base_univ")

LvLK3D.CurrUniv = LvLK3D.BaseUniv
LvLK3D.UniverseStack = LvLK3D.UniverseStack or {}

function LvLK3D.PushUniverse(univ)
    LvLK3D.UniverseStack[#LvLK3D.UniverseStack + 1] = LvLK3D.CurrUniv
    LvLK3D.CurrUniv = univ
end

function LvLK3D.PopUniverse()
    local _prev = LvLK3D.CurrUniv
    LvLK3D.CurrUniv = LvLK3D.UniverseStack[#LvLK3D.UniverseStack] or LvLK3D.BaseUniv
    LvLK3D.UniverseStack[#LvLK3D.UniverseStack] = nil

    return _prev
end

function LvLK3D.ClearUniverse(univ)
    univ = univ or LvLK3D.CurrUniv

    for k, v in pairs(univ["objects"]) do
        univ[k] = nil
    end

    for k, v in pairs(univ["lights"]) do
        univ[k] = nil
    end
end

function LvLK3D.GetUniverseByTag(tag)
    return LvLK3D.UniverseRegistry[tag]
end

function LvLK3D.GetUniverseParams(univ)
    univ = univ or LvLK3D.CurrUniv

    return univ.worldParameteri
end