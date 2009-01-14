// On Death event for respawnable wrecked Bow Ballista
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta2w", OBJECT_SELF);
   // Respawn a new ballista
   location lLoc = GetLocation(OBJECT_SELF);
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   AssignCommand(GetModule(), ActionRespawnObject(fDelay,
      OBJECT_TYPE_PLACEABLE, "dac_ballista2", lLoc));
}

