void useTokenOfSacrifice(object oTarget, object oSelf = OBJECT_SELF);

#include "inc_debug_dac"

void useTokenOfSacrifice(object oTarget, object oSelf = OBJECT_SELF)
{
   //debugVarObject("useTokenOfSacrifice()", OBJECT_SELF);
   //debugVarObject("oTarget", oTarget);
   //debugVarObject("oSelf", oSelf);

   if (GetIsDead(oTarget))
   {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oTarget);
   }

   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(11), oTarget);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT,
      EffectVisualEffect(VFX_IMP_RAISE_DEAD), GetLocation(oTarget));

   effect eHarm = EffectDamage(GetCurrentHitPoints(oSelf) / 2);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, eHarm, oSelf);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HARM),
      oSelf);
}

