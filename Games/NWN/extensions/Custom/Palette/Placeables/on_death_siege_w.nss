// On Death event for respawnable wrecked Siege Engine
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_siege_w", OBJECT_SELF);
   // Respawn an unwrecked version
   // Unwrecked version has same ResRef, without a trailing "w"
   string sResRef = GetStringLeft(GetResRef(OBJECT_SELF),
      GetStringLength(GetResRef(OBJECT_SELF)) - 1);
   location lLoc = GetLocation(OBJECT_SELF);
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   if (fDelay > 0.0)
   {
      AssignCommand(GetModule(), ActionRespawnObject(fDelay,
         OBJECT_TYPE_PLACEABLE, sResRef, lLoc));
   }
}

