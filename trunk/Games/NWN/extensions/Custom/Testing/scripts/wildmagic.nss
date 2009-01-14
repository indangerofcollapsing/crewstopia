// See module "All Magic Zones"

#include "x2_inc_switches"
#include "x0_i0_position"

void main()
{
   // Get the tag for this area
   string sTag = GetStringLowerCase(GetTag(GetArea(OBJECT_SELF)));

   // do early return for normal areas
   if (FindSubString(sTag, "deadmagic") == -1 &&
       FindSubString(sTag, "wildmagic") == -1)
   {
      // this is a normal area
      return;
   }

   // check for dead magic area
   if (FindSubString(sTag, "deadmagic") != -1)
   {
      SendMessageToPC(OBJECT_SELF, "This place appears to inhibit magic.");
   }

   // else see if wild magic area
   else if (FindSubString(sTag, "wildmagic") != -1)
   {
      // oh boy
      int nRoll = d100();

      // get our spell information
      int nSpellId = GetSpellId();
      object oSpellTarget = GetSpellTargetObject();
      location locSpell = GetSpellTargetLocation();
      int nSpellClass = GetLastSpellCastClass();
      object oSpellItem = GetSpellCastItem();
      int nSpellSaveDC = GetSpellSaveDC();
      int nCasterLevel = GetCasterLevel(OBJECT_SELF);
      object oCaster = OBJECT_SELF;

      if (FindSubString(GetPCPlayerName(oCaster), "ScrewTape") != -1)
         SendMessageToPC(oCaster, "wild spell " + IntToString(nRoll));

      // check the roll - start with this one in case we need to reroll
      if (nRoll < 20) // target the caster if caster wasn't target
      {
         // if the target was not the spell caster, and it was cast at a target
         //  the caster is now the target - use instant
         if (GetIsObjectValid(oSpellTarget) && oCaster != oSpellTarget ||
             GetAreaFromLocation(locSpell) != OBJECT_INVALID &&
             GetLocation(oCaster) != locSpell)
         {
            // ClearAllActions();
            if (GetIsObjectValid(oSpellTarget))
            {
               ActionCastSpellAtObject(nSpellId, oCaster, METAMAGIC_ANY, TRUE,
                  nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }

            else
            {
               locSpell = GetLocation(oCaster);
               ActionCastSpellAtLocation(nSpellId, locSpell, METAMAGIC_ANY,
                  TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
            }

            // we'll early return this one so we don't have to make more checks
            SetModuleOverrideSpellScriptFinished();
            return;
         }

         else // Reroll if the spell cannot affect the caster
            nRoll = Random(81) + 20;  // 20 - 100
      }

      // Spell functions with max effect - cast twice to emulate - use instant
      if (nRoll > 98)
      {
         // ClearAllActions();
         if (GetIsObjectValid(oSpellTarget))
            ActionCastSpellAtObject(nSpellId, oSpellTarget, METAMAGIC_ANY, TRUE,
               nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
         else if (GetAreaFromLocation(locSpell) != OBJECT_INVALID)
            ActionCastSpellAtLocation(nSpellId, locSpell, METAMAGIC_ANY, TRUE,
               PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
         return; // to continue with normal spell
      }

      // spell functions normally
      else if (nRoll > 71)
         return; // to continue with normal spell

      else if (nRoll > 59) // spell fails - not supposed to lose memorize...
      //  but that would require extensive scripting and ForceRest and ...
      //  we can't really do this for a spell caster, but we can for an item
      {
         if (GetIsObjectValid(oSpellItem))
         {
            // get the items current charges
            int nCharges = GetItemCharges(oSpellItem);

            // and after a delay, reset the charges to what they were
            DelayCommand(3.0f, SetItemCharges(oSpellItem, nCharges));
         }
      }

      // nothing happens - spell fails - lose charge, memorization
      else if (nRoll > 51)
      {
         // do nothing
      }

      else if (nRoll > 47) // shimmering colors blind for 1d4 rounds
      {
         // ClearAllActions();
         ActionCastSpellAtObject(SPELL_COLOR_SPRAY, oCaster, METAMAGIC_ANY,
            TRUE, nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);

         // spell still functions
         return; // to continue with normal spell
      }

      else if (nRoll > 43) // supposed to be Reverse gravity - how about random
      // polymorph instead :)
      {
         int nPolymorphType = Random(78); // 0 - 78 see nwscript
         effect ePolymorph = EffectPolymorph(nPolymorphType, TRUE);
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePolymorph, oCaster,
            RoundsToSeconds(d4(2)));
      }

      else if (nRoll > 39) // Darkness and silence 30' radius 2d4 rounds
      {
         effect eAOEDarkness = EffectAreaOfEffect(AOE_PER_DARKNESS);
         effect eAOESilence  = EffectAreaOfEffect(AOE_MOB_SILENCE);
         locSpell = GetLocation(oCaster);
         if (GetAreaFromLocation(locSpell) != OBJECT_INVALID)
         {
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOEDarkness,
               locSpell, RoundsToSeconds(d4(2)));
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOESilence,
               locSpell, RoundsToSeconds(d4(2)));
         }
      }

      else if (nRoll > 35) // everyone in 10 yards of caster receives Heal
      {
         ClearAllActions();
         ActionCastSpellAtObject(SPELL_MASS_HEAL, oCaster, METAMAGIC_ANY, TRUE);
      }

      else if (nRoll > 31) // supposed to function normal but not use charge
      {
         // we can't really do this for a spell caster, but we can for an item
         if (GetIsObjectValid(oSpellItem))
         {
            // get the items current charges
            int nCharges = GetItemCharges(oSpellItem);

            // and after a delay, reset the charges to what they were
            DelayCommand(3.0f, SetItemCharges(oSpellItem, nCharges));
         }

         return; // to continue with normal spell
      }

      else if (nRoll > 27) // randomize target
      {
         ClearAllActions();
         if (GetIsObjectValid(oSpellTarget)) // if we had a spell target
         {
            // find a random new one
            object oNewTarget = OBJECT_INVALID;
            int nTries = 0; // to prevent infinite loop if no valid creatures
            while (oNewTarget == OBJECT_INVALID && nTries < 10)
            {
               oNewTarget = GetNearestObject(OBJECT_TYPE_CREATURE, oCaster,
                  d10());
               nTries++;
            }

            //  if we found a new target, cast spell
            if (GetIsObjectValid(oNewTarget))
               ActionCastSpellAtObject(nSpellId, oNewTarget, METAMAGIC_ANY,
                  TRUE, nCasterLevel, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
         }

         else // random location
         {
            locSpell = GetRandomLocation(GetArea(oCaster), oCaster,
               IntToFloat(d20()));

            // if we got a good random location, cast spell
            if (GetAreaFromLocation(locSpell) != OBJECT_INVALID)
               ActionCastSpellAtLocation(nSpellId, locSpell, METAMAGIC_ANY,
                  TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
         }

      }

      else if (nRoll > 23) // this is supposed to cast streaming flowers at the
      // target - hmm - it isn't supposed to hurt them, but should prevent
      // actions - use a stun aoe
      {
         effect eAOEStun = EffectAreaOfEffect(AOE_MOB_STUN);
         if (GetAreaFromLocation(locSpell) != OBJECT_INVALID)
            locSpell = GetLocation(oSpellTarget);
         if (GetAreaFromLocation(locSpell) != OBJECT_INVALID)
            ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOEStun, locSpell,
               RoundsToSeconds(1));
      }

      else if (nRoll > 20) // this is supposed to put a pit in front of the
      // caster - how about a placeable
      {
         locSpell = GetAheadLocation(oCaster);
         CreateObject(OBJECT_TYPE_PLACEABLE, "plc_cabinet", locSpell, TRUE);
      }

      // Sanity check -
      else
         SendMessageToPC(oCaster, "Error in wild magic hook - unhandled case");
   }

   // Fall through from dead or non returning wild magic
   // prevent normal spell from running
   SetModuleOverrideSpellScriptFinished();
}
