LvLK3D = LvLK3D or {}
local ode = require("moonode")

local _MAX_PHYSICS_OBJECTS = LvLK3D.MAX_PHYSICS_OBJECTS * 1

local _surfaceParams = ode.pack_surfaceparameters({
    mu = 50.0,
    slip1 = 0.2,
    slip2 = 0.2,
    soft_erp = 0.96,
    soft_cfm = 0.04,
    approx1 = true,
})
local surfParams = {}

function LvLK3D.NewSurfaceMaterial(name, params)
    local sList = {
        dual = false,
        light = {},
        heavy = {},
        non_dual = {}
    }
    local isDual = params.sound_list["dual"]
    sList.dual = isDual

    if isDual then
        for k, v in ipairs(params.sound_list["light"]) do
            sList["light"][k] = v
        end
        for k, v in ipairs(params.sound_list["heavy"]) do
            sList["heavy"][k] = v
        end
    else
        for k, v in ipairs(params.sound_list) do
            sList["non_dual"][k] = v
        end
    end


    surfParams[name] = {
        ["name"] = name,
        ["sound_list"] = sList,
        ["ode_pack"] = ode.pack_surfaceparameters(params.ode_params),
    }
end

function LvLK3D.GetSurfaceMaterialData(name)
    return surfParams[name]
end

LvLK3D.NewSurfaceMaterial("metal", {
    ["sound_list"] = {
        ["dual"] = true,
        ["light"] = {
            "sounds/physics/metal/metal_light1.wav",
            "sounds/physics/metal/metal_light2.wav",
            "sounds/physics/metal/metal_light3.wav",
            "sounds/physics/metal/metal_light4.wav",
            "sounds/physics/metal/metal_light5.wav",
            "sounds/physics/metal/metal_light6.wav",
            "sounds/physics/metal/metal_light7.wav",
            "sounds/physics/metal/metal_light8.wav",
        },
        ["heavy"] = {
            "sounds/physics/metal/metal_heavy1.wav",
            "sounds/physics/metal/metal_heavy2.wav",
            "sounds/physics/metal/metal_heavy3.wav",
            "sounds/physics/metal/metal_heavy4.wav",
            "sounds/physics/metal/metal_heavy5.wav",
            "sounds/physics/metal/metal_heavy6.wav",
            "sounds/physics/metal/metal_heavy7.wav",
        }
    },
    ["ode_params"] = {
        mu = 50.0,
        slip1 = 0.2,
        slip2 = 0.2,
        soft_erp = 0.96,
        soft_cfm = 0.04,
        approx1 = true,
    },
})


LvLK3D.NewSurfaceMaterial("wood_box", {
    ["sound_list"] = {
        "sounds/physics/wood/wood_box1.wav",
        "sounds/physics/wood/wood_box2.wav",
        "sounds/physics/wood/wood_box3.wav",
        "sounds/physics/wood/wood_box4.wav",
        "sounds/physics/wood/wood_box5.wav",
    },
    ["ode_params"] = {
        mu = 250.0,
        slip1 = 0.1,
        slip2 = 0.1,
        soft_erp = 0.96,
        soft_cfm = 0.04,
        approx1 = true,
    },
})

function LvLK3D.SetupPhysicsWorld(univ)

    univ.odePhys = {
        world = ode.create_world(),
        space = ode.create_hash_space(),
        objects = {},
        objectIDLUT = {},
        body2objects = {}
    }


    univ.odePhys.world:set_gravity({0, -9.8, 0})
    univ.odePhys.world:set_quick_step_num_iterations(12)
end

function LvLK3D.SetPhysicsGravity(grav)
    LvLK3D.CurrUniv.odePhys.world:set_gravity(grav)
end



function LvLK3D.GetPhysicsObjectList()
    return LvLK3D.CurrUniv.odePhys.objects
end

function LvLK3D.GetPhysicsObjectByIndex(index)
    return LvLK3D.CurrUniv.odePhys.objects[index]
end

function LvLK3D.GetPhysicsObjectByName(name)
    return LvLK3D.CurrUniv.odePhys.objectIDLUT[name]
end

function LvLK3D.CanCreatePhysicsObject()
    return (#LvLK3D.CurrUniv.odePhys.objects + 1) <= _MAX_PHYSICS_OBJECTS
end

function LvLK3D.NewPhysicsBox(name, size)
    local univ = LvLK3D.CurrUniv

    if not LvLK3D.CanCreatePhysicsObject() then
        return
    end

    local box = ode.create_box(nil, size[1] * 2, size[2] * 2, size[3] * 2)
    local body = ode.create_body(univ.odePhys.world)

    body:set_mass(ode.mass_box(1, size[1], size[2], size[3], 1))
    box:set_body(body)

    univ.odePhys.space:add(box)

    local objs = univ.odePhys.objects
    local index = #objs + 1

    univ.odePhys.objectIDLUT[name] = index
    univ.odePhys.body2objects[body] = index
    univ.odePhys.objects[index] = {
        otype = "box",
        body = body,
        size = size,
        linked = nil,
        surftype = "metal",
    }

    return index
end


function LvLK3D.NewPhysicsCapsule(name, radius, len)
    local univ = LvLK3D.CurrUniv

    if not LvLK3D.CanCreatePhysicsObject() then
        return
    end

    local capsule = ode.create_capsule(nil, radius, len)
    local body = ode.create_body(univ.odePhys.world)

    body:set_mass(ode.mass_capsule(1, "y", radius, len))
    capsule:set_body(body)

    univ.odePhys.space:add(capsule)


    local objs = univ.odePhys.objects
    local index = #objs + 1

    univ.odePhys.objectIDLUT[name] = index
    univ.odePhys.body2objects[body] = index
    univ.odePhys.objects[index] = {
        otype = "capsule",
        body = body,
        radius = radius,
        len = len,
        linked = nil,
        surftype = "metal",
    }

    return index
end


function LvLK3D.SetPhysicsObjectSurfaceMaterial(index, material)
    if not surfParams[material] then
        return
    end

    LvLK3D.CurrUniv.odePhys.objects[index].surftype = material
end

function LvLK3D.GetPhysicsObjectSurfaceMaterial(index)
    return LvLK3D.CurrUniv.odePhys.objects[index].surftype
end

local _massTypeSetters = {
    ["box"] = function(obj, mass)
        obj.body:set_mass(ode.mass_box(mass, obj.size[1], obj.size[2], obj.size[3], mass))
    end,
    ["capsule"] = function(obj, mass)
        obj.body:set_mass(ode.mass_capsule(mass, "y", obj.radius, obj.len))
    end
}


function LvLK3D.SetPhysicsObjectMass(index, mass)
    local obj = LvLK3D.CurrUniv.odePhys.objects[index]

    if _massTypeSetters[obj.otype] then
        _massTypeSetters[obj.otype](obj, mass)
    else
        print("Unimplemented Mass setter for \"" .. obj.otype .. "\" type!")
    end
end

function LvLK3D.SetPhysicsObjectPos(index, pos)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_position(pos)
end

function LvLK3D.SetPhysicsObjectAng(index, ang)
    local mat_ang = Matrix()
    mat_ang:Identity()
    mat_ang:SetAngles(ang)


    local mat3_ang = {
        {mat_ang[ 1], mat_ang[ 2], mat_ang[ 3]},
        {mat_ang[ 5], mat_ang[ 6], mat_ang[ 7]},
        {mat_ang[ 8], mat_ang[10], mat_ang[11]}
    }

    LvLK3D.CurrUniv.odePhys.objects[index].body:set_rotation(mat3_ang)
end


function LvLK3D.SetPhysicsObjectMat(index, mat)
    local mat3_ang = {
        {mat[ 1], mat[ 2], mat[ 3]},
        {mat[ 5], mat[ 6], mat[ 7]},
        {mat[ 8], mat[10], mat[11]}
    }

    LvLK3D.CurrUniv.odePhys.objects[index].body:set_rotation(mat3_ang)
end


function LvLK3D.SetPhysicsObjectPosAng(index, pos, ang)
    LvLK3D.SetPhysicsObjectPos(index, pos)
    LvLK3D.SetPhysicsObjectAng(index, ang)
end

function LvLK3D.SetPhysicsObjectVel(index, vel)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_linear_vel(vel)
end

function LvLK3D.SetPhysicsObjectAngVel(index, angvel)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_angular_vel(angvel)
end

function LvLK3D.SetPhysicsObjectTorque(index, torque)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_torque(torque)
end


function LvLK3D.AddPhysicsObjectTorque(index, torque)
    LvLK3D.CurrUniv.odePhys.objects[index].body:add_torque(torque)
end


function LvLK3D.AddPhysicsObjectRelTorque(index, torque)
    LvLK3D.CurrUniv.odePhys.objects[index].body:add_rel_torque(torque)
end



function LvLK3D.SetPhysicsObjectStatic(index, bool)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_kinematic(bool)
end

-- Linked objects
-- these just update the transforms of nameVis to look as if they were in namePhys's location
-- you can unlink them too
function LvLK3D.SetLinkedObject(indexPhys, indexVis)
    LvLK3D.CurrUniv.odePhys.objects[indexPhys].linked = indexVis
    LvLK3D.CurrUniv["objects"][indexVis]._linkedPhys = indexPhys
end

function LvLK3D.SetLinkedOffset(index, offset)
    LvLK3D.CurrUniv["objects"][index]._linkedOffset = offset or Vector(0, 0, 0)
end

function LvLK3D.SetPhysicsObjectOnMoveCallback(index, callback)
    LvLK3D.CurrUniv.odePhys.objects[index].body:set_moved_callback(callback)
end



function LvLK3D.GetLinkedObjectPhys(indexVis)
    return LvLK3D.CurrUniv["objects"][indexVis]._linkedPhys
end

function LvLK3D.GetLinkedObjectVis(indexPhys)
    return LvLK3D.CurrUniv.odePhys.objects[indexPhys].linked
end


function LvLK3D.GetPhysicsObjectPos(index)
    local pos = LvLK3D.CurrUniv.odePhys.objects[index].body:get_position()
    return Vector(pos[1], pos[2], pos[3])
end

function LvLK3D.GetPhysicsObjectAng(index)
    local angMat = LvLK3D.CurrUniv.odePhys.objects[index].body:get_rotation()
    local matObj = Matrix(
        angMat[1][1], angMat[1][2], angMat[1][3], 0,
        angMat[2][1], angMat[2][2], angMat[2][3], 0,
        angMat[3][1], angMat[3][2], angMat[3][3], 0,
                   0,            0,            0, 1
    )

    return matObj:GetAngles(), matObj
end

function LvLK3D.GetPhysicsObjectMat(index)
    local angMat = LvLK3D.CurrUniv.odePhys.objects[index].body:get_rotation()
    local matObj = Matrix(
        angMat[1][1], angMat[1][2], angMat[1][3], 0,
        angMat[2][1], angMat[2][2], angMat[2][3], 0,
        angMat[3][1], angMat[3][2], angMat[3][3], 0,
                   0,            0,            0, 1
    )

    return matObj
end

function LvLK3D.GetPhysicsObjectVel(index)
    local vel = LvLK3D.CurrUniv.odePhys.objects[index].body:get_linear_vel()
    return Vector(vel[1], vel[2], vel[3])
end


function LvLK3D.GetPhysicsObjectAngVel(index)
    local vel = LvLK3D.CurrUniv.odePhys.objects[index].body:get_angular_vel()
    return Vector(vel[1], vel[2], vel[3])
end

function LvLK3D.RemovePhysicsObject(index)
    local univ = LvLK3D.CurrUniv

    univ.odePhys.objectIDLUT[univ.odePhys.objects[index].name] = nil
    univ.odePhys.objects[index] = nil
end




local STEPTIME = 0.005
local CONTACT_ID = 0

-- Set the 'near callback', invoked when two geoms are potentially colliding:
ode.set_near_callback(function(o1, o2)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end


    local collide, contactpoints = ode.collide(o1, o2, 32)
    if not collide then return end

    local v1 = o1:get_body():get_linear_vel()
    local v2 = o2:get_body():get_linear_vel()
    v1 = Vector(v1[1], v1[2], v1[3])
    v2 = Vector(v2[1], v2[2], v2[3])

    local len = (v1 - v2):Length()
    if len > 1 then
        local pos = o1:get_position()
        pos = Vector(pos[1], pos[2], pos[3])

        local o1Tag = univ.odePhys.body2objects[o1:get_body()]
        local physMat1 = LvLK3D.GetPhysicsObjectSurfaceMaterial(o1Tag)
        local physSoundList1 = LvLK3D.GetSurfaceMaterialData(physMat1).sound_list

        if physSoundList1.dual then
            if len > 8 then
                local list_heavy = physSoundList1["heavy"]
                local source = LvLK3D.PlaySound3D(list_heavy[math.random(1, #list_heavy)], pos, len * .075, len * .15)
                source:setLooping(false)
                source:play()
            elseif len > 3 then
                local list_light = physSoundList1["light"]
                local source = LvLK3D.PlaySound3D(list_light[math.random(1, #list_light)], pos, len * .275, len * .15)
                source:setLooping(false)
                source:play()
            end
        else
            if len > 6 then
                local list_both = physSoundList1["non_dual"]
                local source = LvLK3D.PlaySound3D(list_both[math.random(1, #list_both)], pos, len * .075, len * .15)
                source:setLooping(false)
                source:play()
            end
        end
    end

    local o2Tag = univ.odePhys.body2objects[o2:get_body()]
    local physMat2 = LvLK3D.GetPhysicsObjectSurfaceMaterial(o2Tag)
    local physData2 = LvLK3D.GetSurfaceMaterialData(physMat2)

    for _, contactpoint in ipairs(contactpoints) do
       local joint = ode.create_contact_joint(univ.odePhys.world, CONTACT_ID, contactpoint, physData2.ode_pack)
       joint:attach(o1:get_body(), o2:get_body())
    end
end)



local function updateLinked()
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    for i = 1, _MAX_PHYSICS_OBJECTS do
        local physObj = univ.odePhys.objects[i]

        if not physObj then
            goto _contLinked
        end

        local linkIdx = physObj.linked
        if linkIdx then
            local linkedObj = LvLK3D.CurrUniv["objects"][linkIdx]

            local linkOff = LvLK3D.CurrUniv["objects"][linkIdx]._linkedOffset or Vector(0, 0, 0)
            local mat_phys = LvLK3D.GetPhysicsObjectMat(i)
            linkOff = linkOff * mat_phys


            LvLK3D.SetObjectPos(linkIdx, LvLK3D.GetPhysicsObjectPos(i) + linkOff)
            --LvLK3D.SetObjectAng(linkIdx, ang_phys)

            linkedObj.mat_rot = mat_phys
            LvLK3D.__recalculateObjectMatrices(linkIdx)
        end


        ::_contLinked::
    end
end

function LvLK3D.PhysicsThink(dt)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    ode.space_collide(univ.odePhys.space)
    univ.odePhys.world:quick_step(dt or STEPTIME)
    ode.destroy_joint_group(CONTACT_ID)

    updateLinked()
end


local function addPhysRender(index, obj)
    local visIdx = LvLK3D.AddObjectToUniv("physobj_" .. index, "cube")
    LvLK3D.SetObjectPos(visIdx, Vector(0, 0, 0))
    LvLK3D.SetObjectMat(visIdx, "white")
    LvLK3D.SetObjectFlag(visIdx, "SHADING", true)
    LvLK3D.SetObjectFlag(visIdx, "NO_TRACE", false)
    LvLK3D.SetObjectScl(visIdx, obj.size)
    LvLK3D.UpdateObjectMesh(visIdx)
    LvLK3D.SetObjectShadow(visIdx, true)
end

function LvLK3D.PhysicsDebugRender()
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    for k, v in pairs(univ.odePhys.objects) do
        local idx = LvLK3D.GetObjectByName("physobj_" .. k)
        if not LvLK3D.CurrUniv["objects"][idx] then
            addPhysRender(k, v)
        end

        LvLK3D.SetObjectPos(idx, LvLK3D.GetPhysicsObjectPos(k))


        local ang_phys, mat_phys = LvLK3D.GetPhysicsObjectAng(k)
        LvLK3D.SetObjectAng(idx, ang_phys)
        LvLK3D.CurrUniv["objects"][idx].mat_rot = mat_phys

    end
end