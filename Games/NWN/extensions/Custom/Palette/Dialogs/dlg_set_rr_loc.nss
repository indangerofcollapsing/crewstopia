#include "inc_recallrune"
#include "inc_variables"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dlg_set_rr_loc", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   if (oPC == OBJECT_INVALID) oPC = GetItemActivator();
   if (oPC == OBJECT_INVALID)
   {
      logError("Can't identify PC in dlg_set_rr_loc");
      SendMessageToPC(GetFirstPC(), "An error occurred in dlg_set_rr_loc.");
      return;
   }

   if (getVarInt(oPC, VAR_DISALLOW_RECALL_RUNES) == TRUE)
   {
      FloatingTextStringOnCreature("Recall Runes do not seem to work here.", oPC);
   }
   else if (! GetIsAreaAboveGround(GetArea(oPC)))
   {
      FloatingTextStringOnCreature("Recall Runes do not work underground.", oPC);
   }
   else
   {
      setRecallLoc(GetLocalInt(oPC, VAR_CURRENT_DLG_LOC), GetLocation(oPC), oPC);
      DeleteLocalInt(oPC, VAR_CURRENT_DLG_LOC);
      object oRune = GetItemActivated();
      SetPlotFlag(oRune, FALSE);
      DestroyObject(oRune, 0.1f);
   }
}
