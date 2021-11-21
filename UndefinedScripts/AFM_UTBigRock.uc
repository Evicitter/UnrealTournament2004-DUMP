// BigRock.uc
//Date: 23/11/2005 16:10:42
//=============================================================================
class AFM_UTBigRock extends Projectile;

var() int NumChunks;

function PostBeginPlay()
{
	local float decision;

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * (0.8 + (0.3 * FRand())) * speed;
	DesiredRotation.Pitch = Rotation.Pitch + Rand(2000) - 1000;
	DesiredRotation.Roll = Rotation.Roll + Rand(2000) - 1000;
	DesiredRotation.Yaw = Rotation.Yaw + Rand(2000) - 1000; 
	decision = FRand();
	if (decision<0.25) 
		PlayAnim('Pos2', 1.0, 0.0);
	else if (decision<0.5) 
		PlayAnim('Pos3', 1.0, 0.0);
	else if (decision <0.75) 
		PlayAnim('Pos4', 1.0, 0.0);
	if (FRand() < 0.5)
		RotationRate.Pitch = Rand(180000);
	if ( (RotationRate.Pitch == 0) || (FRand() < 0.8) )
		RotationRate.Roll = Max(0, 50000 + Rand(200000) - RotationRate.Pitch);
}

function TakeDamage( int NDamage, Pawn instigatedBy, 
				Vector hitlocation, Vector momentum, class<DamageType> damageType) {

	Velocity += Momentum/(DrawScale * 10);
	if (Physics == PHYS_None )
	{
		SetPhysics(PHYS_Falling);
		Velocity.Z += 0.4 * VSize(momentum);
	}
	SpawnChunks(NumChunks);
}

function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local AFM_UTBigRock   TempRock;
	local float scale;

	if ( DrawScale < 1 + FRand() )
		return;

	NumChunks = 1+Rand(num);
	scale = sqrt(0.52/NumChunks);
	if ( scale * DrawScale < 1 )
	{
		NumChunks *= scale * DrawScale;
		scale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++) 
	{
		TempRock = Spawn(class'AFM_UTBigRock');
		if (TempRock != None )
			TempRock.InitFrag(self, scale);
	}
	InitFrag(self, 0.5);
}

function InitFrag(AFM_UTBigRock myParent, float scale)
{
	RotationRate = RotRand();
	scale *= (0.5 + FRand());
	SetDrawScale(scale * myParent.DrawScale);
	if ( DrawScale <= 2 )
		SetCollisionSize(0,0);
	else
		SetCollisionSize(CollisionRadius * DrawScale/Default.DrawScale, CollisionHeight * DrawScale/Default.DrawScale);

	//Velocity = Normal(myParent.Velocity/myParent.speed) * myParent.speed;
}	

auto state Flying
{
	function ProcessTouch (Actor Other, Vector HitLocation)
	{
		local int hitdamage;

		if ( Other == instigator )
			return;
		PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);	

		if ( !Other.IsA('AFM_UTBigRock') ) //&& !Other.IsA('Titan') )
		{
			Hitdamage = Damage * 0.00002 * Pow(DrawScale,3.0) * speed;
			if ( (HitDamage > 6) && (speed > 150) )
				Other.TakeDamage(hitdamage, instigator,HitLocation,
					(35000.0 * Normal(Velocity)), class'crushed' );
		}
	}
	
	simulated function Landed(vector HitNormal)
	{
		HitWall(HitNormal, None);
	}

	function MakeSound()
	{
		local float soundRad;

		if ( Drawscale > 2.0 )
			soundRad = 500 * DrawScale;
		else
			soundRad = 100;
		PlaySound(ImpactSound, SLOT_Misc, DrawScale/8,,soundRad);	
	}

	simulated function HitWall (vector HitNormal, actor Wall)
	{
		local vector RealHitNormal;

		if ( (Role == ROLE_Authority) && (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
			Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), class'DamageType');
		speed = VSize(velocity);
		MakeSound();
		if ( (HitNormal.Z > 0.8) && (speed < 60 - DrawScale) )
		{
			SetPhysics(PHYS_None);
			GotoState('Sitting');	
		}
		else
		{			
			SetPhysics(PHYS_Falling);
			RealHitNormal = HitNormal;
			if ( FRand() < 0.5 )
				RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
			else
				RotationRate.Roll = Max(RotationRate.Roll, 100000);
			HitNormal = Normal(HitNormal + 0.5 * VRand()); 
			if ( (RealHitNormal Dot HitNormal) < 0 )
				HitNormal.Z *= -0.7;
			Velocity = 0.7 * MirrorVectorByNormal(Velocity,HitNormal);
			DesiredRotation = rotator(HitNormal);
			if ( (speed > 150) && (FRand() * 30 < DrawScale) )
				SpawnChunks(NumChunks);
		}
	}

Begin:
	Sleep(5.0);
	SetPhysics(PHYS_Falling);
}

State Sitting
{
Begin:
	SetPhysics(PHYS_None);
	Sleep(DrawScale * 0.5);
	Destroy();
}

defaultproperties
{
	NumChunks=4
	speed=900.000000
	MaxSpeed=1000.000000
	Damage=40.000000
	ImpactSound=Sound'AFM_Res.Titan.Rockhit'
	bNetTemporary=False
	Physics=PHYS_Falling
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=20.000000
	//AnimSequence=Pos1
	//Mesh=LodMesh'UnrealI.TBoulder'
	DrawScale=7.500000
	CollisionRadius=30.000000
	CollisionHeight=30.000000
	bBounce=True
	bFixedRotationDir=True
}