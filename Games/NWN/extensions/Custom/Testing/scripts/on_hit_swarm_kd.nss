// Swarm-style knockdown attack
// Attach to on-hit event of swarm leader (only!)
#include "inc_debug_dac"
#include "prc_alterations"
#include "prc_misc_const"
void main()
{
   //debugVarObject("on_hit_swarm_kd", OBJECT_SELF);

   // Knockdown is a required Feat for this to work.
   if (! GetHasFeat(FEAT_KNOCKDOWN, OBJECT_SELF)) return;

   object oTarget = GetAttackTarget(OBJECT_SELF);
   //debugVarObject("oTarget", oTarget);
   if (oTarget == OBJECT_INVALID) return;

   int nNth = 1;
   int nHD = 0;
   int nAttackers = 0;
   object oAttacker = GetNearestCreature(CREATURE_TYPE_RACIAL_TYPE,
      GetRacialType(OBJECT_SELF), oTarget, nNth, CREATURE_TYPE_REPUTATION,
      REPUTATION_TYPE_FRIEND, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
   do
   {
      //debugVarObject("ally", oAttacker);
      if (GetAttackTarget(oAttacker) == oTarget)
      {
         //debugVarObject("ally is available to swarm", oAttacker);
         // they're attacking the same target as me, so they can swarm with me
         nHD += GetHitDice(oAttacker);
         nAttackers++;
      }
   } while (oAttacker != OBJECT_INVALID);
   //debugVarInt("total HD of swarm", nHD);
   //debugVarInt("nAttackers", nAttackers);

   // @TODO: Does the Swarm Leader revert to standard attack if alone?
   if (nAttackers < 1) return;

   FloatingTextStringOnCreature("Grab it! Trip it! Drag it down!", OBJECT_SELF, TRUE);

   int nDiscipline = GetSkill(oTarget, SKILL_DISCIPLINE, TRUE, TRUE, TRUE,
      TRUE, TRUE, TRUE, TRUE);
   // larger/smaller creatures have a bonus/penalty to discipline checks
   // on knockdown attempts, equal to +4 per size differential.
   int nAttackerSize = PRCGetCreatureSize(OBJECT_SELF);
   // Having Improved Knockdown makes you one size larger for knockdown.
   if (GetHasFeat(FEAT_IMPROVED_KNOCKDOWN, OBJECT_SELF)) nAttackerSize++;
   int nTargetSize = PRCGetCreatureSize(oTarget);
   int nDC = nHD - GetHitDice(oTarget) - nDiscipline +
      ((nAttackerSize - nTargetSize) * nAttackers * 4);
   //debugVarInt("nDC", nDC);
   if (GetIsSkillSuccessful(oTarget, SKILL_DISCIPLINE, nDC))
   {
      FloatingTextStringOnCreature("* knockdown resisted *", oTarget, FALSE);
   }
   else
   {
      FloatingTextStringOnCreature("You are dragged down by the swarm.",
         oTarget, FALSE);
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oTarget,
         3.0f);
   }
}
