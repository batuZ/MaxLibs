

(
	fn select0FaceObj =
( 
	clearSelection()
	num=0
	for obj in geometry do (fv=getPolygonCount obj ;if fv[1]==0 do (num+=1;selectMore obj) )
	pushPrompt (num as string+" objects are zero face")
) 
select0FaceObj()
)