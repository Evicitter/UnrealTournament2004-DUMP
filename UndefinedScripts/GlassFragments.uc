// GlassFragments.uc
//date: 25.11.2005
//============================================
class GlassFragments extends Fragment;

simulated function CalcVelocity(vector Momentum)
{
	Velocity = (FRand()*2.0f)*VRand() * Momentum  * 0.0001f;
}

defaultproperties
{
     Fragments(0)=LodMesh'AFM_Res.Glass01'
     Fragments(1)=LodMesh'AFM_Res.Glass02'
     Fragments(2)=LodMesh'AFM_Res.Glass03'
     Fragments(3)=LodMesh'AFM_Res.Glass04'
     Fragments(4)=LodMesh'AFM_Res.Glass05'
     Fragments(5)=LodMesh'AFM_Res.Glass06'
     Fragments(6)=LodMesh'AFM_Res.Glass07'
     Fragments(7)=LodMesh'AFM_Res.Glass08'
     Fragments(8)=LodMesh'AFM_Res.Glass09'
     numFragmentTypes=9
     ImpactSound=Sound'AFM_Res.General.GlassTink1'
     AltImpactSound=Sound'AFM_Res.General.GlassTink2'
     Mesh=LodMesh'AFM_Res.Glass01'
     CollisionRadius=10.000000
     CollisionHeight=2.000000
}