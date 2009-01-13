int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_BELT, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2107, GetName(oItem));
   return TRUE;
}
