macroScript haha ButtonText:"poly随机选面" category:"poly随机选面" tooltip:"poly随机选面"
(

pt=#()

fn select_face  obj num=
(      
    pt=#()
	numface=polyop.getnumfaces obj
	for e = 1 to num do
	(
	r=random 1 numface
	append pt r	
	)
	polyOp.setFaceSelection obj pt
	update obj
)

rollout ll "Untitled" width:162 height:94
(
	spinner spn1 "选择面数：" pos:[19,25] width:131 height:16 range:[0,10000,0] type:#integer scale:1
	button btn1 "New_seed" pos:[29,55] width:104 height:23
	
	on spn1 changed val do
	(
	select_face $ spn1.value
	)
	on btn1 pressed do
	(
	select_face $ spn1.value
	)
)createdialog ll
)