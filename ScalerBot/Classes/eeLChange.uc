//----------------------------------
//Created by -=EVILemitter=-
//Last update: 25/10/2006 21:46:34
//----------------------------------
class eeLChange extends Interaction;

var transient eeMutScalerBot MyMut;

function NotifyLevelChange()
{
 if(MyMut != None)
    MyMut.beginLevelChange();
 MyMut = None;
 Master.RemoveInteraction(self);
}

DefaultProperties
{
 bActive=False
}
