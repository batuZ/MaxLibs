utility effectlibs "李敏工具集" width:162 height:406
(
	button btn1 "清空材质编辑器" pos:[26,9] width:110 height:24
	button btn2 "开所有组" pos:[26,38] width:110 height:24
	button btn9 "关所有组" pos:[26,66] width:110 height:24
	button btn10 "选择空物体" pos:[26,95] width:110 height:24
	button btn19 "选择VR代理" pos:[26,123] width:110 height:24
	button btn40 "清空孤立点" pos:[26,152] width:110 height:24
	button btn56 "物体坐标归中底" pos:[26,180] width:110 height:24
	button btn15 "选择面数过万物体" pos:[26,208] width:110 height:24
	button btn11 "材质名同贴图" pos:[26,236] width:110 height:24
	button btn12 "合并同名材质" pos:[26,264] width:110 height:24
	button btn3 "按材质合模" pos:[26,295] width:110 height:24
	button btn4 "场景物体编号" pos:[26,324] width:110 height:24
	button btn13 "去除多层高光" pos:[26,356] width:110 height:24
	on btn1 pressed do
	(
			b=#()
			for s=1 to 24 do (a=s as string; i= a+" - Default0";append b i)
			for m=1 to 24 do (meditmaterials[m]=standard(); meditMaterials[m].name =b[m])             --清空材质编辑器
		)
	on btn2 pressed do
	(
		   clearselection();if selection.count!=0 then actionMan.executeAction 0 "59231";clearselection()
	        for a in objects do if isgrouphead a then setgroupopen a true
	        ok                              --开所有组
	       )
	on btn9 pressed do
	(
			clearselection();if selection.count!=0 then actionMan.executeAction 0 "59231";clearselection()
	         for a in objects do  if isopengrouphead a then setgroupopen a false
	          ok                           --关所有组
		)
	on btn10 pressed do
	(
		clearselection();if selection.count!=0 then actionMan.executeAction 0 "59231";clearselection()
	       for a in objects do if isgrouphead a then setgroupopen a true
	         ok 
			for a in geometry do 
	      (b=getpolygoncount a
	               if b[1]==0 and classof a != VRayProxy  
	                      then selectmore a)      --选择空物体
		)
	on btn19 pressed do
	(
			clearselection();if selection.count!=0 then actionMan.executeAction 0 "59231";clearselection()
	         for a in objects do if isgrouphead a then setgroupopen a true
	         ok 
			for a in geometry do 
	          (if classof a == VRayProxy
	                        then selectmore a)      --选择VR代理
		)
	on btn40 pressed do
	(clearselection();if selection.count!=0 then (actionMan.executeAction 0 "59231";clearselection())
	if querybox"会把所有几何体转换为mesh\n 然后再清除孤立点\n 要继续吗？" title:"注意" then
	 (      d=0
	        for a in geometry do (
	                              if classof a != VRayProxy 
	                             then (converttomesh a;b=a.numverts; meshop.deleteisoverts a;c=b-a.numverts;d+=c;update a)
	                                    )
	        e=d as string;
	        x="清除了"+e+"个孤立点";
	         messagebox x;
	         
	))
	on btn56 pressed do
	(
	for i in selection do i.pivot=[i.center.x,i.center.y,i.min.z]
	)
	on btn15 pressed do
	(
		clearselection();if selection.count!=0 then actionMan.executeAction 0 "59231";clearselection()
	       for a in objects do if isgrouphead a then setgroupopen a true
	         ok 
			for a in geometry do 
	      (b=getpolygoncount a
	               if b[1]>=10000  
	                      then selectmore a)      --选择面数过万物体
		)
	on btn11 pressed do
	(
		for a in scenematerials do 
	(
	  g=a as string
	  e=filterstring g ":"
	  if e[e.count] == "Standard" do
	  (
	    r=a.diffusemap as string
	    f=filterstring r ":"
	    if f[f.count] == "Bitmap" and a.diffusemap.bitmap !=undefined do
	       (
	         b=a.diffusemap.bitmap as string
	         c=filterstring b "\."
	         a.name=c[c.count-1]
	         a.diffusemap.name=a.name
	        )
	    )
	) --材质名同贴图
		)
	on btn12 pressed do
	(
		x=0;c=#()
	for a in scenematerials do
	(
	   g=a as string
	   e=filterstring g ":"
	   if e[e.count]=="Standard" do
	     (
	       r=a.diffusemap as string
	       f=filterstring r ":"
	       if f[f.count]=="Bitmap" and a.diffusemap != undefined do
	              if a.diffusemap.apply do 
	                   (x+=1 ; d=finditem scenematerials a; append c d)
	      )
	)--收集贴图裁切被打开的材质
	if x!=0 then
	(
	  (
	   b=#()
				for s=1 to 24 do (a=s as string; i= a+" - Default0";append b i)
				for m=1 to 24 do (meditmaterials[m]=standard(); meditMaterials[m].name =b[m])    
	  )         --清空材质编辑器
	  for i=1 to c.count do meditmaterials[i]=sceneMaterials[c[i]];
	  h=x as string;
	  messagebox("您有"+h+"个材质的贴图裁切被打开\n"+"已放入材质编辑器\n"+"并已跳过对此材质的操作")  title:"请注意"
	)
	 for a in scenematerials do
	        for b in geometry do 
	            (g=true
	             for e=1 to c.count do (g=b.material!=scenematerials[c[e]];if g==false do exit)             
	             if b.material!= undefined and g do
	                if b.material.name==a.name do 
	                          b.material=a
	            )
	--合并同名材质
		)
	on btn3 pressed do
	(
		for a in scenematerials do 
	(
	  (
	  c=#()
	  for b in selection do
	      if b!=Vrayproxy and b.material==a then append c b
	  )
	x=c.count-1
	 if x>0 do 
	          (
	           converttomesh c[1]
	           for i=1 to x do attach c[1] c[i+1]
	           m=#()
			  for i=1 to c[1].numfaces do append m i
			  meshop.unifynormals c[1] m			   
			  update c[1] ()
	           )
	
	)--选择物体按材质合模
		)
	on btn4 pressed do
	(
	i=0
	for a in geometry  do ( b=i as string;a.name=b;i+=1)
	--场景所有物体编号
		)
	on btn13 pressed do
	(
	for a in scenematerials do 
	(       
	       g=a as string
		   e=filterstring g ":"
		   if e[e.count]=="Standard" and a.shaderType==3 do
	                              ( 
	                                a.specularLevel=a.specularLevel2
	                                a.glossiness = a.glossiness2
	                                a.Specular = a.specular2
	                                a.shaderType=1
	                                a.adTextureLock = on
	                               )
	
	)
	--场景中多层高光材质改布林材质
		)
)