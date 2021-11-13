//Created by "EVILemitter"
//Date: 23/05/2006 16:05:46
//==================================================================
class ALLDynamicSkyBox extends SkyZoneInfo; //showcategories(Movement);

var() bool bUseRotation;
var() float ScaleLoc;
var transient vector OldLoc;
var transient rotator OldRot;
var transient PlayerController PC;

simulated function PostBeginPlay()
{
	OldLoc = Location;
	OldRot = Rotation;
	if(ScaleLoc <= 1.0f) ScaleLoc = 1.0f;
	if(PC==None) PC = Level.GetLocalPlayerController();
}

simulated function PostNetBeginPlay()
{
	if(PC==None) PC = Level.GetLocalPlayerController();
}

simulated function Tick(float d)
{
 if(PC != None && PC.ViewTarget != None)
 {
	SetLocation(OldLoc+(PC.ViewTarget.Location/ScaleLoc));
	if(bUseRotation) SetRotation(OldRot+PC.ViewTarget.Rotation);
 }
}

defaultproperties
{
 bStatic=False
 ScaleLoc=4.00
 bUseRotation=False
}