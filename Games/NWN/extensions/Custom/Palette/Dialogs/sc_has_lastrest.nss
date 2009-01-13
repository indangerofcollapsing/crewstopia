#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_has_lastrest", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lLastRest = getLastRestLoc(oPC);
   //debugVarLoc("lLastRest", lLastRest);
   if (isLocationValid(lLastRest))
   {
      SetCustomToken(2113, GetName(GetAreaFromLocation(lLastRest)));
      return TRUE;
   }
   else
   {
      return FALSE;
   }
}
