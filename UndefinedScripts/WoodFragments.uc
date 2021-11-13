//Date: 25/11/2005 15:45:38
class WoodFragments extends Fragment;

var() sound    MiscSound;
var() float ExploSize;
var class<DamageType> BS;

simulated function CalcVelocity(vector Momentum)
{
	local float ExplosionSize;

	ExplosionSize = 0.011 * VSize(Momentum);
	Velocity = VRand()*(ExplosionSize+FRand()*150.0+100.0 + VSize(Momentum)/80);
}

simulated function NewCalcVelocity(vector Momentum,float ExplosionSize)
{
	Velocity = VRand()*(ExplosionSize+FRand()*150.0+100.0 + VSize(Momentum)/80); 
}

auto state Flying
{
	simulated function timer()
	{
		super.Timer();
	}

	simulated function BeginState()
	{
		RandSpin(125000);
		if (RotationRate.Pitch>-10000&&RotationRate.Pitch<10000)
			RotationRate.Pitch=10000;
		if (RotationRate.Roll>-10000&&RotationRate.Roll<10000)
			RotationRate.Roll=10000;
		LinkMesh(Fragments[int(FRand()*numFragmentTypes)]);
		if ( Level.NetMode == NM_Standalone )
			LifeSpan = 20 + 40 * FRand();
		SetTimer(5.0,True);
	}
}

defaultproperties
{
	 BS=class'Engine.DamageType'
     Fragments(0)=LodMesh'AFM_Res.wfrag1'
     Fragments(1)=LodMesh'AFM_Res.wfrag2'
     Fragments(2)=LodMesh'AFM_Res.wfrag3'
     Fragments(3)=LodMesh'AFM_Res.wfrag4'
     Fragments(4)=LodMesh'AFM_Res.wfrag5'
     Fragments(5)=LodMesh'AFM_Res.wfrag6'
     Fragments(6)=LodMesh'AFM_Res.wfrag7'
     Fragments(7)=LodMesh'AFM_Res.wfrag8'
     Fragments(8)=LodMesh'AFM_Res.wfrag9'
     numFragmentTypes=9
     ImpactSound=Sound'AFM_Res.General.WoodHit1'
	 AltImpactSound=Sound'AFM_Res.General.WoodHit2'
     MiscSound=Sound'AFM_Res.General.WoodHit2'
	 Skins(0)=Texture'AFM_Res.Skins.JWoodenBox1'
     CollisionRadius=12.000000
     CollisionHeight=2.000000
     Mass=5.000000
     Buoyancy=6.000000
	 NetPriority=1.400000
	 bBounce=True
     bFixedRotationDir=True
	 bFirstHit=True
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=120.000000
     bCollideActors=False
	 bCollideWorld=True
	 
	 bBlockKarma=True
	 
	Begin Object Class=KarmaParamsCollision Name=KarmaParamsCollision01
        KFriction=2.100000
        KRestitution=1.000000
    End Object
    KParams=KarmaParamsCollision01
}