#include "inc_persistworld"
#include "inc_nbde"
#include "inc_travel"
#include "inc_area"
#include "inc_trap"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_exit_area", OBJECT_SELF);

   // Track location for next time PC enters this module.
   // Trying to save location on On Client Exit event fails because the PC does
   // not have a valid location when that event fires.
   // A more fine-grained approach would put this in the module's On Heartbeat
   // event, but at the expense of more CPU time.
/**** This is not working in practice -- the location is invalid
   object oPC = GetExitingObject();
   //debugVarObject("oPC", oPC);
   if (GetIsPC(oPC))
   {
      location lLast = GetLocation(oPC);
      if (isLocationValid(lLast))
      {
         setLastKnownLocation(oPC);
         //debugVarLoc(GetName(oPC) + " saved location", getLastKnownLocation(oPC));
      }
      else
      {
         logError("Invalid location in on_exit_area for " + GetName(oPC));
      }
   }
****/

   // Save persistent variables to database.
   saveToDatabase();

   if (! isAreaOccupied(OBJECT_SELF))
   {
      areaCleanup(OBJECT_SELF);

      // Remove traps from objects so they can be retrapped on reentry.
      object obj = GetFirstObjectInArea(OBJECT_SELF);
      while (obj != OBJECT_INVALID)
      {
         if (GetLocalString(OBJECT_SELF, VAR_TRAP_ID + ".sDisarmScript") != "")
         {
            //debugVarObject("removing trap on", obj);
            deleteLocalTrap(OBJECT_SELF, VAR_TRAP_ID);
         }
         obj = GetNextObjectInArea(OBJECT_SELF);
      }
   }
}
