void main()
{
  object oBetter = GetLocalObject(OBJECT_SELF,"OHS_BETTER_SHIELD");
  SetLocalObject(OBJECT_SELF,"OHS_BETTER_SHIELD",OBJECT_INVALID);
  object oPoorer = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_SHIELD");
  SetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_SHIELD",oBetter);
  ActionEquipItem(oBetter,INVENTORY_SLOT_LEFTHAND);
  // Retro-fix for pre-1.4 henchmen
  SetDroppableFlag(oBetter,FALSE);
  if (oBetter==GetLocalObject(OBJECT_SELF,"OHS_SURETY"))
  {
    SetItemCursedFlag(oBetter,TRUE);
  }
  else
  {
    SetItemCursedFlag(oBetter,FALSE);
  }
  SetDroppableFlag(oPoorer,FALSE);
  if (oPoorer==GetLocalObject(OBJECT_SELF,"OHS_SURETY"))
  {
    SetItemCursedFlag(oPoorer,TRUE);
  }
  else
  {
    SetItemCursedFlag(oPoorer,FALSE);
  }
}

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole modified    //
// or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////

