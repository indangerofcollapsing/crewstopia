int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTRING, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2111, GetName(oItem));
   return TRUE;
}
