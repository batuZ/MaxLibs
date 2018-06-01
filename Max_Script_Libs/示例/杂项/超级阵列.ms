newwin=newrolloutfloater "Array" 270 270
rollout array1 "array"
(
local this,p1
pickbutton pick "Pickobj"
label obj_name
spinner xnum "X Number" type:#integer range:[1,1000,2] align:#center fieldwidth:60
spinner ynum "Y Number" type:#integer range:[1,1000,2] align:#center fieldwidth:60
button creat "Array"
tool creat1
(
on mousepoint click do
(if click==1 then p1=gridPoint
if click==3 do
(in (dummy pos:p1)
for i=0 to xnum.value-1 do 
for j=0 to ynum.value-1 do
(x=griddist.x
&nbsp;&nbsp; y=griddist.y
&nbsp;&nbsp; copy this pos: (p1+[(x/(xnum.value-1))*i,(y/(ynum.value-1))*j,0])
)
&nbsp;&nbsp;#stop
)

)
)
on pick picked obj do
(this=obj;obj_name.text=this.name
)
on creat pressed do (starttool creat1 snap:#3D)
)
addrollout array1 newwin

