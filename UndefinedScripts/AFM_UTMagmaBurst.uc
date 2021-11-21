// MagmaBurst.uc
//Date: 23/11/2005 16:13:36
//=============================================================================
class AFM_UTMagmaBurst extends AFM_UTRockslide;
    
var() int      MinSpawnedAtOnce;	// 1
var() int      MaxSpawnedAtOnce;	// 3
var() float    MinSpawnSpeed;		// 200
var() float    MaxSpawnSpeed;		// 300
var() float    MinBurnTime;		// 0.4
var() float    MaxBurnTime;		// 1.0
var() float    MinBrightness;		// 0.7	(values can only go from 0.0 -> 1.0)
var() float    MaxBrightness;		// 1.0    "							   "
var() rotator  SpawnCenterDir;
var() int      AngularDeviation;	// approx. 0x2000 -> 8192

function MoreMagma () 
{
	local vector    SpawnLoc;
	local AFM_UTMagma  TempMagma;
	local AFM_UTFlameBall TempFlame;
	local rotator  SpawnDir;

	SpawnLoc = Location - (CubeDimensions*0.5);
	SpawnLoc.X += FRand()*CubeDimensions.X;
	SpawnLoc.Y += FRand()*CubeDimensions.Y;
	SpawnLoc.Z += FRand()*CubeDimensions.Z;

	TempMagma = Spawn (class 'AFM_UTMagma', , '', SpawnLoc);
	TempFlame = Spawn (class 'AFM_UTFlameBall', , '', SpawnLoc);

	SpawnDir = SpawnCenterDir;
	SpawnDir.Pitch += -AngularDeviation + Rand(AngularDeviation*2);
	SpawnDir.Yaw   += -AngularDeviation + Rand(AngularDeviation*2);
	TempMagma.SetRotation(SpawnDir);
	TempMagma.RotationRate = RotRand();
	TempMagma.Speed    = Lerp(FRand(),MinSpawnSpeed,MaxSpawnSpeed);
	TempMagma.BurnTime = Lerp(FRand(),MinBurnTime,MaxBurnTime);
	
	// 0=dark  1=bright
	TempMagma.InitialBrightness = Lerp(FRand(),MinBrightness,MaxBrightness);
	TempMagma.SetDrawScale(Lerp(FRand(),MinScaleFactor,MaxScaleFactor));
}


state() Active 
{
	function MakeRock()
	{
		local int i, NumSpawnedNow;

		NumSpawnedNow = Rand(MaxSpawnedAtOnce-MinSpawnedAtOnce+1)+MinSpawnedAtOnce;
		for (i=0; i<NumSpawnedNow; i++)
			MoreMagma();
	}
}

auto state() Triggered 
{
	function Trigger (actor Other, pawn EventInstigator) 
	{
		GotoState ('Active');
	}
}

defaultproperties
{
     MinSpawnedAtOnce=1
     MaxSpawnedAtOnce=4
     MinSpawnSpeed=200.000000
     MaxSpawnSpeed=1000.000000
     MinBurnTime=20.000000
     MaxBurnTime=25.000000
     MinBrightness=190.000000
     MaxBrightness=240.000000
     SpawnCenterDir=(Pitch=20000)
     AngularDeviation=36000
     CubeDimensions=(X=60.000000,Y=60.000000,Z=60.000000)
     MinBetweenTime=0.700000
     MaxBetweenTime=1.700000
     MinScaleFactor=0.600000
     MaxScaleFactor=1.300000
     Tag=MagmaTest1
}