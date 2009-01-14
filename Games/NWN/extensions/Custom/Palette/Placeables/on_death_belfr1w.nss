// On Death event for respawnable wrecked Belfry
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_belfr1w", OBJECT_SELF);
   // Respawn a new belfry
   location lLoc = GetLocation(OBJECT_SELF);
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   AssignCommand(GetModule(), ActionRespawnObject(fDelay,
      OBJECT_TYPE_PLACEABLE, "dac_belfry1", lLoc));
}

