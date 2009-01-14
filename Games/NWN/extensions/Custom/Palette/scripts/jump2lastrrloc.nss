// Jumps to previous location using a Rune of Recall
#include "inc_travel"
#include "inc_recallrune"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("jump2lastrrloc", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lLastRecallRuneLoc = getPersistentLocation(oPC, VAR_LAST_RECALL_RUNE_LOC);
   //debugVarLoc("lLastRecallRuneLoc", lLastRecallRuneLoc);
   if (isLocationValid(lLastRecallRuneLoc))
   {
      jumpTo(lLastRecallRuneLoc, oPC);
      object oRune = GetItemActivated();
      DestroyObject(oRune, 0.1f);
   }
   else
   {
      logError("No valid bind location for " + GetName(oPC) +
         ", lLastRecallRuneLoc = " + LocationToString(lLastRecallRuneLoc));
      SendMessageToPC(oPC, "I'm sorry, I cannot do that.  Please inform a DM.");
   }
}
