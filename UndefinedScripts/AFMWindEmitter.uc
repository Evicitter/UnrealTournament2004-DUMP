//===========================================================
// Эмитент, произведенный окружающей средой (подобно ветру)
//===========================================================
//Date: 08/02/2006 22:58:34
class AFMWindEmitter extends AFMEmitter;

var vector OldWindAcc;

function ApplyAcc(int num, vector Acc)
{
	Emitters[num].Acceleration.x += Acc.x;
	Emitters[num].Acceleration.y += Acc.y;
}

function RemoveOldAcc(int num, vector OldAcc)
{
	Emitters[num].Acceleration.x -= OldAcc.x;
	Emitters[num].Acceleration.y -= OldAcc.y; 
}

function ApplyWindEffects(vector WAcc, vector OldWAcc)
{
	local int num;

	for(num=0; num < Emitters.length; num++)
	{
		RemoveOldAcc(num, OldWindAcc);
		ApplyAcc(num, WAcc);
	}
	OldWindAcc = WAcc;
}

defaultproperties
{
 bNoDelete=True
}