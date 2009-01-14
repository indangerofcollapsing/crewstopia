//::///////////////////////////////////////////////
//:: Name ohs_hen_combat
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnCombatRoundEnd Event Handler for OHS Henchmen.
   This is a simplified version of x0_ch_hen_combat.
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-12-10
//:: Last Modified: 2004-12-14
//:://////////////////////////////////////////////
//
#include "ohs_i0_combat"
#include "inc_debug_dac"
#include "nw_i0_plot"

void main()
{
  //debugVarObject("ohs_hen_combat", OBJECT_SELF);
  
  OHSCombatRound(OBJECT_INVALID);
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