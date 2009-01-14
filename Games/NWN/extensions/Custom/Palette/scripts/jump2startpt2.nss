// Returns to module start location using Rune of Recall.
#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("jump2startpt2", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lStart = GetStartingLocation();
   AssignCommand(oPC, JumpToLocation(lStart));
   object oRune = GetItemActivated();
   DestroyObject(oRune, 0.1f);
}
