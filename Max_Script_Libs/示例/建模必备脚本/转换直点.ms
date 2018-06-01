(
sel=selection[1]
if sel!=undefined and (classof sel == SplineShape or classof sel == line) then
( numS=numSplines sel
 for i in 1 to numS do
 ( selKnots = getKnotSelection sel i
  for k in selKnots do setKnotType sel i k #corner
 )
 updateshape sel
)
)

