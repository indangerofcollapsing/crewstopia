// Used in altars, randomly spawns an evil planar.
#include "inc_debug_dac"
#include "inc_re_besie"
#include "nw_o2_coninclude"
#include "inc_persistworld"
void main()
{
   //debugVarObject("on_dist_planar", OBJECT_SELF);
   ShoutDisturbed();
   if (onDisturbedGuardMe())
   {
      ActionSpeakString("Thief!  You will pay with your life!");
      spawnSinglePlanar(GetLastDisturbed());
   }
   else if (GetFirstItemInInventory() == OBJECT_INVALID)
   {
//      //debugVarObject("empty, respawning", OBJECT_SELF);
      ActionSpeakString("You have escaped my wrath for now, but you will pay for your heresy.");
      SpeakString("GUARD_ME", TALKVOLUME_SILENT_SHOUT);
      // Container is empty; destroy it so it can respawn later with more goodies.
      // (must also use on_death_XXX_rs)
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()),
         OBJECT_SELF);
   }
}
