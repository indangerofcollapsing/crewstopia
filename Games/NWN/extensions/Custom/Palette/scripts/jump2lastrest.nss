#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("jump2lastrest", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lLastRest = getLastRestLoc(oPC);
   //debugVarLoc("lLastRest", lLastRest);
   if (isLocationValid(lLastRest))
   {
      jumpToLastRest(oPC);
   }
   else
   {
      logError("No valid bind location for " + GetName(oPC) + ", lLastRest = " +
         LocationToString(lLastRest));
      SendMessageToPC(oPC, "I'm sorry, I cannot do that.  Please inform a DM.");
   }
}
