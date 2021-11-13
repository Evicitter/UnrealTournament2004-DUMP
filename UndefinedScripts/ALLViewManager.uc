//Created by Alexander "EVILemitter" Bragin
//Date: 15/05/2006 17:19:48
//Пояснение :: Активировать этот актор триггером
//==================================================
class ALLViewManager extends ALL_Triggers
HideCategories(Sound,Movement,Karma,Force,Collision);

var(LL_FadeView) bool bUseFlashScale;
var(LL_FadeView) float pcInFlashScale, pcOutFlashScale;
var(LL_FadeView) vector InViewFlash, InViewFog,   OutViewFlash, OutViewFog;
var(LL_CameraFx) editinline CameraEffect CameraFxObject;
var(LL_ShakeView) bool bLocalController;
var(LL_ShakeView) float DamageShakeFactor, ASFalloffStartTime, ASFalloffTime, ASOffsetFreq, ASRotFreq;
var(LL_ShakeView) vector  ASOffsetMag;
var(LL_ShakeView) rotator ASRotMag;
var(LL_ShakeView) bool bTriggerShutDownTimer;
var(LL_ShakeView) array<MOD_LOL.ShakeVTc> TimerViewShake;

var transient int tvs;
var transient bool InitFS;
var transient DefaultPhysicsVolume DPV;
var transient PlayerController PC;

State() FadeView
{
//Функция вызываемая после активации триггера
 simulated function Trigger( Actor Other, Pawn EventInstigator )
 {
	//Если bUseFlashScale стоит true, то запустить консольную комманду
	if(bUseFlashScale)
	{
	 if(!InitFS) { ConsoleCommand("SetFlash"@pcInFlashScale); InitFS=true; }
	 else { ConsoleCommand("SetFlash"@pcOutFlashScale); InitFS=false; }
	}
	else
	{
	//Ищем все DefaultPhysicsVolume на карте
	foreach AllActors(class 'DefaultPhysicsVolume', DPV)
		{
			//Ставим им новые значения переменных
			if(!InitFS)
			{
			 DPV.ViewFog = InViewFog;
			 DPV.ViewFlash = InViewFlash;
			 InitFS = true;
			}
			else
			{
			 DPV.ViewFog = OutViewFog;
			 DPV.ViewFlash = OutViewFlash;
			 InitFS = false;
			}
		}
	}
 }
}

State() CameraFx
{
 simulated function Trigger( Actor Other, Pawn EventInstigator )
 {
  if(PC == None) PC = Level.GetLocalPlayerController();
  if(!InitFS) { PC.AddCameraEffect(CameraFxObject); InitFS=true; }
  else { PC.RemoveCameraEffect(CameraFxObject); InitFS=false; }
 }
}

State() CameraShake
{
 simulated function Trigger( Actor Other, Pawn EventInstigator )
 {
  if(TimerViewShake.Length == 0) { InitFS = !InitFS; GOShake(InitFS); }
  else if(TimerViewShake.Length > 0 && !bTriggerShutDownTimer)
  { Enable('Timer'); tvs=0; SetTimer(0.1,true); }
  else if(TimerViewShake.Length > 0 && !bOneAction && bTriggerShutDownTimer)
  { Enable('Timer'); tvs=0; SetTimer(0.1,true); bOneAction=true; }
  else if(TimerViewShake.Length > 0 && bOneAction && bTriggerShutDownTimer)
  { Disable('Timer'); GOShake(false); bOneAction=false; }
 }
 simulated function GOShake(bool bOn)
 {
  //if(!InitFS)
  if(bOn)
  {
  if(DamageShakeFactor > 0) foreach DynamicActors(class'PlayerController',PC) PC.DamageShake(DamageShakeFactor);
  else if(DamageShakeFactor == 0 && !bLocalController) foreach DynamicActors(class'PlayerController',PC)
    PC.SetAmbientShake(ASFalloffStartTime,ASFalloffTime,ASOffsetMag+VRand(),ASOffsetFreq,ASRotMag,ASRotFreq);
  else if(DamageShakeFactor == 0 && bLocalController) PC = Level.GetLocalPlayerController();
    PC.SetAmbientShake(ASFalloffStartTime,ASFalloffTime,ASOffsetMag+VRand(),ASOffsetFreq,ASRotMag,ASRotFreq);
	//InitFS=true;
  }
  else
  {
   if(DamageShakeFactor > 0) foreach DynamicActors(class'PlayerController',PC) PC.DamageShake(0);
   else { foreach DynamicActors(class'PlayerController',PC)
   {
    PC.bEnableAmbientShake = false;
	PC.AmbientShakeFalloffStartTime = 0;
	PC.AmbientShakeFalloffTime = 0;
	PC.AmbientShakeOffsetMag = Vect(0,0,0);
	PC.AmbientShakeOffsetFreq = 0;
	PC.AmbientShakeRotMag = Rot(0,0,0);
	PC.AmbientShakeRotFreq = 0;
   }}
   //InitFS = false;
  }
  //return InitFS;	-Текущий инит.
 }
 simulated function Timer()
 {
  GOShake(TimerViewShake[tvs].bIncludeShake);
  SetTimer(TimerViewShake[tvs].TimerShake,true);
  if(class'MOD_LOL'.default.bShowTestsResult==YES)
	Level.GetLocalPlayerController().ConsoleCommand("Say tvs="$tvs@"bIncS="$TimerViewShake[tvs].bIncludeShake@"TimerShake="$TimerViewShake[tvs].TimerShake@"Len="$TimerViewShake.Length);
  tvs++;
  if(tvs >= TimerViewShake.Length) { Disable('Timer'); GOShake(false); }
 }
}

defaultproperties
{
 bStatic=False
 bUseFlashScale=False
 pcInFlashScale=-1.000000
 pcOutFlashScale=1.000000
 InViewFlash=(X=-10.000000,Y=-10.000000,Z=-10.000000)
 InViewFog=(X=-1.000000,Y=-1.000000,Z=-1.000000)
 OutViewFlash=(X=0.000000,Y=0.000000,Z=0.000000)
 OutViewFog=(X=0.000000,Y=0.000000,Z=0.000000)
 Texture=Texture'Engine.SubActionFade'
 DrawScale=1.845210
 InitialState=FadeView
}