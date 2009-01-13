// Include file for Dug's Incredible Spawn System

// onHeartbeat event for Commoner Spawners
void onCommonerSpawnerHB();
// Returns the number of commoners spawned by oSpawner.
int handleCommoners(object oSpawner);
void destroySpawned(object oSpawner, int nNth = 1);
object spawnCommoner(int nCommonerId);
string selectRandomCommoner(int nCommonerId);
string selectRandomResref(string sFromWhereClause);
location randomWalk(object oCreature = OBJECT_SELF);
// Valid for all Spawners
int getSpawnerId(object oSpawner);
// Valid only for Commoner Spawners
int getMaxSpawns(object oSpawner);
// Valid only for Commoner Spawners
int getMinSpawns(object oSpawner);
// Valid only for Commoner Spawners
int getSpawnRadius(object oSpawner);
// Valid for Commoner and Encounter Spawners
int getWalkChance(object oSpawner);
// Valid for all Spawners
int getStartHour(object oSpawner);
// Valid for all Spawners
int getStopHour(object oSpawner);
// Valid only for Commoner Spawners
string getCommonerTag(object oSpawner);
// Valid only for Encounter Spawners
int getEncounterChance(object oSpawner);
// Valid only for Encounter Spawners
int getEncounterDifficulty(object oSpawner);
// Valid only for Encounter Spawners
int getEncounterRadius(object oSpawner);

// Flag set by the module heartbeat script to disable processing.
const string VAR_DISABLED = "DISABLED";
// Hour of the day to start spawning
const string VAR_SPAWN_BEGIN_HOUR = "DISS_BEGIN_HOUR";
// Hour of the day to stop spawning
const string VAR_SPAWN_END_HOUR = "DISS_END_HOUR";
// Flag set on spawned Commoners so we know which ones to clean up.
const string COMMONER_TAG = "DISS_COMMONER";
// Flag set on spawned Encounter creatures so we know which ones to clean up.
const string SPAWNED_TAG = "DISS_SPAWNED";
// Flag set on creatures to be despawned
const string DESPAWN_TAG = "DISS_DESPAWNING";
// Reference to the object which spawned me
const string VAR_SPAWNED_BY = "DISS_SPAWNED_BY";
// Variable tracking number of spawn points related to me
const string VAR_SPAWN_POINTS = "DISS_SPAWNPOINT_COUNT";
// Delay before respawning
const string VAR_RESPAWN_DELAY = "DISS_RESPAWN_DELAY";

#include "inc_debug_dac"
#include "aps_include"
#include "inc_persistworld"
#include "inc_area"
#include "inc_variables"

void onCommonerSpawnerHB()
{
   if (GetLocalInt(OBJECT_SELF, VAR_DISABLED)) return;
   //debugVarObject("onCommonerSpawnerHB()", OBJECT_SELF);

   int nRespawnDelay = GetLocalInt(OBJECT_SELF, VAR_RESPAWN_DELAY);
   if (nRespawnDelay > 0)
   {
      //debugVarInt(GetName(GetArea(OBJECT_SELF)) + " nRespawnDelay", nRespawnDelay);
      SetLocalInt(OBJECT_SELF, VAR_RESPAWN_DELAY, --nRespawnDelay);
      return;
   }

   int nCommonerId = getSpawnerId(OBJECT_SELF);
   int nMaxSpawns = getMaxSpawns(OBJECT_SELF);
   int nMinSpawns = getMinSpawns(OBJECT_SELF);
   int nSpawnRadius = getSpawnRadius(OBJECT_SELF) * 5;
   int nWalkChance = getWalkChance(OBJECT_SELF);
   int nStartHour = getStartHour(OBJECT_SELF);
   int nStopHour = getStopHour(OBJECT_SELF);
   string sTag = getCommonerTag(OBJECT_SELF);
   object oArea = GetArea(OBJECT_SELF);
   int nCommoners = handleCommoners(OBJECT_SELF);
   int bSpawn = FALSE; // Should we spawn creatures?
   int bDespawn = FALSE; // Should we despawn creatures?
   int nHour = GetTimeHour();
   if (nStartHour == 0 && nStopHour == 0) // default, no time requirement
   {
      bSpawn = TRUE;
   }
   else if (nStartHour < nStopHour) // i.e., start 6, end 18
   {
      bSpawn = (nHour >= nStartHour) && (nHour < nStopHour);
      bDespawn = !bSpawn;
   }
   else // i.e., start 18, stop 6
   {
      bSpawn = (nHour >= nStartHour) || (nHour < nStopHour);
      bDespawn = !bSpawn;
   }
   //debugVarBoolean("bSpawn", bSpawn);
   //debugVarBoolean("bDespawn", bDespawn);

   if (isAreaOccupied(oArea))
   {
      if (bSpawn)
      {
         if (nCommoners < nMinSpawns)
         {
            //debugVarObject("spawning initial commoners", OBJECT_SELF);
            int ii;
            int nRandom = Random(nMaxSpawns - nMinSpawns);
            // Limit to 10 spawns per heartbeat to prevent TMI errors
            for (ii = nCommoners; ii < (nMinSpawns + nRandom) &&
               ii < nCommoners + 10; ii++)
            {
               spawnCommoner(nCommonerId);
            }
         }
         else if (nCommoners < nMaxSpawns)
         {
            int nRatio = (nMaxSpawns - nCommoners) * 100 / nMaxSpawns;
            if (d100() < nRatio)
            {
               spawnCommoner(nCommonerId);
            }
            else if (d100() > nRatio)
            {
               destroySpawned(OBJECT_SELF, Random(nCommoners) + 1);
            }
         }
      }
      else // we've got enough spawned; sleep if appropriate
      {
         int nRespawnDelaySeconds = GetLocalInt(OBJECT_SELF, "RespawnDelay");
         if (nRespawnDelaySeconds > 0)
         {
            SetLocalInt(OBJECT_SELF, VAR_RESPAWN_DELAY,
               nRespawnDelaySeconds / 6);
         }
      }

      if (bDespawn)
      {
         //debugVarObject("despawning commoners", OBJECT_SELF);
         if (nCommoners > 0)
         {
            destroySpawned(OBJECT_SELF, Random(nCommoners) + 1);
         }
      }
   }
   else
   {
      if (nCommoners > 0)
      {
         //debugVarObject("cleaning up commoners", OBJECT_SELF);
         destroySpawned(OBJECT_SELF, Random(nCommoners) + 1);
      }
   }
}

int handleCommoners(object oSpawner)
{
   //debugVarObject("handleCommoners()", OBJECT_SELF);
   //debugVarObject("oSpawner", oSpawner);
   int nCount = 0;
   int nNth = 1;
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_NOT_PC, OBJECT_SELF, nNth, CREATURE_TYPE_IS_ALIVE, TRUE);;
   while (oCreature != OBJECT_INVALID)
   {
      if (GetLocalObject(oCreature, VAR_SPAWNED_BY) == oSpawner)
      {
         nCount++;
         int nWalkChance = getWalkChance(oSpawner);
         if (d100() <= nWalkChance) randomWalk(oCreature);
      }
      oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_NOT_PC, OBJECT_SELF, ++nNth, CREATURE_TYPE_IS_ALIVE, TRUE);;
   }
   //debugVarInt("nCount", nCount);
   return nCount;
}

void destroySpawned(object oSpawner, int nNth = 1)
{
   //debugVarObject("destroySpawned()", OBJECT_SELF);
   //debugVarObject("oSpawner", oSpawner);
   //debugVarInt("nNth", nNth);
   // Yeah, if there are two of the same spawners in the same area this
   // will occasionally fail to despawn the target, but it will happen
   // eventually.
   object oCreature = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR,
      PLAYER_CHAR_NOT_PC, OBJECT_SELF, nNth, CREATURE_TYPE_IS_ALIVE, TRUE);
   if (oCreature != OBJECT_INVALID &&
      GetLocalObject(oCreature, VAR_SPAWNED_BY) == oSpawner &&
      !GetLocalInt(oCreature, DESPAWN_TAG))
   {
      SetLocalInt(oCreature, DESPAWN_TAG, TRUE);
      FloatingTextStringOnCreature("I must be leaving.", oCreature);
      //debugVarObject("I'm despawning", oCreature);
      AssignCommand(oCreature, ClearAllActions(TRUE));
      object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oCreature);
      if (oDoor != OBJECT_INVALID)
      {
         AssignCommand(oCreature, ActionDoCommand(ActionMoveToLocation(
            GetLocation(oDoor))));
      }
      else
      {
         randomWalk(oCreature);
      }
      AssignCommand(oCreature, DestroyObject(oCreature));
   }
}

object spawnCommoner(int nCommonerId)
{
   //debugVarObject("spawnCommoner()", OBJECT_SELF);
   //debugVarInt("nCommonerId", nCommonerId);
   string sResref = selectRandomCommoner(nCommonerId);
   //debugVarString("sResref", sResref);
   // If any spawnpoints are found, cache the total number and pick one randomly
   int nSpawnPoints = GetLocalInt(OBJECT_SELF, VAR_SPAWN_POINTS);
   string sTag = getCommonerTag(OBJECT_SELF);
   if (nSpawnPoints == 0)
   {
      //debugVarObject("counting spawn points", OBJECT_SELF);
      int nNth = 1;
      object oSpawnpoint = GetNearestObjectByTag(sTag);
      while (oSpawnpoint != OBJECT_INVALID)
      {
         oSpawnpoint = GetNearestObjectByTag(sTag, OBJECT_SELF, ++nNth);
      }
      // Use -1 as special value for "already counted, equal to zero"
      nSpawnPoints = (nNth == 1 ?  -1 : nNth - 1);
      SetLocalInt(OBJECT_SELF, VAR_SPAWN_POINTS, nSpawnPoints);
   }
   //debugVarInt("nSpawnPoints", nSpawnPoints);
   location lLocation;
   if (nSpawnPoints > 0)
   {
      //debugMsg("spawning to chosen point");
      lLocation = GetLocation(GetNearestObjectByTag(sTag, OBJECT_SELF,
         Random(nSpawnPoints)));
   }
   else
   {
      //debugMsg("spawning to random location");
      lLocation = getRandomLocation(GetArea(OBJECT_SELF));
   }
   //debugVarLoc("lLocation", lLocation);

   object oCommoner = CreateObject(OBJECT_TYPE_CREATURE, sResref, lLocation,
      FALSE);
   SetLocalInt(oCommoner, COMMONER_TAG + IntToString(nCommonerId), TRUE);
   SetLocalObject(oCommoner, VAR_SPAWNED_BY, OBJECT_SELF);
   //debugVarObject("spawned", oCommoner);
   return oCommoner;
}

string selectRandomCommoner(int nCommonerId)
{
   //debugVarObject("selectRandomCommoner()", OBJECT_SELF);
   //debugVarInt("nCommonerId", nCommonerId);
   int nFreq = Random(10);
   //debugVarInt("nFreq", nFreq);
   string sResref = selectRandomResref(
      "  FROM nwn_commoner$creatures " +
      " WHERE commoner_id = " + IntToString(nCommonerId) +
      "   AND " +
      "     ( frequency >= " + IntToString(nFreq) +
      "    OR frequency = (SELECT MAX(frequency) FROM nwn_commoner$creatures " +
      "          WHERE commoner_id = " + IntToString(nCommonerId) + ")" +
      "     )");
   //debugVarString("sResref", sResref);
   return sResref;
}

string selectRandomResref(string sFromWhereClause)
{
   //debugVarObject("selectRandomResref()", OBJECT_SELF);
   //debugVarString("sFromWhereClause", sFromWhereClause);
   string sSql = "SELECT resref " + sFromWhereClause +
      " ORDER BY rand() LIMIT 1";
   //debugVarString("sSql", sSql);
   SQLExecDirect(sSql);
   string sReturn = "";
   if (SQLFetch())
   {
      sReturn = SQLGetData(1);
   }
   else
   {
      logError("ERROR: no data found for " + sSql + " in selectRandomResref()");
   }
   //debugVarString("sReturn", sReturn);
   return sReturn;
}

location randomWalk(object oCreature = OBJECT_SELF)
{
   object oWaypoint = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj",
      getRandomLocation(GetArea(oCreature)));
   location lLocation = GetLocation(oWaypoint);
   AssignCommand(oCreature, ActionDoCommand(ActionMoveToLocation(lLocation)));
   DestroyObject(oWaypoint);
   return lLocation;
}

// Valid for all Spawners
int getSpawnerId(object oSpawner) { return GetHardness(oSpawner); }
// Valid only for Commoner Spawners
int getMaxSpawns(object oSpawner) { return GetMaxHitPoints(oSpawner); }
// Valid only for Commoner Spawners
int getMinSpawns(object oSpawner) { return GetFortitudeSavingThrow(oSpawner); }
// Valid only for Commoner Spawners
int getSpawnRadius(object oSpawner) {return GetReflexSavingThrow(oSpawner) * 5;}
// Valid for Commoner and Encounter Spawners
int getWalkChance(object oSpawner) { return GetWillSavingThrow(oSpawner); }
// Valid for all Spawners
int getStartHour(object oSpawner)
{
   return GetLocalInt(oSpawner, VAR_SPAWN_BEGIN_HOUR);
}
// Valid for all Spawners
int getStopHour(object oSpawner)
{
   return GetLocalInt(oSpawner, VAR_SPAWN_END_HOUR);
}
// Valid only for Commoner Spawners
string getCommonerTag(object oSpawner)
{
   return COMMONER_TAG + IntToString(getSpawnerId(oSpawner));
}
// Valid only for Encounter Spawners
int getEncounterChance(object oSpawner) { return GetMaxHitPoints(oSpawner); }
// Valid only for Encounter Spawners
int getEncounterDifficulty(object oSpawner)
{
   return GetFortitudeSavingThrow(oSpawner);
}
// Valid only for Encounter Spawners
int getEncounterRadius(object oSpawner)
{
   return GetReflexSavingThrow(oSpawner) * 5;
}

//void main() { onCommonerSpawnerHB(); } // Testing/compiling purposes
