LvLK3D = LvLK3D or {}

function LvLK3D.AddLightToUniv(name, pos, intensity, col)
	LvLK3D.CurrUniv["lights"][name] = {
		pos = pos or Vector(0, 0, 0),
		intensity = 1 / intensity or 1,
		col = col or {1, 1, 1},
		tag = name,
	}

	LvLK3D.CurrUniv["lightCount"] = LvLK3D.CurrUniv["lightCount"] + 1
end

function LvLK3D.SetLightPos(name, pos)
	LvLK3D.CurrUniv["lights"][name].pos = pos or Vector(0, 0, 0)
end