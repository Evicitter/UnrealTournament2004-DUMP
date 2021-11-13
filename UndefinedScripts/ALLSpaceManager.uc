//Created by Alexander "EVILemitter" Bragin
//Date: 15/05/2006 17:22:06
//===========================================================================
class ALLSpaceManager extends ALL_Triggers HideCategories(Sound,Movement,Karma,Force,Collision);

var() bool bAtStartGame, bGoToFirstGravControl, bGoToFirstDamageControl, bTriggerShutDownTimer, bOnceTrigger;

var(LL_GarbajeOptions) bool PVbAlwaysRelevant;
var(LL_GarbajeOptions) ENetRole PVRemoteRole;

var() vector vResetGravVector;
var() name PhysicsVolumeTag;
var() MOD_LOL.ETVolume PhysicsVolumeType;

var() bool ManualControl;
var() edfindable PhysicsVolume ManualTargetVolume;

var(LL_VolumeController) array<MOD_LOL.RealVector> GravityControl;
var(LL_VolumeController) array<MOD_LOL.DamVol> DamageControl;
var(LL_VolumeController) array<MOD_LOL.FogCtrl> FogControl;

var(LL_ZoneInfo_Controller) array<MOD_LOL.ZIFogCtrl> ZoneInfoFogControl;
var(LL_ZoneInfo_Controller) name ZoneInfoTag;
var(LL_ZoneInfo_Controller) bool bGoToFirstZIFogCtrl;

var transient PhysicsVolume PV;
var transient DefaultPhysicsVolume DPV;
var transient ZoneInfo ZI;

var transient int e, p, f, izi;
var transient bool tsdt, oneni;

State() VolumeGravityController
{
	simulated function PostBeginPlay()
	{
	 super.PostBeginPlay();
	 if(bAtStartGame) SetTimer(1.0,true);
	}

	simulated function ResetProp()
	{
	 GravityControl[e].Time = 0.00; PhysicsVolumeTag = '';
	}

	simulated function Timer()
	{
	if(PhysicsVolumeType == VType_DefaultPhysicsVolume)
	{
	 foreach AllActors(class'DefaultPhysicsVolume',DPV)
	 {
		if(bGoToFirstGravControl && e >= GravityControl.Length) e = 0;
		else if(!bGoToFirstGravControl && e >= GravityControl.Length) return;
	
		if( GravityControl.Length > 0 )
		 {
		  DPV.Gravity = GravityControl[e];
		  SetTimer(GravityControl[e].Time,true);
		if(bTriggerShutDownTimer && GravityControl[e].Time >= 0.11)  tsdt = true;
		 }
		if(oneni) DPV.Gravity = vResetGravVector;
	 }
	}

	else if(PhysicsVolumeType == VType_PhysicsVolume)
	{
	 foreach AllActors(class'PhysicsVolume',PV,PhysicsVolumeTag)
	 {
		if(bGoToFirstGravControl && e >= GravityControl.Length) e = 0;
		else if(!bGoToFirstGravControl && e >= GravityControl.Length) return;
		
		if( GravityControl.Length > 0 )
		{
		 PV.Gravity = GravityControl[e]; 
		 PV.NetUpdateTime = Level.TimeSeconds - 1;
		 PV.bAlwaysRelevant = PVbAlwaysRelevant;
		 PV.RemoteRole = PVRemoteRole;
		if ( PV.IsA('DefaultPhysicsVolume') ) Level.DefaultGravity = PV.Gravity.Z; 
		 SetTimer(GravityControl[e].Time,true);
		if(bTriggerShutDownTimer && GravityControl[e].Time >= 0.11)  tsdt = true;
		}
		if(oneni) PV.Gravity = vResetGravVector;
	 }
	}
	e++;
	}

	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
	 if(!bAtStartGame)
		{
			if(!bOnceTrigger) { e = 0; SetTimer(1.0,true); }
			else { e = 0; bAtStartGame = true; SetTimer(1.0,true); }
		}
	 if(tsdt) { oneni = true; SetTimer(0.5,false); }
	}
/*
	if(TypeWorkVolume == TWV_DamageCtrl)
	{
		p++;
		if(PhysicsVolumeType == VType_DefaultPhysicsVolume)
			{
			foreach AllActors(class'DefaultPhysicsVolume',DPV)
			 {
				if(bGoToFirstDamageControl)
					{ if( p >= DamageControl.Length ) p = 0; }
				else if(!bGoToFirstDamageControl)
					{ if( p >= DamageControl.Length ) return; }

				if( DamageControl.Length > 0 )
					{
						DPV.DamagePerSec = DamageControl[p].DamagePerSec;
						if(DamageControl[p].DamageType != None )
							DPV.DamageType = DamageControl[p].DamageType;
						if(DamageControl[p].Tag != '')
							DPV.Tag = DamageControl[p].Tag;
					}
			 }
			}
		else if(PhysicsVolumeType == VType_PhysicsVolume)
			{
			foreach AllActors(class'PhysicsVolume',PV,PhysicsVolumeTag)
			 {
				if(bGoToFirstDamageControl)
					{ if( p >= DamageControl.Length ) p = 0; }
				else if(!bGoToFirstDamageControl)
					{ if( p >= DamageControl.Length ) return; }

				if( DamageControl.Length > 0 )
					{
						PV.DamagePerSec = DamageControl[p].DamagePerSec;
						if(DamageControl[p].DamageType != None )
							PV.DamageType = DamageControl[p].DamageType;
						if(DamageControl[p].Tag != '')
							PV.Tag = DamageControl[p].Tag;
					}
			 }
			}
	}*/
}

/*
State() VolumeFogController
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		f++;
		if(f >= FogControl.Length) f = 0;
	}
	
	simulated function Tick(float DeltaTime)
	{
	local float PixingStart, PixingEnd;
	
	if(FogControl[f].FadeOutTime>0)
		{
		 if(TypeWorkVolume==TWV_FogControl)
		 {
		 PixingStart += (FogControl[f].NewDistanceFogStart - PixingStart) * (DeltaTime / FogControl[f].FadeOutTime);
		 PixingEnd += (FogControl[f].NewDistanceFogEnd - PixingEnd) * (DeltaTime / FogControl[f].FadeOutTime);
		 FogControl[f].FadeOutTime -= DeltaTime;
		  if (FogControl[f].FadeOutTime<=0.0)
			{ PixingStart = FogControl[f].NewDistanceFogStart; PixingEnd = FogControl[f].NewDistanceFogEnd; FogControl[f].FadeOutTime=0.0; }
			
			//Level.DistanceFogStart = PixingStart;
			//Level.DistanceFogEnd = PixingEnd;
			
			if(PhysicsVolumeType == VType_DefaultPhysicsVolume)
			{
			foreach AllActors(class'DefaultPhysicsVolume',DPV)
			 {
				DPV.bDistanceFog = !FogControl[f].bNoDistanceFog;
				DPV.DistanceFogStart = PixingStart;
				DPV.DistanceFogEnd = PixingEnd;
			 }
			}
			else if(PhysicsVolumeType == VType_PhysicsVolume)
			{
			foreach AllActors(class'PhysicsVolume',PV,PhysicsVolumeTag)
			 {
				PV.bDistanceFog = !FogControl[f].bNoDistanceFog;
				PV.DistanceFogStart = PixingStart;
				PV.DistanceFogEnd = PixingEnd;
			 }
			}
		 }			
		}
	}
}
*/

State() VolumeFogController
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		f++;
	 if(f >= FogControl.Length) f = 0;
	 if(PhysicsVolumeType == VType_DefaultPhysicsVolume)
		{
		foreach AllActors(class'DefaultPhysicsVolume',DPV)
		 {
			DPV.bDistanceFog = !FogControl[f].bNoDistanceFog;
			DPV.DistanceFogStart = FogControl[f].NewDistanceFogStart;
			DPV.DistanceFogEnd = FogControl[f].NewDistanceFogEnd;
		 }
		}
	 else if(PhysicsVolumeType == VType_PhysicsVolume)
		{
		foreach AllActors(class'PhysicsVolume',PV,PhysicsVolumeTag)
		 {
			PV.bDistanceFog = !FogControl[f].bNoDistanceFog;
			PV.DistanceFogStart = FogControl[f].NewDistanceFogStart;
			PV.DistanceFogEnd = FogControl[f].NewDistanceFogEnd;
		 }
		}
	}
}

State() ZoneInfoFogController
{
 simulated function Trigger( Actor Other, Pawn EventInstigator )
 {
	izi++;
	if(bGoToFirstZIFogCtrl && izi >= ZoneInfoFogControl.Length) izi = 0;
	foreach AllActors(class'ZoneInfo',ZI,ZoneInfoTag)
	{
		ZI.DistanceFogBlendTime = ZoneInfoFogControl[izi].DistanceFogBlendTime;
		ZI.bDistanceFog = !ZoneInfoFogControl[izi].bNoDistanceFog;
		ZI.bClearToFogColor = ZoneInfoFogControl[izi].bClearToFogColor;
		ZI.DistanceFogColor = ZoneInfoFogControl[izi].DistanceFogColor;
		ZI.DistanceFogEndMin = ZoneInfoFogControl[izi].DistanceFogEndMin;
		ZI.DistanceFogEnd = ZoneInfoFogControl[izi].DistanceFogEnd;
		ZI.DistanceFogStart = ZoneInfoFogControl[izi].DistanceFogStart;				
	}
 }
}

defaultproperties
{
	 //Texture=Texture'AFM_Res.Icons.AFMTriggeredVolumeController'
	 DrawScale=1.000000

	 PVbAlwaysRelevant=True
	 PVRemoteRole=ROLE_DumbProxy
	 
	 bGoToFirstZIFogCtrl=False
	 
	 bAtStartGame=False
	 bGoToFirstGravControl=False
	 bGoToFirstDamageControl=False
	 bTriggerShutDownTimer=False
	 bOnceTrigger=False
	 vResetGravVector=(X=0.000000,Y=0.000000,Z=-950.000000)
	 PhysicsVolumeTag=
	 PhysicsVolumeType=VType_DefaultPhysicsVolume
}