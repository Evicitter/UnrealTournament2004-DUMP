//DMvech.uc
//Предназнвчен для быстрого появления машин в любом типе игры
//OLD:: Использовался как тест машин
//Date: 14/05/2006 15:57:24
//==========================================================================
class DMvech extends Actor placeable;

var() bool bRespawnVehicles, bLoopSpawn;
var() float TimeRespawn;

function PreBeginPlay()
{
	local Vehicle V;
	local ONSVehicleFactory OF;
	
	Level.Game.bAllowVehicles = true;
	foreach DynamicActors(class'Vehicle', V) { V.bTeamLocked = false; V.Team = 255; }
	foreach DynamicActors(class'ONSVehicleFactory', OF) OF.Activate(255);
	
	SetTimer(TimeRespawn, bLoopSpawn);
}

simulated function Timer()
{
	local Vehicle V;
	local ONSVehicleFactory OF;
	local ASVehicleFactory AF;

	Level.Game.bAllowVehicles = true;

	foreach DynamicActors(class'Vehicle', V) { V.bTeamLocked = false; V.Team = 255; }
	
	if (bRespawnVehicles)
	{
		foreach DynamicActors(class'ONSVehicleFactory', OF) { OF.Activate(255); OF.SpawnVehicle(); }
		foreach DynamicActors(class'ASVehicleFactory', AF)	AF.SpawnVehicle();
	}
}

defaultproperties
{
 TimeRespawn=1.000000
 bHidden=True
}