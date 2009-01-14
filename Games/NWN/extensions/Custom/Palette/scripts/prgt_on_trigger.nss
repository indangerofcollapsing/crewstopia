///// Blatantly stolen from the PrC (prgt_inc, prgt_inc_trap)
#include "inc_trap"
#include "inc_debug_dac"
#include "prc_inc_racial" // @DUG

void main()
{
   //debugVarObject("prgt_on_trigger", OBJECT_SELF);
   object oTarget = GetLocalObject(OBJECT_SELF, "Target");
   if (! GetIsObjectValid(oTarget)) oTarget = GetLastUsedBy();
   if (! GetIsObjectValid(oTarget)) oTarget = GetEnteringObject();
   //debugVarObject("oTarget", oTarget);
   struct trap tTrap = getLocalTrap(OBJECT_SELF, "TrapSettings");
   //debug("tTrap = " + trapToString(tTrap));
   //if no trap exists, create a random one
   struct trap tInvalid;
   if (tTrap == tInvalid)
   {
      tTrap = createRandomTrap(FloatToInt(getCR(oTarget)));
      //debug("created random trap: " + trapToString(tTrap));
   }
   // For traps that duplicate spells
   if (tTrap.nSpellID)
   {
      //debugVarInt("trap casting spell", tTrap.nSpellID);
//      ActionCastSpell(tTrap.nSpellID, tTrap.nSpellLevel, 0, tTrap.nSpellDC,
//         tTrap.nSpellMetamagic, CLASS_TYPE_INVALID, FALSE, FALSE, oTarget);
      ActionCastSpellAtObject(tTrap.nSpellID, oTarget, tTrap.nSpellMetamagic,
        TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
   }
   else
   {
      //debug("non-spell trap");
      float fRadius = IntToFloat(tTrap.nRadius);

//      effect eTrapVFX;
//      if (tTrap.nTrapVFX) eTrapVFX = EffectVisualEffect(tTrap.nTrapVFX);
      if (tTrap.nTrapVFX)
      {
         ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(tTrap.nTrapVFX),
            GetLocation(OBJECT_SELF));
      }

      effect eTargetVFX;
      if (tTrap.nTargetVFX)
      {
         eTargetVFX = EffectVisualEffect(tTrap.nTargetVFX);
      }

      effect eBeamVFX;
      if (tTrap.nBeamVFX)
      {
         eBeamVFX = EffectBeam(tTrap.nBeamVFX, OBJECT_SELF, BODY_NODE_CHEST);
      }

      object oVictim = GetFirstObjectInShape(SHAPE_SPHERE, fRadius,
         GetLocation(OBJECT_SELF), TRUE);
      if (fRadius == 0.0) oVictim = oTarget;

      while (GetIsObjectValid(oVictim))
      {
         //debugVarObject("oVictim", oVictim);
         int nDamage;
         int nDiceCount;
         while (nDiceCount < tTrap.nDamageDice)
         {
            nDamage += Random(tTrap.nDamageSize) + 1;
            nDiceCount++;
         }
         nDamage += tTrap.nDamageBonus;

         effect eDamage;
         // Handle negative vs undead and positive vs non-undead
         if ((tTrap.nDamageType == DAMAGE_TYPE_NEGATIVE &&
              MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD
             ) ||
             (tTrap.nDamageType == DAMAGE_TYPE_POSITIVE &&
              MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD
             )
            )
         {
            //debug("effect heal");
            eDamage = EffectHeal(nDamage);
         }
         else
         {
            if (tTrap.nAllowReflexSave)
            {
//               nDamage = PRCGetReflexAdjustedDamage(nDamage, oVictim, tTrap.nSaveDC, SAVING_THROW_TYPE_TRAP);
               nDamage = GetReflexAdjustedDamage(nDamage, oVictim, tTrap.nSaveDC,
                  SAVING_THROW_TYPE_TRAP);
            }
            if (tTrap.nAllowFortSave)
            {
//               int nSave = PRCMySavingThrow(SAVING_THROW_FORT, oVictim,
//                  SAVING_THROW_TYPE_TRAP);
               int nSave = FortitudeSave(oVictim, tTrap.nSaveDC,
                  SAVING_THROW_TYPE_TRAP);
               //debugVarInt("Fort Save", nSave);
               if (nSave == 1) // Success
               {
                  nDamage /= 2;
               }
               else if (nSave == 2) // Immune
               {
                  nDamage = 0;
               }
            }
            if (tTrap.nAllowWillSave)
            {
//               int nSave = PRCMySavingThrow(SAVING_THROW_WILL, oVictim,
//                  SAVING_THROW_TYPE_TRAP);
               int nSave = WillSave(oVictim, tTrap.nSaveDC, SAVING_THROW_TYPE_TRAP);
               //debugVarInt("Will Save", nSave);
               if (nSave == 1) // Success
               {
                  nDamage /= 2;
               }
               else if (nSave == 2) // Immune
               {
                  nDamage = 0;
               }
            }
            //debugVarInt("nDamage", nDamage);
            eDamage = EffectDamage(nDamage, tTrap.nDamageType);
         }

//         if (GetIsEffectValid(eTargetVFX))
         if (tTrap.nTargetVFX)
         {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eTargetVFX, oVictim);
         }
//         if (GetIsEffectValid(eBeamVFX))
         if (tTrap.nBeamVFX)
         {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBeamVFX, oVictim);
         }
//         if (GetIsEffectValid(eDamage))
         if (nDamage != 0)
         {
            //debug("applying eDamage");
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oVictim);
         }
         if (!tTrap.nFakeSpell)
         {
            ActionCastFakeSpellAtObject(tTrap.nFakeSpell, oVictim);
         }
         if (!tTrap.nFakeSpellLoc)
         {
            ActionCastFakeSpellAtLocation(tTrap.nFakeSpell, GetLocation(oVictim));
         }

         if (fRadius == 0.0)
         {
            oVictim = OBJECT_INVALID;
         }
         else
         {
            oVictim = GetNextObjectInShape(SHAPE_SPHERE, fRadius,
               GetLocation(OBJECT_SELF), TRUE);
         }
      }
   }

   int nDelay = tTrap.nRespawnSeconds;
   if (nDelay > 0)
   {
      DelayCommand(0.1 + nDelay, ExecuteScript("trap_reset_self", OBJECT_SELF));
   }

   ExecuteScript("trap_on_trigger", OBJECT_SELF);
}
