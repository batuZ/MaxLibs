rollout nihongdeng "霓虹灯" width:250 height:580
(
	ImgTag bmp1 "Bitmap" pos:[18,288] width:195 height:102 enabled:false  
	button btn1 "选择图片" pos:[17,404] width:90 height:23
	GroupBox grp1 "发光方式：" pos:[11,15] width:209 height:50
	checkbox chk1 "物体" pos:[20,40] width:50 height:17 checked:true
	checkbox chk2 "表面" pos:[85,40] width:50 height:17
	checkbox chk3 "图片" pos:[150,40] width:50 height:17
	checkbox chk4 "闪动" pos:[14,73] width:49 height:19 checked:true
	spinner spn1 "变换时间长度" pos:[38,101] width:180 height:16 range:[0,10000,100]
	spinner spn2 "闪动时间长度" pos:[38,125] width:180 height:16 range:[0,100,2]
	GroupBox grp2 "颜色选项：" pos:[12,157] width:205 height:101
	checkbox chk5 "单色" pos:[20,179] width:50 height:17 checked:true
	checkbox chk6 "单彩" pos:[85,179] width:50 height:17
	checkbox chk7 "多彩" pos:[150,179] width:50 height:17
	GroupBox grp3 "图片方式项：" pos:[9,274] width:215 height:244
	button btn4 "清除图片" pos:[129,404] width:90 height:23
	label lbl1 "    图片尺寸：0/0" pos:[49,436] width:141 height:17
	spinner spn5 "灯格长" pos:[38,459] width:70 height:16 range:[0,100000,10]
	spinner spn6 "灯格宽" pos:[139,459] width:71 height:16 range:[0,100000,10]
	spinner spn7 "灯格比例" pos:[38,488] width:81 height:16 range:[1,100,1]
	button btn7 "计算" pos:[140,487] width:53 height:18
	button btn8 "霓虹灯" pos:[12,524] width:211 height:23
	progressBar pb1 "ProgressBar" pos:[15,554] width:210 height:13
	spinner spn8 "数量" pos:[93,209] width:117 height:16 range:[1,100,10] type:#integer
	spinner spn9 "速度" pos:[93,236] width:117 height:16 range:[0,100,2]
	
	local lstate=1
	local cstate=1
		 
	
	on btn1 pressed do
	(	
	 c= selectbitmap caption:"11"
	 w=c.width-0
	 h=c.height
		bmp1.bitmap=c
		 
		
	lbl1.text="图片尺寸： "+w as string +"/"+h as string
		spn5.value=w/100 
		spn6.value=h/100
		 
	)
	on btn4 pressed do
	(
		bmp1.bitmap=undefined
		lbl1.text="    图片尺寸：0/0"
		)
		
		on btn7 pressed  do
		(
			spn5.value=spn5.value*spn7.value
			spn6.value=spn6.value*spn7.value
			
			)	
		
	on chk1 changed state do
	(
	 chk1.checked=true 
	 chk2.checked=false
	 chk3.checked=false
	 lstate=1
	
	)
	on chk2 changed state do
	(
	 chk2.checked=true 
	 chk1.checked=false
	 chk3.checked=false
	 lstate=2
	format"33\n"
	)
	on chk3 changed state do
	(
	 chk3.checked=true 
	 chk1.checked=false
	 chk2.checked=false
	 lstate=3
	
	)
	on chk5 changed state do
	(
	 chk5.checked=true 
	 chk6.checked=false
	 chk7.checked=false
	 cstate=1
	
	)
	on chk6 changed state do
	(
	 chk6.checked=true 
	 chk5.checked=false
	 chk7.checked=false
	 cstate=2
	
	)
	on chk7 changed state do
	(
	 chk7.checked=true 
	 chk5.checked=false
	 chk6.checked=false
	 cstate=3
	
	)
	on btn8 pressed do
	(
		
		if lstate==1 then
		(
			if selection.count==0 then messagebox "请先选择一个物体"
				else 
			(
			ac=selection
			converttopoly ac  
			if cstate==1 then 
			( 
				for o in selection do 
				(	   m=StandardMaterial ()
				       m.ambient = ( color 255 255 255 )  
	                   m.Diffuse = ( color 255 255 255 )  
				  if chk4.state==true then 
					 (
						  if random -1 1 >=0 then k=1 else k=-1
						for i=0 to spn1.value by spn2.value do
						  (
							set animate on 
							   if k==1 then	at time i m.selfIllumAmount=100
								if k==-1 then at time i m.selfIllumAmount=0
									set animate off
										k=-k
							)
					 )
					 o.material=m
				)
					  
			)
			
			if cstate==2 then
			(
				  
				for o in selection do 
				(	   m=StandardMaterial ()
				       m.ambient = random ( color 0 0 0 ) (color 255 255 255 )
	                   m.Diffuse = m.ambient 
				  if chk4.state==true then 
					 (
						  if random -1 1 >=0 then k=1 else k=-1
						for i=0 to spn1.value by spn2.value do
						  (
							set animate on 
							   if k==1 then	at time i m.selfIllumAmount=100
								if k==-1 then at time i m.selfIllumAmount=0
									set animate off
										k=-k
							)
					 )
					 o.material=m
				 
				
				)
		  )
		  
			if cstate==3 then
			(
				 
				for o in selection do 
				(	   
					  m=StandardMaterial ()					  
				       m.ambient = random ( color 0 0 0 ) (color 255 255 255 )
	                   m.Diffuse = m.ambient 
				  if chk4.state==true then 
					 (
						  if random -1 1 >=0 then k=1 else k=-1
						for i=0 to spn1.value by spn2.value do
						  (
							set animate on 
							   if k==1 then	(at time i m.selfIllumAmount=100;)
								if k==-1 then (at time i m.selfIllumAmount=0;)
									set animate off
										k=-k
							)
							
					 )
					 for i=0 to spn1.value by spn9.value do
						  (
							        set animate on 
							    	  at time i m.ambient = random ( color 0 0 0 ) (color 255 255 255 )
							           at time i m.Diffuse = m.ambient  
								 	   set animate off
										 
							)
					 o.material=m
				 
				
				)
		  )
	  
	  )
		
	  )
	  
	  if lstate==2 then 
	  ( 
		    if selection.count==0 then messagebox"请先选择一个物体"
				else
		(
		  ac=selection
			converttopoly ac  
		   for o in selection do 
		   (
		      n= polyop.getnumfaces o
			    m= Multimaterial ()
		        m.materialList.count = spn8.value
			           for i=1 to spn8.value do 
						    m.materialIDList[i] = i
					   for i=1 to spn8.value do 
					   (
					     for  j=0 to spn1.value by spn9.value do		
				           (  
						      set animate on 
					           at time j	m.materialList[i].ambient =random ( color 0 0 0 ) (color 255 255 255 )
					              at time j   m.materialList[i].Diffuse =m.materialList[i].ambient
						       set animate off 						
					        )					 
					         if chk4.state==true then
					         ( 
						        if random -1 1 >=0 then k=1 else k=-1
						            for h=0 to spn1.value by spn2.value do
						       (
							      set animate on 
							        if k==1 then	(at time h m.materialList[i].selfIllumAmount=100;)
								      if k==-1 then (at time h m.materialList[i].selfIllumAmount=0;)
									set animate off
										k=-k
							    )
						      )
							  pb1.value=(((i as float)/spn8.value)*100) as integer
					   )
						for i=1 to n do
					polyOp.setFaceMatID o i (random 1 spn8.value)
					pb1.value=0
				    o.material=m
				)
				
		)
	  )
	  
	  
	  if lstate==3 then 
	  (
		 if  bmp1.bitmap==undefined do messagebox"请先选择图片！"
			 
		   if bmp1.bitmap!=undefined then 
		   (
			    n=(spn5.value*spn6.value)as float 
			      np=0.0
			     gapw=( bmp1.bitmap.width/spn5.value)as integer
			     gaph=(bmp1.bitmap.height/spn6.value)as integer
			   for i=1 to spn5.value do
			    for j=1 to spn6.value do
			    (
					a=plane length:10 width:10 pos:[i*10,-j*10,0]
					mp=(getpixels bmp1.bitmap [((i-1)*gapw+1),((j-1)*gaph+1)] 1)[1]
					   m=StandardMaterial ()					  
				       m.ambient = mp
	                   m.Diffuse = mp
					if chk4.state==true then 
					 (
						  k=1
						for i=0 to spn1.value by spn2.value do
						  (
							set animate on 
							   if k==1 then	(at time i m.selfIllumAmount=100;)
								if k==-1 then (at time i m.selfIllumAmount=0;)
									set animate off
										k=-k
							)
							
					 )
					 a.material=m
					 np+=1.0
					 pb1.value=((np/n)*100)as integer
				)
				pb1.value=0
			)
			   
		)
		  
		  
		  
		  
		   
	)
)
createdialog nihongdeng