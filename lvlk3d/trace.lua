LvLK3D = LvLK3D or {}
local ffi = require("ffi")
-- trace module for LvLK3D
-- hopefully uses FFI to make it fast

local ltest = ffi.load("lvlk3d/ffi/tracelib.so")

ffi.cdef([[
	typedef struct Vector {
		float x;
		float y;
		float z;
	} Vector;
	
	typedef struct TraceResult {
		bool hit;
		float dist;
		Vector pos;
	} TraceResult;

	TraceResult rayIntersectsTriangle(Vector rayPos, Vector rayDir, Vector v1, Vector v2, Vector v3, bool backface_cull);
]])

local _trace_bf_cull = true
local function traceTriangleC(ro, rd, v1, v2, v3)
	local traceResult = ltest.rayIntersectsTriangle(ro, rd, v1, v2, v3, _trace_bf_cull)

	return traceResult.hit, traceResult.pos, traceResult.dist;
end



local function traceObj(objName, ro, rd)
	local obj = LvLK3D.CurrUniv["objects"][objName]
	if not obj then
		return
	end

	local vecRO = ffi.new("Vector")
	vecRO.x = ro[1]
	vecRO.y = ro[2]
	vecRO.z = ro[3]

	local vecRD = ffi.new("Vector")
	vecRD.x = rd[1]
	vecRD.y = rd[2]
	vecRD.z = rd[3]


	local objMatrix = obj.mat_mdl

	local mdl = LvLK3D.Models[obj.mdl]

	local mdlVerts = mdl.verts
	--local mdlUVs = mdl.uvs
	local mdlIndices = mdl.indices
	local mdlNormals = mdl.normals


	local obj_v1 = ffi.new("Vector")
	local obj_v2 = ffi.new("Vector")
	local obj_v3 = ffi.new("Vector")


	local hit_out = false
	local pos_out = Vector(0, 0, 0)
	local _least_dist = math.huge
	for i = 1, #mdlIndices do
		local indCont = mdlIndices[i]
		local normFlat = mdlNormals[i]


		local v1 = mdlVerts[indCont[1][1]]:Copy()
		local v2 = mdlVerts[indCont[2][1]]:Copy()
		local v3 = mdlVerts[indCont[3][1]]:Copy()

		v1 = v1 * objMatrix
		v2 = v2 * objMatrix
		v3 = v3 * objMatrix



		if (obj["NORM_INVERT"] == true) then
			normFlat = -normFlat
		end

		-- convert the vertices to the cpp format
		obj_v1.x = v1[1]
		obj_v1.y = v1[2]
		obj_v1.z = v1[3]

		obj_v2.x = v2[1]
		obj_v2.y = v2[2]
		obj_v2.z = v2[3]

		obj_v3.x = v3[1]
		obj_v3.y = v3[2]
		obj_v3.z = v3[3]

		local hit, pos, dist = traceTriangleC(vecRO, vecRD, obj_v3, obj_v2, obj_v1)
		if hit and (dist < _least_dist) then
			hit_out = true
			pos_out = Vector(pos.x, pos.y, pos.z)
			_least_dist = dist
		end
	end

	return hit_out, pos_out, _least_dist
end


function LvLK3D.TraceTest()
	local hit, pos, dist = traceObj("cube_center", LvLK3D.CamPos, LvLK3D.CamMatrix_Rot:Forward())

	if hit then
		print("hit;", pos)
		LvLK3D.SetObjectPos("cube_tr", pos)
	end
end

