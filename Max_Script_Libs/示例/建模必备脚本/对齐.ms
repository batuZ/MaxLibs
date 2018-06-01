fn alignToSurf =
(
	objALN=getCurrentSelection()
	escOn=1
	num_objALN=objALN.count
	local surf
	do (  --选择对齐到的物体
		surf=pickObject prompt:"Select a floor surface" 
		isObj=0
		if (keyboard.escPressed == true) do (escON=0;exit())
		if classof(classof surf) == GeometryClass  then isObj = 1 else messageBox "请选择几何体" title:"选择错误"
 	  )
	while isObj == 0
	print ("align to "+surf.name)
-------------------------
	if (objALN.count*escOn)>0 do --对齐多个物体到物体表面
	(
		for i=1 to num_objALN do
		(	
			try (
				pMin= objALN[i].min
				pMax= objALN[i].max
				pPvt= objALN[i].pivot
				rayC=ray [ppvt.x,ppvt.y,(100+surf.max.z)] [0, 0, -1]
				pSurf=intersectRay surf rayC
				move objALN[i] [0,0,(pSurf.position.z-pMin.z)]
				)
			 catch continue
		)--end for
	)--end if	
---------------------------
	if (selection.count * escOn) ==1 and classof(classof selection[1]) == geometryClass do --对齐几何体的点到物体表面
	(
		try(
		vt=selection[1].selectedVerts
		for i=1 to vt.count do
		try
		(
			p=vt[i].pos
			rayC=ray [(p.x),(p.y),(p.z+10000)] [0,0,-1]
			pSurf=intersectRay surf rayC
			vt[i].pos=pSurf.pos
		)
		catch continue
		) catch ()
	)--end if
----------------------------
	if (selection.count *escOn) ==1 and classof(classof selection[1]) == shape do --对齐线条物体的点到物体表面
	(
		subNum=0
		knotCount=numKnots selection[1]
		knotI=0
		for i=1 to 100 do( knotI+=numKnots selection[1] i; 	if knotI==knotCount  do ( subNum=i;exit() ) )
		for i=1 to subNum do
		(
			idx=getKnotSelection selection[1] i
			for j=1 to idx.count do
			try
			(
				pj=getKnotPoint selection[1] i idx[j]
				rayC=ray [(pj.x),(pj.y),(pj.z+10000)] [0,0,-1]
				pSurf=intersectRay surF rayC
				setKnotPoint selection[1] i idx[j] (pSurf.pos)
			)--end for j
			catch continue
		)--end for i 
		updateShape selection[1]
	)--end if
)--end fn
alignToSurf()