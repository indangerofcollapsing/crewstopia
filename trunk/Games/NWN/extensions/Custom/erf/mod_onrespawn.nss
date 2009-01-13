// On Player Respawn event for the module
// Based on nw_o0_respawn

void ApplyPenalty(object oDead);

#include "nw_i0_plot"
#include "inc_bindstone"
#include "inc_travel"

void main()
{
   ExecuteScript("prc_onrespawn", OBJECT_SELF);

   object oRespawner = GetLastRespawnButtonPresser();
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oRespawner);
   ApplyEffectToObject(DURATION_TYPE_INSTANT,
      EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner);
   RemoveEffects(oRespawner);

   location lRespawn = GetLocation(GetWaypointByTag(TAG_RESPAWN_WAYPOINT));
   if (isLocationValid(lRespawn))
   {
      AssignCommand(oRespawner, JumpToLocation(lRespawn));
   }
   else
   {
      AssignCommand(oRespawner, JumpToLocation(GetStartingLocation()));
   }
}

// Applies an XP and GP penalty to the player respawning
void ApplyPenalty(object oDead)
{
   int nXP = GetXP(oDead);
   int nPenalty = 50 * GetHitDice(oDead);
   int nHD = GetHitDice(oDead);
   // * You can not lose a level with this respawning
   int nMin = ((nHD * (nHD - 1)) / 2) * 1000;

   int nNewXP = nXP - nPenalty;
   if (nNewXP < nMin) nNewXP = nMin;
   SetXP(oDead, nNewXP);
   int nGoldToTake = FloatToInt(0.10 * GetGold(oDead));
   // * a cap of 10 000gp taken from you
   if (nGoldToTake > 10000) nGoldToTake = 10000;

   AssignCommand(oDead, TakeGoldFromCreature(nGoldToTake, oDead, TRUE));
   DelayCommand(4.0, FloatingTextStrRefOnCreature(58299, oDead, FALSE));
   DelayCommand(4.8, FloatingTextStrRefOnCreature(58300, oDead, FALSE));
}

