LvLK3D = LvLK3D or {}
function love.load()
	love.filesystem.load("/lvlk3d/lvlk3d.lua")()
	CurTime = 0


	local sw, sh = love.graphics.getDimensions()
	UnivTest = LvLK3D.NewUniverse("Test_LVLK3D")
	RTTest = LvLK3D.NewRenderTarget("TestRT_LVLK3D", sw, sh)
	LvLK3D.BuildProjectionMatrix(sw / sh, 0.01, 1000)



	LvLK3D.NewTexturePPM("loka",       "textures/loka.ppm")

	LvLK3D.NewTexturePPM("mandrill",   "textures/mandrill.ppm")
	LvLK3D.SetTextureFilter("mandrill", "nearest", "nearest")

	LvLK3D.NewTexturePPM("loka_sheet",         "textures/loka_sheet.ppm")
	LvLK3D.SetTextureFilter("loka_sheet", "nearest", "nearest")

	LvLK3D.NewTexturePPM("train_sheet",        "textures/train_sheet.ppm")
	LvLK3D.SetTextureFilter("train_sheet", "nearest", "nearest")

	LvLK3D.NewTexturePPM("traintrack_sheet",   "textures/traintrack_sheet.ppm")
	LvLK3D.SetTextureFilter("traintrack_sheet", "nearest", "nearest")
	LvLK3D.SetTextureWrap("traintrack_sheet", "repeat")

	LvLK3D.NewTexturePNG("happyPNGTest", "textures/happy.png")
	--LvLK3D.ProcTexApplyEffectTest("happyPNGTest")


	--LvLK3D.ProcTexApplyColour(tempProcTest, 1, 0, 1)
	--LvLK3D.ProcTexWorleyMultiply(tempProcTest, 3, 3)

	local tempProcTestMaskX = LvLK3D.ProcTexNewTemp(512, 512)
	LvLK3D.ProcTexApplyColour(tempProcTestMaskX, 1, 0, 0)
	--LvLK3D.ProcTexSimplexMultiply(tempProcTestMask, 2, 2)
	--LvLK3D.ProcTexSimplexMultiply(tempProcTestMask, 4, 4)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskX, 6, 6)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskX, 14, 14)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskX, 24, 24)

	--LvLK3D.ProcTexApplyColourAdd(tempProcTestMask, 0.1, 0.1, 0.1)
	--LvLK3D.ProcTexApplyColourMul(tempProcTestMaskX, 1, 0, 0)



	local tempProcTestMaskY = LvLK3D.ProcTexNewTemp(512, 512)
	LvLK3D.ProcTexApplyColour(tempProcTestMaskY, 0, 1, 0)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskY, 8.46, 9.53)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskY, 17.325, 11.235)
	LvLK3D.ProcTexSimplexMultiply(tempProcTestMaskY, 26.53, 28.64)
	LvLK3D.ProcTexMergeAdd(tempProcTestMaskX, tempProcTestMaskY)

	--LvLK3D.ProcTexWorleyMultiply(tempProcTestMask, 2, 2)
	--LvLK3D.ProcTexInvert(tempProcTestMask)


	local tempProcTestDistortX = LvLK3D.ProcTexNewTemp(512, 512)
	LvLK3D.ProcTexApplyColour(tempProcTestDistortX, 1, 1, 1)
	LvLK3D.ProcTexWorleyMultiply(tempProcTestDistortX, 2.54, 1.35)
	LvLK3D.ProcTexInvert(tempProcTestDistortX)
	LvLK3D.ProcTexApplyColourMul(tempProcTestDistortX, 1, 0, 0)


	local tempProcTestDistortY = LvLK3D.ProcTexNewTemp(512, 512)
	LvLK3D.ProcTexApplyColour(tempProcTestDistortY, 0, 1, 0)
	LvLK3D.ProcTexWorleyMultiply(tempProcTestDistortY, 2.235, 3.246)
	LvLK3D.ProcTexInvert(tempProcTestDistortY)
	LvLK3D.ProcTexApplyColourMul(tempProcTestDistortY, 0, 1, 0)


	local tempProcTestDistort = LvLK3D.ProcTexNewTemp(512, 512)
	LvLK3D.ProcTexApplyColour(tempProcTestDistort, 0, 0, 0)
	LvLK3D.ProcTexMergeAdd(tempProcTestDistort, tempProcTestDistortX)
	LvLK3D.ProcTexMergeAdd(tempProcTestDistort, tempProcTestDistortY)

	local tempProcTest = LvLK3D.ProcTexNewTemp(512, 512)
	--LvLK3D.ProcTexApplyColour(tempProcTest, 1, 1, 1)
	--LvLK3D.ProcTexApplyImage(tempProcTest, LvLK3D.GetTexture("happyPNGTest"))
	--LvLK3D.ProcTexDistort(tempProcTest, tempProcTestMaskX, 0.1)
	--LvLK3D.ProcTexMask(tempProcTest, tempProcTestMask, LvLK3D.GetTexture("happyPNGTest"))


	LvLK3D.ProcTexApplyImage(tempProcTest, LvLK3D.GetTexture("happyPNGTest"))
	LvLK3D.ProcTexDistort(tempProcTest, tempProcTestDistort, 0.05)
	LvLK3D.ProcTexDeclareTexture("procTest", tempProcTest)


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
	local stonesDist = 0.6

	local procPebbles = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(procPebbles, 1, 1, 1)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 4, 4)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 6, 6)
	LvLK3D.ProcTexSimplexMultiply(procPebbles, 8, 8)
	LvLK3D.ProcTexApplyColourAdd(procPebbles, 0.25, 0.25, 0.25)


	local maskDistort = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(maskDistort, 1, 1, 1)
	LvLK3D.ProcTexWorleyMultiplyNormal(maskDistort, stonesSize, stonesSize, stonesDist)
	LvLK3D.ProcTexBlur(maskDistort, 8)
	--LvLK3D.ProcTexInvert(maskDistort)

	local maskStoneBorders = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(maskStoneBorders, 1, 1, 1)
	LvLK3D.ProcTexWorleyMultiply(maskStoneBorders, stonesSize, stonesSize, stonesDist)
	--LvLK3D.ProcTexInvert(procPebbles)
	LvLK3D.ProcTexTreshold(maskStoneBorders, 0.6, 0.25)
	LvLK3D.ProcTexApplyColourAdd(maskStoneBorders, 0.25, 0.25, 0.25)


	local tempShine = LvLK3D.ProcTexNewTemp(256, 256)
	LvLK3D.ProcTexApplyColour(tempShine, 1, 1, 1)
	LvLK3D.ProcTexLightDot(tempShine, maskDistort, Vector(-0.75, -0.25, 1.75):GetNormalized())


	LvLK3D.ProcTexDistort(procPebbles, maskDistort, -0.1)
	LvLK3D.ProcTexMultiply(procPebbles, tempShine)

	LvLK3D.ProcTexDeclareTexture("procPebbles", procPebbles)




	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.SetSunLighting(false) -- dont do sun lighting
		LvLK3D.SetSunCol({1, 1, 1}) -- set col to weird yellow
		--LvLK3D.SetAmbientCol({1 / 10, 1 / 10, 1 / 10}) -- ambient to darker weird yellow




		LvLK3D.AddLightToUniv("LightOne", Vector(0, 3, 0), 2, {0.25, 0.25, 1})
		LvLK3D.AddLightToUniv("LightTwo", Vector(4, 3, 0), 2, {0.25, 1, 0.25})
		LvLK3D.AddLightToUniv("LightThree", Vector(4, 3, 0), 2, {1, 0.25, 0.25})



		LvLK3D.AddObjectToUniv("cube1", "cube")
		LvLK3D.SetObjectPos("cube1", Vector(0, 0, 0))
		LvLK3D.SetObjectMat("cube1", "happyPNGTest")

		LvLK3D.SetObjectFlag("cube1", "SHADING", true)
		LvLK3D.SetObjectFlag("cube1", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube1", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube1", "FULLBRIGHT", false)
		LvLK3D.SetObjectScl("cube1", Vector(.5, .5, .5))
		LvLK3D.UpdateObjectMesh("cube1")
		LvLK3D.SetObjectShadow("cube1", true)

		LvLK3D.AddObjectToUniv("plane_floor", "plane")
		LvLK3D.SetObjectPos("plane_floor", Vector(0, -4, 0))
		LvLK3D.SetObjectScl("plane_floor", Vector(16, 1, 16))
		LvLK3D.SetObjectMat("plane_floor", "mandrill")
		LvLK3D.SetObjectFlag("plane_floor", "SHADING", true)
		LvLK3D.UpdateObjectMesh("plane_floor")



		LvLK3D.AddObjectToUniv("cube_floor", "cube")
		LvLK3D.SetObjectPos("cube_floor", Vector(0, -2, -2.75))
		LvLK3D.SetObjectMat("cube_floor", "procMarble")
		LvLK3D.SetObjectFlag("cube_floor", "SHADING", false)
		LvLK3D.SetObjectFlag("cube_floor", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube_floor", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube_floor", "FULLBRIGHT", true)
		LvLK3D.UpdateObjectMesh("cube_floor")
		LvLK3D.SetObjectShadow("cube_floor", true)

		LvLK3D.AddObjectToUniv("cube_floor2", "cube")
		LvLK3D.SetObjectPos("cube_floor2", Vector(-2, -2, -2.75))
		LvLK3D.SetObjectMat("cube_floor2", "procPebbles")
		LvLK3D.SetObjectFlag("cube_floor2", "SHADING", false)
		LvLK3D.SetObjectFlag("cube_floor2", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube_floor2", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube_floor2", "FULLBRIGHT", true)
		LvLK3D.UpdateObjectMesh("cube_floor2")
		LvLK3D.SetObjectShadow("cube_floor2", true)



		LvLK3D.AddObjectToUniv("train", "train")
		LvLK3D.SetObjectPos("train", Vector(4, -2.05, -3))
		LvLK3D.SetObjectMat("train", "white")
		LvLK3D.SetObjectFlag("train", "SHADING", true)
		LvLK3D.SetObjectFlag("train", "SHADING_SMOOTH", false)
		LvLK3D.UpdateObjectMesh("train")
		LvLK3D.SetObjectShadow("train", true)



		--LvLK3D.AddObjectToUniv("rail", "traintrack")
		--LvLK3D.SetObjectPos("rail", Vector(8, -2, -3))
		--LvLK3D.SetObjectMat("rail", "traintrack_sheet")


		for k, v in pairs(LvLK3D.CurrUniv["lights"]) do
			local idx = "lightID " .. v.tag
			LvLK3D.AddObjectToUniv(idx, "cube")
			LvLK3D.SetObjectPos(idx, v.pos)
			LvLK3D.SetObjectMat(idx, "white")

			LvLK3D.SetObjectFlag(idx, "SHADING", false)
			LvLK3D.SetObjectFlag(idx, "FULLBRIGHT", true)
			LvLK3D.SetObjectScl(idx, Vector(.1, .1, .1))
			LvLK3D.SetObjectCol(idx, v.col)
		end
	LvLK3D.PopUniverse()

end


local function updateLightAndExShadow(id, pos)
	LvLK3D.SetLightPos(id, pos)
	LvLK3D.SetObjectPos("lightID " .. id, pos)
end

function love.update(dt)
	CurTime = CurTime + dt
	--LvLK3D.NoclipCam(dt)

	LvLK3D.MouseCamThink(dt)

	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.SetObjectAng("cube1", Angle(CurTime * 24, CurTime * 32, 0))
		LvLK3D.SetObjectPos("cube1", Vector(math.sin(CurTime * .75) * 2.65, 0, math.cos(CurTime * .4532) * 2.5))





		updateLightAndExShadow("LightOne", Vector(math.cos(CurTime * .65) * 5.6546, 3, math.sin(CurTime * .7645767) * 6.523))
		updateLightAndExShadow("LightTwo", Vector(math.cos(CurTime * 1.85) * 8.6546, math.sin(CurTime * 1.24) + 3, math.sin(CurTime * 1.2645767) * 10.523))
		updateLightAndExShadow("LightThree", Vector(math.cos(CurTime * 0.125) * 12.6546, (math.sin(CurTime * 0.62) * 2) + 3, math.sin(CurTime * 0.25645767) * 10.523))
	LvLK3D.PopUniverse()
end

function love.keypressed(key)
	LvLK3D.ToggleMouseLock(key)
end

function love.mousemoved(mx, my, dx, dy)
	LvLK3D.MouseCamUpdate(dx, dy)
end

function love.draw()
	love.graphics.clear()

	LvLK3D.PushUniverse(UnivTest)
	LvLK3D.PushRenderTarget(RTTest)
		LvLK3D.Clear(.1, .2, .3)
		--LvLK3D.ClearDepth()

		LvLK3D.RenderActiveUniverse()

	LvLK3D.PopRenderTarget()
	LvLK3D.PopUniverse()


	LvLK3D.RenderRTFullScreen(RTTest)


end