// Recall Rune dialog tokens reset
#include "inc_recallrune"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dlg_tok_rr_reset", OBJECT_SELF);

   object oPC = GetItemActivator();
   int nNth = 1;
   for (nNth = 1; nNth < 11; nNth++)
   {
      location lRecall = getRecallLoc(nNth, oPC);
      object oRecall = GetAreaFromLocation(lRecall);
      SetCustomToken(2100 + nNth, (oRecall == OBJECT_INVALID ?
         "(Location not set)" : GetName(oRecall)));
   }
}
