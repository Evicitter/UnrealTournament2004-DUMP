// ================================================================================
//  Класс:  LL_Game.LLMultiAnim
//  Родитель: XGame.xIntroPawn
//  Автор: Alexander "EVILemitter" Bragin
//  Описание: Этот класс необходим для управления анимацией 
//	Date: 15/05/2006 17:15:26
// ================================================================================
class ALLMultiAnim extends xIntroPawn HideCategories(Shield,Pawn,Karma);

var() bool bDynamicShadowAnim, bLoopAnimations, bGoToFirstAnim, bAnimAtStartGame;
var() bool bResetTweenTimeAndRate; //Все TweenTime и Rate переменные в тек. AnimSlot сбросяться на стандарт.
var() array<MOD_LOL.AnimSection> AnimSlot;
var transient int cur;

simulated function BeginPlay()
{
	local int i;
	//Смотрим содержание функции в классе родителя
	super.BeginPlay();
	bShadowCast = bDynamicShadowAnim;
	
	if(bResetTweenTimeAndRate) for(i=0;i<AnimSlot.Length;i++)
	{ AnimSlot[i].Rate = 1.0; AnimSlot[i].TweenTime = 0.2;  }
	
	if (bAnimAtStartGame && AnimSlot.Length > 0)
		BeginAnimation();
}

simulated function BeginAnimation()
{
 if(AnimSlot.Length > 0)
	{
	 if (bLoopAnimations)
		LoopAnim(AnimSlot[cur].Sequence,AnimSlot[cur].Rate,AnimSlot[cur].TweenTime,AnimSlot[cur].Channel);
	 else PlayAnim(AnimSlot[cur].Sequence,AnimSlot[cur].Rate,AnimSlot[cur].TweenTime,AnimSlot[cur].Channel);
	}
 cur++;
}

simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	if(bGoToFirstAnim && (cur >= AnimSlot.Length))	cur = 0;
	BeginAnimation();
}

defaultproperties
{
	 Mesh=SkeletalMesh'LL_Bots.MainSol'
     //MeshNameString="intro_brock.Brock"
	 bDynamicShadowAnim=True
	 bLoopAnimations=True
	 bGoToFirstAnim=True
	 bAnimAtStartGame=False
	 ForceType=FT_DragAlong
	 ForceRadius=10
	 ForceScale=5
	 ForceNoise=0.5
}