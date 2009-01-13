//::///////////////////////////////////////////////
//:: Player Tool 10 Instant Feat
//:: x3_pl_tool10
//:: Copyright (c) 2007 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This is a blank feat script for use with the
    10 Player instant feats provided in NWN v1.69.

    Look up feats.2da, spells.2da and iprp_feats.2da
*/
//:://////////////////////////////////////////////
//:: Created By: Brian Chung
//:: Created On: 2007-12-05
//:://////////////////////////////////////////////

#include "inc_debug_dac"
#include "nw_i0_generic"

void main()
{
   debugVarObject("x3_pl_tool10", OBJECT_SELF);

   object oPC = OBJECT_SELF;
   SendMessageToPC(oPC, "Player Tool 10 activated - Autotarget Nearest Enemy.");

   // @HACK - since this is a quick action, piggyback a save to disk
   // in case of server crash
   if (GetIsPC(oPC)) ExportSingleCharacter(oPC);

   object oAttacker = GetLastAttacker(oPC);
   if (oAttacker == OBJECT_INVALID)
   {
      //debug("last attacker invalid");
      oAttacker = GetNearestCreature(CREATURE_TYPE_REPUTATION,
         REPUTATION_TYPE_ENEMY, oPC, 1, CREATURE_TYPE_IS_ALIVE, TRUE);
   }
   //debugVarObject("oAttacker", oAttacker);
   if (oAttacker == OBJECT_INVALID)
   {
      //debugVarObject("oAttacker", oAttacker);
      FloatingTextStringOnCreature("You perceive nothing unusual.", oPC);
      DetermineCombatRound();
   }
   else
   {
      int nAttackerAppearance = GetAppearanceType(oAttacker);
      //debugVarInt("nAttackerAppearance", nAttackerAppearance);
      if (nAttackerAppearance == -1)
      {
         // Try making the attacker appear
         //debugMessage("Attacker is ethereal.");
         ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectAppear(), oAttacker);
         if (GetAppearanceType(oAttacker) == -1)
         {
            //debugMessage("Attacker still ethereal.");
            // Try again
            object oNew = CreateObject(OBJECT_TYPE_CREATURE, GetResRef(oAttacker),
               GetLocation(oAttacker));
            int nDamage = GetMaxHitPoints(oAttacker) - GetCurrentHitPoints(oAttacker);
            DestroyObject(oAttacker);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDamage), oNew);
         }
      }
      AssignCommand(oPC, ActionAttack(oAttacker));
   }
}