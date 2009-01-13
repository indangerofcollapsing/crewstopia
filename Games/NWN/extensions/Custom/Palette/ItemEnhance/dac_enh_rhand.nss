#include "inc_enhanceitems"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_enh_rhand", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   //debugVarObject("oItem", oItem);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in right hand!");
      return;
   }
   setEnhanceItem(oPC, oItem);
   //debugVarObject("oItem from variable", GetLocalObject(oPC, VAR_ENHANCE_ITEM));
}
