// Template for On Client Leave event on the module
#include "inc_nbde"
#include "inc_travel"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("_mod_on_exit", OBJECT_SELF);

   ExecuteScript("prc_onleave", OBJECT_SELF);

   object oPC = GetExitingObject();
   //debugVarObject("oPC", oPC);
   location lLast = GetLocation(oPC);
   if (isLocationValid(lLast))
   {
      setLastKnownLocation(oPC);
      //debugVarLoc("saved location", getLastKnownLocation(oPC));
   }
//   else
//   {
//      logError("Invalid location for exiting PC " + GetName(oPC) +
//         " in _mod_on_exit:  " + LocationToString(lLast));
//   }
   saveToDatabase();
}
