int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_NECK, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2110, GetName(oItem));
   return TRUE;
}
