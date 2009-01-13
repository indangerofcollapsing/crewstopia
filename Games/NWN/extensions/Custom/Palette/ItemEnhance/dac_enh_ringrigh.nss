#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in right ring!");
      return;
   }
   setEnhanceItem(oPC, oItem);
}
