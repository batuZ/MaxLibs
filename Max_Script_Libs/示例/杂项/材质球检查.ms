rollout 分析材质 "分析材质 " width:150 height:197
(
local theMat, uniqueMats, mapTo, theObj
struct aMat (theInstance, theDiffusemap)

	pickbutton PickObj "第一步：优化材质" pos:[18,7] width:121 height:25
	

label l_nMatIDs_t "Obj Max MatID:" across:2 align:#left
label l_nMatIDs_n ""

label l_nSubMats_t "# SubMats:" across:2 align:#left
label l_nSubMat_n ""

label l_nUniqueSubMats_t "# Unique SubMats:" across:2 align:#left
label l_nUniqueSubMat_n ""

	button checkit "第二步：检查错误" pos:[18,99] width:121 height:25 enabled:true
	button see "第三步：修正错误" pos:[18,135] width:121 height:25 enabled:true
	
	on PickObj picked obj do ---转化网格
	(	theObj=obj
	     select obj
		--if classof obj != Editable_mesh do
		--	if canConvertTo obj mesh then
		--		convertToMesh obj
		--	else
		--		throw "Cannot convert object to Editable Mesh"
		macros.run "Modifier Stack" "Convert_to_Mesh"
		PickObj.text=obj.name
		
		theMat=obj.material --获取材质
		if classof theMat != Multimaterial do throw "Object Material not a MultiMaterial"
		l_nSubMat_n.text=theMat.numsubs as string
		local SubMatUsed=#()
		for f=1 to obj.numfaces do
			SubMatUsed[getFaceMatID obj f]=true
		    l_nMatIDs_n.text=SubMatUsed.count as string
		    uniqueMats=#()
		    mapTo=#()
		for m=1 to theMat.numsubs do
		(	if SubMatUsed[m] != true do continue
			local thisMatDBitmap=undefined
			if classof theMat[m] == StandardMaterial do
				if classof theMat[m].diffusemap == Bitmaptexture do
					thisMatDBitmap=theMat[m].diffusemap.filename
			if thisMatDBitmap == undefined do
			(	append uniqueMats (aMat theMat[m] thisMatDBitmap)
				mapTo[m]=uniqueMats.count
				continue
			)
			local foundMatch=false
			for p=1 to uniqueMats.count do
				if thisMatDBitmap == uniqueMats[p].theDiffusemap do
				(	mapTo[m]=p
					foundMatch=true
					continue
				)
			if not foundMatch do 
			(	append uniqueMats (aMat theMat[m] thisMatDBitmap)
				mapTo[m]=uniqueMats.count
			)
		)
		l_nUniqueSubMat_n.text=uniqueMats.count as string
	
     	local NewMMat=Multimaterial numsubs:uniqueMats.count name:(theObj.name+"_"+theObj.material.name)
		for m=1 to uniqueMats.count do
			NewMMat[m]=copy uniqueMats[m].theInstance
		for f=1 to theObj.numfaces do
		(	local oldID=getFaceMatID theObj f
			setFaceMatID theObj f mapTo[oldID]
		)
		theObj.material=NewMMat
		update theObj
		PickObj.text= "第一步：优化材质"
		
		meditMaterials[1]=theobj.material
	   	     a=meditMaterials[1].materialIDList
			 for i = 1 to a.count do 
				(
				showTextureMap meditMaterials[1].materialList[a[i]] on
				)
	
		
	)
	on checkit pressed do
	(	
	         for obj in selection do
			 (
	           meditMaterials[1]=obj.material
	   	     a=meditMaterials[1].materialIDList
			for i = 1 to a.count do 
			(
			   if meditMaterials[1].material[a[i]].diffuseMap==undifined do  continue
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Tiling = 1
				meditMaterials[1].material[a[i]].diffuseMap.coords.V_Tiling = 1
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Offset=0
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Offset=0
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Angle = 0
			     meditMaterials[1].material[a[i]].diffuseMap.coords.v_Angle = 0 
				meditMaterials[1].material[a[i]].diffuseMap.coords.w_Angle = 0 
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Tile =true
				meditMaterials[1].material[a[i]].diffuseMap.coords.V_Tile =true
				meditMaterials[1].material[a[i]].diffuseMap.apply = off
				meditMaterials[1].material[a[i]].diffuseMap.coords.mapChannel=1
				
				)
	          )
	  )
	  on see pressed do
	(	
	          messagebox "xxx"
	         for obj in selection do
			 (
	           meditMaterials[1]=obj.material
	   	     a=meditMaterials[1].materialIDList
			for i = 1 to a.count do 
			(
			   if meditMaterials[1].material[a[i]].diffuseMap==undifined do  continue
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Tiling = 1
				meditMaterials[1].material[a[i]].diffuseMap.coords.V_Tiling = 1
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Offset=0
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Offset=0
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Angle = 0
			     meditMaterials[1].material[a[i]].diffuseMap.coords.v_Angle = 0 
				meditMaterials[1].material[a[i]].diffuseMap.coords.w_Angle = 0 
				meditMaterials[1].material[a[i]].diffuseMap.coords.U_Tile =true
				meditMaterials[1].material[a[i]].diffuseMap.coords.V_Tile =true
				meditMaterials[1].material[a[i]].diffuseMap.apply = off
				meditMaterials[1].material[a[i]].diffuseMap.coords.mapChannel=1				
				)
	          )
	  )
)
-----------------------------------------------------------------------------------------------------------------------------------------
rollout 轴心变换和导出 "轴心变换和导出" width:160 height:120
(
	button btn5 "选择物体的轴心归零" pos:[9,8] width:140 height:28 
	button btn8 "批量输出3ds格式模型" pos:[9,118] width:140 height:30
	GroupBox grp1 "输出方式" pos:[11,43] width:136 height:67
	radiobuttons rdo1 "" pos:[29,66] width:93 height:32 labels:#("单个输出  ", "整体输出  ") default:2
--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	on btn5 pressed do--轴心归零
	(
		for obj in selection do
		(
			CenterPivot obj
			obj.pivot.z=0
		)
	)
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	on btn8 pressed do --批量导出--选择方式
	(
	   case rdo1.state of
		 (
    			   1:(   --单体输出
	       			  a=for obj in selection collect obj
		   			 if a.count!=0 then
			 			(			
	      				f=getsavepath()
						if f!=undifined then 
						(
						ep=getdir #export 
						setdir #export f---设当前路径
						for i=1 to a.count do
						(
			  				  model=a[i]
							  select model
			   				  m= sceneMaterials [model.material.name]	
                  				  mtype= classof  m
							  case mtype of
				   				(
									Advanced_Lighting_Override : messagebox "目前还不支持Advanced_Lighting_Override"
				 					Architectural : messagebox "目前还不支持Architectural"
				  					Blend : messagebox "目前还不支持Blend"
				  					CompositeMaterial : messagebox "目前还不支持CompositeMaterial"
				  					DoubleSided : messagebox "目前还不支持DoubleSided "
				  					InkNPaint : messagebox "目前还不支持InkNPaint"
				  					Lightscape_Mtl : messagebox "目前还不支持Lightscape_Mtl"
				  					MatteShadow : messagebox "目前还不支持MatteShadow"
				  					MorpherMaterial : messagebox "目前还不支持MorpherMaterial"
				  					MultiMaterial :
										(
				         						aa=m.materialIDList
											for i = 1 to aa.count do 
												(
			  				 						if m.material[aa[i]].diffuseMap==undifined do  continue
						      						b=m.material[aa[i]].diffuseMap.filename
													--/拷贝透明通道
							                            c=getFilenameFile b+"_alpha"
													cc= getFilenamePath b+c+".jpg" --jpg格式
													dd= getFilenamePath b+c+".bmp" --bmp格式
													copyFile cc (f + "\\" +c+".jpg" )
													copyFile dd (f + "\\" +c+".bmp" )
													--/拷贝透明通道
							 						copyFile b (f + "\\" +getFilenameFile b + getFilenameType b)
													
		                        					)--for   
											exportFile model.name #noPrompt selectedOnly:true

										 )
				  					NoMaterial : messagebox "目前还不支持NoMaterialv"
				  					Radiosity_Override : messagebox "目前还不支持Radiosity_Override"
				  					RaytraceMaterial : messagebox "目前还不支持RaytraceMaterial"
				  					Shell_Material : messagebox "目前还不支持Shell_Material"
				  					Shellac : messagebox "目前还不支持Shellac"
				  					Standard :
										(   
							 				if m.diffuseMap==undifined do  continue
						      				b=m.diffuseMap.filename							
							 				copyFile b (f + "\\" +getFilenameFile b + getFilenameType b)
							 				exportFile obj.name #noPrompt selectedOnly:true
							 			)--standard
				    						 TopBottom : messagebox "目前还不支持TopBottom"
				   			 )--case
						)
		     			setdir #export ep---设回默认
					)--if 输出
					else 
						(
			 				messagebox"？？？,真的要放弃吗？太可惜了！！！！！"
						)--else 
            		)--if 选择物体
		 		else  
          			messagebox"请选择物体！！！！！！！！"
		 )---case 1
	   2:(   --整体输入
	         bb=for obj in selection collect obj
			if bb.count!=0 then
			(		
	      		f_name=getsavefilename  types:"3ds模型文件(*.3ds)|*.3ds"			
				if f_name!=undifined then 
					(
						f=getFilenamePath f_name--从全路径中获取路径名称
						f_newname=filenameFromPath f_name
						f_newpath=f+getfilenamefile f_newname
						makeDir f_newpath
						ep=getdir #export 
						setdir #export f_newpath---设当前路径
						for i=1 to bb.count do
							(
			   					obj=bb[i]		
                                     select obj				
			    				     m = sceneMaterials [obj.material.name]	                						   
                 					mtype= classof  m
								case mtype of
				 					  (
										Advanced_Lighting_Override : messagebox "目前还不支持Advanced_Lighting_Override"
				 						Architectural : messagebox "目前还不支持Architectural"
				  						Blend : messagebox "目前还不支持Blend"
				  						CompositeMaterial : messagebox "目前还不支持CompositeMaterial"
				  						DoubleSided : messagebox "目前还不支持DoubleSided "
				  						InkNPaint : messagebox "目前还不支持InkNPaint"
				  						Lightscape_Mtl : messagebox "目前还不支持Lightscape_Mtl"
				  						MatteShadow : messagebox "目前还不支持MatteShadow"
				  						MorpherMaterial : messagebox "目前还不支持MorpherMaterial"
				  						MultiMaterial :
											(
				        							 aa=m.materialIDList
												 for i = 1 to aa.count do 
													(
			  											 if m.material[aa[i]].diffuseMap==undifined do  continue
						      							 b=m.material[aa[i]].diffuseMap.filename	
						                                 	--/拷贝透明通道
							                            	 c=getFilenameFile b+"_alpha"
														 cc= getFilenamePath b+c+".jpg" --jpg格式
														 dd= getFilenamePath b+c+".bmp" --bmp格式
														 copyFile cc (f_newpath + "\\" +c+".jpg" )
														 copyFile dd (f_newpath + "\\" +c+".bmp" )
														--/拷贝透明通道
							 							 copyFile b (f_newpath + "\\" +getFilenameFile b + getFilenameType b)							                         
				          							 )--for  i=1 to aa.count  
                                                       exportFile obj.name #noPrompt selectedOnly:true --<<<<<<<<<<<输出单个模型>>>>>>>>>>>					
											 )
				  						NoMaterial : messagebox "目前还不支持NoMaterialv"
				  						Radiosity_Override : messagebox "目前还不支持Radiosity_Override"
				  						RaytraceMaterial : messagebox "目前还不支持RaytraceMaterial"
				  						Shell_Material : messagebox "目前还不支持Shell_Material"
				  						Shellac : messagebox "目前还不支持Shellac"
				  						Standard :
							 				(   
							 					if m.diffuseMap==undifined do  continue
						      					b=m.diffuseMap.filename	
	                                                        --/拷贝透明通道
							                            c=getFilenameFile b+"_alpha"
													cc= getFilenamePath b+c+".jpg" --jpg格式
													dd= getFilenamePath b+c+".bmp" --bmp格式
													copyFile cc (f_newpath + "\\" +c+".jpg" )
													copyFile dd (f_newpath + "\\" +c+".bmp" )
													--/拷贝透明通道						
												copyFile b (f_newpath+ "\\" +getFilenameFile b + getFilenameType b)	
												exportFile obj.name #noPrompt selectedOnly:true --<<<<<<<<<<<输出单个模型>>>>>>>>>>>	

											 )--standard
				    						 TopBottom : messagebox "目前还不支持TopBottom"
				    					)--case
                   
              			 )--for
						--ep_name=getFilenameFile f_name
						--exportFile ep_name #noPrompt selectedOnly:true --<<<<<<<<<<输出一个总的3ds文件>>>>>>>>>>>
		    				setdir #export ep---设回默认
						)--if 输出
					else 
						(
							 messagebox"？？？,真的要放弃吗？太可惜了！！！！！"
						)--else 
	    			 )---if
			     else  
          	       ( messagebox"请选择物体！！！！！！！！")
             )--case2
		)--case
    )--btn8
)---卷栏结束
----------------------------------------------------------------------------------------------------------------------------------------------------------
rollout 批量变换 "批量变换" width:160 height:372
(
	button btn6 "转换选择物体的材质" pos:[11,332] width:140 height:30
	GroupBox grb "材质参数调节" pos:[12,6] width:138 height:319
	checkbox chk1 "Checkbox" pos:[31,30] width:15 height:13 checked:true
	label lbl2 "双面" pos:[55,29] width:29 height:16
	GroupBox grp3 "自发光" pos:[24,56] width:121 height:68
	checkbox chk2 "" pos:[42,102] width:16 height:13 enabled:false checked:false
	colorPicker cp1 "" pos:[71,100] width:65 height:18 enabled:false color:(color 0 0 0)
	label lbl4 "环境色" pos:[24,138] width:47 height:17
	colorPicker cp2 "" pos:[92,137] width:48 height:18 enabled:false color:(color 255 255 255)
	label lbl5 "漫射色" pos:[24,159] width:47 height:17
	colorPicker cp3 "" pos:[91,158] width:48 height:18 enabled:false color:(color 255 255 255)
	GroupBox grp5 "镜面高光" pos:[20,191] width:119 height:121
	label lbl6 "高光级别" pos:[32,217] width:60 height:16
	label lbl7 "高光区" pos:[33,263] width:52 height:18
	checkbox chk3 "Checkbox" pos:[73,137] width:14 height:18
	checkbox chk4 "Checkbox" pos:[73,159] width:14 height:18 checked:false
	checkbox chk15 "Checkbox" pos:[47,248] width:0 height:0
	checkbox chk5 "Checkbox" pos:[40,237] width:14 height:18
	checkbox chk6 "Checkbox" pos:[40,283] width:14 height:18	
	button btn22 "关" pos:[91,27] width:21 height:21 	
	button btn4 "显" pos:[119,27] width:21 height:21 
	spinner spn1 "" pos:[70,75] width:65 height:16 enabled:false scale:1
	spinner spn2 "" pos:[64,238] width:58 height:16 enabled:false range:[0,999,0] scale:1
	spinner spn3 "" pos:[64,283] width:58 height:16 enabled:false range:[0,100,0] scale:1
			 
	---////////////////////////////////////////////////////////////////////////////////////////////////////////////		 
	---////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	checkbox chk8 "" pos:[42,75] width:16 height:16 checked:false
	groupBox grp4 "" pos:[87,17] width:58 height:35
	on 批量变换 open do
	(
			spn1.value=20.0
			spn2.value=30.0
			spn3.value=30.0
	)
	on btn6 pressed do  ---变换材质
	(
	
	
	
	for obj in selection do 
	(
		meditMaterials[1]=obj.material
		if  iskindof meditMaterials[1] Standardmaterial then
			(
				--检查双面选项
				  case chk1.state of
		  		 (
		  		  true:meditMaterials[1].twoSided =on
	
	       		  false:meditMaterials[1].twoSided =off
	       		 )
				--meditMaterials[1].twoSided = double
				--//////////////////////////////////////////////////////////////////////设置自发光
			case chk8.state of 
			(
			    true:(
					case chk2.state of
		   				(
		   		 		true:
				    			(
							meditMaterials[1].useSelfIllumColor =on
							meditMaterials[1].selfIllumColor = cp1.color
							)
	        		 		false:
				    			(
							meditMaterials[1].useSelfIllumColor =off
							meditMaterials[1].selfIllumination=(spn1.value as integer)
							)
	        				)
					)
			)
			
			if chk3.state then	
						(
						   meditMaterials[1].adLock = off
						meditMaterials[1].Ambient = cp2.color
						)
			else 
			     (meditMaterials[1].adLock = on
				 meditMaterials[1].Ambient=cp3.color)
			if chk4.state do
						 (
						-- meditMaterials[1].adLock = off
						 meditMaterials[1].Diffuse = cp3.color
						 )
	         if chk5.state do  meditMaterials[1].specularLevel=spn2.value as integer
			if chk6.state do	meditMaterials[1].glossiness=spn3.value as integer
	
			)
		else 		
			(
				a=meditMaterials[1].materialIDList
			
				for i = 1 to a.count do 
				(
				--///////////////////////////////////////////////////检查双面选项
				 meditMaterials[2]=meditMaterials[1].materialList[a[i]]
				 case chk1.state of
		  			 (
		  				  true:meditMaterials[2].twoSided =on
	
	       				  false:meditMaterials[2].twoSided =off
	       			  )
				--meditMaterials[1].twoSided = double
				--//////////////////////////////////////////////////////////////////////设置自发光
				case chk8.state of 
				(
			 	   true:(
					case chk2.state of
		   				(
		   		 		true:
				    			(
	
							meditMaterials[2].useSelfIllumColor =on
							meditMaterials[2].selfIllumColor = cp1.color
							)
	        		 		false:
				    			(
							meditMaterials[2].useSelfIllumColor =off
							meditMaterials[2].selfIllumination=(spn1.value as integer)
							)
	        				)
					)
				)
			
			if chk3.state then	
						(
					     meditMaterials[2].adLock = off
						meditMaterials[2].Ambient = cp2.color
						)
			else 
			     (
				 meditMaterials[2].adLock = on
				 meditMaterials[2].Ambient=cp3.color
				 )
			if chk4.state do
				 (
						-- meditMaterials[1].adLock = off
				 meditMaterials[2].Diffuse = cp3.color
				 )
	         if chk5.state do  meditMaterials[2].specularLevel=spn2.value as integer
			if chk6.state do	meditMaterials[2].glossiness=spn3.value as integer
	
	
	
			     )
		
		     )
			 )
			 )
	on chk2 changed state do--基本功能设置
	(
	       case chk2.state of
		   (
		   true:(
				--lbl3.enabled=false
				cp1.enabled=true
	         	     spn1.enabled=false
			 	)
		   false:(
				--lbl3.enabled=true
				cp1.enabled=false
	           	spn1.enabled=true
			 	)
	         )
		)
	on chk3 changed state do
	(
	       case chk3.state of
		   (
		    true:cp2.enabled=true
	        false:cp2.enabled=false
		
	        )
	)
	on chk4 changed state do
	(
	       case chk4.state of
		   (
		   true:cp3.enabled=true
	        false:cp3.enabled=false
	        )
	)
	on chk5 changed state do
	(
	       case chk5.state of
		   (
		   true:spn2.enabled=true
	        false:spn2.enabled=false
	        )
	)
	on chk6 changed state do
	(
	       case chk6.state of
		   (
		   true:spn3.enabled=true
	        false:spn3.enabled=false
	        )
	)
	on btn22 pressed do  ---关闭贴图显示
	(
	for obj in selection do 
			(
			  meditMaterials[1]=obj.material
			  if  iskindof meditMaterials[1] Standardmaterial then
				(
			     showTextureMap  meditMaterials[1] off
			    )
			  else 
			  (
			    a=meditMaterials[1].materialIDList
				for i = 1 to a.count do 
				(
				
				showTextureMap meditMaterials[1].materialList[a[i]] off
				)
			  )
			)
		)
	on btn4 pressed do ---显示贴图
	(
	for obj in selection do 
			(
			  meditMaterials[1]=obj.material
			  if  iskindof meditMaterials[1] Standardmaterial then
				(
			     showTextureMap  meditMaterials[1] on
			     )
			  else 
			  (
			    a=meditMaterials[1].materialIDList
				for i = 1 to a.count do 
				(
				--meditMaterials[1].materialList[a[i]].twoSided = on
				showTextureMap meditMaterials[1].materialList[a[i]] on
				)
			  )
			)
	)
	on chk8 changed state do--基本功能设置
	(
	       case chk8.state of
		   (
		   true:(
				spn1.enabled=true
				chk2.enabled=true
			 	)
		   false:(
				spn1.enabled=false
				chk2.enabled=false
			 	)
	         )
		)
)
if FloaterExampleFloater != undefined do
				(
				closerolloutfloater FloaterExampleFloater
				)		
FloaterExampleFloater = newRolloutFloater "分析材质 1.0" 170 215 
addRollout 分析材质 FloaterExampleFloater
addRollout 批量变换 FloaterExampleFloater
addRollout 轴心变换和导出 FloaterExampleFloater

