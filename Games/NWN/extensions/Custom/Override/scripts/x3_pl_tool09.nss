//::///////////////////////////////////////////////
//:: Player Tool 9 Instant Feat
//:: x3_pl_tool09
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a blank feat script for use with the
    10 Player instant feats provided in NWN v1.69.

    Look up feats.2da, spells.2da and iprp_feats.2da
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

#include "inc_debug_dac"

#include "psi_inc_ppoints"
#include "psi_inc_psifunc"
#include "psi_inc_augment"

void main()
{
   debugVarObject("x3_pl_tool09", OBJECT_SELF);

   object oPC = OBJECT_SELF;
   SendMessageToPC(oPC, "Player Tool 09 activated - Psionic Status.");

   string sCurrentPoints = IntToString(GetCurrentPowerPoints(oPC));
   string sMaxPoints = IntToString(GetMaximumPowerPoints(oPC));

   string sAugment = UserAugmentationProfileToString(
      GetCurrentUserAugmentationProfile(oPC));

   string sMessage = "PP=" + sCurrentPoints + "/" + sMaxPoints +
      " , Augment=" + sAugment;
   if (GetLevelByClass(CLASS_TYPE_WILDER, oPC))
   {
      string sWildSurge = IntToString(GetWildSurge(oPC));
      sMessage += ", Surge=" + sWildSurge;
   }

   SendMessageToPC(oPC, sMessage);
}