//=============================================================================
// RockSlide.uc
//Date: 23/11/2005 16:13:30
//=============================================================================
class AFM_UTRockslide extends KeyPoint;

var() vector   CubeDimensions;
var() bool     TimeLimit;          
var() float    TimeLength;
var() float    MinBetweenTime;
var() float    MaxBetweenTime;
var() float    MinScaleFactor;
var() float    MaxScaleFactor;
var() rotator  InitialDirection;
var() float    minInitialSpeed;
var() float    maxInitialSpeed;

var   float  NextRockTime;
var   float  TotalPassedTime;

function BeginPlay() 
{
	MaxScaleFactor = FMin(1.0, MaxScaleFactor);
	MinScaleFactor = FMax(0.0, MinScaleFactor);
	if (MinBetweenTime >= MaxBetweenTime) 
		MaxBetweenTime=MinBetweenTime + 0.1;
	if (MinScaleFactor >= MaxScaleFactor) 
		MaxScaleFactor=MinScaleFactor;

	Super.BeginPlay();
}

function MakeRock() 
{
	local vector  SpawnLoc;
	local AFM_UTBigRock    TempRock;
	
	SpawnLoc = Location - (CubeDimensions*0.5);
	SpawnLoc.X += FRand()*CubeDimensions.X;
	SpawnLoc.Y += FRand()*CubeDimensions.Y;
	SpawnLoc.Z += FRand()*CubeDimensions.Z;

	TempRock = Spawn (class 'AFM_UTBigRock', ,'', SpawnLoc);
	if ( TempRock != None )
	{
		TempRock.SetRotation(InitialDirection);
		TempRock.Speed = Lerp(FRand(),MinInitialSpeed,MaxInitialSpeed);
		TempRock.SetDrawScale(Lerp(FRand(),MinScaleFactor,MaxScaleFactor));
		TempRock.SetCollisionSize(TempRock.CollisionRadius*TempRock.DrawScale/TempRock.Default.DrawScale, 
									 TempRock.CollisionHeight*TempRock.DrawScale/TempRock.Default.DrawScale);
	}
}

auto state() Triggered 
{
	function Trigger (actor Other, pawn EventInstigator) 
	{
		MakeRock();
		GotoState ('Active');
	}
}

state Active
{
Begin:
	MakeRock();
	NextRockTime = Lerp(FRand(),MinBetweenTime,MaxBetweenTime);
	TotalPassedTime += NextRockTime;
	sleep (NextRockTime);
	if ( !TimeLimit || (TotalPassedTime < TimeLength) ) 
		goto 'RocksFall';
	Destroy();
}

defaultproperties
{
	CubeDimensions=(X=50.000000,Y=50.000000,Z=50.000000)
	TimeLength=10.000000
	MinBetweenTime=1.000000
	MaxBetweenTime=3.000000
	MinScaleFactor=0.500000
	MaxScaleFactor=1.000000
	bStatic=False
	Tag=Event1
	Texture=Texture'AFM_Res.Icons.AFMTriggeredPlaySound'
}