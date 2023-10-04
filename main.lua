LvLK3D = LvLK3D or {}
function love.load()
	love.filesystem.load("/lvlk3d/lvlk3d.lua")()
	CurTime = 0


	local sw, sh = love.graphics.getDimensions()
	UnivTest = LvLK3D.NewUniverse("Test_LVLK3D")
	RTTest = LvLK3D.NewRenderTarget("TestRT_LVLK3D", sw, sh)
	LvLK3D.BuildProjectionMatrix(sw / sh, 0.01, 1000)



	LvLK3D.NewTextureEmpty("white", 16, 16, {255, 255, 255})
	LvLK3D.NewTextureEmpty("indigo", 2, 2, {51, 0, 153})


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



	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.AddLightToUniv("LightOne", Vector(0, 3, 0), 4, {0.25, 0.25, 1})

		LvLK3D.AddLightToUniv("LightTwo", Vector(4, 3, 0), 4, {0.25, 1, 0.25})



		LvLK3D.AddObjectToUniv("cube1", "cube")
		LvLK3D.SetObjectPos("cube1", Vector(0, 0, 0))
		LvLK3D.SetObjectMat("cube1", "none")

		LvLK3D.SetObjectFlag("cube1", "SHADING", true)
		LvLK3D.SetObjectFlag("cube1", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("cube1", "NORM_INVERT", false)
		--LvLK3D.SetObjectScl("cube1", Vector(.5, .5, .5))
		LvLK3D.SetObjectShadow("cube1", true)

		LvLK3D.AddObjectToUniv("plane_floor", "plane")
		LvLK3D.SetObjectPos("plane_floor", Vector(0, -4, 0))
		LvLK3D.SetObjectScl("plane_floor", Vector(16, 1, 16))
		LvLK3D.SetObjectMat("plane_floor", "mandrill")

		LvLK3D.SetObjectFlag("plane_floor", "SHADING", true)
		LvLK3D.UpdateObjectMesh("plane_floor")



		LvLK3D.AddObjectToUniv("lokamodel", "cube")
		LvLK3D.SetObjectPos("lokamodel", Vector(0, -4, -2.75))
		LvLK3D.SetObjectMat("lokamodel", "none")


		LvLK3D.SetObjectFlag("lokamodel", "SHADING", true)
		LvLK3D.SetObjectFlag("lokamodel", "SHADING_SMOOTH", false)
		LvLK3D.SetObjectFlag("lokamodel", "NORM_INVERT", false)
		LvLK3D.UpdateObjectMesh("lokamodel")
		--LvLK3D.SetObjectScl("lokamodel", Vector(.5, .5, .5))

		LvLK3D.SetObjectShadow("lokamodel", true)




		LvLK3D.SetTextureFilter("train_sheet", "nearest", "nearest")
		LvLK3D.AddObjectToUniv("train", "train")
		LvLK3D.SetObjectPos("train", Vector(4, -2, -3))
		LvLK3D.SetObjectMat("train", "train_sheet")
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
	LvLK3D.PopUniverse()


	--LvLK3D.SunDir = LvLK3D.CamMatrix_Rot:Forward()
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