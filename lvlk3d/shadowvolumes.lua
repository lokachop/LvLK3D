LvLK3D = LvLK3D or {}

local function initMeshShadowVolume(obj)
	local mdl = LvLK3D.Models[obj.mdl]

	-- get the verts flat
	local finalMesh = {}
	local mdlVerts = mdl.verts
	local mdlUVs = mdl.uvs
	local mdlIndices = mdl.indices
	local mdlNormals = mdl.normals
	local mdlSmoothNormals = mdl.s_normals


	local isSmooth = obj["SHADING_SMOOTH"] == true
	for i = 1, #mdlIndices do
		local indCont = mdlIndices[i]

		local normFlat = mdlNormals[i]



		local v1 = mdlVerts[indCont[1][1]]
		local uv1 = mdlUVs[indCont[1][2]]
		local norm1 = isSmooth and mdlSmoothNormals[indCont[1][1]] or normFlat

		local v2 = mdlVerts[indCont[2][1]]
		local uv2 = mdlUVs[indCont[2][2]]
		local norm2 = isSmooth and mdlSmoothNormals[indCont[2][1]] or normFlat

		local v3 = mdlVerts[indCont[3][1]]
		local uv3 = mdlUVs[indCont[3][2]]
		local norm3 = isSmooth and mdlSmoothNormals[indCont[3][1]] or normFlat


		finalMesh[#finalMesh + 1] = {v1[1], v1[2], v1[3], uv1[1], uv1[2], norm1[1], norm1[2], norm1[3]}
		finalMesh[#finalMesh + 1] = {v2[1], v2[2], v2[3], uv2[1], uv2[2], norm2[1], norm2[2], norm2[3]}
		finalMesh[#finalMesh + 1] = {v3[1], v3[2], v3[3], uv3[1], uv3[2], norm3[1], norm3[2], norm3[3]}
	end


	obj.mesh = love.graphics.newMesh(vertFormat, finalMesh, "triangles")
	obj.mesh:setTexture(LvLK3D.Textures[obj.mat])
end

