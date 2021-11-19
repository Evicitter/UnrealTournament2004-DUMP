//Date: 10/01/2006 14:59:40
class Interface_SaveGamePage extends UT2K4GUIPage config(MOD_FINALMISSION);

//#EXEC OBJ LOAD FILE=BSInterface.utx

var Automated GUIImage MyBackGround;

//list including all saved games
var Automated GUIList SaveGameList;

//textbox showing the saved map's description
var Automated GUIScrollTextBox TBDesc;

//check if the "empty slot" is needed
var bool bSaving;

//the config var saving the savegame names
var globalconfig array<string> SaveCaptions;

//the config var saving the savegame descs
var globalconfig array<string> SaveDescs;

function InternalOnOpen()
{
    local int i;

        for(i=0; i < SaveCaptions.Length; i++)
        {
                //add all saved games to the savegame list
                SaveGameList.Add(SaveCaptions[i],,SaveDescs[i]);
        }
        if (bSaving)
                //if saving add an empty slot
                SaveGameList.Add("Empty Slot");
}


function bool InternalOnDblClick(GUIComponent Sender)
{
        //added for delegate
        return true;
}

function InternalOnChange(GUIComponent Sender)
{
        if (sender == SaveGameList)
        {
                //set the textbox's content
                TBDesc.SetContent(SaveGameList.GetExtra());
        }
}

DefaultProperties
{
        OnOpen=InternalOnOpen

        Begin Object class=GUIImage name=BackGround
                WinWidth=1
                WinHeight=1
                WinLeft=0
                WinTop=0
                //Image=Material'BSInterface.background_default'
                ImageStyle=ISTY_Scaled
                ImageRenderStyle=MSTY_Normal
                bVisible=true
        End Object
        MyBackGround=BackGround

        Begin Object class=GUIScrollTextBox name=TextBox_Desc
                WinWidth=0.4
                WinHeight=0.4
                WinLeft=0.55
                WinTop=0.055
                bNoTeletype=true
                bVisible=true
        End Object
        TBDesc=TextBox_Desc

        Begin Object Class=GUIList Name=List_Saves
                OnDblClick=InternalOnDblClick
                OnChange=InternalOnChange
                WinTop=0.055
                WinLeft=0.05
                WinWidth=0.4
                WinHeight=0.89
        End Object
        SaveGameList=List_Saves

        WinWidth=1.0
        WinHeight=1.0
        WinTop=0.0
        WinLeft=0.0

        //bIgnoreEsc=true
        bAllowedAsLast=true
}