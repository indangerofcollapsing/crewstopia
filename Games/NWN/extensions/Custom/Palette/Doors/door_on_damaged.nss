const string VAR_DAMAGE_DONE = "DAMAGE";
#include "nw_o2_coninclude"
void main()
{
   object oPC = GetLastHostileActor();
   int nCurrHP = GetCurrentHitPoints();
   int nFortSave = GetFortitudeSavingThrow(OBJECT_SELF);
   int nMaxHP = GetMaxHitPoints();
   int nDamage = nMaxHP - nCurrHP + GetLocalInt(OBJECT_SELF, VAR_DAMAGE_DONE);

   if (nDamage >= nFortSave)
   {
//      FloatingTextStringOnCreature("The door has been successfully bashed open.", oPC, TRUE);
      effect eBashed = EffectVisualEffect(VFX_COM_CHUNK_STONE_SMALL);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eBashed, OBJECT_SELF);
      AssignCommand(oPC, ClearAllActions());
      AssignCommand(OBJECT_SELF, ActionUnlockObject(OBJECT_SELF));
      AssignCommand(OBJECT_SELF, ActionWait(0.1));
      AssignCommand(OBJECT_SELF, ActionOpenDoor(OBJECT_SELF));
      nDamage = 0;
   }
/*
   else if (nDamage >= FloatToInt(nFortSave * 3/4))
   {
      FloatingTextStringOnCreature("The door is hanging on its hinges.", oPC,
         TRUE);
   }
   else if (nDamage >= FloatToInt(nFortSave / 2))
   {
      FloatingTextStringOnCreature("The door seems to be very damaged.", oPC,
         TRUE);
   }
   else if (nDamage >= FloatToInt(nFortSave / 4))
   {
      FloatingTextStringOnCreature("The door seems to be a bit more damaged.",
         oPC, TRUE);
   }
*/
   else
   {
      effect eSparks = EffectVisualEffect(VFX_COM_SPARKS_PARRY);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eSparks, OBJECT_SELF);
   }

   SetLocalInt(OBJECT_SELF, VAR_DAMAGE_DONE, nDamage);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(nMaxHP), OBJECT_SELF);
   SpeakString("GUARD_ME", TALKVOLUME_SILENT_SHOUT);
}

