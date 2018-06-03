dotnet.loadassembly @"bin\x64\Debug\CreateMeshByPoints.dll"
global funcs = dotNetObject "CreateMeshByPoints.ToTIN"
global gridSize = 5
global filePath
clearListener()

-- 建网格
fn createMesh = (
	local vs = #(); fs = #(); points = funcs.points; ids = funcs.ids
-- 	progressStart "创建地形网格..."
	for f=1 to points.count by 3 do(
		append vs [points[f],points[f+1],points[f+2]]
-- 		progressUpdate (100 * f / points.count)
-- 		if getProgressCancel() then exit
		) 
	for d = 1 to ids.count by 3 do (
		append fs [ids[d],ids[d+1],ids[d+2]]
-- 		progressUpdate (100 * d / ids.count)
-- 		if getProgressCancel() then exit
		)
-- 	progressEnd()
	pushPrompt "Done!"
 	mesh vertices:vs  faces:fs
	max tool zoomextents
	)

-- 通过场景选择集创建
fn fromSelection = (
	local arr=#()
	for obj in selection do(
		append arr obj.pos.x
		append arr obj.pos.y
		append arr obj.pos.z
		)
	return funcs.CreateMesh arr
	)

-- 通过栅格创建
fn fromRaster =(

	-- 调.net函数,读取栅格的范围 [0]minx [1]miny [2]maxX [3]maxY
	local outBox = funcs.getOutBox(filePath)

	-- X,Y的长度
	local _xd = outBox[3] - outBox[1]
	local _yd = outBox[4] - outBox[2]
	
	-- 格子数量
	local widthCount = _xd / gridSize
	local lengthCount = _yd / gridSize

	-- 中心坐标
	local posx = _xd/2+outBox[1]
	local posy = _yd/2+outBox[2]
	
	local resMesh = Plane width:_xd length:_yd pos:[posx,posy,0] \
	lengthsegs: lengthCount widthsegs:widthCount isSelected:on
	convertToMesh resMesh
	progressStart "创建地形网格..."
	for v=1 to resMesh.numverts do(
		local px = resMesh.verts[v].pos.x
		local py = resMesh.verts[v].pos.y
		local pz = funcs.getZ_byXY px py
		setVert resMesh v px py pz
		progressUpdate (100 * v / resMesh.numverts)
		if getProgressCancel() then exit
		)
	progressEnd()
	pushPrompt "Done!"
	update resMesh
	max tool zoomextents
	)
	
-- 设置网格大小
rollout setGridSize "" width:232 height:40(
	spinner 'spn1' "Grid Size: " pos:[15,12] width:116 height:22 align:#left range:[0.1,1000, gridSize] 
	button 'btn1' "Go" pos:[170,10] width:48 height:20 align:#left
	on btn1 pressed do(
		fromRaster()
		destroyDialog setGridSize
		)
	on spn1 changed amt do gridSize = amt
	)

-- 打开文件
fn openFiles =(
	--清理
	--resetMaxFile()
	--选择
	filePath = getOpenFileName caption: "open File:" \
	types: "DWG(*.dwg)|*.dwg|ShapeFile(*.shp)|*.shp|GeoTIFF(*.tif)|*.tif|IMAGE(*.img)|*.img";

	--取消
	if (filePath == undefined) then return undefined 

	--文件类型
	local tp = toUpper(getFilenameType filePath)

	-- 栅格数据
	if (tp == ".TIF" or tp == ".IMG") then createdialog setGridSize

	-- shp 文件通过ogr导入
	else if (tp == ".SHP" and funcs.CreateFromSHP(filePath)) then createMesh();

	-- dwg 文件直接导入
	else if (tp == ".DWG") then(
		importFile filePath
		select objects
		if(fromSelection()) then createMesh()
		)
	)

-- 入口
fn beginCreate=(
 	if (selection.count == 0) then openFiles()
 	else if (selection.count > 2 and fromSelection()) then createMesh()
 	)
beginCreate()