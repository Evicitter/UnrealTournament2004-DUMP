//Created by Alexander "EVILemitter" Bragin
//Date: 23/05/2006 17:18:26
//=========================================================================================
class ALLSoundManager extends ALL_Triggers
	hidecategories(Movement,Karma,Force,Collision);

var(AmbientSound) MOD_LOL.EnSoundType TypeEventSnd;
var(AmbientSound) sound TriggeredAmbientSnd;	  //Новый амбиент звук для TriggeredSound
var(AmbientSound) array<sound> ListingAmbientSnd; //Множиство новых амбиент звуков для ListingSound
var(AmbientSound) editinline array<SndManager> PlayerAmbientSnd;

var transient bool btin;
var transient int ioi,pas;
var transient sound Savesnd;

simulated State() TriggerControl
{
	function BeginPlay()
	{
		//Если юзер случайно указал AmbientSound то  опустошить его.
		if (AmbientSound != None) { Savesnd = AmbientSound; AmbientSound = None; }
		if(TypeEventSnd==EST_PlayerSound && PlayerAmbientSnd[pas] != None) PlayerAmbientSnd[pas].BeginPlay(self);
	}
	//Фунция срабатывает если нас активирует триггер
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if ( TypeEventSnd==EST_TriggerSound && TriggeredAmbientSnd != None )
			{
				//Присваиваем AmbientSound к TriggeredAmbientSnd
				if(!btin) { AmbientSound = None; btin = true; }
				else { AmbientSound = TriggeredAmbientSnd; btin = false; }
			}
		else if ( TypeEventSnd==EST_ListSound && ListingAmbientSnd[ioi] != None )
			{
			//Если длины ListingAmbientSnd больше 0 то AmbientSound равен ListingAmbientSnd[число ioi]
				if( ListingAmbientSnd.Length > 0 )
					AmbientSound = ListingAmbientSnd[ioi];
			//Иначе
				else
			//AmbientSound опустошить
					AmbientSound = None;
				ioi++;
			//Если ioi больше или равен длины ListingAmbientSnd то ioi = 0
				if( ioi >= ListingAmbientSnd.Length ) ioi = 0;
			}
	//Если TypeEventSnd равен EST_RandomSound то к AmbientSound присваеваем любой звук из ListingAmbientSnd
		else if(TypeEventSnd==EST_RandomSound) AmbientSound = ListingAmbientSnd[Rand(ListingAmbientSnd.Length)];
		else if(TypeEventSnd==EST_PlayerSound && PlayerAmbientSnd[pas] != None )
		{
		 PlayerAmbientSnd[pas].SndTrigger(self, Other,EventInstigator);
		 pas++;
		 if(pas>=PlayerAmbientSnd.Length) pas = 0;
		}
	}
	simulated function Timer()
	{
		if(TypeEventSnd==EST_PlayerSound) AmbientSound = None;
	}
	simulated function Tick(float DeltaTime)
	{
		if(TypeEventSnd==EST_PlayerSound)
		{
		 if(PlayerAmbientSnd[pas] != None && PlayerAmbientSnd[pas].AOwner != None)
		 {
		  PlayerAmbientSnd[pas].SndTick(self,DeltaTime);
		 }
		}
	}
}

defaultproperties
{
 DrawScale=1.510000
 //Texture=Texture'LL_Res.Icons.AFMTriggeredPlaySound'
 bStatic=False
 SoundVolume=200
 SoundPitch=64
 SoundRadius=64.000000
 InitialState=TriggerControl
}