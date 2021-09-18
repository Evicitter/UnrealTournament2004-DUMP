//-----------------------------------------------------------
//Created by -=EVILemitter=-
//Last update: 02/12/2006 16:57:56
//-----------------------------------------------------------
class eeMWip extends Effects HideDropDown;

var transient GUIComponent MyRender;
var transient PlayerController PC;
var transient xUtil.PlayerRecord PRec;

var() float CPRenderX, CPRenderY, CPRenderZ; //var() vector CPRender;
var() byte RenderFOV;

function PreBeginPlay()
{
 PC = PlayerController(Owner);
 if(PC == None)
 {
  Error("PC == None <<<<<<<< ERROR");
  return;
 }
 PRec = class'xUtil'.static.FindUPLPlayerRecord( PC.GetUrlOption("Character") );

 /*if(PlayerController(Owner) != None && PlayerController(Owner).Player != None)
    MyPage = eeGUICfg_SB(GUIController(PlayerController(Owner).Player.GUIController).ActivePage);
 if(MyPage == None)
    Error("MyPage == None <<<<<<<< ERROR");*/
}

function BeginPlay()
{
 LinkMesh( Mesh(DynamicLoadObject(PRec.MeshName, class'Mesh')) );
 Skins[0] = Material(DynamicLoadObject(PRec.BodySkinName, class'Material'));
 Skins[1] = Material(DynamicLoadObject(PRec.FaceSkinName, class'Material'));

 if(HasAnim('Idle_Rest'))
    LoopAnim( 'Idle_Rest', 1.0f );	//LoopAnim( 'Idle_Rest', 1.0f/Level.TimeDilation );
}

function RenderOverlays(Canvas C)
{
 local vector X, Y, Z;

 if(MyRender == None) return;

 GetAxes(PC.CalcViewRotation, X, Y, Z);
 SetLocation(PC.CalcViewLocation + (CPRenderX * X) + (CPRenderY * Y) + (CPRenderZ * Z));
 C.DrawActorClipped(self, false,  MyRender.ActualLeft(), MyRender.ActualTop(), MyRender.ActualWidth(), MyRender.ActualHeight(), true, RenderFOV);
}

function Destroyed()
{
 MyRender = None;
}

function bool TeamLink(int TeamNum)
{
 switch(EInputKey(TeamNum))
 {
  case IK_A:         CPRenderY -= 1; return false;
  case IK_W:         CPRenderX += 1; return false;
  case IK_D:         CPRenderY += 1; return false;
  case IK_S:         CPRenderX -= 1; return false;
  case IK_GreyPlus:  CPRenderZ -= 1; return false;
  case IK_GreyMinus: CPRenderZ += 1; return false;
  case IK_PageUp:    RenderFOV += 2; return false;
  case IK_PageDown:  RenderFOV -= 2; return false;
 }
 return false;
}

DefaultProperties
{
 bNetInitialRotation=False
 bSkipActorPropertyReplication=True
 bNoRepMesh=True
 NetUpdateFrequency=1.0
 NetPriority=0.1
 bReplicateMovement=False

 bLightingVisibility=False

 MaxLights=0
 ForceNoise=0.0
 SoundRadius=0
 SoundVolume=0
 SoundPitch=0
 TransientSoundVolume=0.0
 TransientSoundRadius=0.0
 SoundOcclusion=OCCLUSION_None
 bHurtEntry=True
 bIgnoreTerminalVelocity=True
 Mass=1.0
 bAcceptsProjectors=False
 bSmoothKarmaStateUpdates=False

 bStasis=True
 bUnlit=true
 DrawType=DT_Mesh
 LODBias=100000
 Skins(0)=None
 Skins(1)=None
 CPRenderX=110
 RenderFOV=60
}
