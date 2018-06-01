
--MacroScript sbrotate
--category:"傻瓜旋转"
--Tooltip:"傻瓜旋转" 
--buttontext:"傻瓜旋转" 
(
global frraa

rollout myy "傻瓜旋转"
(
button st " 转水平 " 
button tg " 与选择平行 " 
button sbclose "关闭" 

on st pressed do
(
local pp1,pp,pp2,p1,p2,b,ddd,c,e,eea,aaa
 pp1=pickpoint prompt:"\n" snap:#3d 
if classOf pp1== Point3   do pp=pickpoint prompt:"\n" snap:#3d rubberBand:pp1
if classof pp1==point3 and classof pp==point3 then
(
c=rectangle()
c.width=(distance pp1 pp)
c.length=0
c.pos=[pp.x-c.width/2,pp.y,pp.z]
sbs=#()
for nnm in selection do
(
if (isgrouphead nnm)==false do append sbs nnm
)
sbs.pivot=pp
aaa=acos((Pp.X-Pp1.X)/(distance pp1 pp))
if aaa<0 do aaa+=180
if pp.y>pp1.y then in coordsys screen ROTATE sbs (eulerangles 0 0 -aaa) else in coordsys screen ROTATE sbs (eulerangles 0 0 aaa)
c.pivot=pp
if pp.y>pp1.y then in coordsys screen ROTATE c (eulerangles 0 0 aaa) else in coordsys screen ROTATE c (eulerangles 0 0 -aaa)
addmodifier c (extrude())
c.extrude.amount=0
)
)
on tg pressed do
(

local pp1,pp,pp2,p1,p2,b,ddd,c,e,eea,aaa
pp1=pickpoint prompt:"\n" snap:#3d 
if classOf pp1 == Point3   do pp=pickpoint prompt:"\n" snap:#3d rubberBand:pp1
if classof pp1==point3 and classof pp==point3 then
(
sbs=#()
for nnm in selection do
(
if (isgrouphead nnm)==false do append sbs nnm
)
sbs.pivot=pp
aaa=acos((Pp.X-Pp1.X)/(distance pp1 pp))
if aaa<0 do aaa+=180
if pp.y>pp1.y then in coordsys screen ROTATE sbs (eulerangles 0 0 aaa) else in coordsys screen ROTATE sbs (eulerangles 0 0 -aaa)
)
)
on sbclose pressed do closerolloutfloater frraa
)
if  frraa!= undefined then
(
 closerolloutfloater frraa
frraa=undefined
 )
frraa=newrolloutfloater "my floater" 150 150 600 600
addrollout myy frraa

)