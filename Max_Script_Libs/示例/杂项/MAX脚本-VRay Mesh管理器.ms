








rollout vrayziding "" width:320 height:300
(
MultiListBox allvrayproxy "显视VRay Mesh路径" selection:0 width:350 height:20 across:2 
button   selmisproxy "丢失的VRay Mesh " pos:[370,25] width:120 height:20
button   selallproxy "选择VRay Mesh" pos:[370,50] width:120 height:20
button   copyproxy "复制VRay Mesh" pos:[370,75] width:120 height:20

edittext  setpathsel pos:[10,300] width:315 height:20

button   openfilepath "..." pos:[335,300] width:30 height:20

button   setpathbutton "指定" pos:[370,300] width:120 height:20

--global allproxy=#()
on vrayziding open do 

( global allproxy=#()

for i in geometry  do
 (if  classof i == VRayProxy and finditem allproxy i.filename == 0 
 do append allproxy i.filename

)

allvrayproxy.items=allproxy

)

on selallproxy  pressed do 
(local selproxy=#()
listnum=allvrayproxy.selection

for i=1 to listnum.count do 
(
--selproxy=#()
  for m in allvrayproxy.selection do 
 ( for i in geometry  do
 (
 if  classof i == VRayProxy and  i.filename == allproxy[m] do  
  (if finditem selproxy i == 0 do append  selproxy i
   )
)

)


)
clearSelection()
for nn in selproxy do (selectmore  nn)


)


on selmisproxy pressed do 
(misproxy=#{}
for s=1 to allproxy.count do
(if doesfileexist allproxy[s]==false do append misproxy s
)

--allvrayproxy.items=allproxy
allvrayproxy.selection=misproxy

)
on copyproxy pressed do 
(file=getsavepath()
for i in allvrayproxy.selection do 
(tempfile=file+"\\"+(filenamefrompath allproxy[i])
copyfile allproxy[i] tempfile

)


)

on openfilepath pressed do 
(openpath=getsavepath()
setpathsel.text=openpath

)
on setpathbutton pressed do
(

--aaab=setpathsel.text+"\\"+(filenamefrompath allproxy[i])
  for m in allvrayproxy.selection do 
 ( for i in geometry  do
 (
 if  classof i == VRayProxy and  i.filename == allproxy[m] do  
  (aaab=setpathsel.text+"\\"+(filenamefrompath i.filename)
  i.filename=aaab
  allproxy[m]=aaab
  allvrayproxy.items=allproxy
   )
)

)



)







)
if rof!=undefined do closerolloutfloater rof
rof=newrolloutfloater "徐婧媛专用MAX脚本-VRay Mesh管理器" 510 350
  addrollout vrayziding rof
