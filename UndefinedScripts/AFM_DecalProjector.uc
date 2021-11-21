class AFM_DecalProjector extends xScorch;

var() array<Material> RandMaterial;
var() array<Material> RandBloodMaterial;
var() array<Material> RandDirtMaterial;

function Material GetRandMat()
{ return RandMaterial[Rand(RandMaterial.Length-1)]; }

function Material GetBloodMat()
{ return RandBloodMaterial[Rand(RandBloodMaterial.Length-1)]; }

defaultproperties
{
     PushBack=24.000000
     RandomOrient=True
     FOV=1
     MaxTraceDistance=60
     bProjectActor=False
     bClipBSP=True
     FadeInTime=0.125000
     GradientTexture=Texture'Engine.GRADIENT_Clip'
     bStatic=False
     LifeSpan=8.000000
     bGameRelevant=True
}