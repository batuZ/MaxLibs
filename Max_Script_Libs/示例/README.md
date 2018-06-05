# 3D Max脚本 功能助记

### 文件操作

##### 加密脚本
将在目标脚本相同目录下产生一个同名的mse文件
```maxscript
	encryptScript @"E:\code\MAXScript\test.ms"
```

##### 引用另一个脚本
```maxscript
	fileinRes = undefind
	try fileinRes = fileIn "load1.ms" catch messagebox "引入失败"失败
	if fileinRes == OK then(
		-- use function in load1.ms
		)
```

##### 打开、导入文件
```maxscript 
	filePaths = getFiles @"E:\test\5-1-3.fbm\*.fbx"
	loadMAXFile f  
	importFile f #noPrompt 
```

##### 输出信息
```maxscript
	msg = "E:\MAXScript"
	print msg
	format "% \n" msg
```

##### 写出文件
```maxscript
	fileStrea = CreateFile @"C:\NewTest.txt"
	if fileStrea == undefined then messagebox "无法创建文档"
	else (
		msg = "abcdef..."
		format "%\n" msg to:fileStrea
		close fileStrea
		messagebox "OK"
		)
```


### 选择

##### 通过类型选择对象集合
```maxscript
	points = $Point* as array
	boxes = $Box* as array
```
##### 获取子级数量
```maxscript
	getNumVerts $
	getNumFaces $
```
##### 获取子级集合
```maxscript
	points = $.verts
	edges = $.edges
	faces = $.faces
	points.count
	=> #verts(#all : $Editable_Mesh:Teapot001 @ [36.801647,5.866935,0.000000])
	=> #edges(#all : $Editable_Mesh:Teapot001 @ [36.801647,5.866935,0.000000])
	=> #faces(#all : $Editable_Mesh:Teapot001 @ [36.801647,5.866935,0.000000])
	=> 530
```

##### 子级和选择集
```maxscript
	-- 获取对象【被选中的】子级，返回【索引数组】 BitArray
	ConvertToMesh $
	pointsIndexArr = getVertSelection $
	egdesIndexArr = getEdgeSelection $
	facesIndexArr = getFaceSelection $

	-- 获取对象【被选中的】子级，返回【选择集】VertexSelection
	pointSelection = $.selectedVerts
	egdesSelection = $.selectedEgdes
	facesSelection = $.selectedFaces

	-- 通过索引数组，选中子级
	indexArr = #(1,3,5,7,9)
	setVertSelection $ indexArr
	setEdgeSelection $ indexArr
	setFaceSelection $ indexArr

	-- 获取对象里开放边的序号，返回索引数组
	indexArr = meshop.getOpenEdges $
```

##### 子级的其它操作
```maxscript
-- 返回一个<BitArray>值，元素为 Mesh 对象里开放边的序号。
	meshop.getOpenEdges <Mesh mesh>

-- 返回一个整数，表示 Mesh 对象的面数，等于属性<mesh>.numfaces 的值。
	getNumFaces <mesh>

-- 从 Mesh 对象删除指定面，并自动对面进行重新编号。
	deleteFace <mesh> <face_index_Integer>
 
-- 返回一个 BitArray 值，元素为 Mesh 对象的顶点序号，这些顶点被参数<facelist>指定的面使用。
	meshop.getVertsUsingFace <Mesh mesh> <facelist>
  
-- 返回一个 BitArray 值，元素为 Mesh 对象的边序号，这些边被参数<facelist>指定的面使用。
	meshop.getEdgesUsingFace <Mesh mesh> <facelist>
  
-- 返回一个 BitArray 值，元素为 Mesh 对象的面序号，这些面被参数<facelist>组成的多
-- 边形所包含。参数 threshold:的默认值为 45 度。如果参数 ignoreVisEdges:为 True，边的可
-- 见性被忽略，但参数 threshold:仍有效。
	meshop.getPolysUsingFace <Mesh mesh> <facelist> \
	ignoreVisEdges:<boolean=False> threshold:<Float=45.>

-- 删除指定面。如果参数 delIsoVerts:为 True，任何单独顶点都将被删除。
	meshop.deleteFaces <Mesh mesh> <facelist> delIsoVerts:<boolean=True>
 
-- 返回一个 BitArray 值，元素为 Mesh 对象的面序号，这些面所在元素的边中至少有一
-- 个面在参数<facelist>所指定的面列表中。如果有指定参数 fence： ，其指定面所在的元素不
-- 会被处理。
	meshop.getElementsUsingFace <Mesh mesh> <facelist> \
	fence:<facelist=unsupplied>

-- 返回一个 BitArray 值，元素为 Mesh 对象的面序号，这些面使用了参数<vertlist>指定
-- 的顶点。
	meshop.getFacesUsingVert <Mesh mesh> <vertlist>

-- 返回指定 Mesh 对象的面数
	meshop.getNumFaces <Mesh mesh>

-- 返回一个 BitArray 值，元素为 Mesh 对象的顶点序号，这些顶点被参数<facelist>指定
-- 的面使用
	meshop.getVertsUsedOnlyByFaces <Mesh mesh> <facelist>

-- 返回一个 BitArray 值，元素为 Mesh 对象的面序号，这些面处在由顶点列表<vertlist>
-- 定义的多边形里。
	meshop.getPolysUsingVert <Mesh mesh> <vertlist> \
	ignoreVisEdges:<boolean=False> threshold:<Float=45.>
	
--poly转成SPline
	polyOp.createShape myPoly myEdes smooth:False name:"myShape" node:unsupplied
```
### 创建

### 符号
符号 | 说明|
---|---|
`()` | 块表达式|
`+ - * / ^` | 数学表达式|
`+= -+ *= /= =` | 数学赋值|
`-- `| 注释语句|
`;` | 将同一行里几个语句分开|
`<eol> `| 文件末尾标记|
`,` | 用于分隔 Array 类数据的各元素|
`[ ] `| 用于 2D 和 3D 点字面常量|
`:` | 函数调用中可选参数指定|
`‘` | Name 类值|
`.` | 小数点|
`{ } `| 用于 BitArray 类值|
`#` | 用于 Array 类值|
`= = != `| 逻辑表达式|
`< <= > >=` | 逻辑表达式|
`?` | 上一次运算的结果|
`$ ...` | 用于 PathName 类数据字面常量|
`..` | 用于 BitArray 类值|
`\` | 源代码续行|