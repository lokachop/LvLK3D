LvLK3D = LvLK3D or {}

love.audio.setDistanceModel("exponent")

LvLK3D.ValidSources = {}
LvLK3D.ActiveSources = {}

function LvLK3D.AddValidSource(path, method)
	LvLK3D.ValidSources[path] = love.audio.newSource(path, method or "static")
end

function LvLK3D.AddNewSoundEffect(name, params)
	love.audio.setEffect(name, params)
end


function LvLK3D.PlaySound3D(path, pos, pitch, volume, effect)
	if not LvLK3D.ValidSources[path] then
		LvLK3D.AddValidSource(path, "static")
	end

	--[[
	local ind = #LvLK3D.ActiveSources + 1
	LvLK3D.ActiveSources[ind] = {
		source = LvLK3D.ValidSources[path]:clone(),
		pos = pos,
	}

	local tbl = LvLK3D.ActiveSources[ind]

	local source = tbl.source
	source:setPosition(pos[1], pos[2], pos[3])
	]]--

	pos = pos or Vector(0, 0, 0)

	local source = LvLK3D.ValidSources[path]:clone()
	source:setPosition(pos[1], pos[2], pos[3])
	source:setPitch(pitch)
	source:setAirAbsorption(10)
	source:setAttenuationDistances(volume, 0)

	if effect then
		source:setEffect(effect, true)
	end


	return source
end


function LvLK3D.SetSourceEffect(source, effect, enable)
	source:setEffect(effect, enable)
end

function LvLK3D.SetSourcePosition(source, pos)
	source:setPosition(pos[1], pos[2], pos[3])
end

function LvLK3D.SetSourceFilter(source, filter)
	source:setFilter(filter)
end

LvLK3D.AddNewSoundEffect("reverbRaytraced", {
	["type"] = "reverb",
	["gain"] = 0.32,
	["highgain"] = 0.89,
	["density"] = 0.4,
	["diffusion"] = 0.03,
	["decaytime"] = decTime,
	["decayhighratio"] = 0.83,
	["earlygain"] = 0.05,
	["earlydelay"] = 0.05,
	["lategain"] = 1.26,
	["latedelay"] = 0.011,
	["roomrolloff"] = 0,
	["airabsorption"] = 0.994,
	["highlimit"] = true
})




local function randomFloat(min, max)
	return min + math.random()  * (max - min);
end


local function randomDir()
	local phi = randomFloat(0, math.pi * 2)
	local costheta = randomFloat(-1, 1)

	local theta = math.acos(costheta)
	local x = math.sin(theta) * math.cos(phi)
	local y = math.sin(theta) * math.sin(phi)
	local z = math.cos(theta)
	return Vector(x, y, z)
end


local function reflect(I, N)
	return I - 2 * N:Dot(I) * N
end


local RT_REVERB_RAYS = 16
local RT_REVERB_RAY_ENERGY = 6
local RT_REVERB_MAX_BOUNCES = 6
local RT_REVERB_ENERGY_EXTRACT = 0.2
function LvLK3D.RayTracedReverbThink(pos)
	local accumLen = 0
	local accumBounces = 0
	local accumEnergyExtract = 0


	local rayCount = 0


	for i = 1, RT_REVERB_RAYS do
		local rpos = pos or LvLK3D.CamPos

		local dir = randomDir()
		local energy = RT_REVERB_RAY_ENERGY

		for j = 1, RT_REVERB_MAX_BOUNCES do
			local hit, hpos, norm, dist, obj = LvLK3D.TraceRay(rpos, dir, RT_REVERB_RAY_ENERGY)

			accumLen = accumLen + dist

			if hit then
				accumEnergyExtract = accumEnergyExtract + RT_REVERB_ENERGY_EXTRACT
				energy = energy - dist
				--suck energy
				--energy = energy * (1 - RT_REVERB_ENERGY_EXTRACT)
			elseif not hit then
				LvLK3D.SetObjectPos("cube_tr", rpos)
				LvLK3D.SetObjectPos("cube_tr_dir", hpos)

				energy = 0
			end

			--print("bounce n*", j)
			--print("eng,", energy)
			--print("dist,", dist)

			if energy <= 0 then
				goto _contRTAudio
			else
				dir = -reflect(dir, norm)
				rpos = hpos + (norm * 0.1)

				accumBounces = accumBounces + 1
			end
		end

		::_contRTAudio::
	end

	accumBounces = accumBounces / RT_REVERB_RAYS
	accumLen = accumLen / RT_REVERB_RAYS
	accumEnergyExtract = accumEnergyExtract / RT_REVERB_RAYS

	--print("b", accumBounces)
	--print("l", accumLen)
	--print("ee", accumEnergyExtract)


	local absorb = math.abs(1 - (accumBounces / RT_REVERB_MAX_BOUNCES))
	local decaySize = (accumLen / RT_REVERB_RAY_ENERGY) * 1.5

	local density =  math.abs(1 - (accumBounces / RT_REVERB_MAX_BOUNCES))

	LvLK3D.AddNewSoundEffect("reverbRaytraced", {
		["type"] = "reverb",
		["gain"] = absorb,
		["highgain"] = 1 - absorb,
		["density"] = density,
		["diffusion"] = density,
		["decaytime"] = decaySize,
		["decayhighratio"] = 0.83,
		["earlygain"] = 0.05,
		["earlydelay"] = 0.05,
		["lategain"] = 1.26,
		["latedelay"] = 0.011,
		["roomrolloff"] = 0,
		["airabsorption"] = 0.994,
		["highlimit"] = true
	})
end


--local nextReverb = 0
local _lastPos = nil
function LvLK3D.SoundThink()
	--[[
	if CurTime > nextReverb then
		LvLK3D.RayTracedReverbThink()
		nextReverb = CurTime + 0.01
	end
	]]--


	if not _lastPos then
		_lastPos = LvLK3D.CamPos:Copy()
	end

	local fow = LvLK3D.CamMatrix_Rot:Forward()
	--print(fow)
	local up = LvLK3D.CamMatrix_Rot:Up()
	--print(up)

	local pos = LvLK3D.CamPos

	_lastPos:Sub(pos)

	local _mul = 256

	love.audio.setOrientation(fow[1], fow[2], fow[3], up[1], up[2], up[3])
	love.audio.setPosition(pos[1], pos[2], pos[3])

	love.audio.setVelocity(-_lastPos[1], -_lastPos[2], -_lastPos[3])

	_lastPos = LvLK3D.CamPos:Copy()
end