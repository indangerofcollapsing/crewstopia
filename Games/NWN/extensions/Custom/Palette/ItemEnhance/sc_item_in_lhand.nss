int StartingConditional()
{
   object oPC = GetPCSpeaker();
   object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
   if (oItem == OBJECT_INVALID) return FALSE;

   SetCustomToken(2103, GetName(oItem));
   return TRUE;
}
