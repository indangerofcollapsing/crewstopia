// On Spawn event for Redcloak the goblin
#include "nw_i0_generic"
#include "inc_diss"
#include "inc_debug_dac"
void main()
{
   SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY);
   SetSpawnInCondition(NW_FLAG_SPECIAL_COMBAT_CONVERSATION);
   SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
   ExecuteScript("x2_def_spawn", OBJECT_SELF);
   float fLevel = GetChallengeRating(OBJECT_SELF);
   switch (GetGameDifficulty())
   {
      case GAME_DIFFICULTY_VERY_EASY: fLevel *= 0.5; break;
      case GAME_DIFFICULTY_EASY: fLevel *= 0.75; break;
      case GAME_DIFFICULTY_NORMAL: break;
      case GAME_DIFFICULTY_DIFFICULT: fLevel *= 1.25; break;
      case GAME_DIFFICULTY_CORE_RULES: fLevel *= 1.5; break;
   }
   int bContinue = TRUE;
   while (bContinue)
   {
      string sSQLFromWhere =
         "FROM nwn_creatures " +
        "WHERE resref like '%gob%' " +
          "AND race_id = 12 " +
          "AND faction_id = 1 " +
          "AND cr <= " + FloatToString(fLevel);

      //debugVarString("sSQLFromWhere", sSQLFromWhere);

      string sResRef = selectRandomResref(sSQLFromWhere);
      if (sResRef == "")
      {
         bContinue = FALSE;
      }
      else
      {
         object oSpawned = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
            GetLocation(OBJECT_SELF));
         //debugVarObject("enc_spawnmobs spawned", oSpawned);
         fLevel -= GetChallengeRating(oSpawned);
      }
   }
}