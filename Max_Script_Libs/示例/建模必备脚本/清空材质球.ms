
		for i=1 to meditmaterials.count do 
		(
			meditmaterials[i]=standard()
			meditmaterials[i].name=(i as string+"-Default")
		)
		for i=1 to 24 do updateMTLInMedit meditmaterials[i]
		max mtledit
