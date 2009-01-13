#include "nw_i0_plot"
void main()
{
   object oPC = GetPCSpeaker();
   RemoveEffects(oPC);
   int nHP = GetMaxHitPoints(oPC) - GetCurrentHitPoints(oPC);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nHP), oPC);
}

