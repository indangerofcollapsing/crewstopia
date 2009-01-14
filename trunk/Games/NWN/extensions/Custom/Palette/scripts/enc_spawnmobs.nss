// Spawn creatures via SQL to scale to the level of the PCs.
// Encounters that use this feature need to:
// 1. Be using NWNX_ODBC or similar database connectivity
// 2. Be set to maximum spawns = 1 (unless you want to really kill 'em!)
// 3. Put this script in the OnEntered event of the encounter.

const string VAR_LAST_PC_ENTERED = "LAST_PC_ENTERED";
const string VAR_SQL_WHERE_CLAUSE = "SQL_WHERE_CLAUSE";
const string VAR_OTHER_FACTIONS = "SPAWN_FACTIONS";
#include "inc_party"
#include "inc_diss"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("enc_spawnmobs", OBJECT_SELF);
   object oCreature = GetEnteringObject();
   //debugVarObject("oCreature", oCreature);

   // Track the PCs entering so we can scale correctly.
   if (GetIsPC(oCreature) || GetIsPC(GetMaster(oCreature)))
   {
      if (GetIsPC(oCreature))
      {
         SetLocalObject(OBJECT_SELF, VAR_LAST_PC_ENTERED, oCreature);
      }
      else
      {
         SetLocalObject(OBJECT_SELF, VAR_LAST_PC_ENTERED,
            GetMaster(oCreature));
      }
   }

   if (! GetIsEncounterCreature(oCreature)) return;

   // Don't continue if the encounter is not active.
   if (! GetEncounterActive(OBJECT_SELF)) return;

   string sSQLWhereClause = GetLocalString(OBJECT_SELF, VAR_SQL_WHERE_CLAUSE);
   if (sSQLWhereClause == "") return;

   // Failsafe: Key the minions to the level of the encounter spawned creature.
   float fLevel = GetChallengeRating(oCreature);
   object oLastPC = GetLocalObject(OBJECT_SELF, VAR_LAST_PC_ENTERED);
   if (oLastPC == OBJECT_INVALID)
   {
      logError("ERROR: scaled encounter, but no last entered PC: " +
         objectToString(OBJECT_SELF) + " in " + GetName(GetArea(OBJECT_SELF)));
   }
   else
   {
      // Key minion level to total party level.
      fLevel = getPartyTotalLevel(oLastPC) * 1.0;
   }
   //debugVarFloat("fLevel", fLevel);

   switch (GetEncounterDifficulty(OBJECT_SELF))
   {
      case ENCOUNTER_DIFFICULTY_VERY_EASY: fLevel *= 0.5; break;
      case ENCOUNTER_DIFFICULTY_EASY: fLevel *= 0.75; break;
      case ENCOUNTER_DIFFICULTY_NORMAL: break;
      case ENCOUNTER_DIFFICULTY_HARD: fLevel *= 1.25; break;
      case ENCOUNTER_DIFFICULTY_IMPOSSIBLE: fLevel *= 1.5; break;
   }
   //debugVarFloat("fLevel", fLevel);

   string sOtherFactions = GetLocalString(OBJECT_SELF, VAR_OTHER_FACTIONS);
   int bContinue = TRUE;
   while (bContinue)
   {
      string sSQLFromWhere =
         "FROM nwn_creatures " +
        "WHERE " + sSQLWhereClause + " " +
          "AND cr <= " + FloatToString(fLevel) + " " +
          "AND faction_id IN (1";
      if (sOtherFactions != "") sSQLFromWhere += "," + sOtherFactions;
      sSQLFromWhere += ") ";

      //debugVarString("sSQLFromWhere", sSQLFromWhere);

      string sResRef = selectRandomResref(sSQLFromWhere);
      if (sResRef == "")
      {
         bContinue = FALSE;
      }
      else
      {
         object oSpawned = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
            GetLocation(oCreature));
         //debugVarObject("enc_spawnmobs spawned", oSpawned);
         if (GetIsFriend(oCreature)) fLevel -= GetChallengeRating(oSpawned);
      }
   }

   DeleteLocalObject(OBJECT_SELF, VAR_LAST_PC_ENTERED);
}