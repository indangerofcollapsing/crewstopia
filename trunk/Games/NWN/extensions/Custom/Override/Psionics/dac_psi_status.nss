#include "psi_inc_ppoints"
#include "psi_inc_psifunc"
#include "psi_inc_augment"

void main()
{
   object oPC = GetItemActivator();

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
