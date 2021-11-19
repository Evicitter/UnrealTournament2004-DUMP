//Date: 30/08/2005 20:04:22
class Interface_LoadPage extends Interface_SaveGamePage;

var Automated GUIButton butLoad;

function bool LeftButtonClick(GUIComponent Sender)
{
    local PlayerController PC;
    local int i;

        PC = PlayerOwner();

        if (Sender == butLoad)
        {
                //get the slot where the game is saved
                i = SaveGameList.FindIndex(SaveGameList.Get());

                //load the savegame
                PC.ClientTravel( "?load="$i, TRAVEL_Absolute, false);
        }

        return true;
}


//just the same, but on double click
function bool InternalOnDblClick(GUIComponent Sender)
{
    local PlayerController PC;
    local int i;

        PC = PlayerOwner();

        if (Sender == SaveGameList)
        {
                //get the slot where the game is saved
                i = SaveGameList.FindIndex(SaveGameList.Get());

                //load the savegame
                PC.ClientTravel( "?load="$i, TRAVEL_Absolute, false);
        }

        return true;
}

DefaultProperties
{
        Begin Object Class=GUIButton Name=Button_Load
                OnClick=LeftButtonClick
                bVisible=true
                bTabStop=False
                RenderWeight=0.6
                TabOrder=0
                WinWidth=0.26
                WinHeight=0.08
                WinLeft=0.63
                WinTop=0.8
                Caption="Load Game"
        End Object
        butLoad=Button_Load

    //don't add the empty slot, because we are loading
    bSaving=false
}