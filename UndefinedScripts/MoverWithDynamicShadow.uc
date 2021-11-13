//Created by "EVILemitter"
//Date: 22/12/2005 22:37:28
class MoverWithDynamicShadow extends Mover;	//Not Placeable

var transient ShadowProjector MoverShadow;
var transient bool bProjUse;
//==================================

//User interface
var() bool bBlobShadow,bUseDynamicShadow;
var() vector DirLight;
var() float DistLight;
var() int MoverMaxTraceDistance;
//==================================

simulated function Destroyed()
{
    if( MoverShadow != None ) MoverShadow.Destroy();
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();
	bProjUse = bool(ConsoleCommand("get ini:Engine.Engine.ViewportManager Projectors"));
    if(bUseDynamicShadow && bProjUse && bActorShadows && (Level.NetMode != NM_DedicatedServer))
    {
        MoverShadow = Spawn(class'ShadowProjector',self,'cmdMoveDShadow',Location);
        MoverShadow.ShadowActor = self;
        MoverShadow.bBlobShadow = bBlobShadow;
        MoverShadow.LightDirection = Normal(DirLight);
        MoverShadow.LightDistance = DistLight;
        MoverShadow.MaxTraceDistance = MoverMaxTraceDistance;
        MoverShadow.InitShadow();
    }
}

defaultproperties
{
	bActorShadows=True
	bBlobShadow=False
	bUseDynamicShadow=True
	bDynamicLightMover=True
	bShadowCast=False
	DirLight=(X=1.000000,Y=1.000000,Z=3.000000)
	DistLight=320.000000
	MoverMaxTraceDistance=3500
}