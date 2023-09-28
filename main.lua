LvLK3D = LvLK3D or {}
function love.load()
	love.filesystem.load("/lvlk3d/lvlk3d.lua")()
	CurTime = 0


	local w, h = love.graphics.getDimensions()
	UnivTest = LvLK3D.NewUniverse("Test_LVLK3D")
	RTTest = LvLK3D.NewRenderTarget("TestRT_LVLK3D", w, h)
	LvLK3D.BuildProjectionMatrix(w / h, 0.01, 1000)



	LvLK3D.PushUniverse(UnivTest)
		LvLK3D.AddObjectToUniv("cube1", "lokachop_sqr")
		LvLK3D.SetObjectPos("cube1", Vector(0, 0, -4))
		LvLK3D.SetObjectFlag("cube1", "SHADING_SMOOTH", true)

		LvLK3D.SetTextureFilter("loka_sheet", "nearest", "nearest")
		LvLK3D.SetObjectMat("cube1", "loka_sheet")

		LvLK3D.UpdateObjectMesh("cube1")



		LvLK3D.SetTextureFilter("train_sheet", "nearest", "nearest")
		LvLK3D.AddObjectToUniv("train", "train")
		LvLK3D.SetObjectPos("train", Vector(4, 0, -4))
		LvLK3D.SetObjectMat("train", "train_sheet")


		LvLK3D.SetTextureFilter("traintrack_sheet", "nearest", "nearest")
		LvLK3D.SetTextureWrap("traintrack_sheet", "repeat")

		LvLK3D.AddObjectToUniv("rail", "traintrack")
		LvLK3D.SetObjectPos("rail", Vector(4, -2, -4))
		LvLK3D.SetObjectMat("rail", "traintrack_sheet")
	LvLK3D.PopUniverse()

end

function love.update(dt)
	CurTime = CurTime + dt
	LvLK3D.NoclipCam(dt)

	LvLK3D.PushUniverse(UnivTest)
	LvLK3D.SetObjectAng("cube1", Angle(CurTime * 32, CurTime * 48, 0))
	LvLK3D.PopUniverse()
end

function love.keypressed(key)
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