
	
  if selection.count==0 then
	(
	PushPrompt "请先选择物体..."
	)
	else
	(
	converttopoly $
	max group explode
	--------------------------------提出所选物体的材质：-------------------
	sel=(selection as array)
	mtl=#()
	append mtl sel[1].material

	for e in sel do
	(
	n=0
	for m in mtl do
	(
	try
	(
	if e.material==m then
	(
	n+=1
	)
	)catch()
	)
	if n==0 then
	(
	append  mtl e.material 
	)
	)

	----------------------------------------END------------------------------------------


	--------------------------------按材质分别塌陷物体：-------------------
	progressstart "Easyfrog_Collapse():"
	for e=1 to mtl.count do
	(
	progressupdate (100.0 * e / mtl.count)
	ef=#()
	for s = 1 to selection.count do 
	(
	if selection[s].material==mtl[e] then
	(
	append ef selection[s]
	)
	)

	for n=1 to ef.count do
	(
	try
	(
	polyop.attach ef[1] ef[n+1]
	)catch()
	)
    
	)
	converttomesh $
	progressEnd()
	)
	----------------------------------------END------------------------------------------
