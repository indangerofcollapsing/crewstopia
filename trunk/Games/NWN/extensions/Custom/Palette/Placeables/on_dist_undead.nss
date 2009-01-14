// Used in crypts, randomly spawns an undead to protect his valuables.
#include "inc_debug_dac"
#include "inc_re_besie"
#include "nw_o2_coninclude"
#include "inc_persistworld"
void main()
{
   //debugVarObject("on_dist_undead", OBJECT_SELF);
   ShoutDisturbed();
   if (onDisturbedGuardMe())
   {
      ActionSpeakString("You dare to disturb my rest?");
      spawnSingleUndead(GetLastDisturbed());
   }
   else if (GetFirstItemInInventory() == OBJECT_INVALID)
   {
//      //debugVarObject("empty, respawning", OBJECT_SELF);
//      ActionSpeakString("This object will respawn later.");
      SpeakString("GUARD_ME", TALKVOLUME_SILENT_SHOUT);
      // Container is empty; destroy it so it can respawn later with more goodies.
      // (must also use on_death_XXX_rs)
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()),
         OBJECT_SELF);
   }
}
