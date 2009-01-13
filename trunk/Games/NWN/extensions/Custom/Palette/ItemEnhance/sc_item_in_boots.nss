int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2108, GetName(oItem));
   return TRUE;
}
