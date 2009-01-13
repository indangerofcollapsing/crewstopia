// Is the upgrade cost negative?
#include "inc_enhanceitems"
#include "inc_debug_dac"
int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetLocalObject(oPC, VAR_ENHANCE_ITEM);
   if (oItem == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "Error in script -- please notify a DM.");
      logError("ERROR: no current item to upgrade for " + objectToString(oPC) +
         " in sc_enh_cost_lt_0");
      return FALSE;
   }

   int nProperty = GetLocalInt(oPC, VAR_ENHANCE_PROPERTY);
   if (nProperty == ENHANCE_PROPERTY_NONE)
   {
      logError("ERROR: No item property for " + objectToString(oPC) +
         " in sc_enh_cost_lt_0");
      return FALSE;
   }

   if (GetItemHasItemProperty(oItem, nProperty)) return FALSE;

   itemproperty ip = getEnhanceIP(oPC);
   if (!GetIsItemPropertyValid(ip))
   {
      logError("ERROR: invalid itemproperty in sc_enh_cost_lt_0");
      return FALSE;
   }

   int nDurationType = GetLocalInt(oPC, VAR_ENHANCE_DURATION);
   if (nDurationType == 0)
   {
      logError("ERROR: invalid duration type for " + objectToString(oPC) +
         " in sc_enh_cost_lt_0");
      return FALSE;
   }

   int nOldValue = GetGoldPieceValue(oItem);
   //debugVarInt("nOldValue", nOldValue);
   object oNewItem = CopyItem(oItem, OBJECT_SELF, TRUE);
   enhanceItem(oNewItem, ip, nDurationType);
   if (! GetItemHasItemProperty(oNewItem, nProperty))
   {
      logError("ERROR: failure to add itemproperty for " + objectToString(oPC) +
         " in sc_enh_cost_lt_0");
   }
   int nNewValue = GetGoldPieceValue(oNewItem);
   //debugVarInt("nNewValue", nNewValue);
   int nCostOfUpgrade = (nNewValue - nOldValue) * ENHANCE_COST_MODIFIER;
   //debugVarInt("nCostOfUpgrade", nCostOfUpgrade);

   return (nCostOfUpgrade < 0);
}
