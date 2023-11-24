LvLK3D = LvLK3D or {}
local ffi = require("ffi")
-- trace module for LvLK3D
-- hopefully uses FFI to make it fast
local tracelib = ffi.load("lvlk3d/ffi/tracelib.so")
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
	
	typedef struct UV {
		float u;
		float v;
	} UV;
	
	typedef struct Face {
		Vector normal;
		unsigned long long v1i;
		unsigned long long v2i;
		unsigned long long v3i;
	
		unsigned long long v1ui;
		unsigned long long v2ui;
		unsigned long long v3ui;
	} Face;
	
	// later later
	typedef struct Model {
		unsigned long long vertCount;
		unsigned long long faceCount;
	
		Vector vertList[2097152];
		Face faceList[1048576];
	
	} Model;
	
	
	typedef struct LvLK3DModelData {
		Vector verts[2097152];
		Vector normals[2097152];
		UV uvs[2097152];
		Face faceInd[1048576];
	} LvLK3DModelData;

	TraceResult rayIntersectsTriangle(Vector rayPos, Vector rayDir, Vector v1, Vector v2, Vector v3, bool backface_cull);
]])

local _trace_bf_cull = true
local function traceTriangleC(ro, rd, v1, v2, v3)
	local traceResult = tracelib.rayIntersectsTriangle(ro, rd, v1, v2, v3, _trace_bf_cull)

	return traceResult.hit, traceResult.pos, traceResult.dist;
end


local function traceObj(obj, ro, rd, minDist)
	--[[
	local obj = LvLK3D.CurrUniv["objects"][objName]
	if not obj then
		return
	end
	]]--

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
	local norm_out = rd
	local dist_out_least = minDist or math.huge


	--local _posPers = ffi.new("Vector")
	for i = 1, #mdlIndices do
		local indCont = mdlIndices[i]
		local normFlat = mdlNormals[i]:Copy()


		local v1 = mdlVerts[indCont[1][1]]:Copy()
		local v2 = mdlVerts[indCont[2][1]]:Copy()
		local v3 = mdlVerts[indCont[3][1]]:Copy()

		v1 = v1 * objMatrix
		v2 = v2 * objMatrix
		v3 = v3 * objMatrix


		normFlat:Rotate(obj.ang)

		if (obj["NORM_INVERT"] == true) then
			normFlat = -normFlat
		end


		-- convert the vertices to the cpp format
		if (obj["NORM_INVERT"] == true) then
			obj_v1.x = v3[1]
			obj_v1.y = v3[2]
			obj_v1.z = v3[3]

			obj_v2.x = v2[1]
			obj_v2.y = v2[2]
			obj_v2.z = v2[3]

			obj_v3.x = v1[1]
			obj_v3.y = v1[2]
			obj_v3.z = v1[3]
		else
			obj_v1.x = v1[1]
			obj_v1.y = v1[2]
			obj_v1.z = v1[3]

			obj_v2.x = v2[1]
			obj_v2.y = v2[2]
			obj_v2.z = v2[3]

			obj_v3.x = v3[1]
			obj_v3.y = v3[2]
			obj_v3.z = v3[3]
		end

		local hit, pos, dist = traceTriangleC(vecRO, vecRD, obj_v1, obj_v2, obj_v3)
		if hit and (dist < dist_out_least) then
			--print(hit, pos.x, pos.y, pos.z, dist)
			hit_out = true
			--_posPers = pos
			pos_out = Vector(pos.x, pos.y, pos.z)

			norm_out = normFlat
			dist_out_least = dist
		end
	end
	--print(_posPers.x, _posPers.y, _posPers.z)
	--pos_out = Vector(_posPers.x, _posPers.y, _posPers.z)

	return hit_out, pos_out, dist_out_least, norm_out
end

function LvLK3D.TraceRay(ro, rd, maxDist)
	local min_dist = maxDist or math.huge
	local ret_hit = false
	local ret_pos = (ro + (rd * maxDist))
	local ret_norm = rd
	local ret_obj = nil

	for k, v in pairs(LvLK3D.CurrUniv["objects"]) do
		if v["NO_TRACE"] then
			goto _contTraceScene
		end

		local hit, pos, dist, norm = traceObj(v, ro, rd, maxDist)
		if hit and dist < min_dist then
			ret_hit = true
			ret_pos = pos
			ret_dist = dist
			ret_norm = norm

			min_dist = dist
			ret_obj = v
		end


		::_contTraceScene::
	end

	return ret_hit, ret_pos, ret_norm, min_dist, ret_obj
end

