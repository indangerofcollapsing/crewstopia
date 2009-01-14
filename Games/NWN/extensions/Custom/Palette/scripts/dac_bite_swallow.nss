// Creature Attack: Swallow Whole
#include "inc_debug_dac"
// #include "prc_alterations"
void main()
{
   // @TODO:
   // Implement a new area, "the belly of the beast", which does acid
   // damage on heartbeat and can be damaged enough to escape from.
   // In the meantime, just do scalable extra damage.

   object oTarget = GetAttackTarget();
   if (oTarget == OBJECT_INVALID)
   {
      logError("dac_bite_swallow: target is invalid");
      return;
   }

   int nAttackerSize = GetCreatureSize(OBJECT_SELF);
//   int nAttackerSize = PRCGetCreatureSize(OBJECT_SELF);
   int nTargetSize = GetCreatureSize(oTarget);
//   int nTargetSize = PRCGetCreatureSize(oTarget);

   if ((nTargetSize + 2) >= nAttackerSize) return;

   // 50% chance of swallowing whole for a huge creature attacking a medium creature
   if (d4() > (nAttackerSize - nTargetSize))
   {
      FloatingTextStringOnCreature(GetName(oTarget) + " avoids being swallowed whole!",
         oTarget);
      return;
   }

   FloatingTextStringOnCreature(GetName(oTarget) + " has been swallowed whole!",
      oTarget);

   int nHD = GetHitDice(OBJECT_SELF);
   if (nHD == 0) nHD = 1;

   effect eChew = EffectDamage(d6(nHD), DAMAGE_TYPE_SLASHING);
   effect eDigest = EffectDamage(d4(nHD), DAMAGE_TYPE_ACID);
   effect eBlind = EffectBlindness();
   effect eParalyze = EffectCutsceneParalyze();
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eChew, oTarget);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eDigest, oTarget);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBlind, oTarget, 6.0f);
   ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalyze, oTarget, 6.0f);

   FloatingTextStringOnCreature(GetName(oTarget) +
      ", due to a limitation in the script, has miraculously escaped!", oTarget);

}
