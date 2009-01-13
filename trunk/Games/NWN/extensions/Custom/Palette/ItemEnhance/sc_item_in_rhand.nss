//#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_item_in_rhand", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
   //debugVarObject("oItem", oItem);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2101, GetName(oItem));
   return TRUE;
}
