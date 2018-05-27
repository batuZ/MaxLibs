global assembly = dotnet.loadassembly @"bin\x64\Debug\CreateMeshByPoints.dll"
if assembly !=undefined then(
global funcs = dotNetObject "CreateMeshByPoints.ToTIN"
)
 /*
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
	dotnet.loadassembly @"\bin\Debug\CreateMeshByPoints.dll"
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
	
fn fromPoints=(
	--openDWG()
	--ds = getObjSet()
	--res = sendToDoNet(ds)
	--createMesh(res)
	)
*/

fn fromRaster fPath =(
	-- 创建一个plane [0]minx [1]miny [2]maxX [3]maxY
	local outBox = funcs.getOutBox(fPath)

	local _xd = outBox[3] - outBox[1]
	local _yd = outBox[4] - outBox[2]
	
	--格子大小
	local gridSize = 5
	local widthCount = _xd / gridSize
	local lengthCount = _yd / gridSize
	

	plane1 = Plane width:_xd length:_yd \
			pos:[_xd/2+outBox[1], _yd/2+outBox[2],0] \
			lengthsegs: lengthCount widthsegs:widthCount \
			isSelected:on
	
	convertToMesh plane1
	
	local pArr =#()
	for v=1 to plane1.numverts do(
		append pArr plane1.verts[v].pos.x
		append pArr plane1.verts[v].pos.y
		)
	--getVert plane1
	local resArr = funcs.CreateFromReaset(pArr)
	
	)


-- 打开文件
fn openFiles=(
	
	--清理
	--resetMaxFile()

	--选择
	local filePath = getOpenFileName caption: "open File:" \
	types: "DWG(*.dwg)|*.dwg|ShapeFile(*.shp)|*.shp|GeoTIFF(*.tif)|*.tif|IMAGE(*.img)|*.img";

	if filePath == undefined then( return undefined )

	--文件类型
	local fileType = toUpper(getFilenameType filePath)

	--选择处理方式
	if fileType == ".TIF" or fileType == ".IMG" then(
		-- 栅格数据 Raster
		fromRaster(filePath)
		)

	else if fileType == ".SHP" then(
		-- shp 文件通过ogr导入
		)

	else if fileType == ".DWG" then(
		-- dwg 文件直接导入
		importFile filePath
		)
	)
 
openFiles()

	
	
	
	
	
	