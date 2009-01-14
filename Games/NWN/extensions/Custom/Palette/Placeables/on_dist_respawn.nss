#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_dist_respawn", OBJECT_SELF);
   if (GetFirstItemInInventory() == OBJECT_INVALID &&
       GetLocalInt(OBJECT_SELF, "re_bRespawned")
      )
   {
//      //debugVarObject("empty, respawning", OBJECT_SELF);
      // Container is empty; destroy it so it can respawn later with more goodies.
      // (must also use on_death_XXX_rs)
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()),
         OBJECT_SELF);
   }
}
