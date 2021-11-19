//Date: 30/08/2005 20:04:22
class Interface_SavePage extends Interface_SaveGamePage;

var Automated GUIButton butSave;

function bool LeftButtonClick(GUIComponent Sender)
{
    local PlayerController PC;
    local int i;

        PC = PlayerOwner();

        if (Sender == butSave)
        {
                //get the slot for save
                i = SaveGameList.FindIndex(SaveGameList.Get());

                //save the game
                PC.ConsoleCommand("SaveGame "$i);

                //save caption and desc to the ini file
                SaveCaptions[i] = PC.Level.Title$" | "$PC.Level.Day$"/"$PC.Level.Month$"/"$PC.Level.Year$" | "$PC.Level.Hour$":"$PC.Level.Minute$":"$PC.Level.Second;
                SaveDescs[i] = PC.Level.Description;
                SaveConfig();

                Controller.CloseMenu(false);
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
                //get the slot for save
                i = SaveGameList.FindIndex(SaveGameList.Get());

                //save the game
                PC.ConsoleCommand("SaveGame "$i);

                //save caption and desc to the ini file
                SaveCaptions[i] = PC.Level.Title$" | "$PC.Level.Day$"/"$PC.Level.Month$"/"$PC.Level.Year$" | "$PC.Level.Hour$":"$PC.Level.Minute$":"$PC.Level.Second;
                SaveDescs[i] = PC.Level.Description;
                SaveConfig();

                Controller.CloseMenu(false);
        }

        return true;
}

DefaultProperties
{
        Begin Object Class=GUIButton Name=Button_Save
                OnClick=LeftButtonClick
                bVisible=true
                bTabStop=False
                RenderWeight=0.6
                TabOrder=0
                WinWidth=0.26
                WinHeight=0.08
                WinLeft=0.63
                WinTop=0.8
                Caption="Save Game"
        End Object
        butSave=Button_Save

    bSaving=true
}