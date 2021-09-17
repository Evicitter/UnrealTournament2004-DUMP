//------------------------------------------------------------------------------
//Created by EVILemitter
//Crt Time		: 30/03/2006 10:14
//Upd Time		: 05/09/2006 22:35
//Last update	: 15/09/2006 21:47:46
//------------------------------------------------------------------------------
class EvilEm_PRTS_CreatorTool extends BrushBuilder config(EvilEm_RTS_Tool);

struct StaticSettings
{
 var() globalconfig bool bAutoCreateStaticMeshes;
 var() globalconfig enum FindMet { FM_Tag, FM_Radius } MethodOfFinding;
 var() globalconfig name TagStaticMesh;
 var() globalconfig float RadiusToStaticMesh;
};

struct PCont
{
 var globalconfig bool bAutoFillMaxTraceDistance;
 var globalconfig enum MetOD { ThisProj, Min,Max } MethodOfDistance;
 var() globalconfig enum ComObj { CreateProj, UpdateActors, DeleteAllProj } ObjCommand;
};

const MAXSIDES = 6;
const DP       = class'DynamicProjector';

var() globalconfig int ShadowResolution;
var() globalconfig name InShadowActorTag, OutShadowActorTag;
var() globalconfig float ShadowRefreshRate;
var() globalconfig float OutMaxTraceDistance, OutProjectorsDrawScale;
var() globalconfig bool bUseGroupingActors;

//struct motion
var() globalconfig PCont ProjController;
var() globalconfig StaticSettings StaticMeshDublicate;
//End STRUCTS ------------------------------------------------------------------

var transient ScriptedTexture ST[MAXSIDES];
var transient DynamicProjector InPr[MAXSIDES], OutPr[MAXSIDES];
var transient CameraTextureClient CTC[MAXSIDES];
var transient Actor InActor, OutActor;
var transient LevelInfo LI;
//var transient UnrealEdEngine UEE;

//------------------ FOR SCRIPTED TEXTURE --------------------------------------
var protected byte CountClicksBuild;    //FOR MEMORY WINDOW
var protected bool IsOpenWindow;        //FOR MEMORY WINDOW
var protected array<string> STGroups;   //FOR MEMORY
var protected int globalId;             //FOR MEMORY
//------------------------- END ------------------------------------------------

//------------------- STATIC MESH CONTROL --------------------------------------
struct DataBaseStaticMeshActor
{
 var() globalconfig StaticMeshActor SelfActor, DublicateActor;
 var() globalconfig StaticMesh      Primitive;
 var() globalconfig vector          Location; //, RelativeLoc;
 var() globalconfig rotator         Rotation;
};

var protected array<DataBaseStaticMeshActor> ListSMA;
var protected int SMId;
//------------------------- END ------------------------------------------------

private function vAutoFillTrace()
{
 local Actor A;
 local vector HL, HN;
 local float t[MAXSIDES], genmax, genmin;
 local int i;

 //LI.ClearStayingDebugLines();

 /*for(i=0; i < MAXSIDES; i++)
 {
  //if(OutPr[i] == None) continue;
  A = LI.Trace(HL,HN,OutPr[i].Location + vector(OutPr[i].Rotation) * 20000, OutPr[i].Location, true);
  t[i] = int(VSize(OutPr[i].Location - HL));
  if(ProjController.MethodOfDistance == ThisProj) OutPr[i].MaxTraceDistance = t[i];
 }

 for(i=0; i < MAXSIDES; i++)
 {
  A = LI.Trace(HL,HN,vector(OutPr[i].Rotation) * 20000, OutPr[i].Location, false);

  t[i] = VSize(OutPr[i].Location - HL);
  OutPr[i].MaxTraceDistance = t[i];

  LI.Trace(VertVec,HN,OutPr[i].Location + vector(OutPr[i].Rotation) * 10000,OutPr[i].FrustumVertices[7],false);
  IsVertSize = VSize((OutPr[i].FrustumVertices[7]) - VertVec);
  t[i] += IsVertSize;

  //localsize = int(VSize(OutPr[i].FrustumVertices[7] + (VSize(OutPr[i].Location - HL)*vector(OutPr[i].rotation))));
  //localsize = int(VSize(HL - (OutPr[i].FrustumVertices[7]) * HN));
  //LI.DrawStayingDebugLine(OutPr[i].FrustumVertices[7],OutPr[i].FrustumVertices[7] + (VSize(OutPr[i].Location - HL)*vector(OutPr[i].rotation)),255,255,255);
  if(ProjController.MethodOfDistance == ThisProj) OutPr[i].MaxTraceDistance = t[i];
 }*/

 for(i=0; i < MAXSIDES; i++)
 {
  if(OutPr[i] == None)
   continue;

  A = LI.Trace(HL, HN, OutPr[i].Location + (vector(OutPr[i].Rotation) * MaxInt), OutPr[i].Location, false);

  t[i] = VSize(OutPr[i].Location - HL) * OutPr[i].DrawScale * Cos((OutPr[i].FOV / 2) * Pi / 180);

  if(ProjController.MethodOfDistance == ThisProj) OutPr[i].MaxTraceDistance = t[i];
 }

 if(ProjController.MethodOfDistance != ThisProj)
 {
  genmax = t[0];	for(i=0; i < MAXSIDES; i++ )   genmax = FMax(t[i],genmax);	//Find max value in massive
  genmin = t[0];	for(i=0; i < MAXSIDES; i++ )   genmin = FMin(t[i],genmin);	//Find min value in massive

  for(i=0; i < MAXSIDES; i++)
  {
   if(ProjController.MethodOfDistance == Min) OutPr[i].MaxTraceDistance = int(genmin);
   else if(ProjController.MethodOfDistance == Max) OutPr[i].MaxTraceDistance = int(genmax);
  }
 }
}

private function string RndString()
{                               
 local byte i;         //ASCII
 local string stmp;    //American Standart Code for Information Interchange

 //All chars = 0-127
 //All action chars = 32 - 127
 //Useforme chars = 65 - 90,97 - 122

 while(i++ <= 8)
 {
  if(bool(Rand(2))) //if(FRand() > 0.5)
   stmp $= Chr(65 + Rand(26));
  else stmp $= Chr(97 + Rand(26));
 }
 return stmp;
}

private function byte BBuildProjectors(optional bool bCreate)  //Return value -- is Warning Code
{
 local string STGroupsName;
 local rotator R;
 local vector LocCTC;
 local int i;

/* if(ObjCommand == 1) for(i=0; i < ArrayCount(Pr); i++) Pr[i].Destroy();
if(Right(string(TempMat),Len(matProjTex)) ~= matProjTex) PMat = TempMat;*/

 //TODO :: BadParametres -- Message;
 if(InShadowActorTag == '' || InShadowActorTag == 'None')   return 2;
 //TODO :: BadParametres -- Message;
 if(OutShadowActorTag == '' || OutShadowActorTag == 'None') return 3;

 LI = LevelInfo(FindObject("MyLevel.LevelInfo0",class'LevelInfo'));
 if(LI == None)
 {
  Warn("LevelInfo - from the first attempt has not been found");
  foreach ALLObjects(class'LevelInfo',LI) break;	//var LI assign first object.
 }

 //Check local Controller
 if(ProjController.ObjCommand == DeleteAllProj)
  {
   for(i=0; i < ArrayCount(InPr); i++)
   { if(InPr[i]!=None) { InPr[i].Group = 'None'; InPr[i].Destroy(); }
     if(OutPr[i]!=None) { OutPr[i].Group = 'None'; OutPr[i].Destroy(); }
     if(CTC[i] != None) { CTC[i].Group = 'None'; CTC[i].Destroy(); }
   }
   if(InActor != None && InActor.Group == InShadowActorTag) InActor.Group = 'None';
   if(OutActor != None && OutActor.Group == OutShadowActorTag) OutActor.Group = 'None';

   if(StaticMeshDublicate.bAutoCreateStaticMeshes)
   {
    for(SMId=0; SMId < ListSMA.Length; SMId++)
     if(ListSMA[SMId].DublicateActor != None)
        ListSMA[SMId].DublicateActor.Destroy();
    ListSMA.Remove(0, ListSMA.Length);
   }

   return 10;
  }

 if(ProjController.ObjCommand == UpdateActors) bCreate = false;

 foreach LI.ALLActors(class'Actor',InActor,InShadowActorTag)
  if(InActor != None) break;

 if(InActor == None) return 4; //BadParametres -- Message;

 foreach LI.ALLActors(class'Actor',OutActor,OutShadowActorTag)
  if(OutActor != None) break;

 if(OutActor == None) return 5; //BadParametres -- Message;

 Log("Distance from"@InActor.name@"to"@OutActor.name@"=="@ VSize(OutActor.Location - InActor.Location),class.name);

 if(bCreate)
 {
  STGroupsName = RndString()$"_n";
  STGroups.Insert(STGroups.Length,1);
  STGroups[globalid] = STGroupsName;
  globalid++;
 }

 for(i=0; i < MAXSIDES; i++)  //for(i=0; i < ArrayCount(CTC); i++)
 {
  //Create Scripted Textutre
  if(bCreate)
    ST[i] = new(LI.Outer, STGroupsName$i, RF_Public+RF_Standalone) class'ScriptedTexture';
  ST[i].SetSize(ShadowResolution,ShadowResolution);
  ST[i].VClampMode = TC_Clamp;
  ST[i].UClampMode = TC_Clamp;
  //Close for ISE ---- IS NO BAD ______________ ||||

  if(bCreate)
  {
   InPr[i] = InActor.Spawn(DP,,ST[i].name,InActor.Location);
   OutPr[i] = OutActor.Spawn(DP,,,OutActor.Location);
  }

  //Created CamRayTrace
  LocCTC = InActor.Location;
  LocCTC.Z -= 100 + (20 * i);
  if(bCreate) CTC[i] = LI.Spawn(class'CameraTextureClient',,,LocCTC);
  CTC[i].FOV = 90;
  CTC[i].RefreshRate = ShadowRefreshRate;
  CTC[i].CameraActor = InPr[i];
  CTC[i].DestTexture = ST[i];
  CTC[i].CameraTag = ST[i].Name;

    if((CTC[i].DestTexture == None) || (CTC[i].CameraActor == None) || (CTC[i].CameraTag == 'None'))
      Warn(CTC[i] @ ":: CameraActor = None or DestTexture = None");

  //Grouping Actor's
  if(bUseGroupingActors)
  {                           //IONP - tech
   if(InActor.Group == 'None') InActor.Group = InShadowActorTag;
   InPr[i].Group = InShadowActorTag;
   CTC[i].Group = InShadowActorTag;
   if(OutActor.Group == 'None') OutActor.Group = OutShadowActorTag;
   OutPr[i].Group = OutShadowActorTag;
  }
  //----------------------------------------------------------------------------
  InPr[i].SetBase(InActor,Vect(0,0,1));
  OutPr[i].SetBase(OutActor,Vect(0,0,1));
  InPr[i].AttachTag = InActor.Tag;
  OutPr[i].AttachTag = OutActor.Tag;
  //InPr[i].SetOwner(InActor);
  //OutPr[i].SetOwner(OutActor);

  InPr[i].FOV = 90;
  OutPr[i].FOV = 90;

  InPr[i].bHardAttach = true;
  OutPr[i].bHardAttach = true;

  OutPr[i].bGradient = true;
  OutPr[i].bProjectStaticMesh = false;
  OutPr[i].ProjTexture = ST[i];
  OutPr[i].bClipBSP = true;
  OutPr[i].bProjectOnUnlit = true;
  OutPr[i].FrameBufferBlendingOp = PB_None;
  OutPr[i].MaterialBlendingOp = PB_AlphaBlend; //PB_Modulate;

  //In PROJECTOR -- MaxTraceDistance don't use
  InPr[i].MaxTraceDistance = 1;
  OutPr[i].MaxTraceDistance = OutMaxTraceDistance;

  //Calculate non Symetric line of Textures
  //PosLine = (Max(U,V)/2) - (Min(V,U)/2) + (Min(V,U)/4);

  //Set Rotation
  R.Pitch = 0;
  if(i == 4) R.Pitch += 16384;
  if(i == 5) R.Pitch -= 16384;
  R.Yaw += 16384;
  R.Roll = 0;

  OutPr[i].SetDrawScale(OutProjectorsDrawScale);

  InPr[i].SetRotation(R);
  OutPr[i].SetRotation(R);

  InPr[i].SetLocation(InActor.Location + vector(InPr[i].Rotation) * 2);
  OutPr[i].SetLocation(OutActor.Location + vector(OutPr[i].Rotation) * (Max(ST[i].MaterialUSize(),ST[i].MaterialVSize())/2) * OutPr[i].DrawScale);
 }

  //MaxTraceDistance in out PROJECTORS -- is CORECTLY
  if(ProjController.bAutoFillMaxTraceDistance)
     vAutoFillTrace();
   //SizeArc = (Pi*OutMaxTraceDistance*90)/180;

 if(StaticMeshDublicate.bAutoCreateStaticMeshes) DevStaticMesh();

 return 255;
}

private function DevStaticMesh()
{
 local StaticMeshActor SMA;
 local bool bAcces, bUpdate;
 local int i, cmats;

 if(LI == None)
 {
  LI = LevelInfo(FindObject("MyLevel.LevelInfo0",class'LevelInfo'));
  if(LI == None) foreach ALLObjects(class'LevelInfo',LI) if(LI!=None) break;
 }

 switch(ProjController.ObjCommand)
 {
  case CreateProj: if(ListSMA.Length > 0) ListSMA.Remove(0,ListSMA.Length); break;
  case UpdateActors: bUpdate = true; break;
 }

 SMId = 0;

 //FILL LIST -------------------------------------------------------------
 foreach LI.AllActors(class'StaticMeshActor',SMA) //I am not use third parametre
 {
  if((StaticMeshDublicate.MethodOfFinding == FM_Tag) &&
     (StaticMeshDublicate.TagStaticMesh == SMA.Tag))
      bAcces = true;

  else if((StaticMeshDublicate.MethodOfFinding == FM_Radius) &&
          VSize(OutActor.Location - SMA.Location) <= StaticMeshDublicate.RadiusToStaticMesh)
      bAcces = true;
  else bAcces = false;

  if(bAcces)
  {
   ListSMA.Insert(ListSMA.Length,1);
   ListSMA[SMid].SelfActor = SMA;
   ListSMA[SMid].Primitive = SMA.StaticMesh;
   ListSMA[SMid].Rotation = SMA.Rotation;
   ListSMA[SMid].Location = SMA.Location;
   //ListSMA[SMid].RelativeLoc = SMA.Location - OutActor.Location;
   SMid++;
  }
  bAcces = false;
 }

 for(SMid=0; SMid < ListSMA.Length; SMid++)
 {
  if(!bUpdate) ListSMA[SMid].DublicateActor = LI.Spawn(class'StaticMeshActor');

  if(ListSMA[SMid].SelfActor == None || ListSMA[SMid].DublicateActor == None)
  {
   ListSMA.Remove(SMid,1);
   SMid--;
   continue;
  }

  if(StaticMeshDublicate.MethodOfFinding != FM_Tag)
   ListSMA[SMid].DublicateActor.Tag = ListSMA[SMid].SelfActor.Tag;
  ListSMA[SMid].DublicateActor.SetStaticMesh(ListSMA[SMid].Primitive);
  ListSMA[SMid].DublicateActor.SetRotation(ListSMA[SMid].Rotation);
  ListSMA[SMid].DublicateActor.SetLocation(ListSMA[SMid].Location + (InActor.Location - OutActor.Location)); //-My logic ---- Projection method
  //ListSMA[SMid].DublicateActor.SetLocation(InActor.Location + ListSMA[SMid].RelativeLoc);                  //-My old bad logic ---- no comment

  cmats = CountMaterials(ListSMA[SMid].Primitive);

  for(i=0; i < cmats; i++)
   ListSMA[SMid].DublicateActor.Skins[i] = Material(FindObject("Engine.GrayTexture",class'Material'));
 }
}

function int CountMaterials(StaticMesh SM) //EvilEm ::>> Simply getting Length Array from variable "materials".
{
 local string s;
 local int count, pos;
 local bool bs;

 if(SM == None)
  return 0;

 s = SM.GetPropertyText("Materials");

 if(s == "")
  return 0;

 do
 {
  pos = InStr(s,"),(");

  if(pos != -1)
  {
   s = Mid(s, pos + 3);
   count++;
  }
  else
   bs = true;
 } until(bs);
 return count + 1;
}

function bool Build()
{
 local string s;

 CountClicksBuild += 1;
 IsOpenWindow = true;
 switch(BBuildProjectors(ProjController.ObjCommand == CreateProj))
 {
  case 0: s = "NULL";                                                           break;
  case 1: s = class @ "-- Not good work code.";                                 break;
  case 2: s = "Specify other value of parameter - InShadowActorTag.";           break;
  case 3: s = "Specify other value of parameter - OutShadowActorTag.";          break;
  case 4: s = "The actor with value Tag <"$InShadowActorTag$"> is not found.";  break;
  case 5: s = "The actor with value Tag <"$OutShadowActorTag$"> is not found."; break;
  case 10: s = "All projectors have been successfully removed";                 break;
  case 11: s = "All selected projectors have been successfully removed";        break;
  case 255: s = "Operation is successfully completed.";                         break;
  default: s = "Such number of a error of a code does not exist.";              break;
 }
 IsOpenWindow = false;

 //StaticSaveConfig();
 if(s != "NULL") BadParameters(s);

 return false;
}

/*      -Int FILE*
[Public]
Object=(Name=EvilEm_RTS_Tool.EvilEm_PRTS_CreatorTool,Class=Class,MetaClass=Editor.BrushBuilder,Autodetect=True)
*/

defaultproperties
{
 ShadowResolution=256
 OutMaxTraceDistance=1000
 OutProjectorsDrawScale=1.0
 ShadowRefreshRate=60.0
 IsOpenWindow=False
 BitmapFilename="CameraAlign"
 ToolTip="EVILemitter -> Pseudo Ray Trace Shadow Creator Tool :: Content creation in UEd. Created Projectors for Method <PseudoRayTraceShadows>"
}
