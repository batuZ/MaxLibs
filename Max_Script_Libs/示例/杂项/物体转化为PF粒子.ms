-- by ±¾.Ç¿Ç¿(qq:42564365) 
-- v 1.0
-- created on:1/12/2005
--tested using max 7.5
-----------------------------------------
--Description:convert selectiion geometry to pf with object's transform and mesh
-----------------------------------------
--(
objToPf_obj=#()
for obj in selection do (ResetXForm obj;convertToMesh obj; append objToPf_obj obj.name)
num=objToPf_obj.count
cmd="
on ChannelsUsed pCont do
(
	pCont.useTime = true 
	pCont.useAge = true
	pCont.usePosition = true
	pCont.useSpeed = true
	pcont.useShape = true
)
on Init pCont do 
(
	global objToPf_st=animationRange.start
	global objToPf_obj = #("
for s in objToPf_obj do cmd+=("$"+s+",")
cmd[cmd.count]=""
cmd+=")
)
on Proceed pCont do 
(
	t1=pCont.getTimeStart()
	if pCont.NumParticles()<1 and t1<objToPf_st do for i=1 to "+num as string+" do
	(
			pCont.AddParticle()
			pCont.particleIndex = i
			pCont.particleTime=0
			pCont.particleAge = 0
			pCont.particlePosition = objToPf_obj[i].pos
			pcont.particleShape=objToPf_obj[i].mesh
			pCont.particleSpeed = [0, 0, 0]
	)
)
on Release pCont do 
(
 
)
"

pfs = PF_Source()
ParticleFlow.BeginEdit()
new_event = Event()
rdr=RenderParticles()
pfs.appendInitialActionList new_event
pfs.appendAction rdr
brt=birth_Script()
brt.name="objToPf"
dsp=DisplayParticles type:6
new_event.appendAction brt
new_event.appendAction dsp
brt.Proceed_Script=cmd
ParticleFlow.EndEdit()
hide selection; clearSelection(); select pfs
--)