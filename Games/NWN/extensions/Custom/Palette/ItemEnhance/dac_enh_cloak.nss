#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in cloak!");
      return;
   }
   setEnhanceItem(oPC, oItem);
}
