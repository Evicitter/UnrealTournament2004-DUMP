//=============================================================================
// Magma.
//Date: 23/11/2005 16:12:36
//=============================================================================
class AFM_UTMagma extends AFM_UTBigRock;

var() float DelaySmoke;
var   float BurnTime;
var   float InitialBrightness;
var   float LastSmokeTime;
var   float PassedTime;

function Timer()
{	local float tempBrightness;

	PassedTime += 0.15;
	if (PassedTime-LastSmokeTime >= DelaySmoke) 
	{
		//Spawn (class 'SmokeTrail', , '', Location+Vect(0,0,8));
		LastSmokeTime = PassedTime;
	}
	tempBrightness = InitialBrightness*(1-((PassedTime*(1-0.1+0.2*FRand()))/BurnTime) **2);
	tempBrightness = FClamp (tempBrightness, 0, 1);
		
	LightBrightness = tempBrightness * 90;
	AmbientGlow     = tempBrightness * 240;
}

auto state Flying
{
	simulated function HitWall (vector HitNormal, actor Wall)
	{
		InitialBrightness *= 1.5;
		Super.HitWall(HitNormal, Wall);
	}

Begin:
	SetTimer(0.15, true);
	if (Speed != 0) Velocity = Vector(Rotation) * Speed;
	RotationRate = RotRand();
	BurnTime = FMin(BurnTime, 0.1);
	SetPhysics (PHYS_Falling);
}

defaultproperties
{
     LifeSpan=15.000000
     bBlockActors=True
     bBlockPlayers=True
     LightType=LT_Steady
     LightBrightness=130
     LightHue=120
     LightSaturation=200
     LightRadius=30
	 bDynamicLight=True
}