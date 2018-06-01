fn unifyFileName obj=
(

noDifMap=#()

obj.material.name=obj.name
meditmaterials[1]=obj.material

num=meditmaterials[1].count
for i in 1 to num do
	(
		meditmaterials[1].materiallist[i].shadertype=1
		if (meditmaterials[1].materiallist[i].diffusemap==undefined)
		then
		(
			append noDifMap i
		)
		else 
		(
		showtexturemap meditmaterials[1].materiallist[i] meditmaterials[1].materiallist[i].diffusemap on 
		zxname=meditmaterials[1].materiallist[i].diffusemap.filename
		zxname=getfilenamefile zxname 
		meditmaterials[1].materiallist[i].name=zxname
		meditmaterials[1].materiallist[i].diffusemap.name=zxname
		if meditmaterials[1].materiallist[i].opacitymap!=undefined
		then
			(
				meditmaterials[1].materiallist[i].opacitymap.name=zxname+"_alpha"
			)
		)

	)

if(noDifMap.count!=0)
do
	(
		indexArr=""
		for i in noDifMap do
		(
			indexArr+=(i as string)+"#\n"
		)
		indexArr+="noDiffuseMap"
		messagebox (indexArr)
	)

)



fn zxcleanmul=
(


struct aMat (theInstance, theDiffusemap)


	theObj=$
	     select $
		--if classof obj != Editable_mesh do
		--	if canConvertTo obj mesh then
		--		convertToMesh obj
		--	else
		--		throw "Cannot convert object to Editable Mesh"
		macros.run "Modifier Stack" "Convert_to_Mesh"
		----PickObj.text=obj.name
		
		theMat=$.material --获取材质
		if classof theMat != Multimaterial do throw "Object Material not a MultiMaterial"
	----	l_nSubMat_n.text=theMat.numsubs as string
		 SubMatUsed=#()
		for f=1 to $.numfaces do
			SubMatUsed[getFaceMatID $ f]=true
		    
		    uniqueMats=#()
		    mapTo=#()
		for m=1 to theMat.numsubs do  
		(	if SubMatUsed[m] != true do continue
			 thisMatDBitmap=undefined
			if classof theMat[m] == StandardMaterial do
				if classof theMat[m].diffusemap == Bitmaptexture do
					thisMatDBitmap=theMat[m].diffusemap.filename
			if thisMatDBitmap == undefined do
			(	append uniqueMats (aMat theMat[m] thisMatDBitmap)
				mapTo[m]=uniqueMats.count
				continue
			)
			 foundMatch=false
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
	-----	l_nUniqueSubMat_n.text=uniqueMats.count as string
	
     	 NewMMat=Multimaterial numsubs:uniqueMats.count name:($.name)
		for m=1 to uniqueMats.count do
			NewMMat[m]=copy uniqueMats[m].theInstance
		for f=1 to $.numfaces do
		(	local oldID=getFaceMatID theObj f
			setFaceMatID $ f mapTo[oldID]
		)
		$.material=NewMMat
		update $
				
		meditMaterials[1]=$.material
	   	     a=meditMaterials[1].materialIDList
			 for i = 1 to a.count do 
				(
				showTextureMap meditMaterials[1].materialList[a[i]] on
				)
				
	meditMaterials[1] = Standardmaterial ()

macros.run "Modifier Stack" "Convert_to_Poly"
	
)

fn clearMat=
(
	for i in 1 to 24 do
	(
		meditmaterials[i]=standardmaterial()
	)
)



rollout det "unifyGeometry" width:180 height:96
(
	GroupBox grp1 "unifyGeometry" pos:[4,7] width:169 height:84
	button zxchange "start" pos:[49,26] width:64 height:21 toolTip:"选择要转换的一个多维物体"
	HyperLink airstick "www.airstick.net" pos:[90,69] width:78 height:15 address:"www.airstick.net"

	on zxchange pressed do
	(
		
		if((selection.count==1)  and  ((superclassof $)==GeometryClass) and ( (classof $.material)== Multimaterial )    )
		do
		(
		zxcleanmul ()  
		unifyFileName $
		clearMat()
		)
	)
)


zx=newrolloutfloater "unifyGeometry" 200 150 
addrollout det zx