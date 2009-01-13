int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2112, GetName(oItem));
   return TRUE;
}
