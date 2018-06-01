(
f = getOpenFileName caption:"²ÄÖÊÎÄ¼þ:" filename:"*.mat" types:"Material Libraries(*.mat)|(*.mat)|3ds Max(*.Max)|(*.Max)|VIZ Render(*.drf)|(*.drf)|3ds Max Characters(*.chr)|(*.chr)|"
if f != undefined then
(
		new = #()
		tmp = loadTempMaterialLibrary f
		if tmp.count > 24 and meditMaterials[1].name == tmp[1].name  then
		(for i = 25 to 48 do append new tmp[i])
		if tmp.count > 48 and meditMaterials[1].name == tmp[25].name  then
		(for i = 49 to 72 do append new tmp[i])
		if tmp.count > 72 and meditMaterials[1].name == tmp[49].name  then
		(for i = 73 to 96 do append new tmp[i])
		if tmp.count > 96 and meditMaterials[1].name == tmp[73].name  then
		(for i = 97 to 120 do append new tmp[i])
		if tmp.count > 120 and meditMaterials[1].name == tmp[97].name  then
		(for i = 121 to 144 do append new tmp[i])
		else (for i = 1 to 24 do append new tmp[i])
		for i=1 to 24 do meditMaterials[i] = standard name:(i as string + " - Default")
		for i = 1 to new.count do (setMeditMaterial i new[i])

)
)