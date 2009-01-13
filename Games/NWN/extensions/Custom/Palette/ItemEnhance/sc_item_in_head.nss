int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2106, GetName(oItem));
   return TRUE;
}
