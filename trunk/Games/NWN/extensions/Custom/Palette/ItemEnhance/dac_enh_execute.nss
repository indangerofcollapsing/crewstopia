#include "inc_enhanceitems"
#include "inc_debug_dac"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetLocalObject(oPC, VAR_ENHANCE_ITEM);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: invalid item in dac_enh_execute");
      return;
   }

   itemproperty ip = getEnhanceIP(oPC);
   if (!GetIsItemPropertyValid(ip))
   {
      logError("ERROR: invalid itemproperty in dac_enh_execute");
      return;
   }

   int nDurationType = GetLocalInt(oPC, VAR_ENHANCE_DURATION);
   if (nDurationType == 0)
   {
      logError("ERROR: invalid duration in dac_enh_execute");
      return;
   }

   enhanceItem(oItem, ip, nDurationType);

   DeleteLocalObject(oPC, VAR_ENHANCE_ITEM);
   DeleteLocalInt(oPC, VAR_ENHANCE_PROPERTY);
   DeleteLocalInt(oPC, VAR_ENHANCE_DURATION);
   DeleteLocalInt(oPC, VAR_ENHANCE_PARAM1);
   DeleteLocalInt(oPC, VAR_ENHANCE_PARAM2);
   DeleteLocalInt(oPC, VAR_ENHANCE_PARAM3);
   DeleteLocalInt(oPC, VAR_ENHANCE_COST);
}
