// Does the item to be enhanced already have the enhancement?
#include "inc_enhanceitems"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_enh_notneeded", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   itemproperty ip = getEnhanceIP(oPC);
   if (!GetIsItemPropertyValid(ip))
   {
      logError("ERROR: invalid itemproperty in sc_enh_notneeded");
      return FALSE;
   }

   int nDurationType = GetLocalInt(oPC, VAR_ENHANCE_DURATION);
   if (nDurationType == 0)
   {
      logError("ERROR: invalid duration type for " + objectToString(oPC) +
         " in sc_enh_notneeded");
      return FALSE;
   }

   object oItem = GetLocalObject(oPC, VAR_ENHANCE_ITEM);
   if (oItem == OBJECT_INVALID)
   {
      SendMessageToPC(oPC, "Error in script -- please notify a DM.");
      logError("ERROR: no current item to upgrade for " + objectToString(oPC) +
         " in sc_enh_notneeded");
      return FALSE;
   }

   return (IPGetItemHasProperty(oItem, ip, nDurationType));
}
