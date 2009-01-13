int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_ARROWS, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2113, GetName(oItem));
   return TRUE;
}
