// Methods and constants useful for Persistent Worlds

void markTemporary(object oObject);
int isTemporary(object oObject);
void areaCleanup(object oArea = OBJECT_SELF);
int isAreaOccupied(object oArea);
void cleanupItems(object oArea = OBJECT_SELF);
void ActionCreateObject(int nObjectType, string sTemplate, location lLocation,
   int bUseAppearAnimation = FALSE, string sNewTag = "");
void ActionRespawnObject(float fDelay, int nObjectType, string sTemplate,
   location lLocation, int bUseAppearAnimation = FALSE, string sNewTag = "");
void respawnPlaceable(object oPlaceable = OBJECT_SELF);
int getRespawnDelay(object obj = OBJECT_SELF);
int onDisturbedGuardMe(object obj = OBJECT_SELF);
void placeableToItem(object oPlaceable, string sResRef, object oUser);
void markKill(object oKilled, object oPC);
int getNumberKilled(string sTag, object oPC);
void setNumberKilled(string sTag, object oPC, int nKilled);
void markKilledBy(object oKilled, object oPC);
int getTimesKilledBy(string sTag, object oPC);
void setTimesKilledBy(string sTag, object oPC, int nKilled);
void exportPC(object oPC = OBJECT_SELF);
void setLastKnownLocation(object oPC = OBJECT_SELF);
location getLastKnownLocation(object oPC = OBJECT_SELF);
int getTreasureValueType(object oPlaceable = OBJECT_SELF);

// Set on Module, Area, or Placeable to respawn certain placeables after X rounds
const string VAR_RESPAWN_TIME = "RespawnTime";
// Set on Module, Area, or Placeable (especially altars and crypts)
const string VAR_GUARD_CHANCE = "GUARD_CHANCE";
// Persistent killed/killed-by tracking
const string VAR_KILLED = "KILLED~";
const string VAR_KILLEDBY = "KILLEDBY~";
// How often to save PC data (seconds)
const string VAR_PC_SAVE_DELAY = "PC_SAVE_DELAY";
// Last known location
const string VAR_PC_LOCATION = "LOCATION";
// Used by on_death_*.nss to determine the value of placeable loot
const string VAR_LOOT_ADJUSTMENT = "LOOT_VALUE_MODIFIER";
// Waypoint tag for loot adjustment subareas
const string WAYPOINT_LOOT_ADJUSTMENT = "LOOT_ADJUSTMENT_WAYPOINT";

const string VAR_TEMPORARY = "delete_me";
const string VAR_COUNTDOWN = "cleanup_countdown";
const float CLEANUP_DELAY_SECONDS = 30.0;
const int USER_EVENT_RESPAWN = 500;

#include "x0_i0_treasure"
#include "inc_heartbeat"
#include "inc_nbde"
//#include "inc_variables"
//#include "inc_travel"
//#include "inc_debug_dac"

void markTemporary(object oObject)
{
   SetLocalInt(oObject, VAR_TEMPORARY, TRUE);
}

int isTemporary(object oObject)
{
   return GetLocalInt(oObject, VAR_TEMPORARY);
}

void areaCleanup(object oArea = OBJECT_SELF)
{
   int Rounds = GetLocalInt(oArea, VAR_COUNTDOWN) + 1;
   SetLocalInt(oArea, VAR_COUNTDOWN, Rounds);
   DelayCommand(CLEANUP_DELAY_SECONDS, cleanupItems());
}

int isAreaOccupied(object oArea)
{
   if (! GetIsObjectValid(oArea)) return FALSE;
   object oPlayer = GetFirstPC();
   while ((GetArea(oPlayer) != oArea) && (oPlayer != OBJECT_INVALID))
   {
      oPlayer = GetNextPC();
   }
   return (oPlayer != OBJECT_INVALID);
}

void cleanupItems(object oArea = OBJECT_SELF)
{
   int Rounds = GetLocalInt(oArea, VAR_COUNTDOWN);
   if (! isAreaOccupied(oArea))
   {
      // If in reaction to the most recent PC leaving the area, clean up.
      if (Rounds == 1)
      {
         object oItem = GetFirstObjectInArea(oArea);
         // When an NPC dies, they drop an object, not an item... like a treasure chest.
         while (oItem != OBJECT_INVALID)
         {
            if (isTemporary(oItem)) DestroyObject(oItem);
            else if (GetIsEncounterCreature(oItem)) DestroyObject(oItem);
            else if (GetTag(oItem) == "BodyBag")
            {
               object oLookIn = GetFirstItemInInventory(oItem);
               while (oLookIn != OBJECT_INVALID)
               {
                  DestroyObject(oLookIn);
                  oLookIn = GetNextItemInInventory(oItem);
               }
               DestroyObject(oItem);
            }
            else if ((GetObjectType(oItem) == OBJECT_TYPE_ITEM))
            {
               DestroyObject(oItem);
            }
            oItem = GetNextObjectInArea(oArea);
         }
         SetLocalInt(oArea, VAR_COUNTDOWN, 0);
      }
      else
      {
         SetLocalInt(oArea, VAR_COUNTDOWN, --Rounds);
      }
   }
   else
   {
      SetLocalInt(oArea, VAR_COUNTDOWN, --Rounds);
   }
}

void ActionCreateObject(int nObjectType, string sTemplate, location lLocation,
   int bUseAppearAnimation = FALSE, string sNewTag = "")
{
   //debugVarObject("ActionCreateObject()", OBJECT_SELF);
   CreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag);
}

void ActionRespawnObject(float fDelay, int nObjectType, string sTemplate,
   location lLocation, int bUseAppearAnimation = FALSE, string sNewTag = "")
{
   //debugVarObject("ActionRespawnObject()", OBJECT_SELF);
   DelayCommand(fDelay, ActionCreateObject(nObjectType, sTemplate, lLocation, bUseAppearAnimation, sNewTag));
}

void respawnPlaceable(object oPlaceable = OBJECT_SELF)
{
   //debugVarObject("respawnPlaceable()", OBJECT_SELF);
   //debugVarObject("oPlaceable", oPlaceable);

   // Timer
   float fDelay = getRespawnDelay(oPlaceable) * DURATION_1_ROUND;
   //debugVarFloat("respawn delay", fDelay);
   if (fDelay < 0.0) return;
   AssignCommand(GetModule(), ActionRespawnObject(fDelay,
      GetObjectType(oPlaceable), GetResRef(oPlaceable), GetLocation(oPlaceable),
      FALSE, GetTag(oPlaceable)));
   ApplyEffectToObject(DURATION_TYPE_INSTANT,
      EffectDamage(GetMaxHitPoints(oPlaceable)),  oPlaceable);
}

int getRespawnDelay(object obj = OBJECT_SELF)
{
   int nDelay = GetLocalInt(obj, VAR_RESPAWN_TIME); // in rounds
   if (nDelay == 0) nDelay = GetWillSavingThrow(obj);
   if (nDelay == 0) nDelay = GetLocalInt(GetArea(obj), VAR_RESPAWN_TIME);
   if (nDelay == 0) nDelay = GetWillSavingThrow(GetArea(obj));
   if (nDelay == 0) nDelay = GetLocalInt(GetModule(), VAR_RESPAWN_TIME);
   if (nDelay == 0) nDelay = GetWillSavingThrow(GetModule());
   if (nDelay == 0) nDelay = Random(50) + 50;
   SetLocalInt(obj, VAR_RESPAWN_TIME, nDelay);
   return nDelay;
}

// Returns TRUE if the placeable which has been disturbed should be guarded.
int onDisturbedGuardMe(object obj = OBJECT_SELF)
{
   int nGuardedChance = getVarInt(obj, VAR_GUARD_CHANCE);
   if (nGuardedChance == 0) nGuardedChance = 25;
   return (d100() > nGuardedChance);
}

void placeableToItem(object oPlaceable, string sResRef, object oUser)
{
   object oItem = CreateItemOnObject(sResRef, oUser);
   //debugVarObject("oItem", oItem);
   if (oItem != OBJECT_INVALID)
   {
      SetLocalString(oItem, "CREATE_PLACEABLE", GetResRef(oPlaceable));
      // Set the item name to match the placeable, with the item name appended.
      SetName(oItem, GetName(oPlaceable) + " (" + GetName(oItem) + ")");
      SetStolenFlag(oItem, TRUE);
      // Allow to respawn (must also use on_death_XXX_rs)
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetMaxHitPoints()),
         oPlaceable);
   }
}

// Persistent tracking of what a PC kills
void markKill(object oKilled, object oKiller)
{
   string sHenchMsg = "";
   if (! GetIsPC(oKiller))
   {
      if (GetIsPC(GetMaster(oKiller)))
      {
         sHenchMsg = " associate " + GetName(oKiller);
         oKiller = GetMaster(oKiller);
      }
      else
      {
         // Not a PC or henchman, so no need to track statistics
         return;
      }
   }
   //debugVarObject("oKiller", oKiller);

   string sTag = GetTag(oKilled);
   int nKilled = getNumberKilled(sTag, oKiller);
   //debugVarInt("nKilled", nKilled);
   nKilled++;
   setNumberKilled(sTag, oKiller, nKilled);
   WriteTimestampedLogEntry(GetName(oKilled) + " killed by " +
      GetName(oKiller) + sHenchMsg + " (total kills: " +
      IntToString(nKilled) + ")");
}

int getNumberKilled(string sTag, object oPC)
{
   return getPersistentInt(oPC, VAR_KILLED + sTag);
}

void setNumberKilled(string sTag, object oPC, int nKilled)
{
   setPersistentInt(oPC, VAR_KILLED + sTag, nKilled);
}

// Persistent tracking of what has killed the PC
void markKilledBy(object oKiller, object oPC)
{
   if (! GetIsPC(oPC)) return;

   string sTag = "[unknown]";
   string sName = "a non-creature, probably a trap";
   if (oKiller != OBJECT_INVALID)
   {
      sTag = GetTag(oKiller);
      sName = GetName(oKiller);
   }

   int nKilled = getTimesKilledBy(sTag, oPC);
   //debugVarInt("nKilled", nKilled);
   nKilled++;
   setTimesKilledBy(sTag, oPC, nKilled);
   WriteTimestampedLogEntry(GetName(oPC) + " killed by " + sName +
      " (total kills: " + IntToString(nKilled) + ")");
}

int getTimesKilledBy(string sTag, object oPC)
{
   return getPersistentInt(oPC, VAR_KILLEDBY + sTag);
}

void setTimesKilledBy(string sTag, object oPC, int nKilled)
{
   setPersistentInt(oPC, VAR_KILLEDBY + sTag, nKilled);
}

void exportPC(object oPC = OBJECT_SELF)
{
   //debugVarObject("exportPC()", OBJECT_SELF);
   setLastKnownLocation(oPC);
}

void setLastKnownLocation(object oPC = OBJECT_SELF)
{
   //debugVarObject("setLastKnownLocation()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   location loc = GetLocation(oPC);
   //debugVarLoc("loc", loc);
   // For some unknown reason, often the location is invalid.  Since we don't
   // know why, trap and ignore it to avoid log file bloat.
   if (isLocationValid(loc)) setPersistentLocation(oPC, VAR_PC_LOCATION, loc);
}

location getLastKnownLocation(object oPC = OBJECT_SELF)
{
   location loc = getPersistentLocation(oPC, VAR_PC_LOCATION);
   //debugVarLoc("getLastKnownLocation()", loc);
   return loc;
}

int getTreasureValueType(object oPlaceable = OBJECT_SELF)
{
   // Loot value can be adjusted by variables on the object itself, the area,
   // and/or the module.  So you can have a low-loot chest in a high-loot
   // area in a low-loot module, which will produce medium-low loot on average.
   // Also, better treasure is guarded by thicker walls, so hardness matters
   // too.
   int nRandom = Random(100) + GetLocalInt(oPlaceable, VAR_LOOT_ADJUSTMENT) +
      GetLocalInt(GetArea(oPlaceable), VAR_LOOT_ADJUSTMENT) +
      GetLocalInt(GetModule(), VAR_LOOT_ADJUSTMENT) + GetHardness(oPlaceable);

   // Since placeables cannot replicate local variables when they respawn,
   // use a waypoint nearby to store loot adjustment for a small subarea.
   object oLootWaypoint = GetNearestObjectByTag(WAYPOINT_LOOT_ADJUSTMENT);
   if (oLootWaypoint != OBJECT_INVALID)
   {
      float fDist = GetDistanceBetween(oPlaceable, oLootWaypoint);
      if (fDist <= 5.0)
      {
         nRandom += GetLocalInt(oLootWaypoint, VAR_LOOT_ADJUSTMENT);
      }
   }

   int nTreasureType = TREASURE_TYPE_LOW;
   if (nRandom > 100) nTreasureType = TREASURE_TYPE_UNIQUE;
   else if (nRandom > 85) nTreasureType = TREASURE_TYPE_HIGH;
   else if (nRandom > 50) nTreasureType = TREASURE_TYPE_MED;
   else nTreasureType = TREASURE_TYPE_LOW;

   return nTreasureType;
}

//void main() {} // testing/compiling purposes
