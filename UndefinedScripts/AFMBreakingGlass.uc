//AFMBreakingGlass.uc
//
//Date: 23/05/2006 16:28:54
//===========================================
class AFMBreakingGlass extends AFMExplodingWall;

//var() float ParticleSize;
//var() float Numparticles;

singular function TakeDamage( int NDamage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	if ( !bOnlyTriggerable ) 
		Explode(instigatedBy, Momentum);
}

// function PreBeginPlay()
// {
	// NumGlassChunks = NumParticles;
	// GlassParticleSize = ParticleSize;
	
	// super.PreBeginPlay();
// }

//ParticleSize=0.750000
//Numparticles=16.000000
	 
defaultproperties
{     
	 GlassParticleSize=0.75
	 NumGlassChunks=16
     ExplosionSize=100.000000
     ExplosionDimensions=90.000000
     NumWallChunks=0
     NumWoodChunks=0
	 EffectSound1=Sound'AFM_Res.General.BreakGlass'
     CollisionRadius=45.000000
     CollisionHeight=45.000000
	 Texture=Texture'AFM_Res.Icons.GlassIc'
}