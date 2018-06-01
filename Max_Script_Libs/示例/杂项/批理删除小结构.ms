

/*
	删除FBX文件中过小的独立结构
	fileDir ： 指定一个文件夹
	maxFaceCount ： 指定一个阈值
*/
fn cleanSmallObj =
(
	try
	(
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
		)catch(messagebox "有BUG联系BT")
	)


	rollout Tools_modle "建模工具" width:148 height:84 rolledUp:on  
(  
    button hit1 "重置Xform" pos:[5,5] width:136 height:21 toolTip:"重置xform，位移旋转归零，缩放归100%" 
	
    on hit1 pressed do  
    (  
       cleanSmallObj()
    )--end on  
)
createdialog Tools_modle
	
	
	
	