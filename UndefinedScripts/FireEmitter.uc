//=============================================================================
// FireEmitter.uc
//Date: 23/05/2006 16:35:08
//=============================================================================
class FireEmitter extends AFMEmitter;

var() int OrigLifeSpan;
var() float SizeChange;
var() float VelZChange;
var() float EmissionChange;
var() float Damage;
var() float DamageDistMag;	// How far the radius or trace should go to hurt stuff
var() class<DamageType> MyDamageType;
var() float	Health;
var() edfindable Emitter MySmoke;
var() Sound BurningSound;
var() bool	bAllowDynamicLight;
var() float FadeTime;			
var() float	WaitAfterFadeTime;
var	float	DefCollRadius;
var	float	DefCollHeight;
var	vector CollisionLocation;

const SHOW_LINES=0;
const OTHER_FIRE_SEARCH_RADIUS	=	1024;
const LIGHT_RAD	= 64;

function PostBeginPlay()
{
	if(!Emitters[0].Disabled) SetupLifetime(LifeSpan);
	else
	{
		OrigLifeSpan=LifeSpan;
		LifeSpan=0;
	}
	Super.PostBeginPlay();
}

function Trigger( Actor Other, Pawn EventInstigator )
{
	Super.Trigger(Other, EventInstigator);

	SetupLifetime(OrigLifeSpan);
	GotoState('Burning');
}

function SetupLifetime(float uselife)
{
	if(uselife > 0)
	{
		OrigLifeSpan=uselife;
		LifeSpan = uselife + (FadeTime+WaitAfterFadeTime);
	}
	else
	{
		OrigLifeSpan=uselife;
		LifeSpan=0;
	}
}

function DoSoundAndLight()
{
	local FireEmitter fe;
	local float dist;
	local int lightcount, soundcount;
	
	ForEach CollidingActors(class'FireEmitter', fe, OTHER_FIRE_SEARCH_RADIUS, Location)
	{
		if(!fe.bDynamicLight) lightcount++;
		if(fe.AmbientSound != None) soundcount++;
		dist = VSize(fe.Location-Location);
	}

	if(soundcount == 0) AmbientSound=BurningSound;
	if(lightcount == 0 && bAllowDynamicLight) SetupAsLight(LIGHT_RAD);
}

function SetupAsLight(float Rad)
{
	bDynamicLight=true;
	LightType=LT_Flicker;
    LightEffect=LE_None;
    LightBrightness=150;
	LightSaturation=150;
	LightHue=15;
    LightRadius=Rad;
}

function SetCollisionLocation(vector SurfaceNormal)
{
	CollisionLocation = Location + DamageDistMag*SurfaceNormal;
}

function DealDamage(float DeltaTime)
{
	if(Damage != 0)
	{
		HurtRadius(DeltaTime*Damage, CollisionRadius, MyDamageType, 0, Location );
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if(damageType == MyDamageType && Health > 0)
	{
		Health-=Damage;

		if(Health <= 0)
		{
			Health = 0;
			GotoState('Fading');
		}
	}
}

function Tick(float DeltaTime)
{
	DealDamage(DeltaTime);
}

auto state Expanding
{
	function Tick(float DeltaTime) { }
	function BeginState()
	{
		if(LifeSpan == 0) GotoState('');
		else GotoState('Burning');
	}
}

state Burning
{
	simulated function Timer()
	{
		GotoState('Fading');
	}
	function SetupLifetime(float uselife)
	{
		Global.SetupLifetime(uselife);
		if(LifeSpan > 0) SetTimer(OrigLifeSpan, false);
	}
	function BeginState()
	{
		if(LifeSpan > 0) SetTimer(OrigLifeSpan, false);
	}
}

state Fading
{
	simulated function Timer()
	{
		GotoState('WaitAfterFade');
	}
	function Tick(float DeltaTime)
	{
		Emitters[0].StartVelocityRange.Z.Max+=(VelZChange*DeltaTime);
		Emitters[0].StartVelocityRange.Z.Min+=(VelZChange*DeltaTime);
		Emitters[0].InitialParticlesPerSecond+=EmissionChange*DeltaTime;
		Emitters[0].ParticlesPerSecond+=EmissionChange*DeltaTime;
	}
	
	function BeginState()
	{
		SetTimer(FadeTime, false);
		VelZChange=-Emitters[0].StartVelocityRange.Z.Min/(FadeTime);
		EmissionChange = -(Emitters[0].ParticlesPerSecond)/(2*FadeTime);

		if(MySmoke != None) MySmoke.GotoState('Fading');
	}
}

state WaitAfterFade
{
	function Tick(float DeltaTime)	{	}

	function BeginState()
	{
		local int i;
		for(i=0; i<Emitters.Length; i++)
			Emitters[i].RespawnDeadParticles = false;
		LifeSpan = WaitAfterFadeTime;
	}
}

simulated function RenderOverlays( canvas Canvas )
{
	local color tempcolor;

	if(Damage != 0 && SHOW_LINES==1)
	{
		tempcolor.R=255;
		Canvas.DrawColor = tempcolor;
	}
}

defaultproperties
{
     Damage=2100.000000
     DamageDistMag=1160.000000
     MyDamageType=Class'Engine.FellLava'
     Health=60.000000
     FadeTime=3.000000
     WaitAfterFadeTime=1.000000
     SoundVolume=255
	 CollisionRadius=2.000000
	 CollisionHeight=1.000000
}