#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in left hand!");
      return;
   }
   setEnhanceItem(oPC, oItem);
}
