//Last update : 28.11.2005 17:33:36
// Baseclass для всей жидкости
class FluidEmitter extends AFMEmitter;

enum FluidTypeEnum
{
	FLUID_TYPE_None,		//0
	FLUID_TYPE_Gas,			//1
	FLUID_TYPE_Urine,		//2
	FLUID_TYPE_Blood,		//3
	FLUID_TYPE_Puke,		//4
	FLUID_TYPE_BloodyPuke,	//5
	FLUID_TYPE_Gonorrhea,	//6
	FLUID_TYPE_BloodyUrine,	//7
	FLUID_TYPE_Napalm,		//8
};

// Рассмотрите CollisionRadius как максимум, используйте это как 'реальный' радиус столкновения
var float UseColRadius;
var FluidEmitter Prev;
var FluidEmitter Next;
var FluidTypeEnum MyType;
var bool bOnFire;
var bool bBeingLit;
//var bool bCanBeDamaged;	==	Warning!!!
var bool bNeedsDirectHit;
var float Health;
var float Quantity;
var bool bInfiniteQuantity;
var bool bStoppedFlow;
var bool bStoppedOnce;	// как только поток остановлен, больше нельзя реактивировать
var Actor MyOwner;
var class<FireEmitter> FireClass;		// тип огня(пожара) мы горим в

const SHOW_LINES = 1;
const MIN_HEALTH = 100;
const DEFAULT_STOP_FLOW_TIME=0.2;
const MAX_PUDDLE_SIZE = 600;
const PUDDLE_FUZZ = 30;
const MAX_TO_LIGHT = 5;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	// Установите моего владельца
	MyOwner = Owner;
	if(Owner != None)
		Instigator = Owner.Instigator;
}

//================================================
// Установите цвета жидкости, изменяя цвета частицы
//================================================
function SetFluidColors(FluidTypeEnum newtype)
{
	local int i, j;
	local vector Tinting;
	local bool bDoTint;

	switch(newtype)
	{
		case FLUID_TYPE_BloodyUrine:
			Tinting.x = 200;
			Tinting.y = 0;
			Tinting.z = 0;
			bDoTint=true;
			break;
		case FLUID_TYPE_BloodyPuke:
			Tinting.x = 200;
			Tinting.y = 0;
			Tinting.z = 0;
			bDoTint=true;
			break;
		case FLUID_TYPE_Gonorrhea:
			Tinting.x = Lerp(FRand(),105,175);
			Tinting.y = 255;
			Tinting.z = 0;
			bDoTint=true;
			break;
	}

	if(bDoTint)
	{
		for(i=0; i<Emitters.Length; i++)
		{
			Emitters[i].UseColorScale=True;

			for(j=0; j<Emitters[i].ColorScale.Length; j++)
			{
				Emitters[i].ColorScale[j].Color.R=Tinting.x;
				Emitters[i].ColorScale[j].Color.G=Tinting.y;
				Emitters[i].ColorScale[j].Color.B=Tinting.z;
			}
		}
	}
}

function SetFluidType(FluidTypeEnum newtype)
{
	SetFluidColors(newtype);
	MyType = newtype;
}

function AddQuantity(float MoreQ, vector InputPoint, FluidEmitter InputFluid)
{	
	Quantity+=MoreQ;
}

function ToggleFlow(float TimeToStop, bool bIsOn)
{
	local bool bOldStopped;
	
	bOldStopped = bStoppedFlow;
	bStoppedFlow=!bIsOn;

	if(bStoppedFlow) bStoppedOnce = true;
	if(Next != None && bOldStopped != bStoppedFlow)
	{ Next.ToggleFlow(TimeToStop, bIsOn); }
}

function SlowlyDestroy()
{
	local int i;

	AutoDestroy=True;
	for(i=0; i<Emitters.length; i++)
	{
		Emitters[i].RespawnDeadParticles=False;
		Emitters[i].ParticlesPerSecond=0;
	}
}

simulated function Destroyed()
{
	if(!bDeleteMe)
	{
		ToggleFlow(0, false);
		if(Next != None)
		{
			if(Next.Prev == self) Next.Prev = None;
			Next = None;
		}
		if(Prev != None)
		{
			if(Prev.Next == self) Prev.Next = None;
			Prev = None;
		}
	}
	Super.Destroyed();
}

function MarkBeingLit()
{
	local FluidEmitter NextOne, PrevOne;
	local int NumberToLight, i;

	NumberToLight = Rand(MAX_TO_LIGHT) + 1;

	NextOne = Next;
	i=0;
	while(NextOne != None && i < NumberToLight)
	{
		i++;
		NextOne.bBeingLit=true;
		NextOne = NextOne.Next;
	}

	PrevOne = Prev;
	i=0;
	while(PrevOne != None && i < NumberToLight)
	{
		i++;
		PrevOne.bBeingLit=true;
		PrevOne = PrevOne.Prev;
	}
	
	bBeingLit=true;
}

function SetAblaze(vector StartPos, bool NewStart)
{
	log("i got called.. gasoline setablaze: myself :"$self);
	bOnFire=true;
}

function bool CheckSmallFireHit( int Damage, float hitrad, Vector hitlocation)
{
	local bool bhithere;

	bhithere = false;
	if(!bOnFire && !bBeingLit && bCanBeDamaged)
	{
		bhithere=true;
		SetAblaze(hitlocation, true);
	}
	return bhithere;
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType)
{
	//local bool bhithere;
	local bool bExplDamage;

	bExplDamage = damageType == class'AFMDamage';

	if(ClassIsChildOf(damageType, class'AFMDamage') || bExplDamage)
	{
		if(!bOnFire && !bBeingLit && bCanBeDamaged)
		{
			if(!bNeedsDirectHit)					Health -= Damage;
			if(Health < MIN_HEALTH || bExplDamage)	SetAblaze(hitlocation, true);
		}
	}
}

simulated event RenderOverlays( canvas Canvas ) {}

defaultproperties
{
     UseColRadius=100.000000
     Health=300.000000
     Quantity=100.000000
     bInfiniteQuantity=True
     FireClass=Class'AFM_Ed.FireEmitter'
     CollisionRadius=800.000000
     CollisionHeight=800.000000
}