// Does the module have a default starting point?  Uh, yes.
// But this only returns TRUE if a variable, ALLOW_JUMP_TO_START_LOC, is set
// on the module.
// It goes along with sc_has_bindstone and sc_has_lastrest, hence the wierdness.
#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_has_startpt", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lStart = GetStartingLocation();
   //debugVarLoc("lStart", lStart);
   SetCustomToken(2114, GetName(GetAreaFromLocation(lStart)));
   return GetLocalInt(GetModule(), "ALLOW_JUMP_TO_START");
}
