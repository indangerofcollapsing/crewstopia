// On Used event for item "dac_snowglobe" (Misc/Other/Snow Globe)
#include "inc_debug_dac"
void main()
{
   object oPC = GetItemActivator();
   location locPC = GetLocation(oPC);
   if (GetStringLeft(GetResRef(GetAreaFromLocation(locPC)), 13) == "dac_snowglobe")
   {
      // Already in the snowglobe, you must want to return.
      location locReturnTo = GetLocalLocation(oPC, "dac_snowglobe_location");
      if (GetAreaFromLocation(locReturnTo) == OBJECT_INVALID)
      {
         logError("ERROR: Invalid return location " + LocationToString(locReturnTo)
            + " in dac_snowglobe");
         // Failsafe - return to starting location
         locReturnTo = GetStartingLocation();
      }
      DeleteLocalLocation(oPC, "dac_snowglobe_location");
      AssignCommand(oPC, ActionJumpToLocation(locReturnTo));
   }
   else
   {
      // Not in the snowglobe, you must want to go there.
      object wpSnowGlobe = GetWaypointByTag("dac_snowglobe");
      if (wpSnowGlobe == OBJECT_INVALID)
      {
         SendMessageToPC(oPC, "The snow globe appears to be broken.");
         return;
      }
      SetLocalLocation(oPC, "dac_snowglobe_location", locPC);
      location locSnowGlobe = GetLocation(wpSnowGlobe);
      AssignCommand(oPC, ActionJumpToLocation(locSnowGlobe));
   }
}
