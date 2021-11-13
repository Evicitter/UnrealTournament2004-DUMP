//WallFragments.uc
//Date: 19/12/2005 14:56:50
//=============================================================================
class WallFragments extends Fragment;

var() sound WallMiscSound;

defaultproperties
{
     Fragments(0)=LodMesh'AFM_Res.wafr1'
     Fragments(1)=LodMesh'AFM_Res.wafr2'
     Fragments(2)=LodMesh'AFM_Res.wafr3'
     Fragments(3)=LodMesh'AFM_Res.wafr4'
     Fragments(4)=LodMesh'AFM_Res.wafr5'
     Fragments(5)=LodMesh'AFM_Res.wafr6'
     Fragments(6)=LodMesh'AFM_Res.wafr7'
     Fragments(7)=LodMesh'AFM_Res.wafr8'
     Fragments(8)=LodMesh'AFM_Res.wafr9'
     Fragments(9)=LodMesh'AFM_Res.wafr10'
     Fragments(10)=LodMesh'AFM_Res.wafr10'
	 Skins(0)=Texture'Engine.DefaultTexture'
     numFragmentTypes=11
     ImpactSound=Sound'AFM_Res.General.Chunkhit1'
     AltImpactSound=Sound'AFM_Res.General.EndPush'
	 WallMiscSound=Sound'AFM_Res.General.EndPush'
     Mesh=LodMesh'AFM_Res.wafr1'
}