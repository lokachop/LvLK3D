LvLK3D = LvLK3D or {}

local myPath = "?.lua;?/init.lua"
local myPathC = "?.dll;??"

package.path = myPath
love.filesystem.setRequirePath(myPath)
package.cpath = myPathC
love.filesystem.setCRequirePath(myPathC)

require("lvlk3d.lvlk3d")

function love.load()
	CurTime = 0



	local sw, sh = love.graphics.getDimensions()
	UnivTest = LvLK3D.NewUniverse("Test_LVLK3D")
	RTTest = LvLK3D.NewRenderTarget("TestRT_LVLK3D", sw, sh)
	LvLK3D.BuildProjectionMatrix(sw / sh, 0.01, 1000)



	LvLK3D.NewTexturePNG("loka",       "textures/loka.png")

	LvLK3D.NewTexturePNG("mandrill",   "textures/mandrill.png")
	LvLK3D.SetTextureFilter("mandrill", "nearest", "nearest")

	LvLK3D.NewTexturePNG("loka_sheet",         "textures/loka_sheet.png")
	LvLK3D.SetTextureFilter("loka_sheet", "nearest", "nearest")

	LvLK3D.NewTexturePNG("train_sheet",        "textures/train_sheet.png")
	LvLK3D.SetTextureFilter("train_sheet", "nearest", "nearest")

	LvLK3D.NewTexturePNG("traintrack_sheet",   "textures/traintrack_sheet.png")
	LvLK3D.SetTextureFilter("traintrack_sheet", "nearest", "nearest")
	LvLK3D.SetTextureWrap("traintrack_sheet", "repeat")

	LvLK3D.NewTexturePNG("happyPNGTest", "textures/happy.png")

	LvLK3D.NewTexturePNG("sky",       "textures/sky_composite.png")
	LvLK3D.SetTextureWrap("sky", "repeat")


	-- lets make some real textures
	local procMarble = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(procMarble, 1, 1, 1)
	LvLK3D.ProcTexSimplexMultiply(procMarble, 6, 6)
	LvLK3D.ProcTexSimplexMultiply(procMarble, 14, 14)
	LvLK3D.ProcTexSimplexMultiply(procMarble, 24, 24)

	LvLK3D.ProcTexApplyColourAdd(procMarble, 0.1, 0.1, 0.1)
	LvLK3D.ProcTexInvert(procMarble)

	LvLK3D.ProcTexDeclareTexture("procMarble", procMarble)


	local stonesSize = 8
	local stonesDist = 1
	local procPebbles = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(procPebbles, 1, 1, 1)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 4, 4)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 6, 6)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 8, 8)
	LvLK3D.ProcTexApplyColourAdd(procPebbles, 0.25, 0.25, 0.25)
	LvLK3D.ProcTexClamp(procPebbles, 0.25, 0.6)

	local maskDistort = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(maskDistort, 1, 1, 1)
	LvLK3D.ProcTexWorleyNormal(maskDistort, stonesSize, stonesSize, stonesDist)
	LvLK3D.ProcTexBlur(maskDistort, 8, 6)

	local maskStoneBorders = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(maskStoneBorders, 1, 1, 1)
	LvLK3D.ProcTexWorleyMultiply(maskStoneBorders, stonesSize, stonesSize, stonesDist)
	LvLK3D.ProcTexTreshold(maskStoneBorders, 1, 0.9)

	local tempShine = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(tempShine, 1, 1, 1)
	LvLK3D.ProcTexLightDot(tempShine, maskDistort, Vector(-0.75, -0.25, 1.75):GetNormalized(), 6, 4)


	LvLK3D.ProcTexDistort(procPebbles, maskDistort, -0.15)
	LvLK3D.ProcTexMultiply(procPebbles, tempShine)
	LvLK3D.ProcTexMultiply(procPebbles, maskStoneBorders)
	LvLK3D.ProcTexDeclareTexture("procPebbles", procPebbles)


	local testNormalSpx = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(testNormalSpx, 1, 1, 1)
	LvLK3D.ProcTexSimplexMultiply(testNormalSpx, 6, 6)
	LvLK3D.ProcTexNormalify(testNormalSpx)

	local testLit = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(testLit, 0.25, 0.45, 0.85)
	LvLK3D.ProcTexLightDot(testLit, testNormalSpx, Vector(-0.75, -0.25, 1.75):GetNormalized(), 0.5, 16)
	LvLK3D.ProcTexDeclareTexture("testSpxNormal", testLit)



	local textureID_0 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(textureID_0, 255 / 255, 255 / 255, 255 / 255)
	LvLK3D.ProcTexSimplexMultiply(textureID_0, 3, 3, 0, 0)
	LvLK3D.ProcTexSimplexMultiply(textureID_0, 6, 6, 0, 0)
	local textureID_1 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(textureID_1, 255 / 255, 255 / 255, 255 / 255)
	LvLK3D.ProcTexWorleyNormal(textureID_1, 3, 3, 0.5)
	LvLK3D.ProcTexBlur(textureID_1, 8, 3, 16)
	LvLK3D.ProcTexDistort(textureID_0, textureID_1, 0.05)
	LvLK3D.ProcTexDeclareTexture("The_name", textureID_0)

	local textureID_0 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(textureID_0, 255 / 255, 255 / 255, 255 / 255)
	LvLK3D.ProcTexWorleyMultiply(textureID_0, 6, 6, 1)
	LvLK3D.ProcTexInvert(textureID_0)
	local textureID_1 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexWorleyNormal(textureID_1, 6, 6, 1)
	LvLK3D.ProcTexInvert(textureID_1)
	LvLK3D.ProcTexDistort(textureID_0, textureID_1, 0.05)
	LvLK3D.ProcTexDeclareTexture("none", textureID_0)
	local textureID_2 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(textureID_2, 255 / 255, 255 / 255, 255 / 255)
	LvLK3D.ProcTexWorleyMultiply(textureID_2, 6, 6, 1)
	LvLK3D.ProcTexInvert(textureID_2)
	local textureID_3 = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexWorleyNormal(textureID_3, 6, 6, 1)
	LvLK3D.ProcTexInvert(textureID_3)
	LvLK3D.ProcTexDistort(textureID_2, textureID_3, 0.05)
	LvLK3D.ProcTexDeclareTexture("bad_nouise", textureID_2)


	LvLK3D.SetupPhysicsWorld(UnivTest)


	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.SetSunLighting(true) -- dont do sun lighting
		LvLK3D.SetSunCol({0.5, 0.5, 0.65}) -- set col to weird yellow
		LvLK3D.SetSunDir(Vector(-0.61, -0.51, 0.59):GetNormalized())
		LvLK3D.SetAmbientCol({.1, .1, .1}) -- ambient to darker weird yellow
		--LvLK3D.SetAmbientCol({0, 0, 0})



		--LvLK3D.AddLightToUniv("LightOne", Vector(0, 3, 2), 4, {0.25, 0.25, 1})
		--LvLK3D.AddLightToUniv("LightTwo", Vector(2, 3, -2), 4, {0.25, 1, 0.25})
		--LvLK3D.AddLightToUniv("LightThree", Vector(-2, 3, -2), 4, {1, 0.25, 0.25})










		local idxCube = LvLK3D.AddObjectToUniv("cube1", "cube")
		LvLK3D.SetObjectPos(idxCube, Vector(0, 0, 0))
		LvLK3D.SetObjectMat(idxCube, "happyPNGTest")
		LvLK3D.SetObjectFlag(idxCube, "SHADING", true)
		LvLK3D.SetObjectFlag(idxCube, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(idxCube, "NORM_INVERT", false)
		LvLK3D.SetObjectFlag(idxCube, "FULLBRIGHT", false)
		LvLK3D.SetObjectScl(idxCube, Vector(.5, .5, .5))
		LvLK3D.UpdateObjectMesh(idxCube)
		LvLK3D.SetObjectShadow(idxCube, true)

		local cubeTr = LvLK3D.AddObjectToUniv("cube_tr", "cube")
		LvLK3D.SetObjectPos(cubeTr, Vector(0, 0, 0))
		LvLK3D.SetObjectMat(cubeTr, "happyPNGTest")
		LvLK3D.SetObjectFlag(cubeTr, "SHADING", true)
		LvLK3D.SetObjectFlag(cubeTr, "NO_TRACE", true)
		LvLK3D.SetObjectScl(cubeTr, Vector(.1, .1, .1))
		LvLK3D.UpdateObjectMesh(cubeTr)
		LvLK3D.SetObjectShadow(cubeTr, true)



		local planeFloor = LvLK3D.AddObjectToUniv("plane_floor", "plane")
		LvLK3D.SetObjectPos(planeFloor, Vector(0, -4, 0))
		LvLK3D.SetObjectScl(planeFloor, Vector(256, 1, 256))
		LvLK3D.SetObjectMat(planeFloor, "mandrill")
		LvLK3D.SetObjectFlag(planeFloor, "SHADING", true)
		LvLK3D.UpdateObjectMesh(planeFloor)

		local lkTest = LvLK3D.AddObjectToUniv("lktest", "lokachop_sqr")
		LvLK3D.SetObjectPos(lkTest, Vector(0, 0, 0))
		LvLK3D.SetObjectScl(lkTest, Vector(1, 1, 1))
		LvLK3D.SetObjectMat(lkTest, "loka_sheet")
		LvLK3D.SetObjectFlag(lkTest, "SHADING", true)
		LvLK3D.SetObjectFlag(lkTest, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(lkTest)
		LvLK3D.SetObjectShadow(lkTest, true)


		local lkTest2 = LvLK3D.AddObjectToUniv("lktest2", "cube_dae")
		LvLK3D.SetObjectPos(lkTest2, Vector(0, -1, -8))
		LvLK3D.SetObjectScl(lkTest2, Vector(1, 1, 1))
		LvLK3D.SetObjectMat(lkTest2, "white")
		LvLK3D.SetObjectFlag(lkTest2, "SHADING", true)
		LvLK3D.SetObjectFlag(lkTest2, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(lkTest2)

		local cubeFloor = LvLK3D.AddObjectToUniv("cube_floor", "cube")
		LvLK3D.SetObjectPos(cubeFloor, Vector(0, -2, -2.75))
		LvLK3D.SetObjectMat(cubeFloor, "procMarble")
		LvLK3D.SetObjectFlag(cubeFloor, "SHADING", false)
		LvLK3D.SetObjectFlag(cubeFloor, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(cubeFloor, "NORM_INVERT", false)
		LvLK3D.SetObjectFlag(cubeFloor, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(cubeFloor)
		LvLK3D.SetObjectShadow(cubeFloor, true)

		local train = LvLK3D.AddObjectToUniv("train", "train")
		LvLK3D.SetObjectPos(train, Vector(4, -2.05, -3))
		LvLK3D.SetObjectMat(train, "train_sheet")
		LvLK3D.SetObjectFlag(train, "SHADING", true)
		LvLK3D.SetObjectFlag(train, "SHADING_SMOOTH", true)
		LvLK3D.SetObjectFlag(train, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(train)
		LvLK3D.SetObjectShadow(train, true)

		local dynamicSourceCube = LvLK3D.AddObjectToUniv("cube_source_dynamic", "cube")
		LvLK3D.SetObjectPos(dynamicSourceCube, Vector(0, 0, 16))
		LvLK3D.SetObjectScl(dynamicSourceCube, Vector(0.5, 0.5, 0.5))
		LvLK3D.SetObjectMat(dynamicSourceCube, "The_name")
		LvLK3D.SetObjectFlag(dynamicSourceCube, "SHADING", false)
		LvLK3D.SetObjectFlag(dynamicSourceCube, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(dynamicSourceCube, "NORM_INVERT", false)
		LvLK3D.SetObjectFlag(dynamicSourceCube, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(dynamicSourceCube)
		LvLK3D.SetObjectShadow(dynamicSourceCube, true)



		local roomCube1 = LvLK3D.AddObjectToUniv("cube_room", "cube")
		LvLK3D.SetObjectPos(roomCube1, Vector(0, 0, -16))
		LvLK3D.SetObjectScl(roomCube1, Vector(4.5, 4.5, 4.5))
		LvLK3D.SetObjectMat(roomCube1, "procMarble")
		LvLK3D.SetObjectFlag(roomCube1, "SHADING", false)
		LvLK3D.SetObjectFlag(roomCube1, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(roomCube1, "NORM_INVERT", true)
		LvLK3D.SetObjectFlag(roomCube1, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(roomCube1)



		local roomCube2 = LvLK3D.AddObjectToUniv("cube_room2", "cube")
		LvLK3D.SetObjectPos(roomCube2, Vector(16, 0, 0))
		LvLK3D.SetObjectScl(roomCube2, Vector(2.5, 2.5, 2.5))
		LvLK3D.SetObjectMat(roomCube2, "procMarble")
		LvLK3D.SetObjectFlag(roomCube2, "SHADING", false)
		LvLK3D.SetObjectFlag(roomCube2, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(roomCube2, "NORM_INVERT", true)
		LvLK3D.SetObjectFlag(roomCube2, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(roomCube2)


		local roomCube3 = LvLK3D.AddObjectToUniv("cube_room3", "cube")
		LvLK3D.SetObjectPos(roomCube3, Vector(-32, 0, 0))
		LvLK3D.SetObjectScl(roomCube3, Vector(8.5, 8.5, 8.5))
		LvLK3D.SetObjectMat(roomCube3, "bad_nouise")
		LvLK3D.SetObjectFlag(roomCube3, "SHADING", false)
		LvLK3D.SetObjectFlag(roomCube3, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(roomCube3, "NORM_INVERT", true)
		LvLK3D.SetObjectFlag(roomCube3, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(roomCube3)


		--LvLK3D.AddObjectToUniv("rail", "traintrack")
		--LvLK3D.SetObjectPos("rail", Vector(8, -2, -3))
		--LvLK3D.SetObjectMat("rail", "traintrack_sheet")


		local function physAndLinked(name, pos, ang, sz, static, mass)
			local idxPhys = LvLK3D.NewPhysicsBox(name .. "_phys", sz)
			LvLK3D.SetPhysicsObjectMass(idxPhys, mass or 5120)
			LvLK3D.SetPhysicsObjectPos(idxPhys, pos)
			LvLK3D.SetPhysicsObjectAng(idxPhys, ang)

			if static then
				LvLK3D.SetPhysicsObjectStatic(idxPhys, true)
			end

			local idxVis = LvLK3D.AddObjectToUniv(name .. "_vis", "cube")
			LvLK3D.SetObjectPos(idxVis, Vector(0, 0, 0))
			LvLK3D.SetObjectMat(idxVis, "white")
			LvLK3D.SetObjectFlag(idxVis, "SHADING", true)
			LvLK3D.SetObjectFlag(idxVis, "NO_TRACE", false)
			LvLK3D.SetObjectScl(idxVis, sz)
			LvLK3D.UpdateObjectMesh(idxVis)
			LvLK3D.SetObjectShadow(idxVis, true)

			LvLK3D.SetLinkedObject(idxPhys, idxVis)
		end

		physAndLinked("boxA", Vector(0, 12, 8.25), Angle(0, 45, 0), Vector(.4, .2, .4), false, 1)
		physAndLinked("boxC", Vector(0, 16, 8), Angle(0, 0, 0), Vector(.4, 1.6, .4), false, 1)
		physAndLinked("boxD", Vector(0, 16, 7), Angle(0, 0, 0), Vector(.1, 0.6, .1), false, 1)

		-- static box
		local sbox_size = 4
		local wall_size = .2
		LvLK3D.AddLightToUniv("LightSbox", Vector(0, -2 + (sbox_size * 1), 8), sbox_size, {0.62, 0.65, 0.75})

		physAndLinked("sboxA", Vector(0, -2 + wall_size * 4, 8), Angle(0, 0, 0), Vector(sbox_size, wall_size, sbox_size), true)
		physAndLinked("sboxB", Vector(-sbox_size, sbox_size * .5, 8), Angle(0, 0, 0), Vector(wall_size, sbox_size, sbox_size), true)
		physAndLinked("sboxC", Vector(sbox_size, sbox_size * .5, 8), Angle(0, 0, 0), Vector(wall_size, sbox_size, sbox_size), true)
		physAndLinked("sboxD", Vector(0, sbox_size * .5, 8 + sbox_size), Angle(0, 0, 0), Vector(sbox_size, sbox_size, wall_size), true)
		physAndLinked("sboxE", Vector(0, sbox_size * .5, 8 - sbox_size), Angle(0, 0, 0), Vector(sbox_size, sbox_size, wall_size), true)



		--physAndLinked("bigFloorA", Vector(0, -8, 0), Angle(0, 0, 0), Vector(32, 4, 32), true)

		local bigFloor = LvLK3D.NewPhysicsBox("bigFloorA", Vector(512, 4, 512))
		LvLK3D.SetPhysicsObjectMass(bigFloor, 5120)
		LvLK3D.SetPhysicsObjectPos(bigFloor, Vector(0, -8, 0))
		LvLK3D.SetPhysicsObjectAng(bigFloor, Angle(0, 0, 0))
		LvLK3D.SetPhysicsObjectStatic(bigFloor, true)



		for k, v in pairs(LvLK3D.CurrUniv["lights"]) do
			local idxLight = LvLK3D.AddObjectToUniv("lightID " .. v.tag, "cube")
			LvLK3D.SetObjectPos(idxLight, v.pos)
			LvLK3D.SetObjectMat(idxLight, "white")

			LvLK3D.SetObjectFlag(idxLight, "SHADING", false)
			LvLK3D.SetObjectFlag(idxLight, "FULLBRIGHT", true)
			LvLK3D.SetObjectScl(idxLight, Vector(.1, .1, .1))
			LvLK3D.SetObjectCol(idxLight, v.col)
		end
	LvLK3D.PopUniverse()




	LvLK3D.AddNewSoundEffect("reverbLarge", {
		["type"] = "reverb",
		["gain"] = 0.4,
		["highgain"] = 1.4,
		["density"] = 0.3,
		["diffusion"] = 0.4,
		["decaytime"] = 1.2 ,
		["decayhighratio"] = 0.83,
		["earlygain"] = 1.26,
		["earlydelay"] = 0.05,
		["lategain"] = 0.0,
		["latedelay"] = 0.011,
		["roomrolloff"] = 0.01,
		["airabsorption"] = 0.994,
		["highlimit"] = true
	})


	LvLK3D.AddNewSoundEffect("reverbHuge", {
		["type"] = "reverb",
		["gain"] = 0.4,
		["highgain"] = 0.6,
		["density"] = 0.1,
		["diffusion"] = 0.3,
		["decaytime"] = 2.4 ,
		["decayhighratio"] = 0.2,
		["earlygain"] = 0.20,
		["earlydelay"] = 0.0,
		["lategain"] = 1.20,
		["latedelay"] = 0.1,
		["roomrolloff"] = 0,
		["airabsorption"] = 0.994,
		["highlimit"] = true
	})

	LvLK3D.AddNewSoundEffect("reverbSmall", {
		["type"] = "reverb",
		["gain"] = 0.5,
		["highgain"] = 3.0,
		["density"] = 0.0,
		["diffusion"] = 0.8,
		["decaytime"] = 0.5,
		["decayhighratio"] = 0.83,
		["earlygain"] = 1,
		["earlydelay"] = 0.1,
		["lategain"] = 0,
		["latedelay"] = 0.011,
		["roomrolloff"] = 10,
		["airabsorption"] = 0.994,
		["highlimit"] = true
	})

	LvLK3D.AddNewSoundEffect("echoTest", {
		["type"] = "echo",
		["delay"] = 0.025,
		["tapdelay"] = 0.025,
		["damping"] = 0.5,
		["feedback"] = 0.5,
		["spread"] = -1,
	})

	local source = LvLK3D.PlaySound3D("sounds/morse.wav", Vector(-4, 0, 0), 1, 1)
	source:setLooping(true)
	source:play()


	local source2 = LvLK3D.PlaySound3D("sounds/Enter the Maze.wav", Vector(16, 0, 0), 1, 3)
	LvLK3D.SetSourceEffect(source2, "reverbSmall", true)
	LvLK3D.SetSourceFilter(source2, {
		["volume"] = 0.0,
		["type"] = "lowpass"
	})
	source2:setLooping(true)
	source2:play()

	Source3_Dynamic = LvLK3D.PlaySound3D("sounds/Space Jazz.wav", Vector(0, 0, -16), 1, 3)
	LvLK3D.SetSourceEffect(Source3_Dynamic, "reverbLarge", true)
	LvLK3D.SetSourceFilter(Source3_Dynamic, {
		["volume"] = 0.0,
		["type"] = "lowpass"
	})
	Source3_Dynamic:setLooping(true)
	Source3_Dynamic:play()


	local source4 = LvLK3D.PlaySound3D("sounds/Simplex.wav", Vector(-32, 0, 0), 1, 5)
	LvLK3D.SetSourceEffect(source4, "reverbHuge", true)
	LvLK3D.SetSourceFilter(source4, {
		["volume"] = 0.0,
		["type"] = "lowpass"
	})
	source4:setLooping(true)
	source4:play()


	SkyUniv = LvLK3D.NewUniverse("skybox_test")
	LvLK3D.PushUniverse(SkyUniv)
		local skyCube = LvLK3D.AddObjectToUniv("skybox_cube", "sky_cube")
		LvLK3D.SetObjectPos(skyCube, Vector(0, 0, 0))
		LvLK3D.SetObjectScl(skyCube, Vector(1, 1, 1))
		LvLK3D.SetObjectMat(skyCube, "sky")
		LvLK3D.SetObjectFlag(skyCube, "NORM_INVERT", false)
		LvLK3D.UpdateObjectMesh(skyCube)
	LvLK3D.PopUniverse()
end


local function updateLightAndExShadow(id, pos)
	LvLK3D.SetLightPos(id, pos)
	LvLK3D.SetObjectPos("lightID " .. id, pos)
end

local function reflect(I, N)
	return I - 2 * N:Dot(I) * N
end



local _throwFlag = false
local _throwIdx = 0

local _radio = nil
local function throwCubes(dt)
	if love.mouse.isDown(1) and not _throwFlag then
		_throwFlag = true
		local fow = LvLK3D.CamMatrix_Rot:Forward()


		local idxPhys = LvLK3D.NewPhysicsBox("throw" .. _throwIdx, Vector(.4, .4, .4))
		LvLK3D.SetPhysicsObjectMass(idxPhys, 2) -- 20 kg
		LvLK3D.SetPhysicsObjectPos(idxPhys, LvLK3D.CamPos + (fow * 1.5))
		LvLK3D.SetPhysicsObjectVel(idxPhys, fow * 16)
		LvLK3D.SetPhysicsObjectSurfaceMaterial(idxPhys, "wood_box")

		if not _radio then
			_radio = LvLK3D.PlaySound3D("sounds/Simplex.wav", Vector(0, 0, -16), 1, 3)
			_radio:setLooping(true)
			_radio:play()
			LvLK3D.SetPhysicsObjectOnMoveCallback(idxPhys, function(obj)
				local pos = obj:get_position()
				local vel = obj:get_linear_vel()

				_radio:setPosition(pos[1], pos[2], pos[3])
				_radio:setVelocity(vel[1], vel[2], vel[3])
			end)
		end

		local idxVis = LvLK3D.AddObjectToUniv("throwVis" .. _throwIdx, "lokachop_sqr")
		LvLK3D.SetObjectPos(idxVis, Vector(0, 0, 0))
		LvLK3D.SetObjectScl(idxVis, Vector(.4, .4, .4))
		LvLK3D.SetObjectMat(idxVis, "loka_sheet")
		LvLK3D.SetObjectFlag(idxVis, "SHADING", true)
		LvLK3D.SetObjectFlag(idxVis, "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag(idxVis, "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh(idxVis)
		LvLK3D.SetObjectShadow(idxVis, true)


		LvLK3D.SetLinkedObject(idxPhys, idxVis)
		LvLK3D.SetLinkedOffset(idxVis, Vector(0, -.4, -.075))


		_throwIdx = _throwIdx + 1
	elseif _throwFlag and not love.mouse.isDown(1) then
		_throwFlag = false
	end
end


local _grabFlag = false
local grabbedObject = nil
local _offsetGrab = 0
local function grabCubes(dt)
	if love.mouse.isDown(1) and not _grabFlag then
		local camPos = LvLK3D.CamPos
		local dir = LvLK3D.CamMatrix_Rot:Forward()
		local hit, pos, norm, dist, obj = LvLK3D.TraceRay(camPos, dir, 8)

		if not obj then
			return
		end

		local physObj = obj._linkedPhys

		if not physObj then
			return
		end


		grabbedObject = physObj
		_offsetGrab = (LvLK3D.GetPhysicsObjectPos(physObj) - camPos):Length()
		_grabFlag = true
	elseif _grabFlag then
		if love.mouse.isDown(1) then
			local camPos = LvLK3D.CamPos
			local dir = LvLK3D.CamMatrix_Rot:Forward()
			local offReal = camPos + (dir * _offsetGrab)

			local diff = offReal - LvLK3D.GetPhysicsObjectPos(grabbedObject)
			local vel = LvLK3D.GetPhysicsObjectVel(grabbedObject)


			LvLK3D.SetPhysicsObjectVel(grabbedObject, (diff - (vel * .025)) * dt * 640)
			--LvLK3D.SetPhysicsObjectAng(grabbedObject, dir * 180)
		else
			_selected = nil
			_grabFlag = false
		end
	end
end

local _interactMode = 0
local _interactToggleFlag = false
local function toggleInteract()
	if love.keyboard.isDown("p") and not _interactToggleFlag then
		_interactMode = (_interactMode + 1) % 2
		_interactToggleFlag = true
		print("NewInteract: " .. _interactMode)
	elseif not love.keyboard.isDown("p") and _interactToggleFlag then
		_interactToggleFlag = false
	end
end


function love.update(dt)
	CurTime = CurTime + dt

	LvLK3D.MouseCamThink(dt)

	LvLK3D.PushUniverse(UnivTest)
		toggleInteract()
		if _interactMode == 0 then
			throwCubes(dt)
		elseif _interactMode == 1 then
			grabCubes(dt)
		end

		local dir = LvLK3D.CamMatrix_Rot:Forward()

		--local hit, pos, norm = LvLK3D.TraceRay(LvLK3D.CamPos, dir, 8)
		--LvLK3D.SetObjectPos("cube_tr", pos + (norm * .1))


		LvLK3D.SetObjectAng(LvLK3D.GetObjectByName("lktest"), Angle(CurTime * 24, CurTime * 32, 0))

		local cube1 = LvLK3D.GetObjectByName("cube1")
		LvLK3D.SetObjectAng(cube1, Angle(CurTime * 24, CurTime * 32, 0))
		LvLK3D.SetObjectPos(cube1, Vector(math.sin(CurTime * .75) * 2.65, 0, math.cos(CurTime * .4532) * 2.5))


		local pCube = Vector(math.sin(CurTime * 1.75) * 2.65, 0, (math.cos(CurTime * 1.4532) * 2.5) - 16)
		LvLK3D.SetObjectPos(LvLK3D.GetObjectByName("cube_source_dynamic"), pCube)
		LvLK3D.SetSourcePosition(Source3_Dynamic, pCube)
		--updateLightAndExShadow("LightOne", Vector(math.cos(CurTime * .65) * 5.6546, 3, math.sin(CurTime * .7645767) * 6.523))
		--updateLightAndExShadow("LightTwo", Vector(math.cos(CurTime * 1.85) * 8.6546, math.sin(CurTime * 1.24) + 3, math.sin(CurTime * 1.2645767) * 10.523))
		--updateLightAndExShadow("LightThree", Vector(math.cos(CurTime * 0.125) * 12.6546, (math.sin(CurTime * 0.62) * 2) + 3, math.sin(CurTime * 0.25645767) * 10.523))

		LvLK3D.PhysicsThink(dt)
		--LvLK3D.PhysicsDebugRender()
		LvLK3D.SoundThink(dt)
	LvLK3D.PopUniverse()


	--print("Vector(" .. dir[1] .. ", " .. dir[2] .. ", " .. dir[3] .. ")")
end

function love.keypressed(key)
	LvLK3D.ToggleMouseLock(key)
end

function love.mousemoved(mx, my, dx, dy)
	LvLK3D.MouseCamUpdate(dx, dy)
end


function love.draw()
	love.graphics.clear(true, true, true)

	LvLK3D.PushRenderTarget(RTTest)
		--LvLK3D.Clear(.1, .2, .3)
		LvLK3D.ClearDepth()

		LvLK3D.PushUniverse(SkyUniv)
			local _camPos = LvLK3D.CamPos * 1
			LvLK3D.SetCamPos(Vector(0, 0, 0))
			LvLK3D.RenderActiveUniverse()
			LvLK3D.SetCamPos(_camPos)

			LvLK3D.ClearDepth()
		LvLK3D.PopUniverse()

		LvLK3D.PushUniverse(UnivTest)

			LvLK3D.RenderActiveUniverse()

		LvLK3D.PopUniverse()
	LvLK3D.PopRenderTarget()

	--LvLK3D.PushPPEffect("cbBlur", {
	--	["blendFactor"] = 0.9
	--})
	--LvLK3D.PushPPEffect("frameAccum", {
	--	["blendFactor"] = 0.97
	--})
	LvLK3D.RenderRTFullScreen(RTTest)

	if _interactMode == 0 then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print("Throw Cubes")
	elseif _interactMode == 1 then
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.print("Grab Cubes")
	end

	local w, h = love.graphics.getDimensions()
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.circle("fill", w * .5, h * .5, 3)

	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.circle("fill", w * .5, h * .5, 2)
end