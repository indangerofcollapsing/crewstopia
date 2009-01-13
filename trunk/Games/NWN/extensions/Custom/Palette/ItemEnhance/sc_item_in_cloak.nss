int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2105, GetName(oItem));
   return TRUE;
}
