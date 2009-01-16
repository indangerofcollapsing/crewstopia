//::///////////////////////////////////////////////
//:: Name ohs_i0_common
//:: Copyright (c) 2004 OldMansBeard.
//:://////////////////////////////////////////////
/*
   A collection of miscellaneous functions for
   OldMansBeard's Henchman System
*/
//:://////////////////////////////////////////////
//:: Created By: OldMansBeard
//:: Created On: 2004-11-25
//:://////////////////////////////////////////////
//:: Modified By:   DonTheDime
//:: Last Modified: 2005-04-05
//:: Comments:
//::     Added three new functions and modified two existing functions
//::     to check for a useable offhand weapon and to determine the best one for
//::     dual wielders to use.
//::     Added new function to check for a successful Use Magic Device skill check
//::     and modified existing IsPermittedItem() function to call for it as needed.
//:://////////////////////////////////////////////
//:: Last Modified by OMB: 2006-04-24

// @DUG #include "x2_inc_itemprop"

const int OHS_STYLE_DEFAULT = 0;
const int OHS_STYLE_WEAPON_AND_SHIELD = 1;
const int OHS_STYLE_TWO_HANDER = 2;
const int OHS_STYLE_DUAL_WIELD = 3;
const int OHS_STYLE_BAREHANDED = 4;
const int OHS_STYLE_ONE_HANDER = 5;

const int OHS_UMD_TYPE_CLASS     = 1;
const int OHS_UMD_TYPE_RACE      = 2;
const int OHS_UMD_TYPE_ALIGNMENT = 3;

// Test if MaxHenchmen needs forcing (eg when just loaded module)
int NeedToForceMaxHenchmen();

// Force the MaxHenchmen parameter to be high enough to get one more in
void ForceMaxHenchmen(object oPC);

// Set Local Variables on oItem by 2DA lookup on baseitems
// but don't repeat the lookups if they are already known.
void SetItemData(object oItem);

// Decide if the caller has the required feat to use oItem
int GetHasRequiredFeat(object oItem);

// Check that oItem has no restrictions that would prevent caller from using it
// Modified by DonTheDime 2005-04-05 to call GetSuccessfulUMDSKillCHeck()
// for a Use Magic Device skill check to overcome restrictions.
int IsPermittedItem(object oItem);

// Check if caller can successfully use a class/race/alignment restricted oItem
// via a Use Magic Device skill check. (Added by DonTheDime 2005-04-05)
// OMB: nRestriction should be one of the OHS_UMB_TYPE_* constants
int GetSuccessfulUMDSkillCheck(int nRestriction, object oItem);

// Check the (weapon)size difference between oItem and caller
int GetSizeDifference(object oItem);

// Decide if oItem is more valuable than oBest
int IsMoreValuable(object oItem, object oBest);

// Decide if oItem is a melee weapon the caller can use
int IsUseableMeleeWeapon(object oItem);

// Decide if oItem is a ranged weapon the caller can use
int IsUseableRangedWeapon(object oItem);

// Decide if oItem is a shield the caller can use
int IsUseableShield(object oItem);

// Check if oItem counts as a 2H weapon for caller (one size larger)
int IsTwoHander(object oItem);

// Check if oItem counts as a light weapon for caller (one size or more smaller)
int IsLightWeapon(object oItem);

// Check if oItem is the right size for use as a primary weapon
// according to the caller's current melee style preference
// (Part of DonTheDime's improvements for dual-wielding)
int IsRightSize(object oItem);

// Find the most valuable melee weapon you possess and can use
// n.b. ignores anything equipped in the left hand
// Modified to check for weapon size as part of DonTheDime's
// dual-wielding improvements.
object GetBestMeleeWeapon();

// Find the most valuable ranged weapon you possess and can use
object GetBestRangedWeapon();

// Find the most valuable shield you possess and can use
object GetBestShield();

// Find the most valuable light melee weapon you possess and can use in the
// off hand for dual wielding. Ignores anything equipped in the right hand.
// Added by DonTheDime (2005-03-15).  Modified (2005-03-21) to check if weapon
// found is the same as the favourite primary melee weapon, ignoring it if found.
object GetBestOffHandWeapon(object oPrimaryWeapon);

// OHS Replacement for IPGetIsMeleeWeapon()
// Uses 2da lookup so CEP etc. weapons are recognised
int OHS_GetIsMeleeWeapon(object oItem);

// OHS Replacement for IPGetIsRangedWeapon()
// Uses 2da lookup so CEP etc. weapons are recognised
int OHS_GetIsRangedWeapon(object oItem);

/*******************/
/* Implementations */
/*******************/

// Test if MaxHenchmen needs forcing (eg when just loaded module)
int NeedToForceMaxHenchmen()
{
  int nBaseMax = GetLocalInt(GetModule(),"OHS_BASE_MAX_HENCHMEN");
  if (nBaseMax==0 || nBaseMax==GetMaxHenchmen()) return TRUE;
  else return FALSE;
}

// Force the MaxHenchmen parameter to be high enough to get one more in
void ForceMaxHenchmen(object oPC)
{
  int nNth=1;
  int nExtras = 0;
  object oHenchman = GetHenchman(oPC,nNth);
  while (GetIsObjectValid(oHenchman))
  {
    if (FindSubString(GetTag(oHenchman),"OHS_")==0) nExtras++;
    nNth++;
    oHenchman = GetHenchman(oPC,nNth);
  }
  int nTotal = nNth-1;
  int nMaxHenchmen = GetMaxHenchmen();
  int nBaseMax = GetLocalInt(GetModule(),"OHS_BASE_MAX_HENCHMEN");
  if (nBaseMax==0)
  {
    nBaseMax = nMaxHenchmen;
    SetLocalInt(GetModule(),"OHS_BASE_MAX_HENCHMEN",nBaseMax);
  }
  int nNeeded = nBaseMax+nExtras+1;
  if (nTotal-nExtras > nBaseMax) nNeeded = nTotal+1;
  if (nNeeded>nMaxHenchmen)
  {
    SetMaxHenchmen(nNeeded);
    //debugVarInt("MaxHenchmen", GetMaxHenchmen());
  }
}

// Set Local Variables on oItem by 2DA lookup on baseitems
// but don't repeat the lookups if they are already known.
void SetItemData(object oItem)
{
  if (!GetIsObjectValid(oItem)) return;
  if (GetLocalInt(oItem,"OHS_ITEM_DATA_KNOWN")==2) return;
  int nData;
  int nBase = GetBaseItemType(oItem);
  nData = StringToInt(Get2DAString("baseitems","WeaponType",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_WEAPONTYPE",nData);
  nData = StringToInt(Get2DAString("baseitems","WeaponSize",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_WEAPONSIZE",nData);
  nData = StringToInt(Get2DAString("baseitems","RangedWeapon",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_RANGEDWEAPON",nData);
  nData = StringToInt(Get2DAString("baseitems","ReqFeat0",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT0",nData);
  nData = StringToInt(Get2DAString("baseitems","ReqFeat1",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT1",nData);
  nData = StringToInt(Get2DAString("baseitems","ReqFeat2",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT2",nData);
  nData = StringToInt(Get2DAString("baseitems","ReqFeat3",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT3",nData);
  nData = StringToInt(Get2DAString("baseitems","ReqFeat4",nBase));
  SetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT4",nData);
  SetLocalInt(oItem,"OHS_ITEM_DATA_KNOWN",2);
}

// Decide if the caller has the required feat to use oItem
int GetHasRequiredFeat(object oItem)
{
  if (!GetIsObjectValid(oItem)) return FALSE;
  SetItemData(oItem);
  int nFeat = GetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT0");
  if (nFeat==0 || GetHasFeat(nFeat)) return TRUE;
  nFeat = GetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT1");
  if (nFeat==0) return FALSE;
  else if (GetHasFeat(nFeat)) return TRUE;
  nFeat = GetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT2");
  if (nFeat==0) return FALSE;
  else if (GetHasFeat(nFeat)) return TRUE;
  nFeat = GetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT3");
  if (nFeat==0) return FALSE;
  else if (GetHasFeat(nFeat)) return TRUE;
  nFeat = GetLocalInt(oItem,"OHS_ITEM_DATA_REQFEAT4");
  if (nFeat==0) return FALSE;
  else if (GetHasFeat(nFeat)) return TRUE;
  else return FALSE;
}

// Check that oItem has no restrictions that would prevent caller from using it
// Modified by DonTheDime 2005-04-05 to call GetSuccessfulUMDSKillCHeck()
// for a Use Magic Device skill check to overcome restrictions.
int IsPermittedItem(object oItem)
{
  itemproperty ip;
  int nType, nSubType;
  int bAllowed = TRUE;
  if (GetItemHasItemProperty(oItem,ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE))
  {
    bAllowed = FALSE;
    //Check if Use Magic Device skill can overcome race restriction
    if (GetHasSkill(SKILL_USE_MAGIC_DEVICE,OBJECT_SELF) && GetSuccessfulUMDSkillCheck(OHS_UMD_TYPE_RACE,oItem))
    {
      bAllowed = TRUE;
    }
    else
    {
      ip = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(ip) && !bAllowed)
      {
        nType = GetItemPropertyType(ip);
        if (nType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE)
        {
          nSubType = GetItemPropertySubType(ip);
          if (nSubType==GetRacialType(OBJECT_SELF)) bAllowed = TRUE;
        }
        ip = GetNextItemProperty(oItem);
      }
    }
  }
  if (!bAllowed) return FALSE;

  if (GetItemHasItemProperty(oItem,ITEM_PROPERTY_USE_LIMITATION_CLASS))
  {
    bAllowed = FALSE;
    //Check if Use Magic Device skill can overcome class restriction
    if (GetHasSkill(SKILL_USE_MAGIC_DEVICE,OBJECT_SELF) && GetSuccessfulUMDSkillCheck(OHS_UMD_TYPE_CLASS,oItem))
    {
      bAllowed = TRUE;
    }
    else
    {
      ip = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(ip) && !bAllowed)
      {
        nType = GetItemPropertyType(ip);
        if (nType == ITEM_PROPERTY_USE_LIMITATION_CLASS)
        {
          nSubType = GetItemPropertySubType(ip);
          if (GetLevelByClass(nSubType)>0) bAllowed = TRUE;
        }
        ip = GetNextItemProperty(oItem);
      }
    }
  }
  if (!bAllowed) return FALSE;

  if (GetItemHasItemProperty(oItem,ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP))
  {
    bAllowed = FALSE;
    //Check if Use Magic Device skill can overcome alignment restriction
    if (GetHasSkill(SKILL_USE_MAGIC_DEVICE,OBJECT_SELF) && GetSuccessfulUMDSkillCheck(OHS_UMD_TYPE_ALIGNMENT,oItem))
    {
      bAllowed = TRUE;
    }
    else
    {
      ip = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(ip) && !bAllowed)
      {
        nType = GetItemPropertyType(ip);
        if (nType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP)
        {
          nSubType = GetItemPropertySubType(ip);
          switch(nSubType)
          {
            case IP_CONST_ALIGNMENTGROUP_ALL:
              bAllowed = TRUE;
              break;
            case IP_CONST_ALIGNMENTGROUP_CHAOTIC:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_CHAOTIC) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENTGROUP_EVIL:
              if (GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENTGROUP_GOOD:
              if (GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENTGROUP_LAWFUL:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENTGROUP_NEUTRAL:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_NEUTRAL ||
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_NEUTRAL) bAllowed=TRUE;
              break;
          }
        }
        ip = GetNextItemProperty(oItem);
      }
    }
  }
  if (!bAllowed) return FALSE;

  if (GetItemHasItemProperty(oItem,ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT))
  {
    bAllowed = FALSE;
    //Check if Use Magic Device skill can overcome alignment restriction
    if (GetHasSkill(SKILL_USE_MAGIC_DEVICE,OBJECT_SELF) && GetSuccessfulUMDSkillCheck(OHS_UMD_TYPE_ALIGNMENT,oItem))
    {
      bAllowed = TRUE;
    }
    else
    {
      ip = GetFirstItemProperty(oItem);
      while (GetIsItemPropertyValid(ip) && !bAllowed)
      {
        nType = GetItemPropertyType(ip);
        if (nType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT)
        {
          nSubType = GetItemPropertySubType(ip);
          switch(nSubType)
          {
            case IP_CONST_ALIGNMENT_CE:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_CHAOTIC &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_CG:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_CHAOTIC &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_CN:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_CHAOTIC &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_NEUTRAL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_LE:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_LG:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_LN:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_LAWFUL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_NEUTRAL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_NE:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_NEUTRAL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_EVIL) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_NG:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_NEUTRAL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_GOOD) bAllowed=TRUE;
              break;
            case IP_CONST_ALIGNMENT_TN:
              if (GetAlignmentLawChaos(OBJECT_SELF)==ALIGNMENT_NEUTRAL &&
                  GetAlignmentGoodEvil(OBJECT_SELF)==ALIGNMENT_NEUTRAL) bAllowed=TRUE;
              break;
          }
        }
        ip = GetNextItemProperty(oItem);
      }
    }
  }
  return bAllowed;
}

// Check if caller can successfully use a class/race/alignment restricted oItem
// via a Use Magic Device skill check. (Added by DonTheDime 2005-04-05)
// OMB: nRestriction should be one of the OHS_UMB_TYPE_* constants
int GetSuccessfulUMDSkillCheck(int nRestriction, object oItem)
{
  int nRankModifier;
  int nValue = GetGoldPieceValue(oItem);
  int nRank = GetSkillRank(SKILL_USE_MAGIC_DEVICE,OBJECT_SELF);

  // Determine nRankModifier based on type of restriction
  switch(nRestriction)
  {
    case OHS_UMD_TYPE_CLASS:
      nRankModifier = 0;
      break;

    case OHS_UMD_TYPE_RACE:
      nRankModifier = 5;
      break;

    case OHS_UMD_TYPE_ALIGNMENT:
      nRankModifier = 10;
      break;
  }

  if (nRank < 1) return FALSE; //Does not have any ranks in the skill
  if (nValue <= 1000 && nRank >= (0 + nRankModifier)) return TRUE;
  else if (nValue <= 4800 && nRank >= (5 + nRankModifier)) return TRUE;
  else if (nValue <= 20000 && nRank >= (10 + nRankModifier)) return TRUE;
  else if (nValue <= 100000 && nRank >= (15 + nRankModifier)) return TRUE;
  else if (nValue <= 300000 && nRank >= (20 + nRankModifier)) return TRUE;
  else if (nValue <= 600000 && nRank >= (25 + nRankModifier)) return TRUE;
  else if (nValue <= 1000000 && nRank >= (30 + nRankModifier)) return TRUE;
  else if (nValue <= 1400000 && nRank >= (35 + nRankModifier)) return TRUE;
  else if (nValue <= 1800000 && nRank >= (40 + nRankModifier)) return TRUE;
  else if (nValue <= 2200000 && nRank >= (45 + nRankModifier)) return TRUE;
  else if (nValue <= 2500000 && nRank >= (50 + nRankModifier)) return TRUE;
  else if (nValue <= 3000000 && nRank >= (55 + nRankModifier)) return TRUE;
  else if (nValue <= 5000000 && nRank >= (60 + nRankModifier)) return TRUE;
  else if (nValue <= 6000000 && nRank >= (65 + nRankModifier)) return TRUE;
  else if (nValue <= 9000000 && nRank >= (75 + nRankModifier)) return TRUE;
  else return FALSE;
}

// Check the (weapon)size difference between oItem and caller
int GetSizeDifference(object oItem)
{
  SetItemData(oItem);
  int nWeaponSize = GetLocalInt(oItem,"OHS_ITEM_DATA_WEAPONSIZE");
  int nMySize = GetCreatureSize(OBJECT_SELF);
  return nWeaponSize-nMySize;
}

// Decide if oItem is more valuable than oBest
int IsMoreValuable(object oItem, object oBest)
{
  if (!GetIsObjectValid(oBest)) return TRUE;
  else return GetGoldPieceValue(oItem)>GetGoldPieceValue(oBest);
}

// Decide if oItem is a melee weapon the caller can use
int IsUseableMeleeWeapon(object oItem)
{
  if (!OHS_GetIsMeleeWeapon(oItem)) return FALSE;
  if (!GetHasRequiredFeat(oItem)) return FALSE;
  if (GetSizeDifference(oItem)>1) return FALSE;
  return TRUE;
}

// Decide if oItem is a ranged weapon the caller can use
int IsUseableRangedWeapon(object oItem)
{
  if (!OHS_GetIsRangedWeapon(oItem)) return FALSE;
  if (!GetHasRequiredFeat(oItem)) return FALSE;
  if (GetSizeDifference(oItem)>1) return FALSE;
  return TRUE;
}

// Decide if oItem is a shield the caller can use
int IsUseableShield(object oItem)
{
  int nType = GetBaseItemType(oItem);
  if (!GetHasFeat(FEAT_SHIELD_PROFICIENCY)) return FALSE;
  else return (nType==BASE_ITEM_LARGESHIELD || nType==BASE_ITEM_SMALLSHIELD || nType==BASE_ITEM_TOWERSHIELD);
}

// Check if oItem counts as a 2H weapon for caller (one size larger)
int IsTwoHander(object oItem)
{
  if (!OHS_GetIsMeleeWeapon(oItem)) return FALSE;
  else return GetSizeDifference(oItem)==1;
}

// Check if oItem counts as a light weapon for caller (one size or more smaller)
int IsLightWeapon(object oItem)
{
  if (!OHS_GetIsMeleeWeapon(oItem)) return FALSE;
  else return GetSizeDifference(oItem) <= -1;
}

// Check if oItem is the right size for use as a primary weapon
// according to the caller's current melee style preference
// (Part of DonTheDime's improvements for dual-wielding)
int IsRightSize(object oItem)
{
  if (!OHS_GetIsMeleeWeapon(oItem)) return FALSE;
  int bOkay;
  int nStyle=GetLocalInt(OBJECT_SELF,"OHS_MELEE_PREF");
  switch(nStyle)
  {
    case OHS_STYLE_ONE_HANDER:
    case OHS_STYLE_DUAL_WIELD:
    case OHS_STYLE_WEAPON_AND_SHIELD:
      // Main weapon is sized for single-handed use
      bOkay = GetSizeDifference(oItem)<=0;
      break;
    case OHS_STYLE_TWO_HANDER:
      // Main weapon counts as large (but not too large)
      bOkay = IsTwoHander(oItem);
      break;
    case OHS_STYLE_BAREHANDED:
    case OHS_STYLE_DEFAULT:
    default:
      // Main weapon is anything not too large
      bOkay = GetSizeDifference(oItem)<=1;
  }
  return bOkay;
}

// Find the most valuable melee weapon you possess and can use
// n.b. ignores anything equipped in the left hand
// Modified to check for weapon size as part of DonTheDime's
// dual-wielding improvements.
object GetBestMeleeWeapon()
{
  object oBest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  if (!IsUseableMeleeWeapon(oBest) || !IsRightSize(oBest)) oBest = OBJECT_INVALID;
  object oItem = GetFirstItemInInventory();
  while (GetIsObjectValid(oItem))
  {
    if (GetIdentified(oItem)
        && IsUseableMeleeWeapon(oItem)
        && IsRightSize(oItem)
        && IsMoreValuable(oItem,oBest)
        && IsPermittedItem(oItem)) oBest = oItem;
    oItem = GetNextItemInInventory();
  }
  return oBest;
}

// Find the most valuable ranged weapon you possess and can use
object GetBestRangedWeapon()
{
  object oBest = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
  if (!IsUseableRangedWeapon(oBest)) oBest = OBJECT_INVALID;
  object oItem = GetFirstItemInInventory();
  while (GetIsObjectValid(oItem))
  {
    if (GetIdentified(oItem)
        && IsUseableRangedWeapon(oItem)
        && IsMoreValuable(oItem,oBest)
        && IsPermittedItem(oItem)) oBest = oItem;
    oItem = GetNextItemInInventory();
  }
  return oBest;
}

// Find the most valuable shield you possess and can use
object GetBestShield()
{
  object oBest = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
  if (!IsUseableShield(oBest)) oBest = OBJECT_INVALID;
  object oItem = GetFirstItemInInventory();
  while (GetIsObjectValid(oItem))
  {
    if (GetIdentified(oItem)
        && IsUseableShield(oItem)
        && IsMoreValuable(oItem,oBest)
        && IsPermittedItem(oItem)) oBest = oItem;
    oItem = GetNextItemInInventory();
  }
  return oBest;
}

// Find the most valuable light melee weapon you possess and can use in the
// off hand for dual wielding. Ignores anything equipped in the right hand.
// Added by DonTheDime (2005-03-15).  Modified (2005-03-21) to check if weapon
// found is the same as the favourite primary melee weapon, ignoring it if found.
object GetBestOffHandWeapon(object oPrimaryWeapon)
{
  object oBest = GetItemInSlot(INVENTORY_SLOT_LEFTHAND);
  if (!IsUseableMeleeWeapon(oBest) || !IsLightWeapon(oBest) || oBest==oPrimaryWeapon) oBest=OBJECT_INVALID;

  object oItem = GetFirstItemInInventory();
  while (GetIsObjectValid(oItem))
  {
    if (GetIdentified(oItem)
        && IsUseableMeleeWeapon(oItem)
        && IsLightWeapon(oItem)
        && oItem != oPrimaryWeapon
        && IsMoreValuable(oItem,oBest)
        && IsPermittedItem(oItem)) oBest=oItem;
    oItem = GetNextItemInInventory();
  }
  return oBest;
}

// OHS Replacement for IPGetIsMeleeWeapon()
// Uses 2da lookup so CEP etc. weapons are recognised
int OHS_GetIsMeleeWeapon(object oItem)
{
  if (!GetIsObjectValid(oItem)) return FALSE;
  SetItemData(oItem);
  if (GetLocalInt(oItem,"OHS_ITEM_DATA_WEAPONTYPE")>0 &&
      GetLocalInt(oItem,"OHS_ITEM_DATA_RANGEDWEAPON")==0)
  {
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}

// OHS Replacement for IPGetIsRangedWeapon()
// Uses 2da lookup so CEP etc. weapons are recognised
int OHS_GetIsRangedWeapon(object oItem)
{
  if (!GetIsObjectValid(oItem)) return FALSE;
  SetItemData(oItem);
  if (GetLocalInt(oItem,"OHS_ITEM_DATA_WEAPONTYPE")>0 &&
      GetLocalInt(oItem,"OHS_ITEM_DATA_RANGEDWEAPON")>0)
  {
    return TRUE;
  }
  else
  {
    return FALSE;
  }
}


////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
// (C) 2004, 2005, 2006 by bob@minors-ranton.fsnet.co.uk (aka "OldMansBeard")         //
//                                                                                    //
// The NWScript source code file to which this notice is attached is copyright.       //
// It may not be published or passed to a third party in part or in whole
// modified or unmodified without the express consent of the copyright holder.                 //
//                                                                                    //
// NWN byte code generated by compiling it or variations of it may be published       //
// or otherwise distributed notwithstanding under the terms of the Bioware EULA.      //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////

//void main() {} // Testing/compiling purposes
