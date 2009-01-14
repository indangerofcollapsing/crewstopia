#include "NW_I0_GENERIC"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_init_combat", OBJECT_SELF);
   object oPC = GetItemActivator();
   //debugVarObject("Item Activator", oPC);
   if (oPC == OBJECT_INVALID) oPC = OBJECT_SELF;
   //debugVarObject("oPC", oPC);

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
