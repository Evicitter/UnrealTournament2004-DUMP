//-----------------------------------------------------------
//Created by -=EVILemitter=-
//Last update: 24/10/2006 18:54:36
//-----------------------------------------------------------
class eeGUICfg_SB extends PopupPageBase;

//Component's
var automated GUIImage iOriginal, iNewModel;
var automated GUIButton bOriginal, bNewModel, bClose;
var automated moFloatEdit feDrawScale, feColHi;
//---------------------------------------------------------------

//Config variables
var() texture FrameTex;
var() array<EMenuRenderStyle> MaxRenderStyles;
//---------------------------------------------------------------

//Example Actor's
var transient PlayerController PC;
var transient eeMWip AlphaP, ScalerP;
//----------------------------------------------------------------

//FUNCTION'S
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
 Super.InitComponent(MyController, MyOwner);

 i_FrameBG.Image = FrameTex;
 i_FrameBG.ImageStyle = ISTY_Scaled;
 i_FrameBG.ImageRenderStyle = MaxRenderStyles[Rand(MaxRenderStyles.Length)];

 PC = MyController.ViewportOwner.Actor;
 if(PC == None)
    PC = PlayerOwner();

 //PlayerOwner().ConsoleCommand( "get xPawn CollisionHeight" );
 //PlayerOwner().ConsoleCommand( "get xPawn CollisionRadius" );
}


function Opened(GUIComponent S)
{
 local rotator r;

 r = rotator(-vector(PC.CalcViewRotation));
 if(AlphaP == None)
 {
    AlphaP = PC.Spawn(class'eeMWip',PC,'Soso', PC.CalcViewLocation, r);
    AlphaP.MyRender = iOriginal;
 }
 if(ScalerP == None)
 {
    ScalerP = PC.Spawn(class'eeMWip',PC,'Soso', PC.CalcViewLocation, r);
    ScalerP.MyRender = iNewModel;
 }
 
 //Aggressive load
 feDrawScale.SetValue(class'eeMutScalerBot'.default.fcDrawScale);
 ScalerP.SetDrawScale(class'eeMutScalerBot'.default.fcDrawScale);
 
 feColHi.SetValue(class'eeMutScalerBot'.default.fcCollisionHeight);
 ScalerP.SetCollisionSize(ScalerP.CollisionRadius, class'eeMutScalerBot'.default.fcCollisionHeight);
 //--------------------------------------------------------------------------------------------------
 
 super.Opened(S);
}

function Closed(GUIComponent S, bool bCanceled)
{
 local eeMWip M;
 foreach PC.DynamicActors(class'eeMWip',M) M.Destroy();
 
 //Aggressive save
 class'eeMutScalerBot'.default.fcDrawScale = feDrawScale.GetValue();
 class'eeMutScalerBot'.default.fcCollisionHeight = feColHi.GetValue();
 class'eeMutScalerBot'.static.StaticSaveConfig();
 //-----------------------------------------------------------------------
  
 super.Closed(S, bCanceled);
}

function bool NotifyLevelChange()
{
 local eeMWip M;
 foreach PC.DynamicActors(class'eeMWip',M) M.Destroy();
 return super.NotifyLevelChange();
}

function bool InternalOnPreDraw( Canvas C )
{
	if ( !bFading )
		return false;

    InactiveFadeColor.A = 255;

	if (CurFadeTime >= 0.0)
	{
		CurFade = Lerp(Controller.RenderDelta / CurFadeTime, CurFade, DesiredFade);
		InactiveFadeColor.R = int(CurFade);
        InactiveFadeColor.G = InactiveFadeColor.R;
        InactiveFadeColor.B = InactiveFadeColor.R;

		CurFadeTime -= Controller.RenderDelta;

		if ( CurFadeTime < 0 )
		{
			CurFade = DesiredFade;
			 InactiveFadeColor.R = int(CurFade);
             InactiveFadeColor.G = InactiveFadeColor.R;
             InactiveFadeColor.B = InactiveFadeColor.R;
			bFading = False;
			if ( bClosing )
			{
				bClosing = False;
				FadedOut();
			}
			else
				FadedIn();
		}
	}

    return false;
}

function CChangePage(GUIComponent Sender)
{
 local moFloatEdit M;

 M = moFloatEdit(Sender);

 switch(M)
 {
  case feDrawScale: ScalerP.SetDrawScale( M.GetValue() ); return;
  case feColHi:     ScalerP.SetCollisionSize(ScalerP.CollisionRadius, M.GetValue()); return;
 }
}

function bool ExitClick(GUIComponent Sender) { Controller.CloseMenu(false); return true; }
function bool ShiftModelsEvent(out byte Key, out byte State, float delta)
{
	if ( (!Controller.CtrlPressed || !Controller.ShiftPressed) || (State < 1) || (State > 2) )
		return false;

    AlphaP.TeamLink(Key);
    ScalerP.TeamLink(Key);

    return false;
}

function MModelRendOrig(Canvas C)
{
 if(AlphaP != None)
    AlphaP.RenderOverlays(C);
}

function MModelRendNew(Canvas C)
{
 if(ScalerP != None)
    ScalerP.RenderOverlays(C);
}

function bool LeftCapMM(float deltaX, float deltaY)
{
	local rotator r;
  	r = AlphaP.Rotation;
    r.Yaw -= (256 * DeltaX);
    AlphaP.SetRotation(r);
    return true;
}

function bool RightCapMM(float deltaX, float deltaY)
{
	local rotator r;
  	r = ScalerP.Rotation;
    r.Yaw -= (256 * DeltaX);
    ScalerP.SetRotation(r);
    return true;
}

DefaultProperties
{
		WinWidth=0.990625
		WinHeight=0.982494
		WinLeft=0.004419
		WinTop=0.013083
		CurFade=255
		DesiredFade=95
		FrameTex=Texture'2K4Menus.BkRenders.Bgndtile'
		MaxRenderStyles(0)=MSTY_Translucent
		MaxRenderStyles(1)=MSTY_Modulated
		MaxRenderStyles(2)=MSTY_Subtractive

    OnKeyEvent=ShiftModelsEvent
	Begin Object class=GUIImage Name=NAMEiOriginal
		WinWidth=0.334368
		WinHeight=0.738758
		WinLeft=0.013266
		WinTop=0.059478
		Image=Material'2K4Menus.Controls.thinpipe_b'
		ImageColor=(R=255,G=255,B=255,A=255)
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled
        RenderWeight=0.3
        OnRendered=MModelRendOrig
	End Object
	iOriginal=NAMEiOriginal

	Begin Object class=GUIImage Name=NAMEiNewModel
		WinWidth=0.334368
		WinHeight=0.738758
		WinLeft=0.360141
		WinTop=0.057395
		Image=Material'2K4Menus.Controls.thinpipe_b'
		ImageColor=(R=255,G=255,B=255,A=255)
		ImageRenderStyle=MSTY_Normal
		ImageStyle=ISTY_Scaled
        RenderWeight=0.3
        OnRendered=MModelRendNew
	End Object
	iNewModel=NAMEiNewModel

	Begin Object class=GUIButton Name=NAMEbOriginal
		WinWidth=0.274015
		WinHeight=0.626260
		WinLeft=0.039634
		WinTop=0.122759
		Caption=""
		Hint=""
        bNeverFocus=true
        StyleName="NoBackground"
        bDropTarget=true
        bCaptureMouse=true
        OnCapturedMouseMove=LeftCapMM
        MouseCursorIndex=5
        bTabStop=false
	End Object
	bOriginal=NAMEbOriginal

	Begin Object class=GUIButton Name=NAMEbNewModel
		WinWidth=0.274015
		WinHeight=0.626260
		WinLeft=0.391196
		WinTop=0.122759
		Caption=""
		Hint=""
        bNeverFocus=true
        StyleName="NoBackground"
        bDropTarget=true
        bCaptureMouse=true
        OnCapturedMouseMove=RightCapMM
        MouseCursorIndex=5
        bTabStop=false
	End Object
	bNewModel=NAMEbNewModel

	Begin Object class=GUIButton Name=NAMEbClose
		WinWidth=0.174015
		WinHeight=0.055948
		WinLeft=0.011509
		WinTop=0.891510
		Caption="CLOSE"
		Hint=""
		OnClick=ExitClick
	End Object
	bClose=NAMEbClose

	Begin Object class=moFloatEdit Name=NAMEfeDrawScale
        WinWidth=0.292765
		WinHeight=0.626260
		WinLeft=0.699007
		WinTop=0.145676
		Caption="DrawScale"
		Hint=""
		MinValue=1.0
	    MaxValue=2.0
	    OnChange=CChangePage
	End Object
	feDrawScale=NAMEfeDrawScale

    Begin Object class=moFloatEdit Name=NAMEfeColHi
		WinWidth=0.292765
		WinHeight=0.626260
		WinLeft=0.699008
		WinTop=0.189425
		Caption="Collision Height"
		Hint=""
		MinValue=44.0
	    MaxValue=100.0
	    OnChange=CChangePage
	End Object
    feColHi=NAMEfeColHi
}
