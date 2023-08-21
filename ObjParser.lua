--[=[
	ObjParser by JoshieGemFinder
	Converts a .obj file (in string form) to a DynamicMesh
	
	https://github.com/JoshieGemFinder/RBLX-Obj2DynamicMesh
]=]

local module = {}

--[[
	Returns the converted DynamicMesh
	obj: String contents of the .obj file
]]
function module.GenerateMeshModel(obj: string): (DynamicMesh)

	assert(obj and type(obj) == 'string', "bad argument #1 to GenerateMesh (string expected, got " .. type(obj) .. ")")

	--create mesh
	local mesh = Instance.new("DynamicMesh")
	mesh.Parent = script

	local vertexCount = 0 -- for negative indices

	local vertices = {} -- list of vertex positions
	local vertexIDs = {} -- list of untextured unnormaled roblox vertices, for if those will be needed

	-- list of UVs
	local UVs = {}

	-- list of normals
	local normals = {}

	local lines = string.gmatch(obj, "%s*([^\r\n]+)%s*") --split lines and trim whitespace
	local line = nil
	repeat
		line = lines()
		if line == nil or #line == 0 then continue end
		while line:sub(-1) == "\\"  do
			line = line:sub(1, -2) .. lines()
		end

		local nextToken = line:gmatch("%S+")

		local tkn = nextToken()

		if tkn:sub(1,1) == "#" then
			continue
		end

		if tkn == "v" then
			vertexCount = vertexCount + 1
			vertices[vertexCount] = Vector3.new(tonumber(nextToken()), tonumber(nextToken()), tonumber(nextToken()))
		elseif tkn == "vt" then
			table.insert(UVs, Vector2.new(tonumber(nextToken()), tonumber(nextToken())))
		elseif tkn == "vn" then
			table.insert(normals, Vector3.new(tonumber(nextToken()), tonumber(nextToken()), tonumber(nextToken())))

		elseif tkn == "f" then
			local faceVertices = {}

			tkn = nextToken()
			while tkn ~= nil do
				local vertex, uv, normal = string.match(tkn, "([^/]+)[/]?([^/]*)[/]?([^/]*)")

				vertex = tonumber(vertex)

				local vertexID = vertex
				if vertex < 0 then
					vertexID = vertexCount + vertex + 1
				end

				local rblxVertex = nil
				if uv == nil and normal == nil then
					rblxVertex = vertexIDs[vertexID]
					if rblxVertex == nil then
						rblxVertex = mesh:AddVertex(vertices[vertexID])
						mesh:SetVertexColor(rblxVertex, Color3.new(1,1,1))
						vertexIDs[vertexID] = rblxVertex
					end
				else
					rblxVertex = mesh:AddVertex(vertices[vertexID])
					mesh:SetVertexColor(rblxVertex, Color3.new(1,1,1))
					if uv ~= nil and #uv > 0 then
						mesh:SetUV(rblxVertex, UVs[tonumber(uv)])
					end

					if normal ~= nil and #normal > 0 then
						mesh:SetVertexNormal(rblxVertex, normals[tonumber(normal)])
					end
				end

				table.insert(faceVertices, rblxVertex)
				tkn = nextToken()
			end

			local n = #faceVertices

			--specification says triangle fan, so we're using triangle fan
			for i=1, n-2 do
				mesh:AddTriangle(faceVertices[1], faceVertices[i + 1], faceVertices[i + 2])
			end


		else --mtllib, usemtl, g, s, l, p
			warn(tkn .. " is not currently supported.")
		end
	until line == nil
	
	return mesh
end

--[[
	Returns the MeshPart and the DynamicMesh
	obj: String contents of the .obj file
]]
function module.GenerateMesh(obj: string): (MeshPart, DynamicMesh)
	local mesh = module.GenerateMeshModel(obj)
	
	local meshPart = mesh:CreateMeshPartAsync(Enum.CollisionFidelity.Default)
	mesh.Parent = meshPart
	
	return meshPart, mesh
end

return module
