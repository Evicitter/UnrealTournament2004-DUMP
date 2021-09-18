//-----------------------------------------------------------
//Created by EVILemitter
//Updated by Nikoderiko
//Last update: 02/12/2006 16:57:18
//Special thanks:
//		'Nikoderiko'
//		'[TT]VAMPIRUS'
//-----------------------------------------------------------
class eeMutScalerBot extends Mutator
      config(ScalerBot);
      //CacheExempt;

var() globalconfig float fcDrawScale, fcCollisionHeight;

var array< class<xPawn> > xPD;

simulated function PreBeginPlay()
{
	fcDrawScale = FClamp(fcDrawScale,1.0f,2.0f);
	fcCollisionHeight = FClamp(fcCollisionHeight,44.0f,95.0f);
}

function xInitInter(PlayerController PC)
{
	local eeLChange LC;
	if((PC != None) && (PC.Player != None) && (PC.Player.InteractionMaster != None))
	{
		LC = eeLChange(PC.Player.InteractionMaster.AddInteraction("ScalerBot.eeLChange", PC.Player));
		LC.MyMut = self;
	}
}

function bool CheckReplacement(Actor O, out byte bSR)
{
	local xPawn P;

	if(PlayerController(O) != None)
		xInitInter(PlayerController(O));

	//if(O.IsA('xPawn'))	//change xPawn class and all childs classes.
	if(O.Class == class'xPawn')	//change only xPawn class.
	{
		P = xPawn(O);
		//if( P.SetCollisionSize(P.default.CollisionRadius, P.default.CollisionHeight * fcDrawScale) )
		//{
			P.SetCollisionSize(P.default.CollisionRadius, P.default.CollisionHeight * fcDrawScale + 4.0f);
			P.SetDrawScale( fcDrawScale );
			P.SetLocation(P.Location + Vect(0,0,1) * (P.CollisionHeight * 0.5f + 4.0f));
		//}
		P.GroundSpeed      = P.default.GroundSpeed * fcDrawScale;
		P.WaterSpeed       = P.default.WaterSpeed * fcDrawScale;
		P.AirSpeed         = P.default.AirSpeed * fcDrawScale;
		P.LadderSpeed      = P.default.LadderSpeed * fcDrawScale;
		P.AccelRate        = P.default.AccelRate * fcDrawScale;
		P.JumpZ            = P.default.JumpZ * Sqrt(fcDrawScale);
		P.MaxFallSpeed     = P.default.MaxFallSpeed * fcDrawScale;
		P.BaseEyeHeight    = P.default.BaseEyeHeight * fcDrawScale + 4.0f;   // base eye

		if(PlayerController(P.Controller) != None)
		 PlayerController(P.Controller).CameraDist = PlayerController(P.Controller).default.CameraDist * fcDrawScale;

		P.CrouchHeight   = P.default.CrouchHeight * fcDrawScale + 4.0f;
		//P.CrouchRadius   = P.default.CrouchRadius * fcDrawScale;
	}
	return true;
}

final function beginLevelChange()
{
}

simulated function PostNetBeginPlay() { Disable('Tick'); }
simulated function String GetHumanReadableName() { return "ScalerBot"; }

DefaultProperties
{
GroupName="ScalerBot"
FriendlyName="SCALER BOT"
Description="This mutator used for control size of bots."
ConfigMenuClassName="ScalerBot.eeGUICfg_SB"

fcDrawScale=1.2
fcCollisionHeight=52.8
}
