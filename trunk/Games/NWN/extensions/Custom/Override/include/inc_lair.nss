#include "inc_area"
#include "inc_debug_dac"

object getLair(object oCreature);
float getDistanceToLair(object oCreature);
void returnToLair(object oCreature, int bRun = FALSE, int bCommandable = FALSE);

// A waypoint that starts with this and ends with a creature's tag is a lair
// for that creature.  It will try to escape to its lair if wounded, and will
// defend the lair with its life.
const string LAIR_TAG_PREFIX = "LAIR_";

// This will return OBJECT_INVALID if the creature does not have a lair.
object getLair(object oCreature)
{
   object oLair = GetObjectByTag(LAIR_TAG_PREFIX + GetTag(oCreature));
   //debugVarObject("oLair", oLair);
   return oLair;
}

float getDistanceToLair(object oCreature)
{
   object oLair = getLair(oCreature);
   // Default to infinity if lair does not exist or is in a different area
   float fDistance = 99999.9f;
   if (GetArea(oLair) == GetArea(oCreature))
   {
      fDistance = GetDistanceBetween(oLair, oCreature);
   }
   //debugVarFloat("distance to lair", fDistance);
   return fDistance;
}

/**
 * bRun = run if true, walk if false
 * bCommandable = if false, creature can not be interrupted
 */
void returnToLair(object oCreature, int bRun = FALSE, int bCommandable = FALSE)
{
   object oLair = getLair(oCreature);
   if (oLair == OBJECT_INVALID)
   {
      logError("No lair found for " + objectToString(oCreature));
      oLair = CreateObject(OBJECT_TYPE_WAYPOINT, "nw_waypoint",
         getRandomLocation(GetArea(oCreature)));
      DelayCommand(600.0, ActionDoCommand(DestroyObject(oLair)));
   }
   AssignCommand(oCreature, ActionMoveToObject(oLair, bRun));
   AssignCommand(oCreature, ActionDoCommand(DestroyObject(oCreature)));
   SetCommandable(bCommandable);
}

//void main() {} // testing/compiling purposes
