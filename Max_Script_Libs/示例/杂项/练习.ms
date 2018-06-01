
-- for循环练习 建一排球
-- for i=1 to 100 do
-- ( 
-- 	a = (10+i) + (10+i+1) + b 
-- 	Sphere radius:(10+i) pos:[a,0,0]
-- 	b = a
-- 	--扩展其它用法
-- 	)



--if判断练习 删掉上面创建的球中半径为半径为单数的

--   --全选 
max select all
for aball in selection do
(
	--if判断球半径的值是不是单数
	if(aball.radius > 0)
	then
	(
		delete aball
		)
		else
		(
			aball.radius = 5
			)
	)


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	