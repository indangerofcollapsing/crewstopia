// On Death event for respawnable broken secret door
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_swall3", OBJECT_SELF);
   object oPlaceable = OBJECT_SELF;
   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   if (fDelay > 0.0)
   {
      AssignCommand(GetModule(), ActionRespawnObject(fDelay,
         GetObjectType(oPlaceable), "dac_swall1", GetLocation(oPlaceable),
         FALSE));
      ApplyEffectToObject(DURATION_TYPE_INSTANT,
         EffectDamage(GetMaxHitPoints(oPlaceable)),  oPlaceable);
   }
}

