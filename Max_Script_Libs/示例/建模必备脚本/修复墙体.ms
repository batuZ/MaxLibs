try(
sel_1 = $ 
sel_2 = copy sel_1 
num = numSplines sel_1 
for i in num to 2 by -1 do deleteSpline sel_1 i 
deleteSpline sel_2 1
addAndWeld sel_1 sel_2 0
updateshape sel_1
)catch()