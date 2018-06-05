
	
2、从一个多边形的已选中的边提取一个SpLine
/****************************************************

	--poly
	myPoly= $ 
	
	--拿到线（点ID集）
	myEdes = polyOp.getEdgeSelection myPoly 
	
	--把poly转成SPline
	polyOp.createShape myPoly myEdes smooth:False name:"myShape" node:unsupplied
*/




5、关于子级的选择
/****************************************************

已选中的子物体 ---> 数组

	通过已经选中的点集 获取一个点的数组
	<mesh,poly>.selectedVerts -------------> <mesh,poly>.verts 获取包括全部点的数组
	getVertSelection <mesh,poly>
	Eg:
		a = $.selectedVerts
		b = getVertSelection $
	Bv:
		#verts(186, 208, 404 : $Editable_Mesh:Tile @ [2876.225098,-4576.110352,227.571991])
		#{186, 208, 404}

	通过已经选中的线集 获取一个线的数组
	<mesh,poly>.selectedEdges -------------> <mesh,poly>.edges 获取包括全部线的数组
	getEdgeSelection <mesh,poly>
	Eg:
		a = $.selectedEdges
		b = getEdgeSelection $
	Bv:
		#edges(908, 1612, 1614, 2906, 2907, 3684 : $Editable_Mesh:Tile @ [2876.225098,-4576.110352,227.571991])
		#{908, 1612, 1614, 2906..2907, 3684}

	通过已经选中的面集 获取一个面的数组
	<mesh,poly>.selectedFaces -------------> <mesh,poly>.faces 获取包括全部面的数组
	getFaceSelection <mesh,poly>
	Eg:
		a = $.selectedFaces
		b = getFaceSelection $
	Bv:
		#faces(303, 2298, 2507 : $Editable_Mesh:Tile @ [2876.225098,-4576.110352,227.571991])
		#{303, 2298, 2507}

数组 ---> 选中子物体
	
	通过一个点数组选中包括的点 ，是getVertSelection $的镜像操作
	setVertSelection <mesh> <vertlist>
	polyOp.setVertSelection <poly> <vertlist>
	Eg:
		setVertSelection $ a
		polyOp.setVertSelection $ a
	Bv:
		OK

	通过一个数组选中包括的线 ，是getEdgeSelection $的镜像操作
	setEdgeSelection <mesh> <edgelist>
	polyOp.setEdgeSelection <Poly poly> <edgelist>
	
	通过一个数组选中包括的面 ，是getFaceSelection $的镜像操作
	setFaceSelection <mesh> <facelist>
	polyOp.setFaceSelection <Poly poly> <facelist>
	
	
	
	
	
其它重点：

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


*/

5、通过类型选择对象集合
/****************************************************

points = $Point* as array

boxes = $Box* as array

*/
