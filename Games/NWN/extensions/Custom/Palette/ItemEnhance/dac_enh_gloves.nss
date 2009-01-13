#include "inc_enhanceitems"
void main()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
   if (oItem == OBJECT_INVALID)
   {
      logError("ERROR: " + objectToString(oPC) + "has nothing in gloves!");
      return;
   }
   setEnhanceItem(oPC, oItem);
}
