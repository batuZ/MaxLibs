 fn openDWG =(
	resetMaxFile()
	filePath = getOpenFileName caption: "open DWG:" types: "DWG(*.dwg)|*.dwg|GeoTIFF(*.tif)|*.tif"
	importFile filePath
	)

fn getObjSet=(
	--points = $Point* as array
	max select all
	objSet=$
	arr=#()
	for obj in objSet do(
		append arr obj.pos.x
		append arr obj.pos.y
		append arr obj.pos.z
		)
	return arr
	)
	
fn sendToDoNet arr =(
	dotnet.loadassembly @"CreateMeshByPoints.dll"
	func = dotNetObject "CreateMeshByPoints.ToTIN"
	return func.CreateFromPoints(arr)
	)
	
fn createMesh res = (
	faces = #()
	faceid= #()
	for f=1 to res.count by 3 do(
		append faces [res[f],res[f+1],res[f+2]]
		) 
	for d = 1 to res.count/3 by 3 do (
		append faceid [d,d+1,d+2]
		)
	print res.count
	print faces
	faceid
 	mesh vertices:faces  faces:faceid
	)

--openDWG()
ds = getObjSet()
res = sendToDoNet(ds)
createMesh(res)
	
	
	
	
	
	
	
	
	
	
	