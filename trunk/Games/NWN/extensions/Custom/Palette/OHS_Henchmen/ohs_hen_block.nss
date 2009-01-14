//::///////////////////////////////////////////////
//:: Name ohs_hen_block
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnBlocked Event Handler for OHS Henchmen
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-12-10
//:://////////////////////////////////////////////

#include "inc_debug_dac"
#include "nw_i0_plot"

void main()
{
  //debugVarObject("ohs_hen_block", OBJECT_SELF);
  
  object oDoor = GetBlockingDoor();
  if (GetIsDoorActionPossible(oDoor,DOOR_ACTION_OPEN))
  {
    DoDoorAction(oDoor,DOOR_ACTION_OPEN);
  }
  else if (GetIsDoorActionPossible(oDoor,DOOR_ACTION_UNLOCK) && GetHasSkill(SKILL_OPEN_LOCK))
  {
    DoDoorAction(oDoor,DOOR_ACTION_UNLOCK);
  }
  else if (GetIsDoorActionPossible(oDoor,DOOR_ACTION_BASH))
  {
    DoDoorAction(oDoor,DOOR_ACTION_BASH);
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