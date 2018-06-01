
if selection.count ==0 then messageBox "选中一个轮廓"
	else(--messagebox (selection.count as string)
		
		--poly
		myPoly= $ 
		
		--拿到线（点ID集）
		myEdes = polyOp.getEdgeSelection myPoly 
		
		--把poly转成SPline
		polyOp.createShape myPoly myEdes smooth:False name:"myShape" node:unsupplied
		
		myShape =$myShape
		
		filePath = "C:\\Users\\Administrator\\Desktop\\NewTest.txt"
		if CreateFile filePath == undefined then messagebox "无法创建文档"
		else fileStrea = CreateFile filePath

		pointCount = numKnots myShape 1
		
		for i=1 to pointCount do 
			(
				format "%\n" (getKnotPoint myShape 1 i) to:fileStrea
			)
		close fileStrea
		)
		messagebox "OK"
	
	

 
