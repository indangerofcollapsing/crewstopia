int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_BULLETS, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2114, GetName(oItem));
   return TRUE;
}
