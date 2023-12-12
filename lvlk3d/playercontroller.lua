LvLK3D = LvLK3D or {}
print("ODE Character controller")

local camPos = Vector(0, 0, 0)
local camAng = Angle(0, 0, 0)


local CAPSULE_RAD = 1
local CAPSULE_TALL = 1.75
local CAPSULE_IDX = "player_controller_capsule"
function LvLK3D.CharacterControllerInit()
	LvLK3D.NewPhysicsCapsule(CAPSULE_IDX, 1, 1.75)
	LvLK3D.SetPhysicsObjectMass(CAPSULE_IDX, 1)
	LvLK3D.SetPhysicsObjectPos(CAPSULE_IDX, Vector(0, 0, 0))
	LvLK3D.SetPhysicsObjectAng(CAPSULE_IDX, Angle(0, 0, 0))
end

function LvLK3D.CharacterControllerThink(dt)
	camPos = LvLK3D.GetPhysicsObjectPos(CAPSULE_IDX)

	local vMul = 4

	local fow = LvLK3D.CamMatrix_Rot:Forward()
	fow:Mul(vMul)

	local rig = LvLK3D.CamMatrix_Rot:Right()
	rig:Mul(vMul)

	local up = LvLK3D.CamMatrix_Rot:Up()
	up:Mul(vMul)


	local vel_add = Vector(0, 0, 0)
	if love.keyboard.isDown("w") then
		LvLK3D.CamVel = LvLK3D.CamVel + fow
	end

	if love.keyboard.isDown("s") then
		LvLK3D.CamVel = LvLK3D.CamVel - fow
	end

	if love.keyboard.isDown("a") then
		LvLK3D.CamVel = LvLK3D.CamVel - rig
	end

	if love.keyboard.isDown("d") then
		LvLK3D.CamVel = LvLK3D.CamVel + rig
	end

	if love.keyboard.isDown("space") then
		LvLK3D.CamVel = LvLK3D.CamVel + up
	end

	if love.keyboard.isDown("lctrl") then
		LvLK3D.CamVel = LvLK3D.CamVel - up
	end

	--LvLK3D.SetPhysicsObjectAng(CAPSULE_IDX, Angle(0, camAng[2], 0))
	camPos = LvLK3D.GetPhysicsObjectPos(CAPSULE_IDX)

	LvLK3D.SetCamPos(camPos + Vector(0, CAPSULE_TALL, 0))
end


function LvLK3D.PlayerCamUpdate(mx, my)
	if not LvLK3D.CamInputLock then
		return
	end

	local mxReal = -mx / 2
	local myReal = -my / 2
	camAng = camAng + Angle(myReal, mxReal, 0)
	print(camAng)
	camAng[1] = math.max(math.min(camAng[1], 89.5), -89.5)

	LvLK3D.CamMatrix_Rot:SetAngles(camAng)
end
