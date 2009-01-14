// On Death event for respawnable wrecked Turreted Arbalest
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta3w", OBJECT_SELF);
   // Respawn a new arbalest
   location lLoc = GetLocation(OBJECT_SELF);
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   AssignCommand(GetModule(), ActionRespawnObject(fDelay,
      OBJECT_TYPE_PLACEABLE, "dac_ballista3", lLoc));
}

