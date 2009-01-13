int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_ARMS, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2109, GetName(oItem));
   return TRUE;
}
