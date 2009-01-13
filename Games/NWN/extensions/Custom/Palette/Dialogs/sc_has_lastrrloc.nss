#include "inc_recallrune"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_has_lastrrloc", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lLastRecalRuneLoc = getPersistentLocation(oPC, VAR_LAST_RECALL_RUNE_LOC);
   //debugVarLoc("lLastRecalRuneLoc", lLastRecalRuneLoc);
   if (isLocationValid(lLastRecalRuneLoc))
   {
      SetCustomToken(2115, GetName(GetAreaFromLocation(lLastRecalRuneLoc)));
      return TRUE;
   }
   else
   {
      return FALSE;
   }
}
