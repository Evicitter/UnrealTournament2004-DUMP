//Date: 18/11/2005 23:24:54
class FMLight extends Light;

var(FMLighting) byte VolumeBrightness, VolumeRadius, VolumeFog;
var(WeaponLight) Material PurpleLightSkin,EffectLightSkin,WeaponLightSkin;

var(FMLighting) const edfindable Light PrimaryStaticLight;	 //NEW (arl) Shadows
var(FMLighting) const edfindable Light PrimaryDynamicLight; //NEW (arl) Shadows

function Light StaticLight(Actor Covered,Actor PSL)
{ if(Covered==None) return PrimaryStaticLight; else return self; }

function Light DynamicLight(Actor Covered,Actor DSL)
{ if(Covered==None) return PrimaryDynamicLight; else return self; }

simulated function UT_Light()
{
	SetCollisionSize(24.0,24.0);
	LightType=LT_Steady;
	LightBrightness=64;
	LightSaturation=255;
	LightRadius=64;
	LightPeriod=32;
	LightCone=128;
}

simulated function UT_OverHeatLight()
{
	RemoteRole=ROLE_SimulatedProxy;
	bDynamicLight=True;
	LifeSpan=20.00;
	LightSaturation=0;
	LightRadius=3;
	LightBrightness=32.00;
}

simulated function UT_QueenTeleportLight()
{
	RemoteRole=ROLE_SimulatedProxy;
	LightType=LT_Pulse;
	LightEffect=LE_NonIncidence;
	LightBrightness=255;
	LightSaturation=0;
	LightRadius=22;
	LifeSpan=1.00;
}

simulated function UT_SightLight()
{
	LightBrightness=104;
	LightHue=107;
	LightSaturation=63;
	LightRadius=4;
	bActorShadows=True;
	LifeSpan=0.50;
}

State() DistanceLightning
{
function BeginPlay()
 {
	LightType = LT_None;
	LightType=LT_Flicker;
	LightBrightness=255;
	LightRadius=56;
	LightPeriod=128;
	LightPhase=32;
	bDynamicLight=True;
	RemoteRole=ROLE_SimulatedProxy;
	SetTimer(5+FRand()*10,False);
 }

function Timer()
 {
	if (LightType == LT_Flicker)
	{
		LightType = LT_None;
		SetTimer(9+FRand()*20,False);		
	}
	else 
	{
		LightType = LT_Flicker;
		SetTimer(0.4+FRand()*0.05,False);
	}
 }
}

State() WeaponLight
{
 simulated function UT_PurpleLight()
 {
  Skins[0]=PurpleLightSkin;
  LifeSpan=1.00;
 }

 simulated function UT_EffectLight()
 {
  LightRadius=2;
  Skins[0]=EffectLightSkin;
  LifeSpan=0.50;
 }
 event BeginState()
 {
	bDynamicLight=True;
	RemoteRole=ROLE_SimulatedProxy;
	LightType=LT_TexturePaletteLoop;
	LightEffect=LE_NonIncidence;
	Skins[0]=WeaponLightSkin;
	bMovable=True;
	bActorShadows=True;
	LightRadius=6;
	LightBrightness=250;
	LightSaturation=32;
	LightHue=28;
	LifeSpan=0.15;
 }
}

State() UT_TorchFlame
{
	function PreBeginPlay()
	{
	 bHidden=False;
	 bDynamicLight=True;
	 bUnlit=True;
	 LightBrightness=40;
     LightRadius=32;
	 //SetDrawType(DT_Mesh);
	 //LightEffect=LE_FireWaver;
	 //LinkMesh(LodMesh'UnrealShare.FlameM');
	}
}

defaultproperties
{
	VolumeBrightness=64.000000
	VolumeRadius=0.000000
	VolumeFog=0.000000
	bStatic=False
	bNoDelete=False
	PurpleLightSkin=Texture'AFM_Res.Effects.ExploPurple'
	EffectLightSkin=Texture'AFM_Res.Effects.BlueLightPal3'
	WeaponLightSkin=Texture'AFM_Res.Effects.WepLightPal'
	bNetTemporary=True
}