//::///////////////////////////////////////////////
//:: Name ohs_hen_damage
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   OnDamaged Event Handler for OHS Henchmen.
   This is a much-modified version of nw_ch_ac6
*/
//:://////////////////////////////////////////////
//:: Created By:    OldMansBeard
//:: Created On:    2004-12-10
//:: Last Modified: 2004-12-14
//:://////////////////////////////////////////////

#include "ohs_i0_combat"
#include "inc_debug_dac"
#include "nw_i0_plot"

// Determine whether or not to switch to the new attacker
int BetterTarget(object oTarget, object oAttacker);

void main()
{
  //debugVarObject("ohs_hen_damage", OBJECT_SELF);
  
  object oAttacker = GetLastDamager();
  object oTarget = GetAttackTarget();
  object oEnemy = GetLastHostileActor(GetMaster());

  if (GetAssociateState(NW_ASC_MODE_STAND_GROUND))
  {
    return;
  }
  else if (GetIsObjectValid(oEnemy) && GetAssociateState(NW_ASC_MODE_DEFEND_MASTER))
  {
    OHSCombatRound(oEnemy);
  }
  else if (BetterTarget(oTarget,oAttacker))
  {
    OHSCombatRound(oAttacker);
  }
}


// Determine whether or not to switch to the new attacker
int BetterTarget(object oTarget, object oAttacker)
{
  if (!GetIsObjectValid(oTarget))
  {
    return TRUE;
  }
  else if (oAttacker==oTarget)
  {
    return FALSE;
  }
  else if (GetDistanceToObject(oAttacker)<=3.0f && GetDistanceToObject(oTarget)>3.0f)
  {
    return TRUE;
  }
  else if (GetHitDice(oAttacker) > GetHitDice(oTarget))
  {
    return TRUE;
  }
  else if (GetTotalDamageDealt() > GetMaxHitPoints(OBJECT_SELF)/4)
  {
    return TRUE;
  }
  else
  {
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