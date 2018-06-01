filePath = @"E:\test\222\Tile\Tile.txt"
dirPath = @"E:\test\222\Tile\"
fs = OpenFile filePath

	global	MinRange
	global Radius
	global	CenterX
	global	CenterY
	global	CenterZ
	global	modelName 

while not eof fs do 
(
	strline =  readLine fs
	if findString strline "</MinRange>" != undefined 
		then  
	(
		begin =	findString strline "<MinRange>"+10
		end =findString strline "</MinRange>"
		MinRange = substring strline begin (end-begin)
		)
	if findString strline "</Radius>" != undefined 
		then
	(
		begin =	findString strline "<Radius>"+ 8
		end = findString strline "</Radius>"
		Radius = substring strline begin (end-begin)
		)
	if findString strline "<Center x=" != undefined 
		then
	(
		a1 = findString strline "<Center x=\""
		a2 = findString strline "\" y=\""
		a3 = findString strline "\" z=\""
		a4 = findString strline "\"/>"
		CenterX = substring strline (a1 + 11) (a2 - a1 - 11) as Number
		CenterY = substring strline (a2 + 5) (a3 - a2-5) as Number
		CenterZ = substring strline (a3 + 5) (a4 - a3-5) as Number
		)
	if findString strline "</ModelPath>" != undefined 
		then
	(
		begin =	findString strline "<ModelPath>"+ 11
		end = findString strline "</ModelPath>"
		modelName = substring strline begin (end - begin)
		
		format "modelName : % \n" modelName
		format "MinRange:   % \n" MinRange
		format "Radius:		% \n" Radius
		format "CenterX:	% \n" CenterX
		format "CenterY:	% \n" CenterY
		format "CenterZ:	% \n" CenterZ
		format " \n" 
		
		 importFile (dirPath + modelName) #noPrompt 
		$.pos = [CenterX,CenterY,CenterZ]
		$.name = modelName
		
		--≥ı ºªØ
		MinRange = undefined
		Radius = undefined
		CenterX = undefined
		CenterY = undefined
		CenterZ = undefined
		modelName = undefined 
		)

	

	)