// You've pissed off the bandit leader.  Now it's fightin' time.
#include "NW_I0_GENERIC"
#include "inc_debug_dac"
#include "inc_dialog"
#include "inc_party"
#include "inc_diss"
#include "inc_area"
void main()
{
   //debugVarObject("dlg_banditfight", OBJECT_SELF);
   object oNPC = getNPCSpeaker();
   //debugVarObject("oNPC", oNPC);
   object oPC = GetPCSpeaker();
   //debugVarObject("oPC", oPC);
   location locPC = GetLocation(oPC);
   if (GetIsPC(oNPC))
   {
      logError("ERROR: PC is attacking himself.");
      return;
   }
   AdjustReputation(oPC, oNPC, -100);
   FloatingTextStringOnCreature("Attack!", oNPC);
   // Spawn in the bandit horde
   float fLevels = IntToFloat(getPartyTotalLevel(oPC, TRUE));
   switch(GetGameDifficulty())
   {
      case GAME_DIFFICULTY_VERY_EASY:
         fLevels *= 0.50;
         break;
      case GAME_DIFFICULTY_EASY:
         fLevels *= 0.75;
         break;
      case GAME_DIFFICULTY_NORMAL:
         break;
      case GAME_DIFFICULTY_DIFFICULT:
         fLevels *= 1.25;
         break;
      case GAME_DIFFICULTY_CORE_RULES:
         fLevels *= 1.5;
         break;
   }
   string sFromWhereClause =
      "  FROM nwn_creatures " +
      " WHERE cr < " + FloatToString(fLevels) +
      "   AND faction_id = 1 " +
      "   AND LOWER(name) NOT LIKE '%leader%' " +
      "   AND LOWER(name) NOT LIKE '%chief%' " +
      "   AND " +
      "     ( LOWER(name) LIKE '%bandit%' " +
      "    OR LOWER(tag) LIKE '%bandit%' " +
      "    OR LOWER(resref) LIKE '%bandit%' " +
      "     )";
   string sResref = "nw_bandit001";
   while (sResref != "" && fLevels > 0.0)
   {
      sResref = selectRandomResref(sFromWhereClause);
      if (sResref != "")
      {
         object oBandit = CreateObject(OBJECT_TYPE_CREATURE, sResref,
            getSurroundLocation(oPC, 10), TRUE);
         //debugVarObject("bandit", oBandit);
         fLevels -= GetChallengeRating(oBandit);
         //debugVarFloat("fLevels", fLevels);
      }
   }
   AssignCommand(oNPC, WrapperActionAttack(oNPC));
   DetermineCombatRound();
}
