
rollout jiaodu "3点角度__ACE"   width:150 height:70 
(
	editText Text_1 "角度值:" 	width:130 height:15 --enabled:false 
	button btn1 "3点测量" width:100 height:20  
	label la1 "拾取第1点"   visible:false --across:2
on btn1 pressed do 		
(
try(	
	la1.visible = true 
	Text_1.text= ""
	la1.text = "拾取第1点" 
	p1=pickpoint snap:#3d 

	if p1 != undefined then 
	(
		p2=pickpoint snap:#3d rubberBand:p1
		la1.text = "拾取第2点"
		if p2 != undefined then 
		(
			p3=pickpoint snap:#3d rubberBand:p2  
			la1.text = "拾取第3点"
			a1 = p3 - p2
			a2=  p1 - p2
			N1 = normalize a1
			N2 = normalize a2
			aa = acos (dot N1 N2)
			la1.visible = false 
			Text_1.text= aa as string		
		)
	)
)catch()
)

)
createdialog jiaodu	



 