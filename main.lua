LvLK3D = LvLK3D or {}
function love.load()
	love.filesystem.load("/lvlk3d/lvlk3d.lua")()
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



	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.SetSunLighting(false) -- dont do sun lighting
		LvLK3D.SetSunCol({1, 1, 1}) -- set col to weird yellow
		LvLK3D.SetSunDir(Vector(0.25, -1, -0.5):GetNormalized())
		--LvLK3D.SetAmbientCol({1 / 10, 1 / 10, 1 / 10}) -- ambient to darker weird yellow




		LvLK3D.AddLightToUniv("LightOne", Vector(0, 3, 2), 4, {0.25, 0.25, 1})
		LvLK3D.AddLightToUniv("LightTwo", Vector(2, 3, -2), 4, {0.25, 1, 0.25})
		LvLK3D.AddLightToUniv("LightThree", Vector(-2, 3, -2), 4, {1, 0.25, 0.25})



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


		LvLK3D.AddObjectToUniv("cube_center", "cube")
		LvLK3D.SetObjectPos("cube_center", Vector(-2, 0, 0))
		LvLK3D.SetObjectMat("cube_center", "happyPNGTest")
		LvLK3D.SetObjectFlag("cube_center", "SHADING", true)
		LvLK3D.UpdateObjectMesh("cube_center")
		LvLK3D.SetObjectShadow("cube_center", true)

		LvLK3D.AddObjectToUniv("cube_tr", "cube")
		LvLK3D.SetObjectPos("cube_tr", Vector(0, 0, 0))
		LvLK3D.SetObjectMat("cube_tr", "happyPNGTest")
		LvLK3D.SetObjectFlag("cube_tr", "SHADING", true)
		LvLK3D.SetObjectScl("cube_tr", Vector(.1, .1, .1))
		LvLK3D.UpdateObjectMesh("cube_tr")
		LvLK3D.SetObjectShadow("cube_tr", true)



		LvLK3D.AddObjectToUniv("plane_floor", "plane")
		LvLK3D.SetObjectPos("plane_floor", Vector(0, -4, 0))
		LvLK3D.SetObjectScl("plane_floor", Vector(16, 1, 16))
		LvLK3D.SetObjectMat("plane_floor", "mandrill")
		LvLK3D.SetObjectFlag("plane_floor", "SHADING", true)
		LvLK3D.UpdateObjectMesh("plane_floor")

		LvLK3D.AddObjectToUniv("lktest", "lokachop_sqr")
		LvLK3D.SetObjectPos("lktest", Vector(0, -2, 0))
		LvLK3D.SetObjectScl("lktest", Vector(1, 1, 1))
		LvLK3D.SetObjectMat("lktest", "loka_sheet")
		LvLK3D.SetObjectFlag("lktest", "SHADING", true)
		LvLK3D.SetObjectFlag("lktest", "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh("lktest")
		--LvLK3D.SetObjectShadow("lktest", true)

		LvLK3D.AddObjectToUniv("cube_floor", "cube")
		LvLK3D.SetObjectPos("cube_floor", Vector(0, -2, -2.75))
		LvLK3D.SetObjectMat("cube_floor", "procMarble")
		LvLK3D.SetObjectFlag("cube_floor", "SHADING", false)
		LvLK3D.SetObjectFlag("cube_floor", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube_floor", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube_floor", "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh("cube_floor")
		LvLK3D.SetObjectShadow("cube_floor", true)

		LvLK3D.AddObjectToUniv("cube_floor2", "cube")
		LvLK3D.SetObjectPos("cube_floor2", Vector(-2, -2, -2.75))
		LvLK3D.SetObjectMat("cube_floor2", "procPebbles")
		LvLK3D.SetObjectFlag("cube_floor2", "SHADING", false)
		LvLK3D.SetObjectFlag("cube_floor2", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube_floor2", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube_floor2", "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh("cube_floor2")
		LvLK3D.SetObjectShadow("cube_floor2", true)

		LvLK3D.AddObjectToUniv("cube_floor3", "cube")
		LvLK3D.SetObjectPos("cube_floor3", Vector(-4, -2, -2.75))
		LvLK3D.SetObjectMat("cube_floor3", "bad_nouise")
		LvLK3D.SetObjectFlag("cube_floor3", "SHADING", false)
		LvLK3D.SetObjectFlag("cube_floor3", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube_floor3", "NORM_INVERT", false)
		LvLK3D.SetObjectFlag("cube_floor3", "FULLBRIGHT", false)
		LvLK3D.UpdateObjectMesh("cube_floor3")
		LvLK3D.SetObjectShadow("cube_floor3", true)

		LvLK3D.AddObjectToUniv("train", "train")
		LvLK3D.SetObjectPos("train", Vector(4, -2.05, -3))
		LvLK3D.SetObjectMat("train", "train_sheet")
		LvLK3D.SetObjectFlag("train", "SHADING", true)
		LvLK3D.SetObjectFlag("train", "SHADING_SMOOTH", true)
		LvLK3D.SetObjectFlag("train", "FULLBRIGHT", false)
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
		LvLK3D.TraceTest()


		LvLK3D.SetObjectAng("cube1", Angle(CurTime * 24, CurTime * 32, 0))
		LvLK3D.SetObjectPos("cube1", Vector(math.sin(CurTime * .75) * 2.65, 0, math.cos(CurTime * .4532) * 2.5))





		--updateLightAndExShadow("LightOne", Vector(math.cos(CurTime * .65) * 5.6546, 3, math.sin(CurTime * .7645767) * 6.523))
		--updateLightAndExShadow("LightTwo", Vector(math.cos(CurTime * 1.85) * 8.6546, math.sin(CurTime * 1.24) + 3, math.sin(CurTime * 1.2645767) * 10.523))
		--updateLightAndExShadow("LightThree", Vector(math.cos(CurTime * 0.125) * 12.6546, (math.sin(CurTime * 0.62) * 2) + 3, math.sin(CurTime * 0.25645767) * 10.523))
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