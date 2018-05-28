dotnet.loadassembly @"bin\x64\Debug\CreateMeshByPoints.dll"
global funcs = dotNetObject "CreateMeshByPoints.ToTIN"
global gridSize = 5
global rPath = ""

-- 建网格
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

fn fromShpFile fPath =(
	createMesh(funcs.CreateFromSHP(fPath))
	)

-- 通过场景选择集创建
fn fromSelection = (
	local arr=#()
	for obj in selection do(
		append arr obj.pos.x
		append arr obj.pos.y
		append arr obj.pos.z
		)
	return funcs.CreateFromPoints arr
	)

-- 通过栅格创建
fn fromRaster rp =(

	-- 调.net函数,读取栅格的范围 [0]minx [1]miny [2]maxX [3]maxY
	local outBox = funcs.getOutBox(rp)

	-- X,Y的长度
	local _xd = outBox[3] - outBox[1]
	local _yd = outBox[4] - outBox[2]
	
	-- 格子大小
	local gridSize = 1

	-- 格子数量
	local widthCount = _xd / gridSize
	local lengthCount = _yd / gridSize

	-- 中心坐标
	local posx = _xd/2+outBox[1]
	local posy = _yd/2+outBox[2]
	
	resMesh = Plane width:_xd length:_yd pos:[posx,posy,0] \
	lengthsegs: lengthCount widthsegs:widthCount isSelected:on
	convertToMesh resMesh
	progressStart "栅格创建地形网格..."
	for v=1 to resMesh.numverts do(
		local px = resMesh.verts[v].pos.x
		local py = resMesh.verts[v].pos.y
		local pz = funcs.getZ_byXY px py
		setVert resMesh v px py pz
		progressUpdate (100 * v / resMesh.numverts)
		if getProgressCancel() then exit
		)
	progressEnd()
	update resMesh
	)
	
-- 设置网格大小
rollout setGridSize "" width:232 height:40
(
	spinner 'spn1' "Grid Size: " pos:[15,12] width:116 height:22 align:#left range:[0.1,1000, gridSize] 
	button 'btn1' "Go" pos:[170,10] width:48 height:20 align:#left
	on btn1 pressed  do(
		fromRaster(rPath)
		)
	on spn1 changed amt do(
		gridSize = amt
		)
	)

-- 打开文件
fn openFiles=(
	
	--清理
	--resetMaxFile()

	--选择
	local filePath = getOpenFileName caption: "open File:" \
	types: "DWG(*.dwg)|*.dwg|ShapeFile(*.shp)|*.shp|GeoTIFF(*.tif)|*.tif|IMAGE(*.img)|*.img";

	--取消
	if filePath == undefined then( return undefined )

	--文件类型
	local fileType = toUpper(getFilenameType filePath)

	-- 栅格数据
	if fileType == ".TIF" or fileType == ".IMG" then(
		rPath = filePath
		createdialog setGridSize
		)
	-- shp 文件通过ogr导入
	else if fileType == ".SHP" then(
		fromShpFile(filePath)
		)
	-- dwg 文件直接导入
	else if fileType == ".DWG" then(
		importFile filePath
		select objects
		fromSelection()
		)
	)

-- 入口
fn beginCreate=(
 	if selection.count == 0 then(
 		openFiles()
 		)
 	else if selection.count > 2 then(
		createMesh(fromSelection())
 		)
 	)
beginCreate()

	
	
	
	
	
	