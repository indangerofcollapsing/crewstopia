// Property already exists, but PC wants to replace it.
#include "inc_enhanceitems"
#include "nw_i0_generic"
//#include "inc_math_dac"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_enh_replaceip", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   object oItem = GetLocalObject(oPC, VAR_ENHANCE_ITEM);
   if (oItem == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "Error in script -- please notify a DM.");
      logError("ERROR: no current item to upgrade for " + objectToString(oPC) +
         " in sc_enh_notneeded");
      return FALSE;
   }

   int nProperty = GetLocalInt(oPC, VAR_ENHANCE_PROPERTY);
   if (nProperty == ENHANCE_PROPERTY_NONE)
   {
      logError("ERROR: No item property in sc_enh_notneeded for " + objectToString(oPC));
      return FALSE;
   }

   itemproperty ip = getEnhanceIP(oPC);

   int nDurationType = GetLocalInt(oPC, VAR_ENHANCE_DURATION);
   if (nDurationType == 0)
   {
      logError("ERROR: invalid duration type for " + objectToString(oPC) +
         " in sc_enh_isneeded");
      return FALSE;
   }

   int nOldValue = GetGoldPieceValue(oItem);
   object oNewItem = CopyItem(oItem, OBJECT_SELF, TRUE);
   enhanceItem(oNewItem, ip, nDurationType);
   int nNewValue = GetGoldPieceValue(oNewItem);
   //debugVarInt("nNewValue", nNewValue);
   int nCharLevel = GetCharacterLevel(oPC);
   int nCostOfUpgrade = ENHANCE_COST_MODIFIER * max((nNewValue - nOldValue),
      (nCharLevel * nCharLevel));
   //debugVarInt("nCostOfUpgrade", nCostOfUpgrade);
   SetLocalInt(oPC, VAR_ENHANCE_COST, nCostOfUpgrade);
   SetCustomToken(2102, IntToString(nCostOfUpgrade));
   return TRUE;
}
