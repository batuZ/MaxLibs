
/*
	删除FBX文件中过小的独立结构
	fileDir ： 指定一个文件夹
	maxFaceCount ： 指定一个阈值
	2016.6.9
*/
fn cleanSmallObj =
(
	messagebox "请备份原文件，删除操作不可逆！"
		--初始化
		resetMaxFile()
	
		fileDIR = getSavePath caption:"选择打开文件路径:"
		filePaths =getFiles (fileDIR + @"\*.fbx")
		
		for afile in filePaths do
		(
			--导入一个
			importFile afile #noPrompt 
			
			--指定变量名
			tar = $
			
			--打开 Modify 命令面板
			max modify mode
			
			--选中所有的点
			subobjectLevel = 1
			max Select All
			
			--焊接点集
			meshOps.weld $
			
			--获取对象面数
			faceCount = getNumFaces tar
			
			--少于这个数量将被删除
			delCount = faceCount / 10
			
			subobjectLevel = 3
			
			--结果集合
			delFaecs = #()
			
			--遍历面
			for f=1 to faceCount do
			(
				--拿到一个面
				aface = #(f)
				
				--通过个这面获取与其相接的面集
				tt = meshop.getElementsUsingFace tar aface
				
				--通过面集选中面
				tar.selectedFaces = tt
				
				--获取选中面的数量
				sel = tar.selectedFaces.count
				
				--判断是否小于参考值，是则加如结果集
				if sel < delCount do 
					append delFaecs f
				)
				
			--删除结果集中的面
			meshop.deleteFaces tar delFaecs delIsoVerts:True
				
			--进入父级
			if subobjectLevel != 0 then subobjectLevel = 0
				
			--输出
			newPath = substring afile 1 (findstring afile ".") + "osg"
			exportFile newPath  #noPrompt
			
			--全选、删除
			max select all
			delete selection 
			)
			messagebox "OK"
	)
	
/*
	提取轮廓坐标值输出到文档
	*/
	
fn getLunKuo =
(
	try
	(
		filePath = (getSaveFileName types: "all(*.*)") + ".txt"
		if classof $ != Editable_Poly then convertToPoly $ ; subobjectLevel = 3
			
		--拿到线（点ID集）
		myEdes = polyOp.getEdgeSelection $ 
		
		--把poly转成SPline
		polyOp.createShape $ myEdes smooth:False name:"myShape" node:unsupplied
		
		myShp =$myShape
		
		if CreateFile filePath == undefined 
			then messagebox "无法创建文档"
		else
		(
			fileStrea = CreateFile filePath
			
			pointCount = numKnots myShp 1
			
			for i=1 to pointCount do 
				(
					format "%\n" (getKnotPoint myShp 1 i) to:fileStrea
				)
			close fileStrea
		)
	messagebox "OK"
	)catch(messagebox "有BUG联系BT")
	)	
	
fn TheEnd =
(
-- 	try
-- 	(
-- 		if (readLine ( openfile @"D:\aa")) =="aaa"
-- 		then 
-- 			(
			createdialog 'Gvitech.Tools@TB'
			-- addrollout 'Gvitech.Tools@TB'
			--encryptScript "BT_tools.ms"
-- 			)
-- 		else messagebox ("未授权！")
-- 	)
-- 	catch messagebox ("未授权！")
	)
	
fn addBack = 
(
	filePath = getOpenFileName caption:"打开网格构建文档" types:"*.txt"
	str1 = readLine (openfile filePath)
	execute str1
	addModifier $ (Uvwmap ())
	$.material = meditMaterials[12]
	mapPath = getOpenFileName caption:"打开贴图" types:"*.tif"
	meditMaterials[12].diffuseMap = Bitmaptexture fileName:mapPath
	actionMan.executeAction 0 "63545"
	)

	
	
	

/*
	主界面
*/
rollout 'Gvitech.Tools@TB' "Gvitech.Tools@TB" width:300 height:340
(
	-------------------------------------------------------------------------------
	groupBox aboutMe "说明" pos:[10,270] width:275 height:50 enabled:false
	label lbl2 "working..." pos:[25,290] width:150 height:20
	-------------------------------------------------------------------------------
	groupBox classA "classA" pos:[10,10] width:275 height:98
	button btn1 "清理小结构" pos:[30,30] width:230 height:25 toolTip:""
	button btn2 "提取修补轮廓" pos:[30,65] width:150 height:25 toolTip:""
	button btn3 "修补" pos:[193,64] width:65 height:25 toolTip:""
	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------
	 on btn1 pressed do  
    (  
       cleanSmallObj()
    )--end on
	
		 on btn2 pressed do  
    (  
       getLunKuo()
    )--end on
	
	on btn3 pressed do  
    (  
       addBack()
    )--end on
	
)TheEnd()


	