//========================================
//AFMWind.uc
//Date: 14/05/2006 15:55:30
//========================================
class AFMWind extends Info placeable;

var() int UpdateFreqTime,	MagMax,	MagMin,	StartAngle,	AngleChangeMax,	AngleChangeMin;

var transient float Angle;
var transient vector Acc,OldAcc;

const DEG_360 				= 6.28;
const CONVERT_360_TO_2PI 	= 0.01746;	//== 6.28 / 360

function PostBeginPlay()
{
	SetTimer(UpdateFreqTime, true);
	Angle=Rand(DEG_360);
	OldAcc.x=0;
	OldAcc.y=0;
	Angle = StartAngle*CONVERT_360_TO_2PI;
	Super.PostBeginPlay();
}

function GenAcc()
{
	local float AngDelta;
	local int UseMag;
	
	OldAcc = Acc;
	AngDelta = (Rand(AngleChangeMax - AngleChangeMin) + AngleChangeMin)*CONVERT_360_TO_2PI;
	
	if(bool(Rand(2)))	Angle += AngDelta;
	else				Angle -= AngDelta;

	if(Angle > DEG_360)		Angle-=DEG_360;
	else if(Angle < 0)		Angle+= DEG_360;

	UseMag = Rand(MagMax - MagMin) + MagMin;

	Acc.x = UseMag*Cos(Angle);
	Acc.y = UseMag*Sin(Angle);
}

function Timer()
{
	local AFMWindEmitter e;
	GenAcc();
	foreach AllActors(class'AFMWindEmitter', e)
		e.ApplyWindEffects(Acc, OldAcc);
}

defaultproperties
{
     UpdateFreqTime=4
     MagMax=250
     MagMin=150
     AngleChangeMax=40
     AngleChangeMin=20
	 Texture=Texture'Engine.S_Wind'
}