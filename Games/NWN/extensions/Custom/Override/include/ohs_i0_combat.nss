//::///////////////////////////////////////////////
//:: Name ohs_i0_combat
//:: Copyright (c) 2004 OldMansBeard
//:://////////////////////////////////////////////
/*
   Miscellaneous functions to support OHS henchman combat
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-12-13
//:: Modified On: 2005-04-04
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Modified By:   DonTheDime
//:: Last Modified: 2005-04-01
//:: Comments:      Commented out the IsTwoHander function and added a modified
//::     one to ohs_i0_common.  Also modified EquipFavouriteWeapons function to
//::     adjust the weapon(s) equiped based upon OHS_MELEE_PREF setting: one-handed
//::     with shield => 1; two-handed => 2; dual-wield => 3; unarmed => 4; one-handed
//::     without shield => 5; and default -no set preference- => 0.  Further
//::     modified EquipFavouriteWeapons function to allow wielding of shields for
//::     appropriate ranged weapons (dart, shuriken, sling, and throwing axe).
//:://////////////////////////////////////////////
//:: Last Modified OMB: 2006-04-24

#include "x0_inc_henai"
#include "ohs_i0_common"

// Equip favourite ranged or melee weapon and possibly shield
// according to preference and target.  Modified by DonTheDime (2005-03-15) to
// adjust the melee weapon(s) equipped based upon OHS_MELEE_PREF setting. Further
// modified by DonTheDime (2005-04-01) to remove a light weapon or shield in the
// left hand if one-handed only (5) preference is set.
void EquipFavouriteWeapons(object oTarget);

// Wrapper for x0_inc_henai::HenchmenCombatRound()
void OHSCombatRound(object oTarget);

/*******************/
/* Implementations */
/*******************/

// Favourite ranged weapon if available, otherwise best
object OptimumRangedWeapon()
{
  object oItem = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_RANGED_WEAPON");
  if (!GetIsObjectValid(oItem) || GetItemPossessor(oItem)!=OBJECT_SELF)
  {
    oItem = GetBestRangedWeapon();
    SetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_RANGED_WEAPON",oItem);
  }
  return oItem;
}

// Favourite melee weapon if suitable, otherwise best
object OptimumMeleeWeapon()
{
  object oItem = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_MELEE_WEAPON");
  if (!GetIsObjectValid(oItem) || GetItemPossessor(oItem)!=OBJECT_SELF || !IsRightSize(oItem))
  {
    oItem = GetBestMeleeWeapon();
    SetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_MELEE_WEAPON",oItem);
  }
  return oItem;
}

// Choose the most appropriate right-hand object
object ChooseRight(int nStyle, object oTarget)
{
  object oNewRight;
  int bPreferRanged = GetAssociateState(NW_ASC_USE_RANGED_WEAPON);
  int bCloseCombat  = GetIsObjectValid(oTarget) && GetDistanceToObject(oTarget)<3.0f && !GetHasFeat(FEAT_POINT_BLANK_SHOT);

  if (bPreferRanged && !bCloseCombat) // Determine favourite/best ranged weapon
  {
    oNewRight = OptimumRangedWeapon();
    if (!GetIsObjectValid(oNewRight)) bPreferRanged = FALSE;
  }

  if (bCloseCombat || !bPreferRanged) // Determine favourite/best melee weapon
  {
    if (nStyle==OHS_STYLE_BAREHANDED) oNewRight = OBJECT_INVALID;
    else
    {
      oNewRight = OptimumMeleeWeapon();
      if (!GetIsObjectValid(oNewRight) && GetIsObjectValid(oTarget))
      {
        // Emergency combat situation - do the best you can
        SetLocalInt(OBJECT_SELF,"OHS_MELEE_PREF",OHS_STYLE_DEFAULT);
        oNewRight = OptimumMeleeWeapon();
      }
    }
  }
  return oNewRight;
}

// Favourite shield if available, otherwise best shield
object OptimumShield()
{
  object oItem = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_SHIELD");
  if (!GetIsObjectValid(oItem) || GetItemPossessor(oItem)!=OBJECT_SELF)
  {
    oItem = GetBestShield();
    SetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_SHIELD",oItem);
  }
  return oItem;
}

// Favourite off-hand weapon if available, otherwise best
object OptimumSecondWeapon(object oNewRight)
{
  object oItem = GetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_MELEE_OFFHAND");
  if (!GetIsObjectValid(oItem) || GetItemPossessor(oItem)!=OBJECT_SELF || !IsLightWeapon(oItem) || oItem==oNewRight)
  {
    oItem = GetBestOffHandWeapon(oNewRight);
    SetLocalObject(OBJECT_SELF,"OHS_FAVOURITE_MELEE_OFFHAND",oItem);
  }
  return oItem;
}

// Choose the most appropriate off-hand object
object ChooseLeft(int nStyle, object oNewRight)
{
  object oNewLeft;
  object oOldLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
  int bUsingTorch = GetBaseItemType(oOldLeft)==BASE_ITEM_TORCH;

  if (OHS_GetIsRangedWeapon(oNewRight))
  {
    int nType = GetBaseItemType(oNewRight);
    if (nType == BASE_ITEM_DART || nType == BASE_ITEM_SHURIKEN ||
        nType == BASE_ITEM_SLING || nType == BASE_ITEM_THROWINGAXE)
    {
      if (bUsingTorch) oNewLeft = oOldLeft;
      else oNewLeft = OptimumShield();
    }
    else
    {
      oNewLeft = OBJECT_INVALID;
    }
  }
  else if (IsTwoHander(oNewRight)) oNewLeft = OBJECT_INVALID;
  else if (bUsingTorch) oNewLeft =  oOldLeft;
  else switch(nStyle)
  {
    case OHS_STYLE_BAREHANDED:
    case OHS_STYLE_ONE_HANDER:
        oNewLeft = OBJECT_INVALID;
        break;

    case OHS_STYLE_DUAL_WIELD:
        oNewLeft = OptimumSecondWeapon(oNewRight);
        break;

    default: oNewLeft = OptimumShield();
  }

  return oNewLeft;
}

// Make any necessary actions to ensure that oNewRight and oNewLeft are in place
void MakeChanges(object oNewRight, object oNewLeft)
{
  object oOldRight = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  object oOldLeft  = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);

  // Determine if slots need changing
  int bSwitchRight = (oNewRight != oOldRight);
  int bSwitchLeft  = (oNewLeft != oOldLeft);

  // Do the necessary actions
  if (bSwitchRight || bSwitchLeft) ClearAllActions();
  if (bSwitchLeft)
  {
    if (GetIsObjectValid(oNewLeft)) ActionEquipItem(oNewLeft,INVENTORY_SLOT_LEFTHAND);
    else ActionUnequipItem(oOldLeft);
  }
  if (bSwitchRight && bSwitchLeft) ActionWait(0.7);
  if (bSwitchRight)
  {
    if (GetIsObjectValid(oNewRight)) ActionEquipItem(oNewRight,INVENTORY_SLOT_RIGHTHAND);
    else ActionUnequipItem(oOldRight);
  }
}

// Equip favourite ranged or melee weapon and possibly shield
// according to preference and target.  Modified by DonTheDime (2005-03-15) to
// adjust the melee weapon(s) equipped based upon OHS_MELEE_PREF setting. Further
// modified by DonTheDime (2005-04-01) to remove a light weapon or shield in the
// left hand if one-handed only (5) preference is set.
void EquipFavouriteWeapons(object oTarget)
{
  int nStyle = GetLocalInt(OBJECT_SELF,"OHS_MELEE_PREF");
  object oNewRight = ChooseRight(nStyle, oTarget);
  object oNewLeft = ChooseLeft(nStyle,oNewRight);
  MakeChanges(oNewRight,oNewLeft);
}

// Wrapper for x0_inc_henai::HenchmenCombatRound()
void OHSCombatRound(object oTarget)
{
  if (GetIsObjectValid(oTarget))
  {
    SetCommandable(TRUE);
  }
  EquipFavouriteWeapons(oTarget);
  HenchmenCombatRound(oTarget);
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


