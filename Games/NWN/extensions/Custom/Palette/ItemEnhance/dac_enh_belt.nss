#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in armor!");
      return;
   }
   setEnhanceItem(oPC, oItem);
}
