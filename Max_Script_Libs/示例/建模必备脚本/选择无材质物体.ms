

pt=#()
for e in geometry do
(
if e.material==undefined then 
append pt e
)
for s in shapes do
(
if s.material==undefined then
append pt s
)
select pt
