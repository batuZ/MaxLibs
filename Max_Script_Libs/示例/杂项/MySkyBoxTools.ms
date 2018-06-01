
resetmaxfile #noPrompt;
mapPaht = getOpenFileName types:"JPG|*.jpg" -->"Data(*.dat)|*.dat|Excel(*.csv)|*.csv|All|*.*|";
savePath = getsavepath caption:"Save Folder";
try(
--> create camera
Targetcamera fov:90 pos:[0,0,0] name:"UP" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [0,0,100]));
Targetcamera fov:90 pos:[0,0,0] name:"DN" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [0,0,-100]));
Targetcamera fov:90 pos:[0,0,0] name:"RT" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [100,0,0]));
Targetcamera fov:90 pos:[0,0,0] name:"BK" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [0,-100,0]));
Targetcamera fov:90 pos:[0,0,0] name:"LF" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [-100,0,0]));
Targetcamera fov:90 pos:[0,0,0] name:"FR" target:(Targetobject transform:(Matrix3 [1,0,0]	[0,1,0] [0,0,1] [0,100,0]));
	
--> create skyball
ball = Sphere radius:1000 segs:128 pos:[0,0,0] isselected:true;

--> change Normals
convertToMesh ball;
meshop.flipNormals ball	ball.faces;

--> UVWMap
max modify mode;
addModifier ball (Uvwmap());
ball.modifiers[1].maptype = 2;
	
--> material
ball.material = meditMaterials[1];
ss=ball.material;
ss.selfIllumamount = 100;
ss.diffuse = color 255 255 255;
ss.ambient = color 255 255 255;
ss.specular = color 255 255 255;
ss.diffuseMap = Bitmaptexture filename:mapPaht;
	
--> outPut
render camera:$UP outputSize:[1024,1024] outputFile:(savePath + @"\UP.jpg");
render camera:$DN outputSize:[1024,1024] outputFile:(savePath + @"\DN.jpg");
render camera:$RT outputSize:[1024,1024] outputFile:(savePath + @"\RT.jpg");
render camera:$BK outputSize:[1024,1024] outputFile:(savePath + @"\BK.jpg");
render camera:$LF outputSize:[1024,1024] outputFile:(savePath + @"\LF.jpg");
render camera:$FR outputSize:[1024,1024] outputFile:(savePath + @"\FR.jpg");
	resetmaxfile #noPrompt;
	messageBox("OK!");
)catch(
resetmaxfile #noPrompt;
messageBox("Failed!");
)