LvLK3D = LvLK3D or {}
local ode = require("moonode")

local _surfaceParams = ode.pack_surfaceparameters({
    mu = 50.0,
    slip1 = 0.2,
    slip2 = 0.2,
    soft_erp = 0.96,
    soft_cfm = 0.04,
    approx1 = true,
 })


function LvLK3D.SetupPhysicsWorld(univ)

    univ.odePhys = {
        world = ode.create_world(),
        space = ode.create_hash_space(),
        surfpar = _surfaceParams,
        objects = {},
    }

    univ.odePhys.world:set_gravity({0, -9.8, 0})
    univ.odePhys.world:set_quick_step_num_iterations(12)
end

function LvLK3D.SetPhysicsGravity(grav)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    univ.odePhys.world:set_gravity(grav)
end



function LvLK3D.NewPhysicsBox(name, size)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    local box = ode.create_box(nil, size[1] * 2, size[2] * 2, size[3] * 2)
    local body = ode.create_body(univ.odePhys.world)

    body:set_mass(ode.mass_box(1, size[1], size[2], size[3], 1))
    box:set_body(body)

    univ.odePhys.space:add(box)

    univ.odePhys.objects[name] = {
        otype = "box",
        body = body,
        box = box,
        size = size,
    }
end

local _massTypeSetters = {
    ["box"] = function(obj, mass)
        obj.body:set_mass(ode.mass_box(mass, obj.size[1], obj.size[2], obj.size[3], mass))
    end
}


function LvLK3D.SetPhysicsObjectMass(name, mass)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    local obj = univ.odePhys.objects[name]

    if _massTypeSetters[obj.otype] then
        _massTypeSetters[obj.otype](obj, mass)
    else
        print("Unimplemented Mass setter for \"" .. obj.otype .. "\" type!")
    end
end

function LvLK3D.SetPhysicsObjectPos(name, pos)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    univ.odePhys.objects[name].body:set_position(pos)
end

function LvLK3D.SetPhysicsObjectAng(name, ang)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    local mat_ang = Matrix()
    mat_ang:Identity()
    mat_ang:SetAngles(ang)


    local mat3_ang = {
        {mat_ang[ 1], mat_ang[ 2], mat_ang[ 3]},
        {mat_ang[ 5], mat_ang[ 6], mat_ang[ 7]},
        {mat_ang[ 8], mat_ang[10], mat_ang[11]}
    }

    univ.odePhys.objects[name].body:set_rotation(mat3_ang)
end


function LvLK3D.SetPhysicsObjectPosAng(name, pos, ang)
    LvLK3D.SetPhysicsObjectPos(name, pos)
    LvLK3D.SetPhysicsObjectAng(name, ang)
end

function LvLK3D.SetPhysicsObjectVel(name, vel)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    univ.odePhys.objects[name].body:set_linear_vel(vel)
end



function LvLK3D.SetPhysicsObjectStatic(name, bool)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    univ.odePhys.objects[name].body:set_kinematic(bool)
end



function LvLK3D.GetPhysicsObjectPos(name)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end


    local pos = univ.odePhys.objects[name].body:get_position()
    return Vector(pos[1], pos[2], pos[3])
end

function LvLK3D.GetPhysicsObjectAng(name)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end


    local angMat = univ.odePhys.objects[name].body:get_rotation()
    local matObj = Matrix(
        angMat[1][1], angMat[1][2], angMat[1][3], 0,
        angMat[2][1], angMat[2][2], angMat[2][3], 0,
        angMat[3][1], angMat[3][2], angMat[3][3], 0,
                   0,            0,            0, 1
    )

    return matObj:GetAngles(), matObj
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
    for _, contactpoint in ipairs(contactpoints) do
       local joint = ode.create_contact_joint(univ.odePhys.world, CONTACT_ID, contactpoint, _surfaceParams)
       joint:attach(o1:get_body(), o2:get_body())
    end
end)

function LvLK3D.PhysicsThink(dt)
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    ode.space_collide(univ.odePhys.space)
    univ.odePhys.world:quick_step(dt or STEPTIME)
    ode.destroy_joint_group(CONTACT_ID)
end


local function addPhysRender(k, obj)
    local idx = "physobj_" .. k

    LvLK3D.AddObjectToUniv(idx, "cube")
    LvLK3D.SetObjectPos(idx, Vector(0, 0, 0))
    LvLK3D.SetObjectMat(idx, "white")
    LvLK3D.SetObjectFlag(idx, "SHADING", true)
    LvLK3D.SetObjectFlag(idx, "NO_TRACE", false)
    LvLK3D.SetObjectScl(idx, obj.size)
    LvLK3D.UpdateObjectMesh(idx)
    --LvLK3D.SetObjectShadow(idx, true)
end

function LvLK3D.PhysicsDebugRender()
    local univ = LvLK3D.CurrUniv
    if not univ.odePhys then
        return
    end

    for k, v in pairs(univ.odePhys.objects) do
        local idx = "physobj_" .. k
        if not LvLK3D.CurrUniv["objects"][idx] then
            addPhysRender(k, v)
        end

        LvLK3D.SetObjectPos(idx, LvLK3D.GetPhysicsObjectPos(k))


        local ang_phys, mat_phys = LvLK3D.GetPhysicsObjectAng(k)
        LvLK3D.SetObjectAng(idx, ang_phys)
        LvLK3D.CurrUniv["objects"][idx].mat_rot = mat_phys

    end
end