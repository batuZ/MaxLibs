--macroScript haha ButtonText:"车行线" category:"车行线" tooltip:"车行线"
(
rollout cxx "车行线制做" width:200 height:150
(
	spinner cd "车行线的长度" pos:[12,24] width:181 height:16 enabled:true range:[0,100000,5000] type:#float
	spinner kuan "车行线的宽度" pos:[12,56] width:181 height:16 range:[0,5000,150] type:#float
	button ok "OK！开整！！" pos:[36,100] width:132 height:30
	on ok pressed do
	(
	undo on
	(
	    addmodifier $ (normalize_spl())
	     $.modifiers[#normalize_spl].length=cd.value
	       macros.run "Modifier Stack" "Convert_to_Spline"
		   for e in 1 to (numsplines $) do
		   (
			for i in 1 to (numsegments $ e) by 2 do 
			(
			setsegselection $ e #(i) keep:(if i==1 then false else true)
			)
			)
			macros.run "Modifier Stack" "SubObject_2"
			actionMan.executeAction 0 "40020"
			modPanel.setCurrentObject $.baseObject
		    a=$
			applyoffset $ kuan.value
              select a 
			macros.run "Modifier Stack" "Convert_to_Mesh"
            $.castShadows = off
            move $ [0,0,10]
	         clearSelection() 
			 )
		)
)createdialog cxx
)
