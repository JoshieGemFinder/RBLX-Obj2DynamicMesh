# RBLX-Obj2DynamicMesh
Converts a .obj file to a Roblox `DynamicMesh`

# FFlags
As of writing, DynamicMesh is not out yet. You'll need to [enable](https://github.com/MaximumADHD/Roblox-Studio-Mod-Manager) the [Fast Flags](https://devforum.roblox.com/t/roblox-fflag-watcher/254517) `FFlagSimEnableDynamicMesh` and `FFlagSimEnableDynamicMeshPhase2` to turn them on.

# Usage

### `ObjParser.GenerateMesh(obj: string): (MeshPart, DynamicMesh)`
* `obj`: `string`. The contents of the .obj file, in a string format.

Returns:
* `MeshPart`: A `MeshPart` representing the provided .obj file.
* `DynamicMesh`: The mesh behind the returned `MeshPart`. See [`GenerateMeshModel()`](#GenerateMeshModel)

### `ObjParser.GenerateMeshModel(obj: string): (DynamicMesh)`
<span id="GenerateMeshModel"></span>
* `obj`: `string`. The contents of the .obj file, in a string format.

Returns:
* `DynamicMesh`: A `DynamicMesh` representing the provided .obj file.

## Examples

![airboat](https://github.com/JoshieGemFinder/RBLX-Obj2DynamicMesh/assets/79513611/d2721bc7-28b8-4084-8bda-4d748aca7001)

![gourd](https://github.com/JoshieGemFinder/RBLX-Obj2DynamicMesh/assets/79513611/3f12ec36-7667-415c-b261-50b85a46c8ab)
