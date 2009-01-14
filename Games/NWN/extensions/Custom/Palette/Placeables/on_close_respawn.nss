// Make sure On Death has on_death_XXXX_rs set
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_close_respawn", OBJECT_SELF);
   if (GetFirstItemInInventory() == OBJECT_INVALID)
   {
      //debug("empty, respawning " + GetName(OBJECT_SELF));
      ApplyEffectToObject(DURATION_TYPE_INSTANT,
         EffectDamage(GetMaxHitPoints()),  OBJECT_SELF);
   }
}
