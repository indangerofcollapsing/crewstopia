#include "ohs_i0_messages"
int StartingConditional()
{
  object oBetter = GetLocalObject(OBJECT_SELF,"OHS_BETTER_SHIELD");
  object oNow = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_SHIELD");
  if (GetIsObjectValid(oBetter) && oBetter!=oNow)
  {
    SetCustomToken(794,GetName(oBetter));
    return TRUE;
  }
  else if (GetIsObjectValid(oNow))
  {
    SetCustomToken(794,GetName(oNow));
    return FALSE;
  }
  else
  {
    string sPresentState = OHS_GetStringByLanguage(202,GetPCSpeaker());
    SetCustomToken(794,sPresentState);
    return FALSE;
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


