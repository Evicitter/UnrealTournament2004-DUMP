// AFMExplodingWall.uc
//Exploding Wall Class uc NoNative
//
//Date: 23/05/2006 16:45:12
//=============================================================================
class AFMExplodingWall extends FMEffects placeable;

var() float ExplosionSize			"Размер взрыва";
var() float ExplosionDimensions		"Измерения взрыва";
//========================================================================
var() float WallParticleSize		"Размер частицы стены";
var() float WoodParticleSize		"Размер частицы дерева";
var() float GlassParticleSize		"Размер частицы стекла";
//========================================================================
var() int NumWallChunks				"Количество кусков стены";
var() int NumWoodChunks				"Количество кусков дерева";
var() int NumGlassChunks			"Количество кусков стекла";
//========================================================================
var() array<Material> WallTextures	"Текстура фрагментов стены";
var() array<Material> WoodTextures	"Текстура фрагментов дерева";
var() array<Material> GlassTextures	"Текстура фрагментов стекла";
//========================================================================
var() int Health					"Здоровье";
var() name ActivatedBy[5]			"Активизированный";
var() bool bTranslucentGlass		"Прозрачное стекло";
var() bool bUnlitGlass				"Неосвещенное стекло";
var() bool bTwoSidesGlass			"Двусторонний фрагмент";
//========================================================================
var bool bAbort;

function PreBeginPlay()
{
	SetDrawType(DT_None);
	super.PreBeginPlay();
}

singular function Trigger( actor Other, pawn EventInstigator )
{
 Explode(EventInstigator, vector(Rotation));
}

singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation,
					Vector momentum, class<DamageType> damageType)
{
	if ( bOnlyTriggerable )
		return;
		
	//if ( DamageType != class'DamageType' );
     Health -= NDamage;
	if ( Health <= 0 )
		Explode(instigatedBy, Momentum);
}

function Explode( pawn EventInstigator, vector Momentum)
{
	local int i;
	local Fragment s;

	if( Event != 'None' || Event != '' )
		TriggerEvent(Event, self, Instigator);

	Instigator = EventInstigator;

	if ( Instigator != None )
		MakeNoise(1.0);
		
	PlaySound(EffectSound1, SLOT_None,2.0,,64.000000);

	if( !bOnlyTriggerable )
	 EffectSound2 = EffectSound1;
	
	PlaySound(EffectSound2, SLOT_None,2.0,,64.000000);
	
	for (i=0 ; i < NumWallChunks ; i++) 
	{
		s = Spawn( class 'WallFragments',,,Location+ExplosionDimensions*VRand());
		if ( s != None )
		{
			s.CalcVelocity(Momentum);	//,ExplosionSize);
			s.SetDrawScale(WallParticleSize);
			s.Skins = WallTextures;
		}
	}
	
	for (i=0 ; i < NumWoodChunks ; i++) 
	{
		s = Spawn( class 'WoodFragments',,,Location+ExplosionDimensions*VRand());
		if ( s != None )
		{
			s.CalcVelocity(Momentum);	//,ExplosionSize);
			s.SetDrawScale(WoodParticleSize);
			s.Skins = WoodTextures;
		}
	}
	
	for (i=0 ; i < NumGlassChunks ; i++) 
	{
		s = Spawn( class 'GlassFragments',Owner,,Location+ExplosionDimensions*VRand());
		if ( s != None )
		{
			s.CalcVelocity(Momentum);	// ExplosionSize);
			s.SetDrawScale(GlassParticleSize);
			s.Skins = GlassTextures;
			s.bUnlit = bUnlitGlass;
			if (bTranslucentGlass) s.Style = STY_Translucent;
		}
	}
	Destroy();
}

defaultproperties
{
     ExplosionSize=200.000000
     ExplosionDimensions=120.000000
     WallParticleSize=1.000000
     WoodParticleSize=1.000000
     GlassParticleSize=1.000000
     NumWallChunks=10
     NumWoodChunks=3
     ActivatedBy(0)=exploded
     bNetTemporary=False
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Sprite
     Texture=Texture'AFM_Res.Icons.ExploIc'
     DrawScale=0.300000
     CollisionRadius=32.000000
     CollisionHeight=32.000000
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
}