//Created by "EVILemitter"
//Принцип работы см. класс "MoverWithDynamicShadow"
//Date: 22/12/2005 22:30:02
class KarmaShadow extends KActor;
//===================================================

//Karma properties (Not for User)
var transient ShadowProjector KarmaShadow;
var transient bool bUseProj;
//==================================

//User interface
var() bool bBlobShadow,bUseDynamicShadow;
var() vector NapravlenieSveta;
var() float DistanciyaSveta;
var() int KarmaMaxTraceDistance;
//==================================

simulated function Destroyed()
{
    if( KarmaShadow != None )
        KarmaShadow.Destroy();
}

simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
	bUseProj = bool(ConsoleCommand("get ini:Engine.Engine.ViewportManager Projectors"));
    if(bUseDynamicShadow && bUseProj && bActorShadows && (Level.NetMode != NM_DedicatedServer))
    {
        KarmaShadow = Spawn(class'ShadowProjector',self,'KS_SP',Location);
        KarmaShadow.ShadowActor = self;
        KarmaShadow.bBlobShadow = bBlobShadow;
        KarmaShadow.LightDirection = Normal(NapravlenieSveta);
        KarmaShadow.LightDistance = DistanciyaSveta;
        KarmaShadow.MaxTraceDistance = KarmaMaxTraceDistance;
        KarmaShadow.InitShadow();
    }
}

defaultproperties
{
	bActorShadows=True
	bBlobShadow=False
	bUseDynamicShadow=True
	bShadowCast=False
	NapravlenieSveta=(X=1.000000,Y=1.000000,Z=3.000000)
	DistanciyaSveta=320.000000
	KarmaMaxTraceDistance=3500
	StaticMesh=StaticMesh'AS_Decos.ExplodingBarrel'
}