// Return TRUE if you refuse to work for the PCSpeaker
#include "ohs_i0_toolkit"
int StartingConditional()
{
  object oPC = GetPCSpeaker();
  if (OHS_GetIsCompanion(OBJECT_SELF))
  {
    // I'm a Companion. I only work for my own player but
    // otherwise I'm not fussy.
    string sMyPlayer = GetLocalString(OBJECT_SELF,"OHS_S_PLAYER_OWNER");
    string sYourPlayer = GetPCPlayerName(oPC);
    if (sMyPlayer!=sYourPlayer) return TRUE;
    else return FALSE;
  }
  else
  {
    // I'm just a registered henchman. I'll work for anyone with enough XP.
    return (GetXP(OBJECT_SELF)>GetXP(GetPCSpeaker()));
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