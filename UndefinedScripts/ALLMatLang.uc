//Creted by "EVILemitter"
//Date: 23/05/2006 16:06:12
//=========================================================
class ALLMatLang extends Modifier
	editinlinenew
	hidecategories(Modifier);
	
var() editinlineuse Material ENGMaterial;
var() editinlineuse Material RUSMaterial;
var() editinlineuse Material JAPMaterial;
var() editinlineuse Material CHIMaterial;
var() editinlineuse Material FRAMaterial;
var() editinlineuse Material GERMaterial;
var() editinlineuse Material KORMaterial;

simulated function GOMaterial()
{
 switch(class'MOD_LOL'.default.LanguageIndex)
 {
  case 0: if(ENGMaterial != None) Material = ENGMaterial; return; //English
  case 1: if(RUSMaterial != None) Material = RUSMaterial; return; //Russian
  case 2: if(JAPMaterial != None) Material = JAPMaterial; return; //Japan
  case 3: if(CHIMaterial != None) Material = CHIMaterial; return; //China
  case 4: if(FRAMaterial != None) Material = FRAMaterial; return; //France
  case 5: if(GERMaterial != None) Material = GERMaterial; return; //Germany
  case 6: if(KORMaterial != None) Material = KORMaterial; return; //Korea
  default: Material = Texture'Editor.Bad'; return; //Bad Tex__
 }
}

function Reset();
function Trigger( Actor Other, Actor EventInstigator );

defaultproperties
{
	Material=Texture'Editor.Bkgnd'
}