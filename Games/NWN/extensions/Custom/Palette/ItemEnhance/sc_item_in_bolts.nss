int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_BOLTS, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2115, GetName(oItem));
   return TRUE;
}
