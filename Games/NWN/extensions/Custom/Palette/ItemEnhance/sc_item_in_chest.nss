int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2104, GetName(oItem));
   return TRUE;
}
