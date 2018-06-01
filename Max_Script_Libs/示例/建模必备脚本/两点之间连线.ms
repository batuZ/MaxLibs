
(
on execute do
(
oldname=$.name
pp=#()
if numsplines!=1 then
(
for i=1 to (numsplines $) do
(
a=getknotselection $ i
if a.count==1 then
(
pointA=getknotpoint $ i (a[1])
append pp pointA
)
else if a.count==2 then
(
pp[1]=getknotpoint $ i (a[1])
pp[2]=getknotpoint $ i (a[2]))
)
)
undo on
(
fn drawLineBetweenTwoPoints pointA pointB =
(
ss = SplineShape pos:pointA name:"newline"
addNewSpline ss
addKnot ss 1 #corner #line PointA
addKnot ss 1 #corner #line PointB
updateShape ss
ss
)
try
(
newSpline = drawLineBetweenTwoPoints pp[1] pp[2] 
addAndWeld $ $newline  0.1
--select $newline
--$.name=oldname
subobjectLevel = 1
)
catch()
)
)
)
