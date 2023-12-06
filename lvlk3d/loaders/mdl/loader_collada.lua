LvLK3D = LvLK3D or {}
LvLK3D.RelaPath = "lvlk3d"

local function requireRelative(path)
	return require(LvLK3D.RelaPath .. "." .. path)
end


local xml2lua = requireRelative("libs.external.xml2lua")
local xml2lua_tree = requireRelative("libs.external.tree")

local _tblPrintAdd = 2
local function printTable(tbl, elevStr)
	elev = elev or 0
	local spacing = elevStr or ""

	for k, v in pairs(tbl) do
		if type(v) == "table" then
			print(spacing .. "[" .. k .. "]: " .. "[" .. tostring(tbl) .. "]")

			local newElevStr = spacing .. "|" .. string.rep(" ", _tblPrintAdd)
			printTable(v, newElevStr)
		else
			print(spacing .. "[" .. k .. "]: " .. tostring(v))
		end
	end
end



local dae_loaders = {
	["library_geometries"] = function(data)
		local realData = data.geometry.mesh.source


		local posArray = {}
		local normArray = {}
		local uvArray = {}
		for k, v in ipairs(realData) do
			--print(k .. ": ")
			--printTable(v)

			local arr = v.float_array

			--error("done.")
		end

		--error("done.")
	end
}


function LvLK3D.DeclareModelCollada(name, data)
	print("[" .. name .. "]: COLLADA")

	local handler = xml2lua_tree:new()
	xml2lua.parser(handler):parse(data)

	local root = handler.root.COLLADA


	--local assetNfo = root.asset
	--printTable(assetNfo)

	local libs_to_load = {}
	libs_to_load[#libs_to_load + 1] = "library_geometries" -- TODO: push this to 2nd maybe?
	libs_to_load[#libs_to_load + 1] = "library_controllers"
	libs_to_load[#libs_to_load + 1] = "library_animations"


	for k, v in ipairs(libs_to_load) do -- forces order
		if dae_loaders[v] then
			dae_loaders[v](root[v])
		else
			print("Unimplemented COLLADA library \"" .. v .. "\"! Kill Lokachop...")
		end
	end
end



function LvLK3D.LoadModelFromCollada(name, path)
	local data = love.filesystem.read(path)
	if not data then
		error("Could not read model \"" .. path .. "\"")
		return
	end

	LvLK3D.DeclareModelCollada(name, data)
end