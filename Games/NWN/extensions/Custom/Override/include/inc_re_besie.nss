//////////////////////////////////////////////////
/*
Custom Random Encounter utils for use with the BESIE
Random Encounter Package by Ray Miller
*/
//////////////////////////////////////////////////
//::///////////////////////////////////////////////
//:: Name re_rndenc
//:: FileName re_rndenc.nss
//:: Copyright (c) 2002 Raymond Miller
//:://////////////////////////////////////////////
/*
This script creates functions called randomEncounter(),
cleanHouse(), and SetRndEncProperties() for use in the NWN
scripting language.  This script is meant to be used as an #include
and is part of the BESIE Random Encounter package by Ray Miller
*/
//:://////////////////////////////////////////////
//:: Created By: Ray Miller
//:: Created On: 7/6/2002
//:://////////////////////////////////////////////
/*
This script represents the standard encounter table
for the BESIE Random Encounter System By Ray Miller.
It is meant to be used as an include, and will not
compile on its own.
*/
//:://////////////////////////////////////////////
//:: Created By: Ray Miller
//:: Created On: God knows.  I wrote this months ago!
//:: Updated by Doug Crews for CEP 2.0
//:://////////////////////////////////////////////

struct RndEncProperties
{
   int bInitialized;
   int iDifficulty;
   int bConsiderCR;
   string sCreatureTable;
   int iLifeTime;
   int iMph;
   int iEncounterType;
   int bConflict;
   int iChanceOnRest;
   int bLOSCheck;
};

// Encounter Type Constants
const int ENCOUNTER_TYPE_AREA = 3;
const int ENCOUNTER_TYPE_PARTY = 1;
const int ENCOUNTER_TYPE_IND = 2;
const int ENCOUNTER_TYPE_TOTALPARTYLEVELS = 4;

struct tMinMaxCR
{
   float fMinCR;
   float fMaxCR;
};

// FUNCTION DECLARATIONS

string getRndEncCreature(float fMinCR = 0.0, float fMaxCR = 9999.0,
   string sCreatureTable = "");

// Sets properties for random encounters that are likely to seldom change
// - oObject: The object that holds these properties.
// - iDifficulty: 1 to 10
// - bConsiderCR: If TRUE takes CR of creature into consideration when
//   choosing an encounter.
// - sCreatureTable: "re_***" - where *** is a string of letter and/or numbers
//   to indicate to the function what type
//   of creatures to spawn.  They are as follows:
//      a - animals
//      c - construct
//      d - dragon
//      e - elemental
//      g - giant
//      h - humanoid
//      i - insect
//      m - miscellaneous
//      p - planar
//      u - undead
//      b - bandit
//      x1 through x### - These are for custom encounter tables.
//      t1 through t### - These are for treasure tables.
// - iLifeTime: Time in seconds before unengaged encounters decay.
// - Mph: Should equal the Minutes Per Hour setting of the Module.
// - iEncounterType:
//      ENCOUNTER_TYPE_PARTY - Takes into consideration the average level of the
//      entire party of the PC who is to
//      receive the encounter when choosing an encounter of appropriate
//      difficulty level.
//      ENCOUNTER_TYPE_TOTALPARTYLEVELS (default) - Takes into consideration the
//      TOTAL of all the levels of the PC's party who
//      currently reside in the same area as the PC to receive the encounter.
//      ENCOUNTER_TYPE_AREA - Takes into consideration the levels off all PCs
//      and henchmen within a 20m radius of the PC
//      who is to receive the encounter.
//      ENCOUNTER_TYPE_IND - Takes into consideration only the levels of the
//   individual PC who is to receive the encounter.
// - bConflict: If set to TRUE then random encounters can occur during combat.
// - iChanceOnRest: The chance of a random encounter occuring when a PC rests
//   (only matters on Area Object and the "re_onrest"
//   script must be placed in PlayerOnRest handler of the module object).
// - bLOSCheck: Dependant upon a broken scripting function.  (future use!)
// Note:  This function is best called by the OnModuleLoad or OnAreaLoad
//   handler.
void setRndEncProperties(object oObject = OBJECT_SELF, int iDifficulty = 4,
   int bConsiderCR = TRUE, string sCreatureTable = "re_ceghimpubt0",
   int iLifeTime = 180, int iMph = 2, int iEncounterType = 4,
   int bConflict = FALSE, int iChanceOnRest = 20, int bLOSCheck = FALSE);

// Returns the structure "RndEncProperties" containing all the Random Encounter
// Properties set on oObject.
// The elements of the structure are as follows:
// - bInitialized: TRUE if properties have been set on this object.
// - iDifficulty: 1 to 10
// - bConsiderCR: If TRUE, takes CR of creature into consideration when
//   choosing an encounter.
// - sCreatureTable: "re_***" - where *** is a string of letter and/or numbers
//   to indicate to the function what type
//   of creatures to spawn.  They are as follows:
//      a - animals
//      c - construct
//      d - dragon
//      e - elemental
//      g - giant
//      h - humanoid
//      i - insect
//      m - miscellaneous
//      p - planar
//      u - undead
//      b - bandit
//      x1 through x### - These are for custom encounter tables.
//      t1 through t### - These are for treasure tables.
// - iLifeTime: Time in seconds before unengaged encounters decay.
// - iMph: Should equal the Minutes Per Hour setting of the Module.
// - iEncounterType:
//      ENCOUNTER_TYPE_PARTY - Takes into consideration the average level of the
//      entire party of the PC who is to
//      receive the encounter when choosing an encounter of appropriate
//      difficulty level.
//      ENCOUNTER_TYPE_TOTALPARTYLEVELS (default) - Takes into consideration the
//      TOTAL of all the levels of the PC's party who
//      currently reside in the same area as the PC to receive the encounter.
//      ENCOUNTER_TYPE_AREA - Takes into consideration the levels off all PCs
//      and henchmen within a 20m radius of the PC
//      who is to receive the encounter.
//      ENCOUNTER_TYPE_IND - Takes into consideration only the levels of the
//      individual PC who is to receive the encounter.
// - bConflict: If TRUE then random encounters can occur during combat.
// - iChanceOnRest: The chance of a random encounter occuring when a PC rests
//   (only matters on Area Object and the "re_onrest"
//   script must be placed in PlayerOnRest handler of the module object).
// - bLOSCheck: Dependant upon a broken scripting function.  (future use!)
struct RndEncProperties getRndEncProperties(object oObject);

// Generates the likelihood of a random encounter.
// - fChanceOfEncounter: Odds of encounter spawning when funciton is called.
//   Accurate to two decimal places.  .01 to 100.00 percent chance.
// - oEncounterObject: The object about which the encounter will spawn, whose
//   levels (if a player) will be considered when determining an appropriate
//   creature.
// - sTemplate: When used as the sCreatureTable parameter in the
//   setRndEncProperties()
//   function this parameter has higher priority.  It can also be set to the
//   tag of a specific creature, or to "random" to use the default table set
//   by setRndEncProperties()
// - iMinNumberOfCreatures: If > 0, a random number of creatures between this
//   and iMaxNumberOfCreatures
//   will spawn.  If set to 0, then exactly the number of creatures set by
//   iMaxNumberOfCreatures will spawn.
// - iMaxNumberOfCreatures: If this and iMinNumberOfCreatures is set to 0 then
//   the number of Creatures
//   spawned will be determined by the CR of the creature spawned compared to
//   the levels of the player(s).
// - iMinEncounterDistance: If set to 0, encounter distance will always be at
//   the number set by iMaxEncounterDistance.
// - iMaxEncounterDistance: Farthest distance the encounter can be from
//   oEncounterObject.
// - iOrientation: 0 to 360.  Counterclockwise representing the angle from
//   facing where the encounter will spawn.
//   a value of 0 will spawn the encounter directly in front of
//   oEncounterObject.  360 will generate a random angle.
// - iTolerance: The number of degrees by which the angle can randomly be off
//   from iOrientation.
// - iCheckDistance: The distance a PC has to move before a Random Encounter
//   check can be made against him.  If the PC has
//   not covered this much distance, then a call to the randomEncounter()
//   function for this PC will yield
//   OBJECT_INVALID.
// - iLevelOverride: Use this to force the function to base the encounter on a
//   character level other than that
//   determined by oEncounterObject.
// - iDifficulty: Overrides the difficulty setting determined by the
//   setRndEncProperties() function.
object randomEncounter(float fChanceOfEncounter = 100.0,
   object oEncounterObject = OBJECT_SELF, string sTemplate = "random",
   int iMinNumberOfCreatures = 0, int iMaxNumberOfCreatures = 0,
   int iMinEncounterDistance = 1, int iMaxEncounterDistance = 15,
   int iOrientation = 360, int iTolerance = 0, int iCheckDistance = 0,
   int iLevelOverride = 0, int iDifficulty = 0);

// Used to "clean up" an area that has become littered by random encounters.
// - bDestroyPlotItems - Tells the function whether or not to destroy items
//   with their plot flags set.  If set to TRUE,
//   plot items will be destroyed just like any other item.
// - oArea - The area to clean up.
// - iSpawnOverride - Overrides the default (set by the setRndEncProperties()
//   function) time to destroy random encounter
//   creatures who are not engaged by PCs.
// - iItemOverride - Overrides the default time of 30 minutes after which to
//   destroy items dropped by PCs
//   Note: Only works if the "re_moditemdrop" script included with the BESIE
//   Random Encounter package
//   is placed in the module OnItemUnacquire handler.
// - iBodyBagOverride - Overrides the default time of 5 minutes after which to
//   destroy loot that was dropped by creatures
//   who were killed.
// NOTE: If there is bDestroyPlotItems is FALSE and there is a plot item or
// items inside a container or body bag, the container
// and all non-plot items will decay but the plot item(s) will be left.
// NOTE: A value of zero assigned to the override parameters will cause the
// function to use the default value for that parameter.
void cleanHouse(int bDestroyPlotItems = FALSE, object oArea = OBJECT_SELF,
   int iSpawnOverride = 0, int iItemOverride = 0, int iBodyBagOverride = 0);

// Returns the game's calander time in seconds since time zero.
// - iMph: Minutes Per Hour.  This should match the module's setting.
int getTimeInSeconds(int iMph = 2);

// Causes oCreature to walk to a randomly determined location.
// - lCenter: The center of a circle in which random destinations
// can be generated.
// - iDistance: The distance from lCenter in which to randomly
// generate destinations.
// - oCreature: The creature to perform the random walk.
// Note: Unlike the default RandomWalk function, this function does not
// persist until a ClearAllActions is called.  Instead this
// function generates a single random destination and the move to that
// destination is added to the creatures action queue only once per call.
location randomWalk2(location lCenter, int iDistance = 20,
   object oCreature = OBJECT_SELF);

// Returns TRUE if we should only do housecleaning, FALSE if encounters are wanted.
int besieInit(string sToolType);

object spawnSingleUndead(object oPC);
object spawnSinglePlanar(object oPC);

#include "inc_nbde"
#include "inc_debug_dac"

void MOB(string sResRef, float fCR, int iWeight = 1, int iMin = 0, int iMax = 0);
void Commoner(string sResRef, int iWeight = 1);
struct tMinMaxCR getEncounterCR(object oEncounterObject = OBJECT_SELF,
   int nEncounterType = ENCOUNTER_TYPE_AREA);

void MOB(string sResRef, float fCR, int iWeight = 1, int iMin = 0, int iMax = 0)
{
   //debugVarObject("MOB()", OBJECT_SELF);
   //debugVarString("sResRef", sResRef);
   //debugVarFloat("fCR", fCR);
   int iVarNum = GetLocalInt(OBJECT_SELF, "re_iVarNum");
   struct tMinMaxCR tCR = getEncounterCR(OBJECT_SELF, ENCOUNTER_TYPE_AREA);
   //debugVarFloat("tCR.fMinCR", tCR.fMinCR);
   //debugVarFloat("tCR.fMaxCR", tCR.fMaxCR);
   float fMinCR = tCR.fMinCR;
   if (fMinCR > 18.0)
   {
      fMinCR = 18.0;
      SetLocalFloat(OBJECT_SELF, "re_fMinCR", fMinCR);
   }
   float fMaxCR = tCR.fMaxCR;
   if (fMaxCR == 0.0)
   {
      fMaxCR = 9999.0;
      SetLocalFloat(OBJECT_SELF, "re_fMaxCR", fMaxCR);
   }
   //debugVarFloat("tCR.fMinCR", tCR.fMinCR);
   //debugVarFloat("tCR.fMaxCR", tCR.fMaxCR);
   if (fCR >= fMinCR && fCR <= fMaxCR && GetStringLowerCase(sResRef) != "")
   {
      object oMod = GetModule();
      int ii;
      for (ii = 1; ii <= iWeight; ii++)
      {
         //debugVarString("MOB() including", sResRef);
         SetLocalString(oMod, "re_sCreatureList" + IntToString(iVarNum), sResRef);
         SetLocalInt(oMod, "re_iMaxNumberOfCreatures" + IntToString(iVarNum), iMax);
         SetLocalInt(oMod, "re_iMinNumberOfCreatures" + IntToString(iVarNum), iMin);
         iVarNum++;
      }
   }
   SetLocalInt(OBJECT_SELF, "re_iVarNum", iVarNum);
   //debugVarInt("re_iVarNum", GetLocalInt(OBJECT_SELF, "re_iVarNum"));
}

void Commoner(string sResRef, int iWeight = 1)
{
   //debugVarObject("Commoner()", OBJECT_SELF);
   //debugVarString("sResRef", sResRef);
   int iVarNum = GetLocalInt(OBJECT_SELF, "re_iVarNum");
   object oMod = GetModule();
   if (GetStringLowerCase(sResRef) != "")
   {
      int ii;
      for (ii = 1; ii <= iWeight; ii++)
      {
         SetLocalString(oMod, "re_sCreatureList" + IntToString(iVarNum), sResRef);
         iVarNum++;
      }
   }
   SetLocalInt(OBJECT_SELF, "re_iVarNum", iVarNum);
}

struct tMinMaxCR getEncounterCR(object oEncounterObject = OBJECT_SELF,
   int nEncounterType = ENCOUNTER_TYPE_AREA)
{
   //debugVarObject("getEncounterCR()", OBJECT_SELF);
   //debugVarObject("oEncounterObject", oEncounterObject);
   //debugVarInt("nEncounterType", nEncounterType);

   struct tMinMaxCR tReturn;

/*
   if (GetLocalInt(GetModule(), "re_bConsiderCR") == FALSE)
   {
      //debug("ignoring CR");
      tReturn.fMinCR = 0.0;
      tReturn.fMaxCR = 9999.0;
      SetLocalFloat(OBJECT_SELF, "re_fMinCR", tReturn.fMinCR);
      SetLocalFloat(OBJECT_SELF, "re_fMaxCR", tReturn.fMaxCR);
      return tReturn;
   }
*/

   float fMinCR = GetLocalFloat(OBJECT_SELF, "re_fMinCR");
   float fMaxCR = GetLocalFloat(OBJECT_SELF, "re_fMaxCR");
   if (fMaxCR > 0.0)
   {
      //debug("found fMaxCR in local variable");
      tReturn.fMinCR = fMinCR;
      tReturn.fMaxCR = fMaxCR;
      return tReturn;
   }

   int iLevels;
   object oPC;
   object oHenchman;
   int nNth = 1;
   switch (nEncounterType)
   {
      case ENCOUNTER_TYPE_AREA:
         oPC = GetFirstObjectInShape(SHAPE_SPHERE, 20.0,
            GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
         while (GetIsObjectValid(oPC))
         {
            if (GetIsPC(oPC))
            {
               iLevels = iLevels + GetHitDice(oPC);
               oHenchman =GetHenchman(oPC, nNth);
               while (GetIsObjectValid(oHenchman))
               {
                  iLevels = iLevels + GetHitDice(oHenchman);
                  nNth++;
                  oHenchman =GetHenchman(oPC, nNth);
               }
            }
            oPC = GetNextObjectInShape(SHAPE_SPHERE, 20.0,
               GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
         }
         break;
      case ENCOUNTER_TYPE_PARTY:
         iLevels = GetFactionAverageLevel(oEncounterObject);
         break;
      case ENCOUNTER_TYPE_TOTALPARTYLEVELS:
         oPC = GetFirstFactionMember(oEncounterObject);
         while (GetIsObjectValid(oPC))
         {
            if (GetArea(oPC) == GetArea(oEncounterObject))
            {
               iLevels = iLevels + GetHitDice(oPC);
            }
            oPC = GetNextFactionMember(oEncounterObject);
         }
         break;
      case ENCOUNTER_TYPE_IND:
         // If the variable iEncounterType is set to IND, this
         // routine determines the total character levels based upon the
         // character level of the object that spawned the encounter.
         // if the object that spawned the encounter is NOT a PC then
         // the number of creatures spawned will be one.  This shouldn't
         // happen since the the encounter type sets itself to AREA if
         // the encounter object is a placeable.
         if (GetIsPC(oEncounterObject))
         {
            iLevels = GetHitDice(oEncounterObject);
         }
   }

   float fDifficulty = pow(1.25, GetGameDifficulty() - 1.0);
   //debugVarFloat("fDifficulty", fDifficulty);
   //debugVarInt("iLevels", iLevels);
   float fLevels = IntToFloat(iLevels) * fDifficulty;
   //debugVarFloat("fLevels", fLevels);

   tReturn.fMaxCR = (fLevels < 0.25 ? 0.25 : fLevels);
   //debugVarFloat("tReturn.fMaxCR", tReturn.fMaxCR);
   tReturn.fMinCR = IntToFloat(FloatToInt(tReturn.fMaxCR * 0.3));
   //debugVarFloat("tReturn.fMinCR", tReturn.fMinCR);

   SetLocalFloat(OBJECT_SELF, "re_fMinCR", tReturn.fMinCR);
   SetLocalFloat(OBJECT_SELF, "re_fMaxCR", tReturn.fMaxCR);

   return tReturn;
}

void setRndEncProperties(object oObject = OBJECT_SELF, int iDifficulty = 4,
   int bConsiderCR = TRUE, string sCreatureTable = "re_ceghimpubt0",
   int iLifeTime = 180, int iMph = 2, int iEncounterType = 4,
   int bConflict = TRUE, int iChanceOnRest = 20, int bLOSCheck = FALSE)
{
   SetLocalInt(oObject, "re_bInitialized", TRUE);
   SetLocalInt(oObject, "re_iDifficulty", iDifficulty);
   SetLocalInt(oObject, "re_bConsiderCR", bConsiderCR);
   SetLocalString(oObject, "re_sCreatureTable", sCreatureTable);
   SetLocalInt(oObject, "re_iLifeTime", iLifeTime);
   SetLocalInt(oObject, "re_iMph", iMph);
   SetLocalInt(oObject, "re_iEncounterType", iEncounterType);
   SetLocalInt(oObject, "re_bConflict", bConflict);
   SetLocalInt(oObject, "re_iChanceOnRest", iChanceOnRest);
   SetLocalInt(oObject, "re_bLOSCheck", bLOSCheck);
}

struct RndEncProperties getRndEncProperties(object oObject = OBJECT_SELF)
{
   if (oObject == GetModule() && !GetLocalInt(GetModule(), "re_bInitialized"))
   {
      setRndEncProperties(GetModule());
   }
   struct RndEncProperties strProps;
   strProps.bInitialized = GetLocalInt(oObject, "re_bInitialized");
   strProps.iDifficulty = GetLocalInt(oObject, "re_iDifficulty");
   strProps.bConsiderCR = GetLocalInt(oObject, "re_bConsiderCR");
   strProps.sCreatureTable = GetLocalString(oObject, "re_sCreatureTable");
   strProps.iLifeTime = GetLocalInt(oObject, "re_iLifeTime");
   strProps.iMph = GetLocalInt(oObject, "re_iMph");
   strProps.iEncounterType = GetLocalInt(oObject, "re_iEncounterType");
   strProps.bConflict = GetLocalInt(oObject, "re_bConflict");
   strProps.iChanceOnRest = GetLocalInt(oObject, "re_iChanceOnRest");
   strProps.bLOSCheck = GetLocalInt(oObject, "re_bLOSCheck");
   return strProps;
}

object randomEncounter(float fChanceOfEncounter = 100.0,
   object oEncounterObject = OBJECT_SELF, string sTemplate = "random",
   int iMinNumberOfCreatures = 0, int iMaxNumberOfCreatures = 0,
   int iMinEncounterDistance = 1, int iMaxEncounterDistance = 15,
   int iOrientation = 360, int iTolerance = 0, int iCheckDistance = 0,
   int iLevelOverride = 0, int iDifficulty = 0)
{
   //debug("randomEncounter()");
   // IF PROPERTIES ARE NOT SET ON MODULE OBJECT THEN SET THEM WITH DEFAULTS
   if (! GetLocalInt(GetModule(), "re_bInitialized"))
   {
      setRndEncProperties(GetModule());
   }

   // DETERMINE IF ENCOUNTER HAPPENS
   // Has the player moved farther than the CheckDistance?
   float fTravelDistance;
   if (GetIsPC(oEncounterObject))
   {
      if (!GetLocalInt(oEncounterObject, "re_bOldLocationSet"))
      {
         SetLocalInt(oEncounterObject, "re_bOldLocationSet", TRUE);
         SetLocalLocation(oEncounterObject, "re_lOldLocation",
            GetLocation(oEncounterObject));
         if (iCheckDistance)
         {
            //debug("No encounter - travel distance");
            return OBJECT_INVALID;
         }
      }
      if (GetDistanceBetweenLocations(GetLocation(oEncounterObject),
          GetLocalLocation(oEncounterObject, "re_lOldLocation")) < 0.0
         )
      {
         SetLocalLocation(oEncounterObject, "re_lOldLocation",
            GetLocation(oEncounterObject));
         if (iCheckDistance)
         {
            //debug("No encounter - travel distance 2");
            return OBJECT_INVALID;
         }
      }
      fTravelDistance =
         GetDistanceBetweenLocations(GetLocation(oEncounterObject),
         GetLocalLocation(oEncounterObject, "re_lOldLocation"));
      SetLocalFloat(oEncounterObject, "re_fTravelDistance",
         GetLocalFloat(oEncounterObject, "re_fTravelDistance") +
         fTravelDistance);
      SetLocalLocation(oEncounterObject, "re_lOldLocation",
         GetLocation(oEncounterObject));
      if (GetLocalFloat(oEncounterObject, "re_fTravelDistance") >=
          IntToFloat(iCheckDistance)
         )
      {
         DeleteLocalFloat(oEncounterObject, "re_fTravelDistance");
      }
      else
      {
         //debug("No encounter - travel distance 3");
         return OBJECT_INVALID;
      }
   }
   // The following two lines allow for a chance of encounter with a
   // precision of up to two decimal places.  ie. 100.00.  An encounter
   // can have as little as a 0.01 chance of occuring.
   int iHappens = Random(10000) + 1;
   int iChanceOfEncounter = FloatToInt(fChanceOfEncounter * 100);
   if (iChanceOfEncounter < iHappens)
   {
      //debug("No encounter - random chance");
      return OBJECT_INVALID;
   }
   // Are encounters disabled for this player?
   if (GetLocalInt(GetModule(), "re_" + GetPCPlayerName(oEncounterObject)))
   {
      //debug("No encounter - disabled for this PC");
      return OBJECT_INVALID;
   }
   // Are random encounters disabled altogether?
   if (GetLocalInt(GetModule(), "re_disable"))
   {
      //debug("No encounter - disabled globally");
      return OBJECT_INVALID;
   }
   // Is the player in combat with bConflict equal to false?
   object oHolder;
   int iCounter7 = 1; // Used in checking for nearby enemies.
   if (GetLocalInt(oEncounterObject, "re_bInitialized"))
   {
      oHolder = oEncounterObject;
   }
   else if (GetLocalInt(GetArea(oEncounterObject), "re_bInitialized"))
   {
      oHolder = GetArea(oEncounterObject);
   }
   else
   {
      oHolder = GetModule();
   }
   int bConflict = GetLocalInt(oHolder, "re_bConflict");
   if (! bConflict && GetIsPC(oEncounterObject))
   {
      if (GetIsInCombat(oEncounterObject))
      {
         //debug("No encounter - in combat");
         return OBJECT_INVALID;
      }
      object oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,
         oEncounterObject, iCounter7);
      while (GetIsObjectValid(oNearest) && GetDistanceToObject(oNearest) < 35.0)
      {
         if (GetIsEnemy(oNearest) && (GetIsInCombat(oNearest) ||
            GetObjectSeen(oNearest)))
         {
            //debug("No encounter - in combat 2");
            return OBJECT_INVALID;
         }
         iCounter7++;
         oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE,
            oEncounterObject, iCounter7);
      }
   }
   // Are any nearby party members in a conversation?
   object oAmIAPC = GetFirstObjectInShape(SHAPE_SPHERE, 35.0,
      GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
   while (GetIsObjectValid(oAmIAPC))
   {
      if (GetIsPC(oAmIAPC))
      {
         if (GetFactionEqual(oEncounterObject, oAmIAPC))
         {
            if (IsInConversation(oAmIAPC))
            {
               //debug("No encounter - in dialog");
               return OBJECT_INVALID;
            }
         }
      }
      oAmIAPC = GetNextObjectInShape(SHAPE_SPHERE, 25.0, GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
   }

   // DECLARE AND INITIALIZE VARIABLES
   object oMod = GetModule();
   int iMph;
   if (! iDifficulty) iDifficulty = GetLocalInt(oHolder, "re_iDifficulty");
   int bConsiderCR = GetLocalInt(oHolder, "re_bConsiderCR");
   if (GetStringLowerCase(sTemplate) == "random")
   {
      sTemplate = GetLocalString(GetModule(), "re_sCreatureTable");
   }
   int iLifeTime = GetLocalInt(oHolder, "re_iLifeTime");
   if (! GetLocalInt(oHolder, "re_iMph"))
   {
      iMph = 2;
   }
   else
   {
      iMph = GetLocalInt(oHolder, "re_iMph");
   }
   int bLOSCheck = GetLocalInt(oHolder, "re_bLOSCheck");
   int iEncounterType = GetLocalInt(oHolder, "re_iEncounterType");
   int iCounter1 = 1; // Used to count the creatures when spawning them.
   int iCounter2 = 1; // Used in loop to set difficulty level.
   // Used in loop to check line of sight float fEncounterDistance
   // (future use!).
   int iCounter3 = 1;
   // Used in determining the PC to spawn the encounter if the encounter object
   // passed is an area or the module.
   int iCounter4;
   int iCounter5; // Used in determining treasure table.
   int iCounter6; // Used in giving treasure.
   int iNumberOfCreatures;
   int iEncounterDistance;
   int iFacingSameWay;
   int iLevels;
   int iTableNumber;
   int bNumberByLevel = FALSE;
   int bNoEncounter = FALSE;
   int bComplete1 = FALSE;
   int bComplete2 = FALSE;
   int bTreasure;
   float fMaxCR;
   float fEncounterDistance;
   float fNewEncounterDistance;
   float fCreatureFacing;
   float fEncounterAngle;
   float fEncounterVector;
   float fAngleOffset;
   float fLevels;
   float fDifficulty = 0.167;
   string sBuild;
   string sTreasure = sTemplate;
   object oArea;
   if (oEncounterObject == GetModule())
   {
      oAmIAPC = GetFirstPC();
      while (GetIsObjectValid(oAmIAPC))
      {
         if (!GetLocalInt(GetModule(), "re_" + GetPCPlayerName(oAmIAPC)))
         {
            SetLocalObject(oMod, "re_oEncounterObject" + IntToString(iCounter4), oAmIAPC);
            iCounter4++;
         }
         oAmIAPC = GetNextPC();
      }
      oEncounterObject = GetLocalObject(oMod, "re_oEncounterObject" + IntToString(Random(iCounter4)));
   }
   else if (GetObjectType(oEncounterObject) == 0 && oEncounterObject !=
      GetModule())
   {
      oArea = oEncounterObject;
      oAmIAPC = GetFirstObjectInArea(oArea);
      while (GetIsObjectValid(oAmIAPC))
      {
         if (GetIsPC(oAmIAPC) && !GetLocalInt(GetModule(), "re_" + GetPCPlayerName(oAmIAPC)))
         {
            SetLocalObject(oArea, "re_oEncounterObject" + IntToString(iCounter4), oAmIAPC);
            iCounter4++;
         }
         oAmIAPC = GetNextObjectInArea(oArea);
      }
      oEncounterObject = GetLocalObject(oArea, "re_oEncounterObject" + IntToString(Random(iCounter4)));
   }
   else
   {
      oArea = GetArea(oEncounterObject);
   }
   if (! GetIsPC(oEncounterObject)) iEncounterType = ENCOUNTER_TYPE_AREA;
   location lCreatureLocation;
   vector vEncounterObjectVector = GetPosition(oEncounterObject);
   int iMin = 60;
   int iHr = iMin * iMph;
   int iDay = iHr * 24;
   int iMth = iDay * 28;
   int iYr = iMth * 12;
   if (iDifficulty > 10)
   {
      iDifficulty = 10;
   }
   if (iDifficulty == 0)
   {
      iDifficulty = GetGameDifficulty() * 2;
   }
   while (iCounter2 <= iDifficulty)
   {
      fDifficulty = fDifficulty * 1.5;
      iCounter2++;
   }

   // ERROR CORRECTION
   if (iMaxNumberOfCreatures < iMinNumberOfCreatures)
   {
      iMaxNumberOfCreatures = iMinNumberOfCreatures;
   }
   if (iMaxEncounterDistance < iMinEncounterDistance)
   {
      iMaxEncounterDistance = iMinEncounterDistance;
   }
   if (! GetIsPC(oEncounterObject))
   {
      iEncounterType = ENCOUNTER_TYPE_AREA;
   }

   // CHECK TO SEE IF PC IS RESTING VIA THE BESIE "re_onrest" SCRIPT AND IF SO
   // REMOVE RESTING EFFECTS.
   if (GetIsPC(oEncounterObject) && GetLocalInt(oEncounterObject, "re_resting"))
   {
      DeleteLocalInt(oEncounterObject, "re_resting");
      effect eEffect = GetFirstEffect(oEncounterObject);
      while (GetIsEffectValid(eEffect))
      {
         if (GetEffectType(eEffect) == EFFECT_TYPE_BLINDNESS &&
            GetEffectCreator(eEffect) == GetModule())
         {
            RemoveEffect(oEncounterObject, eEffect);
         }
         if (GetEffectType(eEffect) == VFX_IMP_SLEEP &&
             GetEffectCreator(eEffect) == GetModule()
            )
         {
            RemoveEffect(oEncounterObject, eEffect);
         }
         eEffect = GetNextEffect(oEncounterObject);
      }
   }

   // DETERMINE THE ANGLE OFFSET OF THE SPAWN
   if (iOrientation == 360)
   {
      fEncounterAngle = IntToFloat(Random(360));
   }
   else
   {
      fEncounterAngle = GetFacingFromLocation(GetLocation(oEncounterObject)) +
         IntToFloat(iOrientation);
      fEncounterAngle = (fEncounterAngle + (IntToFloat(iTolerance) * 0.5)) -
         (IntToFloat(Random(iTolerance)));
   }

   // DETERMINE THE DISTANCE FROM THE SPAWNING OBJECT
   if (iMinEncounterDistance == 0)
   {
      iMinEncounterDistance = iMaxEncounterDistance;
      fEncounterDistance = IntToFloat(iMaxEncounterDistance);
   }
   else
   {
      fEncounterDistance = IntToFloat(iMinEncounterDistance +
         Random((iMaxEncounterDistance - iMinEncounterDistance) + 1));
   }
   iEncounterDistance = FloatToInt(fEncounterDistance);

   // DETERMINE THE FACING OF THE SPAWN
   if (GetLocalInt(oEncounterObject, "re_Facing"))
   {
      fCreatureFacing = fEncounterAngle + 180.0;
      iFacingSameWay = TRUE;
      DeleteLocalInt(oEncounterObject, "re_Facing");
   }
   else
   {
      fCreatureFacing = IntToFloat(Random(360));
      // Note: If there is more than one creature there is a 50% chance
      // they will all be facing the same direction
      iFacingSameWay = Random(2);
   }

   // DETERMINE TOTAL CHARACTER LEVELS TO CONSIDER WHEN CHOOSING A CREATURE
   // AND/OR DETERMINING THE NUMBER OF CREATURES TO SPAWN.
   // If the variable iEncounterType is AREA, this routine
   // determines the total character levels
   // based upon the character levels of all PCs
   // in a 20 meter radius around the object that spawned
   // the encounter.
   // Later on the total character levels will be compared to
   // the challenge rating of the creature spawned, and a number
   // of creatures will be determined from that comparison.
   if (iEncounterType == ENCOUNTER_TYPE_AREA)
   {
      oAmIAPC = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
      while (GetIsObjectValid(oAmIAPC))
      {
         if (GetIsPC(oAmIAPC))
         {
            iLevels = iLevels + GetLevelByPosition(1, oAmIAPC) + GetLevelByPosition(2, oAmIAPC) + GetLevelByPosition(3, oAmIAPC);
            if (GetIsObjectValid(GetHenchman(oAmIAPC)))
            {
               iLevels = iLevels + GetLevelByPosition(1, GetHenchman(oAmIAPC)) +
                  GetLevelByPosition(2, GetHenchman(oAmIAPC)) +
                  GetLevelByPosition(3, GetHenchman(oAmIAPC));
            }
         }
         oAmIAPC = GetNextObjectInShape(SHAPE_SPHERE, 20.0, GetLocation(oEncounterObject), FALSE, OBJECT_TYPE_CREATURE);
      }
   }
   else if (iEncounterType == ENCOUNTER_TYPE_PARTY)
   {
      iLevels = GetFactionAverageLevel(oEncounterObject);
   }
   else if (iEncounterType == ENCOUNTER_TYPE_TOTALPARTYLEVELS)
   {
      object oObject = GetFirstFactionMember(oEncounterObject);
      while (GetIsObjectValid(oObject))
      {
         if (GetArea(oObject) == GetArea(oEncounterObject))
         {
            iLevels = iLevels + GetLevelByPosition(1, oObject) + GetLevelByPosition(2, oObject) + GetLevelByPosition(3, oObject);
         }
         oObject = GetNextFactionMember(oEncounterObject);
      }
   }
   else
   {
      // If the variable iEncounterType is set to IND, this
      // routine determines the total character levels based upon the
      // character level of the object that spawned the encounter.
      // if the object that spawned the encounter is NOT a PC then
      // the number of creatures spawned will be one.  This shouldn't
      // happen since the the encounter type sets itself to AREA if
      // the encounter object is a placeable.
      if (GetIsPC(oEncounterObject))
      {
         iLevels = GetLevelByPosition(1, oEncounterObject) + GetLevelByPosition(2, oEncounterObject) + GetLevelByPosition(3, oEncounterObject);
      }
   }
   // Modify the float representing the total levels by the difficulty level.
   if (iLevelOverride)
   {
      iLevels = iLevelOverride;
   }
   fLevels = IntToFloat(iLevels) * fDifficulty;

   // CHOOSE A CREATURE TO SPAWN
   if (GetStringLowerCase(sTemplate) == "random" ||
       GetStringLowerCase(GetStringLeft(sTemplate, 3)) == "re_"
      )
   {
      if (GetStringLowerCase(GetStringLeft(sTemplate, 3)) == "re_")
      {
         sTemplate = GetStringRight(sTemplate, GetStringLength(sTemplate) - 3);
      }
/*
      if (fLevels < 0.25)
      {
         fMaxCR = 0.25;
      }
      else
      {
         fMaxCR = fLevels;
      }
      float fMinCR = IntToFloat(FloatToInt(fMaxCR * 0.3));
      // If there is a definative number of creatures to spawn passed to
      // the randomEncounter function when it is called, then do not
      // allow as much play in the low end, and a little more in the
      // high end challange ratings.
      if (iMinNumberOfCreatures == 0 && iMaxNumberOfCreatures > 1)
      {
         fMinCR = IntToFloat(FloatToInt(fMaxCR * 0.4));
         fMaxCR = fMaxCR * 1.2;
         fMinCR = IntToFloat(FloatToInt(fMinCR));
      }
      if (iMinNumberOfCreatures == 0 && iMaxNumberOfCreatures == 1)
      {
         fMinCR = IntToFloat(FloatToInt(fMaxCR * 0.6));
         fMaxCR = fMaxCR * 1.2;
         fMinCR = IntToFloat(FloatToInt(fMinCR));// Round off the CR.
      }
      if (GetLocalInt(oHolder, "re_bConsiderCR") == FALSE)
      {
         fMaxCR = 9999.0;
         fMinCR = 0.0;
      }
      //debugVarFloat("fMinCR", fMinCR);
      //debugVarFloat("fMaxCR", fMaxCR);
*/

      //debugVarObject("oEncounterObject", oEncounterObject);
      struct tMinMaxCR tCR = getEncounterCR(oEncounterObject, iEncounterType);
      //debugVarFloat("tCR.fMinCR", tCR.fMinCR);
      //debugVarFloat("tCR.fMaxCR", tCR.fMaxCR);

      //debugVarString("sTemplate", sTemplate);
      sTemplate = getRndEncCreature(tCR.fMinCR, tCR.fMaxCR, sTemplate);
      //debugVarString("getRndEncCreature() chose", sTemplate);
      if (sTemplate == "")
      {
         //debug("No encounter - no creature chosen");
         return OBJECT_INVALID;
      }
   }

   // DETERMINE IF CREATURE IS TO HAVE TREASURE AND WHAT TABLES TO USE
   if (GetLocalString(oMod, "re_s2DATreasure") != "")
   {
      sTreasure = GetLocalString(oMod, "re_s2DATreasure");
      DeleteLocalString(oMod, "re_s2DATreasure");
   }
   for(iCounter5 = 0; iCounter5 <= GetStringLength(sTreasure); iCounter5++)
   {
      if (bTreasure
      && (GetSubString(sTreasure, iCounter5, 1) == "0" || StringToInt(GetSubString(sTreasure, iCounter5, 1)) > 0))
      {
         sBuild = sBuild + GetSubString(sTreasure, iCounter5, 1);
      }
      else if (bTreasure)
      {
         iTableNumber++;
         SetLocalString(OBJECT_SELF, "re_sTreasureTable" + IntToString(iTableNumber), sBuild);
         bTreasure = FALSE;
         sBuild = "";
      }
      if (GetStringLowerCase(GetSubString(sTreasure, iCounter5, 1)) == "t")
      {
         bTreasure = TRUE;
      }
   }

   // DETERMINE LOCATION AND SPAWN ONE CREATURE
   // NOTE: Line Of Sight checks have a bug.  Bioware says they are looking
   // into the bug.  I have spent an ungodly amount of hours trying to come
   // up with an acceptable work-around to the Line Of Sight functionality
   // of Get**ObjectInShape().  Unless somebody else can come up with a working
   // LOS check, I have no choice but to disregard LOS checks until they are
   // fixed.
   //
   // if (LOSCheck = TRUE)
   //     {
   //     <LOS code goes here>
   //     }
   //
   // note: one creature is spawned in now so its challange rating can be
   // used to determine if more are needed. (if that option is set)
   vector vEncounterVector = AngleToVector(fEncounterAngle);
   vector vVectorOffset = vEncounterVector * fEncounterDistance;
   vector vCreatureVector = vEncounterObjectVector + vVectorOffset;
   lCreatureLocation = Location(oArea, vCreatureVector, fCreatureFacing);
   object oCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate,
      lCreatureLocation, FALSE);

   // VERIFY THE RESREF OF THE SPAWNED CREATURE AGAINST THE TEMPLATE AND RETURN
   // AN ERROR IF THEY DO NOT MATCH
   if (GetStringLowerCase(GetResRef(oCreature)) !=
       GetStringLowerCase(sTemplate)
      )
   {
      string sError = "BESIE Error: " + sTemplate +
         " does not match the blueprint of a valid creature object!";
      DestroyObject(oCreature);
      logError(sError);
      SendMessageToAllDMs(sError);
      WriteTimestampedLogEntry(sError);
      //debug("No encounter - invalid resref");
      return OBJECT_INVALID;
   }

   // DETERMINE THE NUMBER OF ADDITIONAL CREATURES TO SPAWN.
   // If the min and max number of creatures in the function call are zero
   // then get the min and max number from the local variables in the module
   // object.
   if (iMinNumberOfCreatures == 0 && iMaxNumberOfCreatures == 0)
   {
      iMinNumberOfCreatures = GetLocalInt(oMod, "re_iMinNumberOfCreatures");
      iMaxNumberOfCreatures = GetLocalInt(oMod, "re_iMaxNumberOfCreatures");
   }
   // Now that we are done with these local integers, we need to clean reset
   // them to their defaults so we don't accidentally use old numbers later.
   SetLocalInt(oMod, "re_iMinNumberOfCreatures", 0);
   SetLocalInt(oMod, "re_iMaxNumberOfCreatures", 0);
   if (iMinNumberOfCreatures == 0 && iMaxNumberOfCreatures != 0)
   {
      iNumberOfCreatures = iMaxNumberOfCreatures;
   }
   if (iMinNumberOfCreatures != 0 && iMaxNumberOfCreatures != 0)
   {
      iNumberOfCreatures = iMinNumberOfCreatures +
         Random((iMaxNumberOfCreatures - iMinNumberOfCreatures) + 1);
   }
   if (iMinNumberOfCreatures == 0 && iMaxNumberOfCreatures == 0)
   {
      // This is the routine that sets the number of creatures to spawn
      // based on their challenge rating and the total character levels.
      // It chooses a random number between one half (truncated) and 120
      // percent (1 for every 4) of the number of creatures ideal for the
      // difficulty level set.
      iMaxNumberOfCreatures = FloatToInt(fLevels /
         GetChallengeRating(oCreature));
      iMinNumberOfCreatures = FloatToInt(IntToFloat(iMaxNumberOfCreatures) *
         0.5);
      iMaxNumberOfCreatures = FloatToInt(IntToFloat(iMaxNumberOfCreatures) *
         1.25);

      // These lines were added with the v1.7 release because I noticed a
      // situation where characters of
      // up to level 4 would still spawn orcs, goblins and other < CR1 creatures
      // but they would
      // spawn a rediculous amount of them because of the low CR/LV ratio.  This
      // is just to eliminate that.
      if (iMinNumberOfCreatures > 8) iMinNumberOfCreatures = 8;
      if (iMaxNumberOfCreatures > 9) iMaxNumberOfCreatures = 9;

      iNumberOfCreatures = iMinNumberOfCreatures +
         Random((iMaxNumberOfCreatures - iMinNumberOfCreatures) + 1);
      if ((iNumberOfCreatures < 1) && (iLevels > 0))
      {
         iNumberOfCreatures = 1;
      }
   }

   // SPAWN THOSE SUCKERS!
   while (iCounter1 <= iNumberOfCreatures)
   {
      // Stick some labels on the creature for record keeping and
      // reference (future use!)
      SetLocalInt(oCreature, "re_brandomEncounter", TRUE);
      SetLocalObject(oCreature, "re_orandomEncounterSpawner", oEncounterObject);
      SetLocalInt(oCreature, "re_irandomEncounterCounter", 1);
      SetLocalInt(oCreature, "re_irandomEncounterSpawnTime",
         (GetCalendarYear() * iYr) + (GetCalendarMonth() * iMth) +
         (GetCalendarDay()* iDay) + (GetTimeHour()* iHr) + (GetTimeMinute() *
         iMin) + GetTimeSecond());
      SetLocalInt(oCreature, "re_irandomEncounterLifeTime", iLifeTime);
      /*-------------------------
      This routine was removed in v1.8 because the standard treasure tables were removed and replaced with a routine that simply awards an appropriate amount of coin.
      if (!GetLocalInt(GetModule(), "re_standardtable") ||
          (GetLocalInt(GetModule(), "re_standardtable") && iCounter1 < 4)
         )
      // The preceding if statement looks for a local variable set by the
      // standard treasure table included with BESIE.  If this variable is
      // set then it halts execution of the treasure script after the first
      // 3 creatures.  This prevents a Too Many Instructions error.
      {
         // Delete standard table int so as not to interfere with custom scripts.
         DeleteLocalInt(GetModule(), "re_standardtable");
         */
         // Give treasure to the creature if any tables are set.
         for(iCounter6 = 1; iCounter6 <= iTableNumber; iCounter6++)
         {
            ExecuteScript("re_treasure" + GetLocalString(OBJECT_SELF,
               "re_sTreasureTable" + IntToString(iCounter6)), oCreature);
         }
      //}
      if (iCounter1 < iNumberOfCreatures)
      {
         oCreature = CreateObject(OBJECT_TYPE_CREATURE, sTemplate,
            lCreatureLocation, FALSE);
      }
      iCounter1++;
      // Determine the facing of the next creature
      if (iFacingSameWay == FALSE)
      {
         fCreatureFacing = IntToFloat(Random(360));
         lCreatureLocation = Location(oArea, vCreatureVector, fCreatureFacing);
      }
   }
   // Stick a label on the spawning object for record keeping and
   // reference (future use?)
   SetLocalObject(oEncounterObject, "re_oLastrandomEncounterSpawned",
      oCreature);
   //debug("Encounter spawned using " + GetName(oCreature));
   return oCreature;
}

void cleanHouse(int bDestroyPlotItems = FALSE, object oArea = OBJECT_SELF,
   int iSpawnOverride = 0, int iItemOverride = 0, int iBodyBagOverride = 0)
{
   // GET THE TIME SCALE FOR THE MODULE
   int iMph = GetLocalInt(GetModule(), "re_iMph");
   if (! iMph) iMph = 2;

   // DECLARE AND INTIALIZE VARIABLES
   int iMin = 60;
   int iHr = iMin * iMph;
   int iDay = iHr * 24;
   int iMth = iDay * 28;
   int iYr = iMth * 12;
   int bShouldIKillHim = TRUE;
   int iLifeTime;
   int iItemLifeTime;
   int iBodyBagLifeTime;
   int iPresentTime = (GetCalendarYear() * iYr) + (GetCalendarMonth() * iMth) +
      (GetCalendarDay() * iDay) + (GetTimeHour() * iHr) + (GetTimeMinute() *
      iMin) + GetTimeSecond();
   object oObject;

   // GET EACH OBJECT IN THE AREA AND TEST FOR VALIDITY
   // The following assignment uses a peculiar property of the GetArea()
   // function in that if the GetArea() function
   // is called on an area then the area is returned.  So the oArea parameter
   // of the CleanHouse function can be set
   // to an area or an object within that area and the function will work.
   // (unless and/or until this is changed).
   object oAmIASpawn = GetFirstObjectInArea(GetArea(oArea));
   while (GetIsObjectValid(oAmIASpawn))
   {
      // IS IT A BODY BAG?
      if (GetTag(oAmIASpawn) == "BodyBag" && !GetLocalInt(oAmIASpawn, "re_bDroppedItem"))
      {
         SetLocalInt(oAmIASpawn, "re_bDroppedItem", TRUE);
         SetLocalInt(oAmIASpawn, "re_iDropTime", iPresentTime);
         object oItem = GetFirstItemInInventory(oAmIASpawn);
         while (GetIsObjectValid(oItem))
         {
            if (GetLocalInt(oItem, "bItemForGold")) DestroyObject(oItem);
            oItem = GetNextItemInInventory(oAmIASpawn);
         }
      }
      // IS IT A DROPPED ITEM?
      if (GetLocalInt(oAmIASpawn, "re_bDroppedItem"))
      {
         // HAS IT BEEN AROUND TOO LONG?
         if (iItemOverride)
         {
            iItemLifeTime = iItemOverride;
         }
         else
         {
            iItemLifeTime = 1800;
         }
         if (iBodyBagOverride)
         {
            iBodyBagLifeTime = iBodyBagOverride;
         }
         else
         {
            iBodyBagLifeTime = 300;
         }
         if ((iPresentTime - GetLocalInt(oAmIASpawn, "re_iDropTime") >
            iItemLifeTime && GetTag(oAmIASpawn) != "BodyBag") ||
            (iPresentTime - GetLocalInt(oAmIASpawn, "re_iDropTime") >
            iBodyBagLifeTime && GetTag(oAmIASpawn) == "BodyBag"))
            // && !GetPlotFlag(oAmIASpawn))
         {
            if (GetHasInventory(oAmIASpawn))
            {
               oObject = GetFirstItemInInventory(oAmIASpawn);
               while (GetIsObjectValid(oObject))
               {
                  if (!GetPlotFlag(oObject) || bDestroyPlotItems)
                  {
                     DestroyObject(oObject, 0.0);
                  }
                  oObject = GetNextItemInInventory(oAmIASpawn);
               }
            }
            if (!GetPlotFlag(oAmIASpawn) || bDestroyPlotItems)
            {
               DestroyObject(oAmIASpawn, 0.0);
            }
         }
      }
      // IS HE IS A RANDOM ENCOUNTER?
      if (GetLocalInt(oAmIASpawn, "re_brandomEncounter"))
      {
         // HAS HE BEEN AROUND TOO LONG?
         if (iSpawnOverride)
         {
            iLifeTime = iSpawnOverride;
         }
         else
         {
            iLifeTime = GetLocalInt(oAmIASpawn, "re_irandomEncounterLifeTime");
         }
         if (iPresentTime - GetLocalInt(oAmIASpawn, "re_irandomEncounterSpawnTime") >
            iLifeTime)
         {
            // IS HE IN COMBAT?
            if (!GetIsInCombat(oAmIASpawn))
            {
               // GET EACH PC AND TEST IF THE CREATURE SEES HIM
               // Note: this is because the creature might be charmed
               // or influenced not to attack the PCs by other means.
               object oPC = GetFirstPC();
               if (GetIsObjectValid(oPC))
               {
                  while (GetIsObjectValid(oPC))
                  {
                     if (GetObjectSeen(oPC, oAmIASpawn))
                     {
                        bShouldIKillHim = FALSE;
                     }
                     oPC = GetNextPC();
                  }
               }
               // IF THE CREATURE HAS PASSED ALL OF THESE CHECKS, DESTROY HIM.
               if (bShouldIKillHim)
               {
                  // This is prevent despawning of creatures while possessed
                  // by a DM.
                  if (! GetIsPC(oAmIASpawn))
                  {
                     DestroyObject(oAmIASpawn, 0.0);
                  }
               }
            }
         }
      }
      oAmIASpawn = GetNextObjectInArea(oArea);
   }
}

// GET TIME IN SECONDS FUNCTION
int getTimeInSeconds(int iMph = 2)
{
   if (!iMph) iMph = GetLocalInt(GetModule(), "re_iMph");
   int iMin = 60;
   int iHr = iMin * iMph;
   int iDay = iHr * 24;
   int iMth = iDay * 28;
   int iYr = iMth * 12;
   int iPresentTime = (GetCalendarYear() * iYr) + (GetCalendarMonth() * iMth) +
      (GetCalendarDay() * iDay) + (GetTimeHour() * iHr) + (GetTimeMinute() *
      iMin) + GetTimeSecond();
   return iPresentTime;
}

location randomWalk2(location lCenter, int iDistance = 20,
   object oCreature = OBJECT_SELF)
{
   //debugVarObject("randomWalk2", oCreature);
   object oArea = GetAreaFromLocation(lCenter);
   float fAngle = IntToFloat(Random(360));
   float fDistance = IntToFloat(Random(iDistance) + 1);
   vector vVector = AngleToVector(fAngle);
   vector vVectorOffset = vVector * fDistance;
   vector vFinalVector = GetPositionFromLocation(lCenter) + vVectorOffset;
   location lLocation = Location(oArea, vFinalVector, fAngle);
   object oWaypoint = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_invisobj",
      lLocation);
   lLocation = GetLocation(oWaypoint);
   AssignCommand(oCreature, ActionDoCommand(ActionMoveToLocation(lLocation)));
   DestroyObject(oWaypoint);
   //debugVarLoc("lLocation", lLocation);
   return lLocation;
}

object spawnSingleUndead(object oPC)
{
   //debugVarObject("spawnSingleUndead()", oPC);
   object oCreature;
   struct tMinMaxCR tCR = getEncounterCR(oPC, ENCOUNTER_TYPE_TOTALPARTYLEVELS);
   if (testODBC())
   {
      string sResRef = "nw_skeleton"; // failsafe value
      SQLExecDirect(
         "SELECT resref " +
          " FROM nwn_creatures " +
         " WHERE race_id = 24 " +
           " AND cr BETWEEN " + FloatToString(tCR.fMinCR) + " AND " +
              FloatToString(tCR.fMaxCR) + " " +
           " AND " +
             " ( module_name IS NULL " +
            " OR module_name = 'Bioware' " +
            " OR module_name = 'CEP' " +
            " OR module_name = '" + GetModuleName() + "' " +
             " ) " +
           " AND faction_id IN (1) " +
         " ORDER BY rand() LIMIT 1");
      if (SQLFetch() == SQL_SUCCESS) sResRef = SQLGetData(1);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
         GetLocation(OBJECT_SELF));
   }
   else
   {
      int nFreq = 1;
      SetLocalFloat(OBJECT_SELF, "re_fMinCR", tCR.fMinCR);
      //debugVarFloat("tCR.fMinCR", tCR.fMinCR);
      SetLocalFloat(OBJECT_SELF, "re_fMaxCR", tCR.fMaxCR);
      //debugVarFloat("tCR.fMaxCR", tCR.fMaxCR);
      MOB("nw_lich001", 28.000, nFreq); // Lich
      MOB("nw_lich003", 17.000, nFreq); // Lich
      MOB("nw_lichboss", 21.000, nFreq); // Lich
      MOB("nw_vampire", 6.000, nFreq); // Vampire
      MOB("nw_vampire003", 16.000, nFreq); // Vampire Mage
      MOB("nw_vampire004", 13.000, nFreq); // Vampire Priest
      MOB("nw_vampire002", 13.000, nFreq); // Vampire Rogue
      MOB("nw_vampire001", 12.000, nFreq); // Vampire Warrior
      MOB("zep_batbattle", 4.000, nFreq); // Battle Bat
      MOB("zep_batbone", 4.000, nFreq); // Bone Bat
      MOB("zep_ghostpirate", 5.000, nFreq); // Ghost Pirate
      MOB("zep_ghostf_001", 7.000, nFreq); // Ghost, Female - Blue
      MOB("zep_ghostf_002", 7.000, nFreq); // Ghost, Female - Green
      MOB("zep_ghostf_003", 7.000, nFreq); // Ghost, Female - Red
      MOB("zep_ghostf_007", 7.000, nFreq); // Ghost, Female Black-Green
      MOB("zep_ghostf_008", 7.000, nFreq); // Ghost, Female Black-Blue
      MOB("zep_ghostf_009", 7.000, nFreq); // Ghost, Female Black-Red
      MOB("zep_ghostf_004", 7.000, nFreq); // Ghost, Female Gray-Blue
      MOB("zep_ghostf_005", 7.000, nFreq); // Ghost, Female Gray-Blue
      MOB("zep_ghostf_006", 7.000, nFreq); // Ghost, Female Gray-Blue
      MOB("zep_ghostf_010", 7.000, nFreq); // Ghost, Male - Blue
      MOB("zep_ghostf_011", 7.000, nFreq); // Ghost, Male - Green
      MOB("zep_ghostf_012", 7.000, nFreq); // Ghost, Male - Red
      MOB("zep_ghostf_016", 7.000, nFreq); // Ghost, Male Black-Green
      MOB("zep_ghostf_017", 7.000, nFreq); // Ghost, Male Black-Blue
      MOB("zep_ghostf_018", 7.000, nFreq); // Ghost, Male Black-Red
      MOB("zep_ghostf_013", 7.000, nFreq); // Ghost, Male Gray-Blue
      MOB("zep_ghostf_014", 7.000, nFreq); // Ghost, Male Gray-Blue
      MOB("zep_ghostf_015", 7.000, nFreq); // Ghost, Male Gray-Blue
      MOB("zep_flvampf_001", 14.000, nFreq); // Vampire Rogue, Flying
      MOB("zep_flvampm_001", 13.000, nFreq); // Vampire Warrior, Flying
      MOB("nw_shadow", 3.000, nFreq); // Shadow
      MOB("nw_shfiend", 7.000, nFreq); // Shadow Fiend
      MOB("zep_shade001", 4.000, nFreq); // Hooded Shade
      MOB("zep_shade", 2.000, nFreq); // Shade
      MOB("nw_skeleton", 0.500, nFreq); // Skeleton
      MOB("nw_skelchief", 7.000, nFreq); // Skeleton Chieftain
      MOB("nw_skelmage", 4.000, nFreq); // Skeleton Mage
      MOB("nw_skelpriest", 4.000, nFreq); // Skeleton Priest
      MOB("nw_skelwarr01", 6.000, nFreq); // Skeleton Warrior w/Sword
      MOB("nw_skelwarr02", 6.000, nFreq); // Skeleton Warrior w/Axe
      MOB("zep_skelredeyes", 5.000, nFreq); // Bone Medusa
      MOB("zep_skelflaming", 3.000, nFreq); // Flaming Dead
      MOB("zep_skelpurple", 3.000, nFreq); // Lifestealer
      MOB("zep_skelgreen", 3.000, nFreq); // Poisonous Dead
      MOB("zep_skelyellow", 3.000, nFreq); // Restless Dead
      MOB("zep_skeldoll2", 0.500, nFreq); // Skeletal Doll w/Crossbow
      MOB("zep_skeldolls", 0.500, nFreq); // Skeletal Doll w/Spear
      MOB("zep_skeldwarf", 1.000, nFreq); // Skeletal Dwarf w/Axe
      MOB("zep_skeldwarf2", 1.000, nFreq); // Skeletal Dwarf w/Crossbow
      MOB("zep_skelogre", 3.000, nFreq); // Skeletal Ogre
      MOB("zep_skelpir1", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skelpir2", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skelpir3", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skelpir4", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skelpir5", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skelpir6", 4.000, nFreq); // Skeleton Pirate
      MOB("zep_skeldyn_001", 6.000, nFreq); // Skeleton, Dynamic
      MOB("nw_allip", 3.000, nFreq); // Allip
      MOB("nw_spectre", 6.000, nFreq); // Spectre
      MOB("nw_wraith", 5.000, nFreq); // Wraith
      MOB("zep_visagegr", 7.000, nFreq); // Greater Visage
      MOB("zep_wraith1", 8.000, nFreq); // Hooded Wraith
      MOB("zep_wraith2", 8.000, nFreq); // Hooded Wraith
      MOB("zep_visage", 5.000, nFreq); // Visage
      //debugVarInt("re_iVarNum", GetLocalInt(OBJECT_SELF, "re_iVarNum"));
      //debug("finished setting MOBs");
      object oCreature = randomEncounter(100.0f, OBJECT_SELF, "re_", 1, 1, 1, 1);
   }
   //debugVarObject("oCreature", oCreature);

   effect eMind = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMind, GetLocation(OBJECT_SELF));

   return oCreature;
}

object spawnSinglePlanar(object oPC)
{
   //debugVarObject("spawnSinglePlanar()", oPC);
   int nFreq = 1;
   struct tMinMaxCR tCR = getEncounterCR(oPC, ENCOUNTER_TYPE_TOTALPARTYLEVELS);
   object oCreature;
   if (testODBC())
   {
      string sResRef = "nw_hellhound"; // failsafe value
      SQLExecDirect(
         "SELECT resref " +
          " FROM nwn_creatures " +
         " WHERE race_id = 20 " +
           " AND cr BETWEEN " + FloatToString(tCR.fMinCR) + " AND " +
              FloatToString(tCR.fMaxCR) + " " +
           " AND " +
             " ( module_name IS NULL " +
            " OR module_name = 'Bioware' " +
            " OR module_name = 'CEP' " +
            " OR module_name = '" + GetModuleName() + "' " +
             " ) " +
           " AND faction_id IN (1) " +
         " ORDER BY rand() LIMIT 1");
      if (SQLFetch() == SQL_SUCCESS) sResRef = SQLGetData(1);
      oCreature = CreateObject(OBJECT_TYPE_CREATURE, sResRef,
         GetLocation(OBJECT_SELF));
   }
   else
   {
      SetLocalFloat(OBJECT_SELF, "re_fMinCR", tCR.fMinCR);
      //debugVarFloat("tCR.fMinCR", tCR.fMinCR);
      SetLocalFloat(OBJECT_SELF, "re_fMaxCR", tCR.fMaxCR);
      //debugVarFloat("tCR.fMaxCR", tCR.fMaxCR);
      MOB("nw_demon", 15.000, nFreq); // Balor [Tanarri]
      MOB("nw_balorboss", 16.000, nFreq); // Balor Lord [Tanarri]
      MOB("x2_spiderdemo001", 12.000, nFreq); // Bebelith [Tanarri]
      MOB("x2_erinyes", 8.000, nFreq); // Erinyes [Baatezu]
      MOB("nw_halffnd001", 8.000, nFreq); // Half-Fiend Warrior [Tanarri]
      MOB("nw_hellhound", 4.000, nFreq); // Hell Hound [Baatezu]
      MOB("nw_beastxvim", 5.000, nFreq); // Hound Of Xvim [Baatezu]
      MOB("nw_devil001", 15.000, nFreq); // Pit Fiend [Baatezu]
      MOB("x2_pitfiend001", 15.000, nFreq); // Pit Fiend [Baatezu]
      MOB("nw_rakshasa", 7.000, nFreq); // Rakshasa [Baatezu]
      MOB("nw_shmastif", 4.000, nFreq); // Shadow Mastiff
      MOB("nw_dmsucubus", 7.000, nFreq); // Succubus [Tanarri]
      MOB("nw_dmvrock", 10.000, nFreq); // Vrock [Tanarri]
      MOB("zep_abishaib_001", 8.000, nFreq); // Abishai, Black [Baatezu]
      MOB("zep_abishaib_003", 8.000, nFreq); // Abishai, Black [Baatezu]
      MOB("zep_abishaib_002", 12.000, nFreq); // Abishai, Blue [Baatezu]
      MOB("zep_abishaib_004", 12.000, nFreq); // Abishai, Blue [Baatezu]
      MOB("zep_abishaig_001", 10.000, nFreq); // Abishai, Green [Baatezu]
      MOB("zep_abishaig_002", 10.000, nFreq); // Abishai, Green [Baatezu]
      MOB("zep_abishair_001", 14.000, nFreq); // Abishai, Red [Baatezu]
      MOB("zep_abishair_002", 14.000, nFreq); // Abishai, Red [Baatezu]
      MOB("zep_abishaiw_001", 6.000, nFreq); // Abishai, White [Baatezu]
      MOB("zep_abishaiw_002", 6.000, nFreq); // Abishai, White [Baatezu]
      MOB("zep_balor_001", 15.000, nFreq); // Balor, Black [Tanarri]
      MOB("zep_balor_004", 15.000, nFreq); // Balor, Black [Tanarri]
      MOB("zep_balor_005", 15.000, nFreq); // Balor, Blue [Tanarri]
      MOB("zep_balor_006", 15.000, nFreq); // Balor, Green [Tanarri]
      MOB("zep_balor_002", 15.000, nFreq); // Balor, Ice [Tanarri]
      MOB("zep_balor_003", 15.000, nFreq); // Balor, Lightning [Tanarri]
      MOB("zep_balor_007", 15.000, nFreq); // Balor, Purple [Tanarri]
      MOB("zep_balor_008", 15.000, nFreq); // Balor, Silver [Tanarri]
      MOB("zep_balor_009", 15.000, nFreq); // Balor, Teal [Tanarri]
      MOB("zep_balor_010", 15.000, nFreq); // Balor, White [Tanarri]
      MOB("zep_balor_011", 15.000, nFreq); // Balor, Yellow [Tanarri]
      MOB("zep_balrog", 16.000, nFreq); // Balrog [Baatezu]
      MOB("zep_rakshasab", 7.000, nFreq); // Bear Rakshasa [Baatezu]
      MOB("zep_bebilithb", 13.000, nFreq); // Bebilith [Tanarri]
      MOB("zep_bebilithc", 11.000, nFreq); // Bebilith [Tanarri]
      MOB("zep_cornugon", 11.000, nFreq); // Cornugon Gold [Baatezu]
      MOB("zep_cornugona", 11.000, nFreq); // Cornugon Dun [Baatezu]
      MOB("zep_marilith", 12.000, nFreq); // Demonic Marilith [Tanarri]
      MOB("zep_erinyes", 9.000, nFreq); // Erinyes [Baatezu]
      MOB("zep_erinyes2", 10.000, nFreq); // Magma Erinyes [Baatezu]
      MOB("zep_flerinyes1", 11.000, nFreq); // Erinyes, Flying [Baatezu]
      MOB("zep_halffiendf", 2.000, nFreq); // Female Half-Fiend
      MOB("zep_gelugon", 13.000, nFreq); // Gelugon [Baatezu]
      MOB("zep_glabrezu", 14.000, nFreq); // Glabrezu [Tanarri]
      MOB("zep_cornugongr", 14.000, nFreq); // Greater Cornugon [Baatezu]
      MOB("zep_hamatula_35e", 12.000, nFreq); // Greater Hamatula [Baatezu]
      MOB("zep_hamatula", 9.000, nFreq); // Hamatula [Baatezu]
      MOB("zep_spidfiend1", 10.000, nFreq); // Kakkuu [Tanarri]
      MOB("zep_spidfiend2", 10.000, nFreq); // Lycosidilth [Tanarri]
      MOB("zep_maelephant", 10.000, nFreq); // Maelephant
      MOB("zep_halffiend", 2.000, nFreq); // Male Half-Fiend
      MOB("zep_mane", 0.500, nFreq); // Mane [Tanarri]
      MOB("zep_mane2", 0.500, nFreq); // Mane [Tanarri]
      MOB("zep_mane3", 0.500, nFreq); // Mane [Tanarri]
      MOB("zep_merilith2", 12.000, nFreq); // Marilith [Tanarri]
      MOB("zep_marilithbg", 28.000, nFreq); // Marilith Blackguard [Tanarri]
      MOB("zep_mezzoloth", 10.000, nFreq); // Mezzoloth [Yugoloth]
      MOB("zep_nabassu", 19.000, nFreq); // Nabassu [Tanarri]
      MOB("zep_nighthag", 8.000, nFreq); // Night Hag [Yugoloth]
      MOB("zep_osyluth1", 9.000, nFreq); // Osyluth Green [Baatezu]
      MOB("zep_osyluth2", 9.000, nFreq); // Osyluth Blue [Baatezu]
      MOB("zep_osyluth3", 9.000, nFreq); // Osyluth White [Baatezu]
      MOB("zep_spidfiend3", 10.000, nFreq); // Phisarazu [Tanarri]
      MOB("zep_pitfiend", 16.000, nFreq); // Pit Fiend [Baatezu]
      MOB("zep_spidfiend4", 10.000, nFreq); // Raklupis [Tanarri]
      MOB("zep_spidfiend5", 10.000, nFreq); // Spithriku [Tanarri]
      MOB("zep_succubus", 7.000, nFreq); // Succubus Nude [Tanarri]
      MOB("zep_sucubusa", 7.000, nFreq); // Succubus Clothed [Tanarri]
      MOB("zep_flsucc_001", 7.000, nFreq); // Succubus, Flying (matches nw_dmsucubus) [Tanarri]
      MOB("zep_ultroloth", 16.000, nFreq); // Ultroloth [Yugoloth]
      MOB("zep_demonvorlan", 12.000, nFreq); // Vorlan Demon
      MOB("zep_vrock", 10.000, nFreq); // Vrock [Tanarri]
      MOB("zep_rakshasaw", 7.000, nFreq); // Wolf Rakshasa [Baatezu]
      MOB("zep_yagnoloth", 12.000, nFreq); // Yagnoloth [Yugoloth]
      //debugVarInt("re_iVarNum", GetLocalInt(OBJECT_SELF, "re_iVarNum"));
      //debug("finished setting MOBs");
      oCreature = randomEncounter(100.0f, OBJECT_SELF, "re_", 1, 1, 1, 1);
   }
   //debugVarObject("oCreature", oCreature);

   effect eMind = EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_3);
   ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eMind, GetLocation(OBJECT_SELF));

   return oCreature;
}

string getRndEncCreature(float fMinCR = 0.0, float fMaxCR = 9999.0,
   string sCreatureTable = "")
{
   //debugVarObject("getRndEncCreature()", OBJECT_SELF);
   // DECLARE AND INTIALIZE VARIABLES
   object oModule = GetModule();
   string sBuild = "";
   string sSQLWhere = "";
   int bCustom;
   int bCommoner;
   int nLoop;
   int iVarNum = GetLocalInt(OBJECT_SELF, "re_iVarNum");
   //debugVarInt("iVarNum", iVarNum);
   // @DUG if (fMinCR > 18.0) fMinCR = 18.0;
   sCreatureTable = GetStringLowerCase(sCreatureTable);
   //debugVarString("sCreatureTable", sCreatureTable);
   if (GetStringLeft(sCreatureTable, 8) == "commoner")
   {
      //debug("Using commoners");
      sCreatureTable = "z" + GetStringRight(sCreatureTable,
         GetStringLength(sCreatureTable) - 8);
      //debugVarString("sCreatureTable", sCreatureTable);
   }

   // The following code was added with v1.8.  It checks to see if the template
   // contains the string '2da'.
   // If so it checks to ensure the tag name matches the file name of a 2DA
   // file by looking for the 'TableLength' parameter on Row 0.  If it is
   // present, a check is made to ensure that the parameter is correct.  If so,
   // the standard or 'old style' table will be ignored and this routine will
   // draw an encounter from the 2da file.
   if (GetStringLeft(sCreatureTable, 3) == "2da")
   {
      //debug("BESIE using 2DA");
      string s2DAMatch = "re_" + GetStringRight(GetStringLowerCase(sCreatureTable),
         GetStringLength(sCreatureTable) - 4);
      int iTableLength = StringToInt(Get2DAString(s2DAMatch, "TableLength", 0));
      if (iTableLength && Get2DAString(s2DAMatch, "ResRef", iTableLength) != "" &&
          Get2DAString(s2DAMatch, "ResRef", iTableLength + 1) == ""
         )
      {
         int iRnd = Random(iTableLength) + 1;
         string sTreasure = Get2DAString(s2DAMatch, "Treasure", iRnd);
         int iMinimum = StringToInt(Get2DAString(s2DAMatch, "Minimum", iRnd));
         int iMaximum = StringToInt(Get2DAString(s2DAMatch, "Maximum", iRnd));
         if (! iMinimum && ! iMaximum) iMaximum = 1;
         SetLocalInt(oModule, "re_iMinNumberOfCreatures", iMinimum);
         SetLocalInt(oModule, "re_iMaxNumberOfCreatures", iMaximum);
         string sCreature = Get2DAString(s2DAMatch, "ResRef", iRnd);
         if (sTreasure != "")
         {
            SetLocalString(GetModule(), "re_s2DATreasure", sTreasure);
         }
         return sCreature;
      }
      else
      {
         string sError = "BESIE error: 2DA Table " + s2DAMatch +
            " is not present or is invalid!";
         SendMessageToAllDMs(sError);
         logError(sError);
         return "";
      }
   }

   string sRaceList = "-1";
   int nFreq = 1;
   for (nLoop = 0; nLoop <= GetStringLength(sCreatureTable); nLoop++)
   {
      string sCode = GetSubString(sCreatureTable, nLoop, 1);
      //debugVarString("BESIE code", sCode);
      if (sCode == "n")
      {
         // PICK RANDOM ABERRATION
         if (testODBC()) sRaceList += ",7";
         else
         {
            MOB("nw_battdevour", 11.000, nFreq); // Battle Devourer
            MOB("x2_beholder001", 13.000, nFreq); // Beholder [Beholder]
            MOB("x2_beholder003", 15.000, nFreq); // Beholder Mage [Beholder]
            MOB("x2_drider001", 6.000, nFreq); // Drider [Drow]
            MOB("x2_drider002", 10.000, nFreq); // Drider Chief [Drow]
            MOB("x2_drider003", 17.000, nFreq); // Drider Chief [Drow]
            MOB("x2_drider004", 23.000, nFreq); // Drider Chief [Drow]
            MOB("x2_drider005", 28.000, nFreq); // Drider Chief [Drow]
            MOB("x2_fdrider002", 7.000, nFreq); // Drider Cleric [Drow]
            MOB("x2_driderw01", 8.000, nFreq); // Drider Wizard [Drow]
            MOB("nw_ettercap", 5.000, nFreq); // Ettercap
            MOB("x2_beholder002", 3.000, nFreq); // Eyeball [Beholder]
            MOB("x2_fdrider001", 6.000, nFreq); // Female Drider [Drow]
            MOB("nw_horror", 5.000, nFreq); // Hook Horror
            MOB("nw_devour", 7.000, nFreq); // Intellect Devourer
            MOB("x2_mindflayer001", 9.000, nFreq); // Mindflayer [Illithid]
            MOB("x2_mindfdarkener", 16.000, nFreq); // Mindflayer Darkener [Illithid]
            MOB("x2_mindfveneratr", 20.000, nFreq); // Mindflayer Venerator [Illithid]
            MOB("x2_mindflayer002", 19.000, nFreq); // Ulitharid [Illithid]
            MOB("nw_umberhulk", 9.000, nFreq); // Umber Hulk
            MOB("nw_willowisp", 8.000, nFreq); // Will O'wisp
            MOB("zep_aboleth", 8.000, nFreq); // Aboleth
            MOB("zep_beholder", 12.000, nFreq); // Beholder [Beholder]
            MOB("zep_beholder_dt", 12.000, nFreq); // Beholder, Death Tyrant [Beholder]
            MOB("zep_dridarmor_a", 10.000, nFreq); // Drider Fighter w/Sword [Drow]
            MOB("zep_dridarmor_b", 10.000, nFreq); // Drider Fighter w/Axe [Drow]
            MOB("zep_dridfem_a", 11.000, nFreq); // Female Drider [Drow]
            MOB("zep_dridfem_b", 11.000, nFreq); // Female Drider [Drow]
            MOB("zep_dridfem_c", 14.000, nFreq); // Female Drider [Drow]
            MOB("zep_dridfem_d", 14.000, nFreq); // Female Drider [Drow]
            MOB("zep_dridarmor_c", 10.000, nFreq); // Female Drider Fighter [Drow]
            MOB("zep_flyeye", 5.000, nFreq); // Flying Eye [Beholder]
            MOB("zep_driderm1", 7.000, nFreq); // Male Drider [Drow]
            MOB("zep_dridmale_b", 7.000, nFreq); // Male Drider [Drow]
            MOB("zep_dridmale_c", 6.000, nFreq); // Male Drider [Drow]
            MOB("zep_dridmale_d", 6.000, nFreq); // Male Drider [Drow]
            MOB("zep_dridmale_e", 6.000, nFreq); // Male Drider [Drow]
            MOB("zep_meenlock1", 5.000, nFreq); // Meenlock
            MOB("zep_meenlock2", 5.000, nFreq); // Meenlock
            MOB("zep_meenlock3", 5.000, nFreq); // Meenlock
            MOB("zep_meenlock4", 5.000, nFreq); // Meenlock
            MOB("zep_illithid6", 9.000, nFreq); // Mindflayer, Small [Illithid]
            MOB("zep_illithid", 9.000, nFreq); // Mindflayer [Illithid]
            MOB("zep_illithid1", 9.000, nFreq); // Mindflayer [Illithid]
            MOB("zep_illithid2", 9.000, nFreq); // Mindflayer Biologist [Illithid]
            MOB("zep_illithid3", 9.000, nFreq); // Mindflayer Biologist [Illithid]
            MOB("zep_illithid5", 9.000, nFreq); // Mindflayer Scientist [Illithid]
            MOB("zep_illithid4", 9.000, nFreq); // Murray [Illithid]
            MOB("zep_rustmonster", 5.000, nFreq); // Rust Monster
            MOB("zep_illithidkid", 7.000, nFreq); // Young Mindflayer [Illithid]
         }
      }
      else if (sCode == "a")
      {
         // PICK RANDOM ANIMAL
         if (testODBC()) sRaceList += ",8";
         else
         {
            MOB("nw_beardireboss", 15.000, nFreq); // Ancient Dire Bear [Predator]
            MOB("nw_bearblck", 2.000, nFreq); // Black Bear [Predator]
            MOB("nw_bearbrwn", 5.000, nFreq); // Brown Bear [Predator]
            MOB("nw_beardire", 9.000, nFreq); // Dire Bear [Predator]
            MOB("nw_bearkodiak", 6.000, nFreq); // Grizzly Bear [Predator]
            MOB("nw_bearpolar", 6.000, nFreq); // Polar Bear [Predator]
            MOB("zep_legendan_002", 15.000, nFreq); // Legendary Bear [Predator]
            MOB("zep_bearsloth", 2.000, nFreq); // Sloth Bear [Predator]
            MOB("zep_bearspec", 2.000, nFreq); // Spectacled Bear [Predator]
            MOB("zep_bearsun", 2.000, nFreq); // Sun Bear [Predator]
            MOB("zep_legendan_004", 9.000, nFreq); // Legendary Eagle
            MOB("nw_direwolf", 5.000, nFreq, 5, 20); // Dire Wolf [Predator]
            MOB("nw_wolfdireboss", 11.000, nFreq, 1, 1); // Pack Leader [Predator]
            MOB("nw_wolfwint", 5.000, nFreq, 5, 20); // Winter Wolf [Predator]
            MOB("nw_wolf", 1.000, nFreq, 5, 20); // Wolf [Predator]
            MOB("nw_worg", 3.000, nFreq, 5, 20); // Worg [Predator]
            MOB("zep_legendan_001", 10.000, nFreq); // Legendary Wolf [Predator]
            MOB("zep_worg", 3.000, nFreq); // Worg
            MOB("nw_cougar", 2.000, nFreq, 1, 2); // Cougar [Predator]
            MOB("nw_cragcat", 2.000, nFreq, 1, 2); // Crag Cat [Predator]
            MOB("nw_diretiger", 11.000, nFreq, 1, 2); // Dire Tiger [Predator]
            MOB("nw_jaguar", 3.000, nFreq, 1, 2); // Jaguar [Predator]
            MOB("nw_cat", 2.000, nFreq, 1, 2); // Leopard [Predator]
            MOB("nw_lion", 3.000, nFreq, 5, 20); // Lioness [Predator]
            MOB("nw_beastmalar001", 7.000, nFreq); // Malar Panther [Predator]
            MOB("nw_panther", 2.000, nFreq, 1, 2); // Panther [Predator]
            MOB("zep_catcloudleop", 2.000, nFreq, 1, 2); // Clouded Leopard [Predator]
            MOB("zep_cougar", 0.250, nFreq, 1, 2); // Cougar [Predator]
            MOB("zep_catleopard", 2.000, nFreq, 1, 2); // Snow Leopard [Predator]
            MOB("zep_cattiger", 4.000, nFreq, 1, 2); // Tiger [Predator]
            MOB("zep_tigerwhite", 4.000, nFreq, 1, 2); // White Tiger [Predator]
            MOB("nw_badger", 0.500, nFreq); // Badger [Predator]
            MOB("nw_boar", 2.000, nFreq); // Boar
            MOB("nw_bulette", 7.000, nFreq); // Bulette [Predator]
            MOB("nw_direbadg", 3.000, nFreq); // Dire Badger [Predator]
            MOB("nw_boardire", 5.000, nFreq); // Dire Boar [Predator]
            MOB("nw_ratdire001", 0.500, nFreq); // Dire Rat [Predator]
            MOB("nw_sharkgoblin", 2.000, nFreq); // Goblin Shark [Predator]
            MOB("nw_sharkhammer", 3.000, nFreq); // Hammerhead Shark [Predator]
            MOB("nw_sharkmako", 3.000, nFreq); // Mako Shark [Predator]
            MOB("nw_rat001", 0.125, nFreq, 1, 20); // Rat
            MOB("zep_ape", 3.000, nFreq); // Ape, Carnivorous [Predator]
            MOB("zep_hyenaspot", 1.000, nFreq, 5, 20); // Spotted Hyena [Predator]
            MOB("zep_hyenastripe", 1.000, nFreq, 5, 20); // Striped Hyena [Predator]
            MOB("zep_hugedesertvi", 4.000, nFreq); // Huge Desert Viper [Predator]
            MOB("zep_hugeforestvi", 4.000, nFreq); // Huge Forest Viper [Predator]
            MOB("zep_hugejunglevi", 4.000, nFreq); // Huge Jungle Viper [Predator]
            MOB("zep_hugeswampvi", 4.000, nFreq); // Huge Swamp Viper [Predator]
            MOB("zep_meddesertvi", 2.000, nFreq); // Medium Desert Viper [Predator]
            MOB("zep_medforestvi", 2.000, nFreq); // Medium Forest Viper [Predator]
            MOB("zep_medjunglevi", 2.000, nFreq); // Medium Jungle Viper [Predator]
            MOB("zep_medswampvi", 2.000, nFreq); // Medium Swamp Viper [Predator]
            MOB("zep_tinydesertvi", 0.500, nFreq); // Tiny Desert Viper [Predator]
            MOB("zep_tinyforestvi", 0.500, nFreq); // Tiny Forest Viper [Predator]
            MOB("zep_tinyjunglevi", 0.500, nFreq); // Tiny Jungle Viper [Predator]
            MOB("zep_tinyswampvi", 0.500, nFreq); // Tiny Swamp Viper [Predator]
            MOB("zep_legendan_003", 11.000, nFreq); // Legendary Boar
         }
      }
      else if (sCode == "c")
      {
         // PICK RANDOM CONSTRUCT
         if (testODBC()) sRaceList += ",10";
         else
         {
            MOB("x2_golem002", 32.000, nFreq); // Adamantium Golem
            MOB("nw_bathorror", 13.000, nFreq); // Battle Horror
            MOB("nw_golbone", 11.000, nFreq); // Bone Golem
            MOB("nw_golclay", 10.000, nFreq); // Clay Golem
            MOB("nw_goldmflesh001", 25.000, nFreq); // Demonflesh Golem
            MOB("nw_golflesh", 8.000, nFreq); // Flesh Golem
            MOB("nw_helmhorr", 11.000, nFreq); // Helmed Horror
            MOB("x2_goliron_huge", 21.000, nFreq); // Huge Iron Golem
            MOB("nw_goliron", 16.000, nFreq); // Iron Golem
            MOB("nw_minogon", 8.000, nFreq); // Minogon
            MOB("x2_golem001", 35.000, nFreq); // Mithral Golem
            MOB("nw_shguard", 13.000, nFreq); // Shield Guardian
            MOB("nw_golstone", 12.000, nFreq); // Stone Golem
            MOB("zep_golemame", 7.000, nFreq); // Amethyst Golem
            MOB("zep_animchest", 3.000, nFreq); // Animated Chest
            MOB("zep_animchestf", 3.000, nFreq); // Animated Flying Chest
            MOB("zep_animtable", 4.000, nFreq); // Animated Table
            MOB("zep_animtome1", 0.500, nFreq); // Animated Tome
            MOB("zep_animtome2", 0.500, nFreq); // Animated Tome
            MOB("zep_animtome3", 0.500, nFreq); // Animated Tome
            MOB("zep_animtome4", 0.500, nFreq); // Animated Tome
            MOB("zep_animwheel", 2.000, nFreq); // Animated Wheel
            MOB("zep_golemcitr", 7.000, nFreq); // Citrine Golem
            MOB("zep_animcutter", 3.000, nFreq); // Cutter
            MOB("zep_golememer", 12.000, nFreq); // Emerald Golem
            MOB("zep_golem_dam1", 19.000, nFreq); // Golem, Damaged 1
            MOB("zep_golem_dam2", 15.000, nFreq); // Golem, Damaged 2
            MOB("zep_golem_weath", 23.000, nFreq); // Golem, Weathered
            MOB("zep_maug", 4.000, nFreq); // Maug
            MOB("zep_maugcap", 14.000, nFreq); // Maug Captain
            MOB("zep_maugcom", 20.000, nFreq); // Maug Commander
            MOB("zep_mauglieu", 10.000, nFreq); // Maug Lieutenant
            MOB("zep_maughserg", 6.000, nFreq); // Maug Sergeant
            MOB("zep_mechspider", 5.000, nFreq); // Mechanized Spider
            MOB("zep_minogon", 8.000, nFreq); // Minogon
            MOB("zep_golemobs", 7.000, nFreq); // Obsidian Golem
            MOB("zep_golemrub", 11.000, nFreq); // Ruby Golem
            MOB("zep_golemsapph", 7.000, nFreq); // Sapphire Golem
            MOB("zep_scarecr", 6.000, nFreq); // Scarecrow
            MOB("zep_sguard_001", 15.000, nFreq); // Shield Guardian, Bizarro
            MOB("zep_shguard_002", 15.000, nFreq); // Shield Guardian, Black
            MOB("zep_shguard_003", 15.000, nFreq); // Shield Guardian, Blue
            MOB("zep_shguard_004", 15.000, nFreq); // Shield Guardian, Clan
            MOB("zep_shguard_005", 15.000, nFreq); // Shield Guardian, Fatal
            MOB("zep_shguard_006", 15.000, nFreq); // Shield Guardian, Gold
            MOB("zep_shguard_007", 15.000, nFreq); // Shield Guardian, Knight
            MOB("zep_shguard_008", 15.000, nFreq); // Shield Guardian, Mage
            MOB("zep_shguard_009", 15.000, nFreq); // Shield Guardian, Mortar
            MOB("zep_shguard_010", 15.000, nFreq); // Shield Guardian, Rust
            MOB("zep_shguard_011", 15.000, nFreq); // Shield Guardian, Vuong
            MOB("zep_shguard_012", 15.000, nFreq); // Shield Guardian, Wood
            MOB("zep_spiker", 8.000, nFreq); // Spiker
            MOB("zep_twigblight", 0.250, nFreq); // Twig Blight
         }
      }
      else if (sCode == "d")
      {
         // PICK RANDOM DRAGON
         if (testODBC()) sRaceList += ",11";
         else
         {
            MOB("nw_drgblack001", 13.000, nFreq); // Adult Black Dragon
            MOB("nw_drgblue001", 14.000, nFreq); // Adult Blue Dragon
            MOB("nw_drgbrass001", 13.000, nFreq); // Adult Brass Dragon [Commoner]
            MOB("nw_drgbrnz001", 15.000, nFreq); // Adult Bronze Dragon [Commoner]
            MOB("nw_drgcopp001", 14.000, nFreq); // Adult Copper Dragon [Commoner]
            MOB("nw_drggold001", 16.000, nFreq); // Adult Gold Dragon [Commoner]
            MOB("nw_drggreen001", 14.000, nFreq); // Adult Green Dragon
            MOB("nw_drgred001", 15.000, nFreq); // Adult Red Dragon
            MOB("nw_drgsilv001", 16.000, nFreq); // Adult Silver Dragon [Commoner]
            MOB("nw_drgwhite001", 12.000, nFreq); // Adult White Dragon
            MOB("nw_drgblack003", 21.000, nFreq); // Ancient Black Dragon
            MOB("nw_drgblue003", 23.000, nFreq); // Ancient Blue Dragon
            MOB("nw_drgbrass003", 22.000, nFreq); // Ancient Brass Dragon [Commoner]
            MOB("nw_drgbrnz003", 23.000, nFreq); // Ancient Bronze Dragon [Commoner]
            MOB("nw_drgcopp003", 22.000, nFreq); // Ancient Copper Dragon [Commoner]
            MOB("nw_drggold003", 25.000, nFreq); // Ancient Gold Dragon [Commoner]
            MOB("nw_drggreen003", 22.000, nFreq); // Ancient Green Dragon
            MOB("nw_drgred003", 24.000, nFreq); // Ancient Red Dragon
            MOB("x2_dragonshad001", 22.000, nFreq); // Ancient Shadow Dragon
            MOB("nw_drgsilv003", 24.000, nFreq); // Ancient Silver Dragon [Commoner]
            MOB("nw_drgwhite003", 20.000, nFreq); // Ancient White Dragon
            MOB("x0_dragon_faerie", 5.000, nFreq); // Faerie Dragon [Commoner]
            MOB("nw_halfdra002", 8.000, nFreq); // Half-Dragon Cleric [Commoner]
            MOB("nw_halfdra001", 9.000, nFreq); // Half-Dragon Sorceror
            MOB("nw_drgblack002", 17.000, nFreq); // Old Black Dragon
            MOB("nw_drgblue002", 18.000, nFreq); // Old Blue Dragon
            MOB("nw_drgbrass002", 17.000, nFreq); // Old Brass Dragon [Commoner]
            MOB("nw_drgbrnz002", 19.000, nFreq); // Old Bronze Dragon [Commoner]
            MOB("nw_drgcopp002", 18.000, nFreq); // Old Copper Dragon [Commoner]
            MOB("nw_drggold002", 21.000, nFreq); // Old Gold Dragon [Commoner]
            MOB("nw_drggreen002", 18.000, nFreq); // Old Green Dragon
            MOB("nw_drgred002", 19.000, nFreq); // Old Red Dragon
            MOB("nw_drgsilv002", 20.000, nFreq); // Old Silver Dragon [Commoner]
            MOB("nw_drgwhite002", 16.000, nFreq); // Old White Dragon
            MOB("x2_dragonpris001", 37.000, nFreq); // Prismatic Dragon
            MOB("x0_dragon_pseudo", 0.500, nFreq); // Pseudodragon [Commoner]
            MOB("x0_wyrmling_blk", 3.000, nFreq); // Wyrmling Black Dragon
            MOB("x0_wyrmling_blu", 5.000, nFreq); // Wyrmling Blue Dragon
            MOB("x0_wyrmling_brs", 4.000, nFreq); // Wyrmling Brass Dragon [Commoner]
            MOB("x0_wyrmling_brz", 5.000, nFreq); // Wyrmling Bronze Dragon [Commoner]
            MOB("x0_wyrmling_cop", 5.000, nFreq); // Wrymling Copper Dragon [Commoner]
            MOB("x0_wyrmling_gld", 7.000, nFreq); // Wrymling Gold Dragon [Commoner]
            MOB("x0_wyrmling_grn", 4.000, nFreq); // Wrymling Green Dragon
            MOB("x0_wyrmling_red", 5.000, nFreq); // Wyrmling Red Dragon
            MOB("x0_wyrmling_sil", 6.000, nFreq); // Wyrmling Silver Dragon [Commoner]
            MOB("x0_wyrmling_wht", 3.000, nFreq); // Wrymling White Dragon
            MOB("zep_drgbkad_001", 13.000, nFreq); // Black Dragon Adult
            MOB("zep_drgbkad_002", 13.000, nFreq); // Black Dragon Adult Flying
            MOB("zep_drgbkan_001", 21.000, nFreq); // Black Dragon Ancient
            MOB("zep_drgbko_001", 17.000, nFreq); // Black Dragon Old
            MOB("zep_drgbkw_001", 3.000, nFreq); // Black Dragon Wyrmling
            MOB("zep_drgblad_001", 14.000, nFreq); // Blue Dragon Adult
            MOB("zep_drgblad_002", 14.000, nFreq); // Blue Dragon Adult Flying
            MOB("zep_drgblan_001", 23.000, nFreq); // Blue Dragon Ancient
            MOB("zep_drgblo_001", 18.000, nFreq); // Blue Dragon Old
            MOB("zep_drgblw_001", 5.000, nFreq); // Blue Dragon Wyrmling
            MOB("zep_drgbsad_001", 13.000, nFreq); // Brass Dragon Adult [Commoner]
            MOB("zep_drgbsad_002", 13.000, nFreq); // Brass Dragon Adult Flying [Commoner]
            MOB("zep_drgbsan_001", 22.000, nFreq); // Brass Dragon Ancient [Commoner]
            MOB("zep_drgbso_001", 17.000, nFreq); // Brass Dragon Old [Commoner]
            MOB("zep_drgbsw_001", 4.000, nFreq); // Brass Dragon Wyrmling [Commoner]
            MOB("zep_drgbzad_001", 15.000, nFreq); // Bronze Dragon Adult [Commoner]
            MOB("zep_drgbzad_002", 15.000, nFreq); // Bronze Dragon Adult Flying [Commoner]
            MOB("zep_drgbzan_001", 23.000, nFreq); // Bronze Dragon Ancient [Commoner]
            MOB("zep_drgbzo_001", 19.000, nFreq); // Bronze Dragon Old [Commoner]
            MOB("zep_drgbzw_001", 5.000, nFreq); // Bronze Dragon Wyrmling [Commoner]
            MOB("zep_drgcpad_001", 14.000, nFreq); // Copper Dragon Adult [Commoner]
            MOB("zep_drgcpad_002", 14.000, nFreq); // Copper Dragon Adult Flying [Commoner]
            MOB("zep_drgcpan_001", 22.000, nFreq); // Copper Dragon Ancient [Commoner]
            MOB("zep_drgcpo_001", 18.000, nFreq); // Copper Dragon Old [Commoner]
            MOB("zep_drgcpw_001", 5.000, nFreq); // Copper Dragon Wyrmling [Commoner]
            MOB("zep_cgdrga_001", 23.000, nFreq); // Dragon, Gem - Amethyst
            MOB("zep_cgdrga_002", 23.000, nFreq); // Dragon, Gem - Amethyst
            MOB("zep_cgdrgc_001", 22.000, nFreq); // Dragon, Gem - Crystal
            MOB("zep_cgdrgc_002", 22.000, nFreq); // Dragon, Gem - Crystal
            MOB("zep_cgdrge_001", 23.000, nFreq); // Dragon, Gem - Emerald
            MOB("zep_cgdrge_002", 23.000, nFreq); // Dragon, Gem - Emerald
            MOB("zep_cgdrgo_001", 21.000, nFreq); // Dragon, Gem - Obsidian
            MOB("zep_cgdrgs_001", 22.000, nFreq); // Dragon, Gem - Sapphire
            MOB("zep_cgdrgs_002", 22.000, nFreq); // Dragon, Gem - Sapphire
            MOB("zep_cgdrgt_001", 24.000, nFreq); // Dragon, Gem - Topaz
            MOB("zep_cgdrgt_002", 24.000, nFreq); // Dragon, Gem - Topaz
            MOB("zep_drgrust", 22.000, nFreq); // Dragon, Rust
            MOB("zep_drggoad_001", 16.000, nFreq); // Gold Dragon Adult [Commoner]
            MOB("zep_drggoad_002", 16.000, nFreq); // Gold Dragon Adult Flying [Commoner]
            MOB("zep_drggoan_001", 25.000, nFreq); // Gold Dragon Ancient [Commoner]
            MOB("zep_drggoo_001", 21.000, nFreq); // Gold Dragon Old [Commoner]
            MOB("zep_drggow_001", 7.000, nFreq); // Gold Dragon Wyrmling [Commoner]
            MOB("zep_drggrad_001", 14.000, nFreq); // Green Dragon Adult
            MOB("zep_drggrad_002", 14.000, nFreq); // Green Dragon Adult Flying
            MOB("zep_drggran_001", 22.000, nFreq); // Green Dragon Ancient
            MOB("zep_drggro_001", 18.000, nFreq); // Green Dragon Old
            MOB("zep_drggrw_001", 4.000, nFreq); // Green Dragon Wyrmling
            MOB("zep_halfdrafnd", 9.000, nFreq); // Half-Dragon Fiend
            MOB("zep_drgrdad_001", 15.000, nFreq); // Red Dragon Adult
            MOB("zep_drgrdad_002", 15.000, nFreq); // Red Dragon Adult Flying
            MOB("zep_drgrdan_001", 24.000, nFreq); // Red Dragon Ancient
            MOB("zep_drgrdo_001", 19.000, nFreq); // Red Dragon Old
            MOB("zep_drgrdw_001", 5.000, nFreq); // Red Dragon Wyrmling
            MOB("zep_drgslad_001", 16.000, nFreq); // Silver Dragon Adult [Commoner]
            MOB("zep_drgslad_002", 16.000, nFreq); // Silver Dragon Adult Flying [Commoner]
            MOB("zep_drgslan_001", 24.000, nFreq); // Silver Dragon Ancient [Commoner]
            MOB("zep_drgslo_001", 20.000, nFreq); // Silver Dragon Old [Commoner]
            MOB("zep_drgslw_001", 6.000, nFreq); // Silver Dragon Wyrmling [Commoner]
            MOB("zep_drgwtad_001", 12.000, nFreq); // White Dragon Adult
            MOB("zep_drgwtad_002", 12.000, nFreq); // White Dragon Adult Flying
            MOB("zep_drgwtan_001", 20.000, nFreq); // White Dragon Ancient
            MOB("zep_drgwto_001", 16.000, nFreq); // White Dragon Old
            MOB("zep_drgwtw_001", 3.000, nFreq); // White Dragon Wyrmling
         }
      }
      else if (sCode == "e")
      {
         // PICK RANDOM ELEMENTAL
         if (testODBC()) sRaceList += ",16";
         else
         {
            MOB("nw_air", 4.000, nFreq); // Air Elemental
            MOB("nw_earth", 4.000, nFreq); // Earth Elemental
            MOB("nw_airelder", 20.000, nFreq); // Elder Air Elemental
            MOB("nw_eartheld", 17.000, nFreq); // Elder Earth Elemental
            MOB("nw_fireelder", 17.000, nFreq); // Elder Fire Elemental
            MOB("nw_watelder", 16.000, nFreq); // Elder Water Elemental
            MOB("nw_fire", 3.000, nFreq); // Fire Elemental
            MOB("nw_airgreat", 18.000, nFreq); // Greater Air Elemental
            MOB("nw_earthgreat", 15.000, nFreq); // Greater Earth Elemental
            MOB("nw_firegreat", 15.000, nFreq); // Greater Fire Elemental
            MOB("nw_watergreat", 14.000, nFreq); // Greater Water Elemental
            MOB("nw_airhuge", 13.000, nFreq); // Huge Air Elemental
            MOB("nw_earthhuge", 11.000, nFreq); // Huge Earth Elemental
            MOB("nw_firehuge", 12.000, nFreq); // Huge Fire Elemental
            MOB("nw_waterhuge", 11.000, nFreq); // Huge Water Elemental
            MOB("nw_invstalk", 6.000, nFreq); // Invisible Stalker
            MOB("nw_water", 4.000, nFreq); // Water Elemental
            MOB("zep_belker", 6.000, nFreq); // Belker
            MOB("zep_genie_001", 8.000, nFreq); // Genie, Dao
            MOB("zep_genie_002", 6.000, nFreq); // Genie, Djinni
            MOB("zep_genie_003", 9.000, nFreq); // Genie, Efreeti
            MOB("zep_genie_004", 8.000, nFreq); // Genie, Efreeti
            MOB("zep_genie_005", 5.000, nFreq); // Genie, Janni
            MOB("zep_genie_006", 12.000, nFreq); // Genie, Marid
            MOB("zep_elemairl", 11.000, nFreq); // Huge Air Elemental
            MOB("zep_elemashl", 11.000, nFreq); // Huge Ash Elemental
            MOB("zep_elemdustl", 12.000, nFreq); // Huge Dust Elemental
            MOB("zep_elemearthl", 12.000, nFreq); // Huge Earth Elemental
            MOB("zep_elemfirel", 11.000, nFreq); // Huge Fire Elemental
            MOB("zep_elemicel", 11.000, nFreq); // Huge Ice Elemental
            MOB("zep_lightningh", 11.000, nFreq); // Huge Lightning Elemental
            MOB("zep_elemmagmal", 11.000, nFreq); // Huge Magma Elemental
            MOB("zep_elemminl", 12.000, nFreq); // Huge Mineral Elemental
            MOB("zep_elemoozel", 12.000, nFreq); // Huge Ooze Elemental
            MOB("zep_elemradncl", 11.000, nFreq); // Huge Radiance Elemental
            MOB("zep_elemsaltl", 12.000, nFreq); // Huge Salt Elemental
            MOB("zep_elemsmokel", 11.000, nFreq); // Huge Smoke Elemental
            MOB("zep_elemsteaml", 11.000, nFreq); // Huge Steam Elemental
            MOB("zep_elemvacuuml", 11.000, nFreq); // Huge Vacuum Elemental
            MOB("zep_elemwaterl", 11.000, nFreq); // Huge Water Elemental
            MOB("zep_elemairm", 6.000, nFreq); // Large Air Elemental
            MOB("zep_elemashm", 6.000, nFreq); // Large Ash Elemental
            MOB("zep_elemdustm", 6.000, nFreq); // Large Dust Elemental
            MOB("zep_elemearthm", 6.000, nFreq); // Large Earth Elemental
            MOB("zep_elemfirem", 6.000, nFreq); // Large Fire Elemental
            MOB("zep_elemicem", 6.000, nFreq); // Large Ice Elemental
            MOB("zep_lightningl", 6.000, nFreq); // Large Lightning Elemental
            MOB("zep_elemmagmam", 6.000, nFreq); // Large Magma Elemental
            MOB("zep_elemminm", 6.000, nFreq); // Large Mineral Elemental
            MOB("zep_elemoozem", 6.000, nFreq); // Large Ooze Elemental
            MOB("zep_elemradncm", 7.000, nFreq); // Large Radiance Elemental
            MOB("zep_elemsaltm", 6.000, nFreq); // Large Salt Elemental
            MOB("zep_elemsmokem", 6.000, nFreq); // Large Smoke Elemental
            MOB("zep_elemsteamm", 6.000, nFreq); // Large Steam Elemental
            MOB("zep_elemvacuumm", 6.000, nFreq); // Large Vacuum Elemental
            MOB("zep_elemwaterm", 6.000, nFreq); // Large Water Elemental
            MOB("zep_elemairs", 2.000, nFreq); // Small Air Elemental
            MOB("zep_elemashs", 2.000, nFreq); // Small Ash Elemental
            MOB("zep_elemdusts", 2.000, nFreq); // Small Dust Elemental
            MOB("zep_elemearths", 2.000, nFreq); // Small Earth Elemental
            MOB("zep_elemfires", 1.000, nFreq); // Small Fire Elemental
            MOB("zep_elemices", 2.000, nFreq); // Small Ice Elemental
            MOB("zep_lightnings", 3.000, nFreq); // Small Lightning Elemental
            MOB("zep_elemmagmas", 1.000, nFreq); // Small Magma Elemental
            MOB("zep_elemmins", 2.000, nFreq); // Small Mineral Elemental
            MOB("zep_elemoozes", 2.000, nFreq); // Small Ooze Elemental
            MOB("zep_elemradncs", 3.000, nFreq); // Small Radiance Elemental
            MOB("zep_elemsalts", 2.000, nFreq); // Small Salt Elemental
            MOB("zep_elemsmokes", 2.000, nFreq); // Small Smoke Elemental
            MOB("zep_elemsteams", 2.000, nFreq); // Small Steam Elemental
            MOB("zep_elemvacuums", 2.000, nFreq); // Small Vacuum Elemental
            MOB("zep_elemwaters", 2.000, nFreq); // Small Water Elemental
         }
      }
      else if (sCode == "g")
      {
         // PICK RANDOM GIANT
         if (testODBC()) sRaceList += ",18";
         else
         {
            MOB("nw_ettin", 8.000, nFreq); // Ettin
            MOB("nw_gnthill", 10.000, nFreq); // Hill Giant
            MOB("nw_gntmount", 10.000, nFreq); // Mountain Giant
            MOB("zep_cyclopsa", 10.000, nFreq); // Armored Cyclops
            MOB("zep_cyclops", 10.000, nFreq); // Cyclops
            MOB("zep_gnthillc_001", 15.000, nFreq, 1, 1); // Hill Giant Chief
            MOB("zep_gntmntc_001", 14.000, nFreq, 1, 1); // Mountain Giant Chief
            MOB("zep_gntstone_001", 22.000, nFreq); // Stone Giant
            MOB("nw_gntfire", 12.000, nFreq); // Fire Giant Male
            MOB("x0_gntfirefem", 10.000, nFreq); // Fire Giant Female
            MOB("nw_gntfrost", 10.000, nFreq); // Frost Giant Male
            MOB("x0_gntfrostfem", 9.000, nFreq); // Frost Giant Female
            MOB("zep_gntfirea_001", 12.000, nFreq); // Fire Giant Adept
            MOB("zep_gntfirec_001", 12.000, nFreq); // Fire Giant Cleric
            MOB("zep_gntfirek_001", 21.000, nFreq); // Fire Giant Warrior
            MOB("zep_gntfrsta_001", 11.000, nFreq); // Frost Giant Adept
            MOB("zep_gntfrstc_001", 16.000, nFreq); // Frost Giant Cleric
            MOB("zep_gntfrstj_001", 26.000, nFreq); // Frost Giant Jarl
            MOB("zep_gntfrsts_001", 20.000, nFreq); // Frost Giant Sorcerer
            MOB("zep_gntfrstw_001", 19.000, nFreq); // Frost Giant Warrior
            MOB("nw_ogre01", 3.000, nFreq); // Ogre
            MOB("nw_ogre02", 3.000, nFreq); // Ogre
            MOB("nw_ogrechief01", 6.000, nFreq); // Ogre Berserker w/Axe
            MOB("nw_ogrechief02", 6.000, nFreq); // Ogre Berserker w/Sword
            MOB("nw_ogreboss", 9.000, nFreq, 1, 1); // Ogre Chieftain
            MOB("nw_ogremageboss", 18.000, nFreq); // Ogre High Mage
            MOB("nw_ogremage01", 5.000, nFreq); // Ogre Mage
            MOB("nw_ogremage02", 5.000, nFreq); // Ogre Mage
            MOB("zep_dlaogre_001", 11.000, nFreq); // Ogre
            MOB("nw_troll", 5.000, nFreq); // Troll
            MOB("nw_trollchief", 7.000, nFreq); // Troll Berserker
            MOB("nw_trollboss", 9.000, nFreq, 1, 1); // Troll Chieftain
            MOB("nw_trollwiz", 7.000, nFreq); // Troll Shaman
            MOB("zep_troll", 5.000, nFreq); // Troll
         }
      }
      else if (sCode == "h")
      {
         // PICK RANDOM HUMANOID
         if (testODBC()) sRaceList += ",12,13,14,15";
         else
         {
            MOB("nw_bugbeara", 2.000, nFreq); // Bugbear w/Morningstar
            MOB("nw_bugbearb", 2.000, nFreq); // Bugbear w/Crossbow
            MOB("nw_bugbearboss", 10.000, nFreq, 1, 1); // Bugbear Chieftain
            MOB("nw_bugchiefa", 5.000, nFreq); // Bugbear Hero w/Sword
            MOB("nw_bugchiefb", 5.000, nFreq); // Bugbear Hero w/Axe
            MOB("nw_bugwiza", 4.000, nFreq); // Bugbear Shaman w/Dagger
            MOB("nw_bugwizb", 4.000, nFreq); // Bugbear Shaman w/Mace
            MOB("zep_arcticbugb", 4.000, nFreq); // Arctic Bugbear
            MOB("zep_arcticbugbch", 12.000, nFreq, 1, 1); // Arctic Bugbear Chieftain
            MOB("zep_arcticbugbsh", 6.000, nFreq); // Arctic Bugbear Shaman
            MOB("zep_bugbear_001", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_002", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_003", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_004", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_005", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_006", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_007", 2.000, nFreq); // Bugbear Warrior
            MOB("zep_bugbear_008", 0.250, nFreq); // Bugbear, Young
            MOB("nw_dryad", 2.000, nFreq); // Dryad [Commoner]
            MOB("nw_grig", 2.000, nFreq); // Grig
            MOB("nw_nixie", 1.000, nFreq); // Nixie [Commoner]
            MOB("nw_nymph", 3.000, nFreq); // Nymph [Commoner]
            MOB("nw_pixie", 2.000, nFreq); // Pixie
            MOB("zep_pixie", 1.000, nFreq); // Pixie [Commoner]
            MOB("zep_pixie_001", 2.000, nFreq); // Pixie, Blue
            MOB("zep_pixie_002", 2.000, nFreq); // Pixie, Orange
            MOB("zep_pixie_003", 2.000, nFreq); // Pixie, Pink
            MOB("zep_pixie_004", 2.000, nFreq); // Pixie, Purple
            MOB("zep_satyr", 4.000, nFreq); // Satyr [Commoner]
            MOB("zep_satyrs", 2.000, nFreq); // Small Satyr [Commoner]
            MOB("nw_goblina", 0.250, nFreq); // Goblin w/Morningstar
            MOB("nw_goblinb", 0.250, nFreq); // Goblin w/Shortbow
            MOB("nw_goblinboss", 11.000, nFreq, 1, 1); // Goblin Chieftain
            MOB("nw_gobchiefa", 4.000, nFreq); // Goblin Elite w/Sword
            MOB("nw_gobchiefb", 3.000, nFreq); // Goblin Elite w/Axe
            MOB("nw_gobwiza", 3.000, nFreq); // Goblin Shaman w/Hammer
            MOB("nw_gobwizb", 3.000, nFreq); // Goblin Shaman w/Dagger
            MOB("nw_hobgoblin001", 0.250, nFreq); // Hobgoblin
            MOB("nw_hobgoblin002", 2.000, nFreq); // Hobgoblin Shaman
            MOB("zep_goblin", 0.250, nFreq); // Cave Goblin
            MOB("zep_goblinbes", 4.000, nFreq); // Cave Goblin Berserker
            MOB("zep_goblinboss", 11.000, nFreq, 1, 1); // Cave Goblin Chieftain
            MOB("zep_goblinscout", 3.000, nFreq); // Cave Goblin Scout
            MOB("zep_goblinsha", 3.000, nFreq); // Cave Goblin Shaman
            MOB("zep_frostgoblin", 2.000, nFreq); // Frost Goblin
            MOB("zep_frostgobchie", 13.000, nFreq, 1, 1); // Frost Goblin Chieftain
            MOB("zep_frostgobwiz", 4.000, nFreq); // Frost Goblin Shaman
            MOB("zep_gobspidrider", 4.000, nFreq); // Goblin Spider Rider
            MOB("zep_goblinworgg", 5.000, nFreq); // Worg Rider (Spawns Goblin On Death)
            MOB("zep_goblinworgr", 6.000, nFreq); // Worg Rider (Spawns Nothing On Death)
            MOB("zep_goblinworgrw", 5.000, nFreq); // Worg Rider (Spawns Worg On Death)
            MOB("x0_asabi_chief", 6.000, nFreq, 1, 1); // Asabi Chieftain
            MOB("x0_asabi_shaman", 5.000, nFreq); // Asabi Shaman
            MOB("x0_asabi_warrior", 2.000, nFreq); // Asabi Warrior
            MOB("nw_kobold001", 0.333, nFreq); // Kobold
            MOB("nw_kobold002", 0.333, nFreq); // Kobold
            MOB("nw_kobold003", 2.000, nFreq); // Kobold Thug
            MOB("nw_kobold004", 2.000, nFreq); // Kobold Footpad
            MOB("nw_kobold005", 2.000, nFreq); // Kobold Shaman
            MOB("nw_kobold006", 2.000, nFreq); // Kobold Healer
            MOB("nw_oldchiefa", 4.000, nFreq, 1, 1); // Lizardfolk Chieftain w/Axe
            MOB("nw_oldchiefb", 4.000, nFreq, 1, 1); // Lizardfolk Chieftain w/Swords
            MOB("nw_oldmagea", 4.000, nFreq); // Lizardfolk Shaman w/Staff
            MOB("nw_oldmageb", 4.000, nFreq); // Lizardfolk Shaman w/Club
            MOB("nw_oldwarb", 2.000, nFreq); // Lizardfolk Warrior w/Crossbow
            MOB("nw_oldwarra", 2.000, nFreq); // Lizardfolk Warrior w/Scimitar
            MOB("nw_sahuagin", 2.000, nFreq); // Sahaugin w/Crossbow
            MOB("nw_sahuaginclr", 2.000, nFreq); // Sahaugin Cleric
            MOB("nw_sahuaginldr", 3.000, nFreq); // Sahaugin Leader
            MOB("nw_trog001", 1.000, nFreq); // Troglodyte
            MOB("nw_trog003", 5.000, nFreq); // Troglodyte Cleric
            MOB("nw_trog002", 3.000, nFreq); // Troglodyte Warrior
            MOB("nw_yuan_ti001", 5.000, nFreq); // Yuan-Ti
            MOB("nw_yuan_ti003", 6.000, nFreq); // Yuan-Ti Priest
            MOB("nw_yuan_ti002", 5.000, nFreq); // Yuan-Ti Sorceror
            MOB("zep_koboldfly", 0.333, nFreq); // Flying Kobold
            MOB("zep_koboldfly2", 0.333, nFreq); // Flying Kobold
            MOB("zep_koboldfly5", 2.000, nFreq); // Flying Kobold Chief
            MOB("zep_koboldfly6", 2.000, nFreq); // Flying Kobold Chief
            MOB("zep_koboldfly3", 2.000, nFreq); // Flying Kobold Shaman
            MOB("zep_koboldfly4", 2.000, nFreq); // Flying Kobold Shaman
            MOB("zep_icekobold", 2.000, nFreq); // Ice Kobold
            MOB("zep_icekoboldnob", 2.000, nFreq); // Ice Kobold Noble
            MOB("zep_icekoboldsha", 3.000, nFreq); // Ice Kobold Shaman
            MOB("nw_minotaur", 4.000, nFreq); // Minotaur
            MOB("nw_minchief", 8.000, nFreq); // Minotaur Berserker
            MOB("nw_minotaurboss", 13.000, nFreq, 1, 1); // Minotaur Chieftain
            MOB("nw_minwiz", 9.000, nFreq); // Minotaur Shaman
            MOB("nw_orca", 0.250, nFreq); // Orc Green w/Axe
            MOB("nw_orcb", 0.250, nFreq); // Orc Blue w/Longbow
            MOB("nw_orcchiefa", 3.000, nFreq); // Orc Champion Green w/Axe
            MOB("nw_orcchiefb", 3.000, nFreq); // Orc Champion Blue w/Morningstar
            MOB("nw_orcboss", 10.000, nFreq, 1, 1); // Orc Chieftain Blue
            MOB("nw_orcwiza", 4.000, nFreq); // Orc Shaman Green
            MOB("nw_orcwizb", 4.000, nFreq); // Orc Shaman Blue
            MOB("zep_orcbloodg", 0.250, nFreq); // Bloodguard Orc
            MOB("zep_urakhai", 1.000, nFreq); // Elite Orc
            MOB("zep_urakhaib", 5.000, nFreq); // Elite Orc Berserker
            MOB("zep_urakhaic", 12.000, nFreq); // Elite Orc Captain
            MOB("zep_urakhais", 4.000, nFreq); // Elite Orc Scout
            MOB("zep_urakhaisold", 1.000, nFreq); // Elite Orc Soldier
            MOB("zep_orc", 0.250, nFreq); // Orc
            MOB("zep_orc3", 0.250, nFreq); // Orc Champion
            MOB("zep_orcboss", 10.000, nFreq, 1, 1); // Orc Chieftain
            MOB("zep_orc4", 0.250, nFreq); // Orc Fighter
            MOB("zep_orc2", 0.250, nFreq); // Orc In Chainmail
            MOB("zep_orcmerc", 0.250, nFreq); // Orc Mercenary
            MOB("zep_frostorc", 3.000, nFreq); // Snow Orc
            MOB("zep_frostorcch", 6.000, nFreq); // Snow Orc Champion
            MOB("zep_frostorcsh", 7.000, nFreq); // Snow Orc Shaman
            MOB("nw_gnoll001", 1.000, nFreq); // Gnoll
            MOB("nw_gnoll002", 3.000, nFreq); // Gnoll Shaman
            MOB("x0_medusa", 6.000, nFreq); // Medusa
            MOB("nw_seahag", 4.000, nFreq); // Sea Hag
            MOB("x0_stinger", 3.000, nFreq); // Stinger
            MOB("x0_stinger_chief", 7.000, nFreq, 1, 1); // Stinger Chieftain
            MOB("x0_stinger_mage", 5.000, nFreq); // Stinger Mage
            MOB("x0_stinger_war", 5.000, nFreq); // Stinger Warrior
            MOB("zep_annis", 6.000, nFreq); // Annis
            MOB("zep_trollocb", 2.000, nFreq); // Boar Beastman
            MOB("zep_cmgnoll_001", 1.000, nFreq); // Gnoll
            MOB("zep_trollocg", 2.000, nFreq); // Goat Beastman
            MOB("zep_drgnkin_001", 5.000, nFreq); // Dragonkin, Black
            MOB("zep_drgnkin_002", 5.000, nFreq); // Dragonkin, Black
            MOB("zep_drgnkin_003", 5.000, nFreq); // Dragonkin, Blue
            MOB("zep_drgnkin_004", 5.000, nFreq); // Dragonkin, Blue
            MOB("zep_drgnkin_005", 5.000, nFreq); // Dragonkin, Brass
            MOB("zep_drgnkin_006", 5.000, nFreq); // Dragonkin, Brass
            MOB("zep_drgnkin_007", 5.000, nFreq); // Dragonkin, Bronze
            MOB("zep_drgnkin_008", 5.000, nFreq); // Dragonkin, Bronze
            MOB("zep_drgnkin_009", 5.000, nFreq); // Dragonkin, Copper
            MOB("zep_drgnkin_010", 5.000, nFreq); // Dragonkin, Copper
            MOB("zep_drgnkin_011", 5.000, nFreq); // Dragonkin, Gold
            MOB("zep_drgnkin_012", 5.000, nFreq); // Dragonkin, Gold
            MOB("zep_drgnkin_013", 5.000, nFreq); // Dragonkin, Green
            MOB("zep_drgnkin_014", 5.000, nFreq); // Dragonkin, Green
            MOB("zep_drgnkin_015", 5.000, nFreq); // Dragonkin, Prismatic
            MOB("zep_drgnkin_016", 5.000, nFreq); // Dragonkin, Prismatic
            MOB("zep_drgnkin_017", 5.000, nFreq); // Dragonkin, Red
            MOB("zep_drgnkin_018", 5.000, nFreq); // Dragonkin, Red
            MOB("zep_drgnkin_019", 5.000, nFreq); // Dragonkin, Shadow
            MOB("zep_drgnkin_020", 5.000, nFreq); // Dragonkin, Shadow
            MOB("zep_drgnkin_021", 5.000, nFreq); // Dragonkin, Silver
            MOB("zep_drgnkin_022", 5.000, nFreq); // Dragonkin, Silver
            MOB("zep_drgnkin_023", 5.000, nFreq); // Dragonkin, White
            MOB("zep_drgnkin_024", 5.000, nFreq); // Dragonkin, White
            MOB("zep_gibber_001", 0.500, nFreq); // Gibberling
            MOB("zep_gibber_002", 0.500, nFreq); // Gibberling
            MOB("zep_cmgnoll_001", 1.000, nFreq); // Gnoll
            MOB("zep_cmgnoll_012", 1.000, nFreq); // Gnoll, Female
            MOB("zep_cmgnoll_013", 1.000, nFreq); // Gnoll, Female
            MOB("zep_cmgnoll_002", 1.000, nFreq); // Gnoll, Ginger
            MOB("zep_cmgnoll_003", 1.000, nFreq); // Gnoll, Gnollene
            MOB("zep_cmgnoll_004", 1.000, nFreq); // Gnoll, Howin
            MOB("zep_cmgnoll_005", 1.000, nFreq); // Gnoll, Kylie
            MOB("zep_cmgnoll_006", 1.000, nFreq); // Gnoll, Raven
            MOB("zep_cmgnoll_007", 1.000, nFreq); // Gnoll, Red Moon
            MOB("zep_cmgnoll_009", 1.000, nFreq); // Gnoll, Silvermoon Female
            MOB("zep_cmgnoll_008", 1.000, nFreq); // Gnoll, Silvermoon Male
            MOB("zep_cmgnoll_010", 1.000, nFreq); // Gnoll, Sparky
            MOB("zep_cmgnoll_011", 1.000, nFreq); // Gnoll, Vishtani
            MOB("zep_trollocg", 2.000, nFreq); // Goat Beastman
            MOB("zep_greenhag", 5.000, nFreq); // Green Hag
            MOB("zep_halfdrgn_001", 4.000, nFreq); // Half-Dragon, Gold
            MOB("zep_halfdrgn_002", 4.000, nFreq); // Half-Dragon, Silver
            MOB("zep_trolloch", 2.000, nFreq); // Hawk Beastman
            MOB("zep_kenku_001", 2.000, nFreq); // Kenku
            MOB("zep_kenku_002", 2.000, nFreq); // Kenku
            MOB("zep_kenku_003", 2.000, nFreq); // Kenku
            MOB("zep_kenku_004", 2.000, nFreq); // Kenku
            MOB("zep_kenku_fem", 2.000, nFreq); // Kenku, Female
            MOB("zep_kenku_hev", 2.000, nFreq); // Kenku, Heavy
            MOB("zep_kuotoa_001", 2.000, nFreq); // Kuo-toa
            MOB("zep_kuotoa_002", 4.000, nFreq); // Kuo-toa Hunter
            MOB("zep_kuotoa_003", 4.000, nFreq); // Kuo-toa Hunter
            MOB("zep_kuotoa_004", 5.000, nFreq); // Kuo-toa Shaman
            MOB("zep_kuotoa_005", 5.000, nFreq); // Kuo-toa Shaman
            MOB("zep_ogrillon", 2.000, nFreq); // Ogrillon Grey w/Axe
            MOB("zep_ogrillon001", 2.000, nFreq); // Ogrillon Grey w/Sword
            MOB("zep_ogrillon3", 2.000, nFreq); // Ogrillon Brown w/Club
            MOB("zep_ogrillon4", 2.000, nFreq); // Ogrillon Brown w/Sword
         }
      }
      else if (sCode == "i")
      {
         // PICK RANDOM INSECT
         if (testODBC()) sRaceList += ",25";
         else
         {
            MOB("zep_gantfire", 3.000, nFreq); // Giant Fire Ant
            MOB("zep_gantguard", 6.000, nFreq); // Giant Ant Hive Guard
            MOB("zep_ganthvqueen", 5.000, nFreq, 1, 1); // Giant Ant Hive Queen
            MOB("zep_gantlarva", 0.250, nFreq); // Giant Ant Larva
            MOB("zep_gantqueen", 4.000, nFreq); // Giant Ant Queen
            MOB("zep_gantsoldier", 3.000, nFreq); // Giant Ant Soldier
            MOB("zep_giantantwork", 2.000, nFreq); // Giant Ant Worker
            MOB("nw_btlfire", 0.250, nFreq); // Fire Beetle
            MOB("nw_btlbomb", 3.000, nFreq); // Bombardier Beetle
            MOB("nw_beetleboss", 16.000, nFreq, 1, 1); // Hive Mother
            MOB("nw_btlfire02", 3.000, nFreq); // Spitting Fire Beetle
            MOB("nw_btlstag", 7.000, nFreq); // Stag Beetle
            MOB("nw_btlstink", 3.000, nFreq); // Stink Beetle
            MOB("zep_beetlebomb", 3.000, nFreq); // Bombardier Beetle
            MOB("zep_beetlefiref", 1.000, nFreq); // Fine Fire Beetle
            MOB("zep_beetlefireh", 6.000, nFreq); // Huge Fire Beetle
            MOB("zep_beetlefiret", 1.000, nFreq); // Tiny Fire Beetle
            MOB("zep_beetleslicf", 2.000, nFreq); // Fine Slicer Beetle
            MOB("zep_beetleslich", 6.000, nFreq); // Huge Slicer Beetle
            MOB("zep_beetleslict", 1.000, nFreq); // Tiny Slicer Beetle
            MOB("zep_beetlespitf", 1.000, nFreq); // Fine Spitting Fire Beetle
            MOB("zep_beetlespith", 7.000, nFreq); // Huge Spitting Fire Beetle
            MOB("zep_beetlespitt", 2.000, nFreq); // Tiny Spitting Fire Beetle
            MOB("zep_beetlestagf", 2.000, nFreq); // Fine Stag Beetle
            MOB("zep_beetlestagh", 9.000, nFreq); // Huge Stag Beetle
            MOB("zep_beetlestagt", 3.000, nFreq); // Tiny Stag Beetle
            MOB("zep_beetlestnkf", 1.000, nFreq); // Fine Stink Beetle
            MOB("zep_beetlestnkh", 7.000, nFreq); // Huge Stink Beetle
            MOB("zep_beetlestnkt", 2.000, nFreq); // Tiny Stink Beetle
            MOB("zep_bugcloud", 2.000, nFreq); // Cloud of Bugs
            MOB("zep_gwasp", 3.000, nFreq, 1, 10); // Giant Wasp
            MOB("zep_bugcloudl", 5.000, nFreq); // Large Cloud of Bugs
            MOB("zep_mcenti_001", 2.000, nFreq); // Monstrous Centipede, Large
            MOB("zep_mcenti_002", 2.000, nFreq); // Monstrous Centipede, Medium
            MOB("zep_mcenti_003", 1.000, nFreq); // Monstrous Centipede, Small
            MOB("zep_scorp001", 2.000, nFreq); // Black Scorpion
            MOB("zep_scorpg001", 3.000, nFreq); // Giant Black Scorpion
            MOB("zep_scorpg003", 3.000, nFreq); // Giant Red Scorpion
            MOB("zep_scorpg", 3.000, nFreq); // Giant Scorpion
            MOB("zep_scorpg002", 3.000, nFreq); // Giant Slimy Scorpion
            MOB("zep_scorph001", 7.000, nFreq); // Huge Black Scorpion
            MOB("zep_scorph003", 7.000, nFreq); // Huge Red Scorpion
            MOB("zep_scorph", 7.000, nFreq); // Huge Scorpion
            MOB("zep_scorph002", 7.000, nFreq); // Huge Slimy Scorpion
            MOB("zep_scorp003", 2.000, nFreq); // Red Scorpion
            MOB("zep_scorp", 2.000, nFreq); // Scorpion
            MOB("zep_scorp002", 2.000, nFreq); // Slimy Scorpion
            MOB("nw_spiddire", 7.000, nFreq); // Dire Spider
            MOB("nw_spidgiant", 3.000, nFreq); // Giant Spider
            MOB("nw_spidphase", 3.000, nFreq); // Phase Spider
            MOB("nw_spiderboss", 14.000, nFreq, 1, 1); // Queen Spider
            MOB("nw_spidswrd", 4.000, nFreq); // Sword Spider
            MOB("nw_spidwra", 4.000, nFreq); // Wraith Spider
            MOB("zep_spidbloodbak", 5.000, nFreq); // Bloodback Spider
            MOB("zep_spiddire", 3.000, nFreq); // Dire Spiderling
            MOB("zep_spiderling", 0.167, nFreq); // Fire Spiderling
            MOB("zep_spiderlingsw", 2.000, nFreq); // Sword Spiderling
            MOB("zep_spidgiant", 1.000, nFreq); // Giant Spiderling
            MOB("zep_spidice", 5.000, nFreq); // Ice Spider
            MOB("zep_spidphase", 1.000, nFreq); // Phase Spiderling
            MOB("zep_spidredback", 7.000, nFreq); // Redback Spider
            MOB("zep_spidwra", 4.000, nFreq); // Wraith Spiderling
         }
      }
      else if (sCode == "m")
      {
         // PICK RANDOM MISCELLANEOUS
         if (testODBC()) sRaceList += ",9,17,19,29";
         else
         {
            MOB("x0_sphinx", 13.000, nFreq); // Androsphinx [Commoner]
            MOB("x0_basilisk", 5.000, nFreq); // Basilisk
            MOB("nw_blinkdog", 3.000, nFreq, 5, 10); // Blink Dog [Commoner]
            MOB("x0_cockatrice", 5.000, nFreq); // Cockatrice
            MOB("x2_deeprothe001", 1.000, nFreq); // Deep Rothe
            MOB("nw_gargoyle", 3.000, nFreq); // Gargoyle
            MOB("x0_gorgon", 7.000, nFreq); // Gorgon
            MOB("x0_gynosphinx", 8.000, nFreq); // Gynosphinx [Commoner]
            MOB("nw_krenshar", 2.000, nFreq); // Krenshar
            MOB("x0_manticore", 6.000, nFreq); // Manticore
            MOB("nw_stirge", 0.333, nFreq, 1, 20); // Stirge
            MOB("zep_sphinxandro", 13.000, nFreq); // Androsphinx [Commoner]
            MOB("zep_cbaslsk_001", 6.000, nFreq); // Basilisk, Abyssal
            MOB("zep_sphinxgyno", 8.000, nFreq); // Gynosphinx [Commoner]
            MOB("zep_sphinxhier", 7.000, nFreq); // Hieracosphinx
            MOB("zep_manticore", 5.000, nFreq); // Manticore
            MOB("x2_gelcube", 3.000, nFreq); // Gelatinous Cube
            MOB("nw_grayrend", 8.000, nFreq); // Gray Render
            MOB("nw_grayooze", 3.000, nFreq); // Gray Ooze
            MOB("x2_harpy001", 5.000, nFreq); // Harpy
            MOB("nw_ochrejellylrg", 5.000, nFreq); // Ochre Jelly
            MOB("nw_ochrejellymed", 3.000, nFreq); // Ochre Jelly
            MOB("nw_ochrejellysml", 1.000, nFreq); // Ochre Jelly
            MOB("zep_leech_l", 8.000, nFreq); // Leech, Large
            MOB("zep_leech_m", 6.000, nFreq); // Leech, Medium
            MOB("zep_leech_s", 3.000, nFreq); // Leech, Small
            MOB("zep_blackpuddl", 4.000, nFreq); // Large Black Pudding
            MOB("zep_blackpuddm", 3.000, nFreq); // Medium Black Pudding
            MOB("zep_blackpudds", 3.000, nFreq); // Small Black Pudding
            MOB("zep_brownpuddl", 4.000, nFreq); // Large Brown Pudding
            MOB("zep_brownpuddm", 3.000, nFreq); // Medium Brown Pudding
            MOB("zep_brownpudds", 3.000, nFreq); // Small Brown Pudding
            MOB("zep_crystaloozel", 3.000, nFreq); // Large Crystal Ooze
            MOB("zep_crystaloozem", 2.000, nFreq); // Medium Crystal Ooze
            MOB("zep_crystaloozes", 2.000, nFreq); // Small Crystal Ooze
            MOB("zep_dunpuddingl", 4.000, nFreq); // Large Dun Pudding
            MOB("zep_dunpuddingm", 3.000, nFreq); // Medium Dun Pudding
            MOB("zep_dunpuddings", 3.000, nFreq); // Small Dun Pudding
            MOB("zep_grayoozel", 3.000, nFreq); // Large Gray Ooze
            MOB("zep_grayoozem", 2.000, nFreq); // Medium Gray Ooze
            MOB("zep_grayoozes", 2.000, nFreq); // Small Gray Ooze
            MOB("zep_greenslimel", 4.000, nFreq); // Large Green Slime
            MOB("zep_greenslimem", 3.000, nFreq); // Medium Green Slime
            MOB("zep_greenslimes", 3.000, nFreq); // Small Green Slime
            MOB("zep_mustardjell", 4.000, nFreq); // Large Mustard Jelly
            MOB("zep_mustardjelm", 3.000, nFreq); // Medium Mustard Jelly
            MOB("zep_mustardjels", 3.000, nFreq); // Small Mustard Jelly
            MOB("zep_ochrejellyl", 4.000, nFreq); // Large Ochre Jelly
            MOB("zep_ochrejellym", 3.000, nFreq); // Medium Ochre Jelly
            MOB("zep_ochrejellys", 3.000, nFreq); // Small Ochre Jelly
            MOB("zep_oliveslimel", 4.000, nFreq); // Large Olive Slime
            MOB("zep_oliveslimem", 3.000, nFreq); // Medium Olive Slime
            MOB("zep_oliveslimes", 3.000, nFreq); // Small Olive Slime
            MOB("zep_slitheringl", 4.000, nFreq); // Large Slithering Tracker
            MOB("zep_slitheringm", 2.000, nFreq); // Medium Slithering Tracker
            MOB("zep_slitherings", 3.000, nFreq); // Small Slithering Tracker
            MOB("zep_whitepuddl", 4.000, nFreq); // Large White Pudding
            MOB("zep_whitepuddm", 3.000, nFreq); // Medium White Pudding
            MOB("zep_whitepudds", 3.000, nFreq); // Small White Pudding
            MOB("zep_vines1", 3.000, nFreq); // Assassin Vines Vertical
            MOB("zep_vines2", 3.000, nFreq); // Assassin Vines Horizontal
            MOB("zep_myconid", 2.000, nFreq); // Myconid Adult [Commoner]
            MOB("zep_myconidking", 4.000, nFreq, 1, 1); // Myconid King [Commoner]
            MOB("zep_myconidspro", 0.500, nFreq); // Myconid Sprout [Commoner]
            MOB("zep_shrieker", 0.125, nFreq); // Shrieker
            MOB("zep_thorny", 3.000, nFreq); // Thorny
            MOB("zep_thornyrider", 4.000, nFreq); // Thorny Rider (Spawns Nothing On Death)
            MOB("zep_thornyridert", 4.000, nFreq); // Thorny Rider (Spawns Thorny On Death)
            MOB("zep_thornyriderv", 4.000, nFreq); // Thorny Rider (Spawns Vegepygmy On Death)
            MOB("zep_treant", 8.000, nFreq); // Treant [Commoner]
            MOB("zep_vegepygmy", 1.000, nFreq); // Vegepygmy
            MOB("zep_vegepygmyb", 3.000, nFreq); // Vegepygmy Bodyguard
            MOB("zep_vegepygmych", 5.000, nFreq, 1, 1); // Vegepygmy Chief
            MOB("zep_vegepygmysc", 4.000, nFreq); // Vegepygmy Subchief
         }
      }
      else if (sCode == "p")
      {
         // PICK RANDOM PLANAR
         if (testODBC()) sRaceList += ",20";
         else
         {
            MOB("nw_ctrumpet", 11.000, nFreq); // Celestial Avenger [Commoner]
            MOB("nw_halfcel001", 9.000, nFreq); // Half-Celestial Warrior [Commoner]
            MOB("nw_chound01", 6.000, nFreq); // Hound Archon [Commoner] [Archon]
            MOB("nw_clantern", 5.000, nFreq); // Lantern Archon [Commoner] [Archon]
            MOB("zep_lupinal1", 5.000, nFreq); // Female Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal2", 5.000, nFreq); // Female Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal3", 5.000, nFreq); // Female Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal4", 5.000, nFreq); // Female Lupinal [Defender] [Guardinal]
            MOB("zep_planetarf", 17.000, nFreq); // Female Planetar [Defender] [Aasimon]
            MOB("zep_lupinal5", 5.000, nFreq); // Male Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal6", 5.000, nFreq); // Male Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal7", 5.000, nFreq); // Male Lupinal [Defender] [Guardinal]
            MOB("zep_lupinal8", 5.000, nFreq); // Male Lupinal [Defender] [Guardinal]
            MOB("zep_planetarm", 16.000, nFreq); // Male Planetar [Defender] [Aasimon]
            MOB("zep_lolth", 74.000, nFreq, 1, 1); // Aspect Of Lolth
            MOB("zep_vecna", 54.000, nFreq, 1, 1); // Vecna
            MOB("nw_demon", 15.000, nFreq); // Balor [Tanarri]
            MOB("nw_balorboss", 16.000, nFreq); // Balor Lord [Tanarri]
            MOB("x2_spiderdemo001", 12.000, nFreq); // Bebelith [Tanarri]
            MOB("x2_erinyes", 8.000, nFreq); // Erinyes [Baatezu]
            MOB("nw_halffnd001", 8.000, nFreq); // Half-Fiend Warrior [Tanarri]
            MOB("nw_hellhound", 4.000, nFreq); // Hell Hound [Baatezu]
            MOB("nw_beastxvim", 5.000, nFreq); // Hound Of Xvim [Baatezu]
            MOB("nw_devil001", 15.000, nFreq); // Pit Fiend [Baatezu]
            MOB("x2_pitfiend001", 15.000, nFreq); // Pit Fiend [Baatezu]
            MOB("nw_rakshasa", 7.000, nFreq); // Rakshasa [Baatezu]
            MOB("nw_shmastif", 4.000, nFreq); // Shadow Mastiff
            MOB("nw_dmsucubus", 7.000, nFreq); // Succubus [Tanarri]
            MOB("nw_dmvrock", 10.000, nFreq); // Vrock [Tanarri]
            MOB("zep_abishaib_001", 8.000, nFreq); // Abishai, Black [Baatezu]
            MOB("zep_abishaib_003", 8.000, nFreq); // Abishai, Black [Baatezu]
            MOB("zep_abishaib_002", 12.000, nFreq); // Abishai, Blue [Baatezu]
            MOB("zep_abishaib_004", 12.000, nFreq); // Abishai, Blue [Baatezu]
            MOB("zep_abishaig_001", 10.000, nFreq); // Abishai, Green [Baatezu]
            MOB("zep_abishaig_002", 10.000, nFreq); // Abishai, Green [Baatezu]
            MOB("zep_abishair_001", 14.000, nFreq); // Abishai, Red [Baatezu]
            MOB("zep_abishair_002", 14.000, nFreq); // Abishai, Red [Baatezu]
            MOB("zep_abishaiw_001", 6.000, nFreq); // Abishai, White [Baatezu]
            MOB("zep_abishaiw_002", 6.000, nFreq); // Abishai, White [Baatezu]
            MOB("zep_balor_001", 15.000, nFreq); // Balor, Black [Tanarri]
            MOB("zep_balor_004", 15.000, nFreq); // Balor, Black [Tanarri]
            MOB("zep_balor_005", 15.000, nFreq); // Balor, Blue [Tanarri]
            MOB("zep_balor_006", 15.000, nFreq); // Balor, Green [Tanarri]
            MOB("zep_balor_002", 15.000, nFreq); // Balor, Ice [Tanarri]
            MOB("zep_balor_003", 15.000, nFreq); // Balor, Lightning [Tanarri]
            MOB("zep_balor_007", 15.000, nFreq); // Balor, Purple [Tanarri]
            MOB("zep_balor_008", 15.000, nFreq); // Balor, Silver [Tanarri]
            MOB("zep_balor_009", 15.000, nFreq); // Balor, Teal [Tanarri]
            MOB("zep_balor_010", 15.000, nFreq); // Balor, White [Tanarri]
            MOB("zep_balor_011", 15.000, nFreq); // Balor, Yellow [Tanarri]
            MOB("zep_balrog", 16.000, nFreq); // Balrog [Baatezu]
            MOB("zep_rakshasab", 7.000, nFreq); // Bear Rakshasa [Baatezu]
            MOB("zep_bebilithb", 13.000, nFreq); // Bebilith [Tanarri]
            MOB("zep_bebilithc", 11.000, nFreq); // Bebilith [Tanarri]
            MOB("zep_cornugon", 11.000, nFreq); // Cornugon Gold [Baatezu]
            MOB("zep_cornugona", 11.000, nFreq); // Cornugon Dun [Baatezu]
            MOB("zep_marilith", 12.000, nFreq); // Demonic Marilith [Tanarri]
            MOB("zep_dretch", 4.000, nFreq); // Dretch [Tanarri]
            MOB("zep_dretchcook", 4.000, nFreq); // Dretch, Cook [Tanarri]
            MOB("zep_erinyes", 9.000, nFreq); // Erinyes [Baatezu]
            MOB("zep_erinyes2", 10.000, nFreq); // Magma Erinyes [Baatezu]
            MOB("zep_flerinyes1", 11.000, nFreq); // Erinyes, Flying [Baatezu]
            MOB("zep_halffiendf", 2.000, nFreq); // Female Half-Fiend
            MOB("zep_gelugon", 13.000, nFreq); // Gelugon [Baatezu]
            MOB("zep_glabrezu", 14.000, nFreq); // Glabrezu [Tanarri]
            MOB("zep_cornugongr", 14.000, nFreq); // Greater Cornugon [Baatezu]
            MOB("zep_hamatula_35e", 12.000, nFreq); // Greater Hamatula [Baatezu]
            MOB("zep_hamatula", 9.000, nFreq); // Hamatula [Baatezu]
            MOB("zep_spidfiend1", 10.000, nFreq); // Kakkuu [Tanarri]
            MOB("zep_spidfiend2", 10.000, nFreq); // Lycosidilth [Tanarri]
            MOB("zep_maelephant", 10.000, nFreq); // Maelephant
            MOB("zep_halffiend", 2.000, nFreq); // Male Half-Fiend
            MOB("zep_mane", 0.500, nFreq); // Mane [Tanarri]
            MOB("zep_mane2", 0.500, nFreq); // Mane [Tanarri]
            MOB("zep_mane3", 0.500, nFreq); // Mane [Tanarri]
            MOB("zep_merilith2", 12.000, nFreq); // Marilith [Tanarri]
            MOB("zep_marilithbg", 28.000, nFreq); // Marilith Blackguard [Tanarri]
            MOB("zep_mezzoloth", 10.000, nFreq); // Mezzoloth [Yugoloth]
            MOB("zep_nabassu", 19.000, nFreq); // Nabassu [Tanarri]
            MOB("zep_nighthag", 8.000, nFreq); // Night Hag [Yugoloth]
            MOB("zep_osyluth1", 9.000, nFreq); // Osyluth Green [Baatezu]
            MOB("zep_osyluth2", 9.000, nFreq); // Osyluth Blue [Baatezu]
            MOB("zep_osyluth3", 9.000, nFreq); // Osyluth White [Baatezu]
            MOB("zep_spidfiend3", 10.000, nFreq); // Phisarazu [Tanarri]
            MOB("zep_pitfiend", 16.000, nFreq); // Pit Fiend [Baatezu]
            MOB("zep_spidfiend4", 10.000, nFreq); // Raklupis [Tanarri]
            MOB("zep_smiley", 0.500, nFreq); // Smiley
            MOB("zep_spidfiend5", 10.000, nFreq); // Spithriku [Tanarri]
            MOB("zep_succubus", 7.000, nFreq); // Succubus Nude [Tanarri]
            MOB("zep_sucubusa", 7.000, nFreq); // Succubus Clothed [Tanarri]
            MOB("zep_flsucc_001", 7.000, nFreq); // Succubus, Flying (matches nw_dmsucubus) [Tanarri]
            MOB("zep_ultroloth", 16.000, nFreq); // Ultroloth [Yugoloth]
            MOB("zep_demonvorlan", 12.000, nFreq); // Vorlan Demon
            MOB("zep_vrock", 10.000, nFreq); // Vrock [Tanarri]
            MOB("zep_rakshasaw", 7.000, nFreq); // Wolf Rakshasa [Baatezu]
            MOB("zep_yagnoloth", 12.000, nFreq); // Yagnoloth [Yugoloth]
            MOB("nw_mepair", 3.000, nFreq); // Air Mephit
            MOB("nw_mepdust", 3.000, nFreq); // Dust Mephit
            MOB("nw_mepearth", 3.000, nFreq); // Earth Mephit
            MOB("nw_mepfire", 3.000, nFreq); // Fire Mephit
            MOB("nw_mepice", 3.000, nFreq); // Ice Mephit
            MOB("nw_imp", 3.000, nFreq); // Imp [Baatezu]
            MOB("nw_mepmagma", 3.000, nFreq); // Magma Mephit
            MOB("nw_mepooze", 3.000, nFreq); // Ooze Mephit
            MOB("nw_dmquasit", 3.000, nFreq); // Quasit [Tanarri]
            MOB("nw_mepsalt", 3.000, nFreq); // Salt Mephit
            MOB("nw_mepsteam", 3.000, nFreq); // Steam Mephit
            MOB("nw_mepwater", 3.000, nFreq); // Water Mephit
            MOB("x2_azer001", 2.000, nFreq); // Azer Male [Commoner]
            MOB("x2_azer002", 2.000, nFreq); // Azer Female [Commoner]
            MOB("nw_fenhound", 4.000, nFreq); // Fenhound [Commoner]
            MOB("x0_form_myrmarch", 11.000, nFreq); // Formian Myrmarch
            MOB("x0_form_queen", 20.000, nFreq, 1, 1); // Formian Queen
            MOB("x0_form_taskmast", 7.000, nFreq); // Formian Taskmaster
            MOB("x0_form_warrior", 4.000, nFreq); // Formian Warrior
            MOB("x0_form_worker", 1.000, nFreq); // Formian Worker
            MOB("nw_tiefling02", 0.500, nFreq); // Tiefling
            MOB("zep_bladeling", 1.000, nFreq); // Bladeling
            MOB("zep_craniumrat", 1.000, nFreq); // Cranium Rat [Commoner]
            MOB("zep_dabus", 4.000, nFreq); // Dabus [Defender] [Sigil]
            MOB("zep_etherscarab", 0.500, nFreq); // Ether Scarab [Commoner]
            MOB("zep_azerfemale", 2.000, nFreq); // Female Azer [Commoner]
            MOB("zep_azermale", 2.000, nFreq); // Male Azer [Commoner]
            MOB("zep_marut", 18.000, nFreq); // Marut [Commoner]
            MOB("zep_monodrone", 0.500, nFreq); // Monodrone [Modron]
            MOB("zep_salanob", 11.000, nFreq); // Noble Salamander
            MOB("zep_sala", 6.000, nFreq); // Salamander
            MOB("zep_salaflamebro", 3.000, nFreq); // Salamander Flamebrother
            MOB("zep_secundus", 19.000, nFreq); // Secundus [Modron]
            MOB("zep_elderxorn", 11.000, nFreq); // Xorn [Commoner]
            MOB("x2_slaadblack001", 30.000, nFreq); // Black Slaad
            MOB("nw_slaadbl", 7.000, nFreq); // Blue Slaad
            MOB("nw_slaaddeth", 15.000, nFreq); // Death Slaad
            MOB("nw_slaaddthboss", 15.000, nFreq); // Death Slaad Lord
            MOB("nw_slaadgray", 10.000, nFreq); // Gray Slaad
            MOB("nw_slaadgryboss", 11.000, nFreq); // Gray Slaad Lord
            MOB("nw_slaadgrn", 9.000, nFreq); // Green Slaad
            MOB("nw_slaadred", 6.000, nFreq); // Red Slaad
            MOB("x2_slaadwhite001", 25.000, nFreq); // White Slaad
            MOB("zep_slaadgrn", 9.000, nFreq); // Green Slaad
         }
      }
      else if (sCode == "s")
      {
         // PICK RANDOM SHAPECHANGER
         if (testODBC()) sRaceList += ",23";
         else
         {
            MOB("nw_aranea", 3.000, nFreq); // Aranea
            MOB("nw_werecat001", 0.500, nFreq); // Bandit (werecat)
            MOB("nw_wererat001", 0.500, nFreq); // Bandit (wererat)
            MOB("nw_werewolf001", 0.500, nFreq); // Bandit (werewolf)
            MOB("nw_werecat", 5.000, nFreq); // Werecat
            MOB("nw_wererat", 0.500, nFreq); // Wererat
            MOB("nw_werewolf", 2.000, nFreq); // Werewolf
            MOB("zep_barghest", 5.000, nFreq); // Barghest
            MOB("zep_doppelganger", 3.000, nFreq); // Doppelganger
            MOB("zep_skulkf", 2.000, nFreq); // Female Skulk
            MOB("zep_goblinbargh", 4.000, nFreq); // Goblin (Spawns Barghest On Death)
            MOB("zep_barghestg", 8.000, nFreq); // Greater Barghest
            MOB("zep_goblinbarghg", 6.000, nFreq); // Greater Goblin (Spawns Greater Barghest On Death)
            MOB("zep_skulkm", 2.000, nFreq); // Male Skulk
            MOB("zep_werebat", 3.000, nFreq); // Werebat
            MOB("zep_werejag_001",  5.000, nFreq); // Werejaguar
            MOB("zep_werewolf_001", 2.000, nFreq); // Werewolf
         }
      }
      else if (sCode == "u")
      {
         // PICK RANDOM UNDEAD
         if (testODBC()) sRaceList += ",24";
         else
         {
            MOB("nw_ghast", 4.000, nFreq); // Ghast
            MOB("nw_ghoul", 2.000, nFreq); // Ghoul
            MOB("nw_ghoullord", 5.000, nFreq); // Ghoul Lord
            MOB("nw_ghoulboss", 10.000, nFreq); // Ghoul Ravager
            MOB("zep_iceghoul", 3.000, nFreq); // Ice Ghoul
            MOB("zep_reaver_001", 16.000, nFreq); // Reaver
            MOB("nw_mumcleric", 10.000, nFreq); // Greater Mummy
            MOB("nw_mummy", 5.000, nFreq); // Mummy
            MOB("nw_mummyboss", 11.000, nFreq); // Mummy Lord
            MOB("nw_mumfight", 10.000, nFreq); // Mummy Warrior
            MOB("zep_cjguard_001", 12.000, nFreq); // Jackal Guardian
            MOB("x2_mindflayer003", 18.000, nFreq); // Alhoon [Illithid]
            MOB("nw_lich002", 18.000, nFreq); // Baelnorn [Commoner]
            MOB("nw_bodak", 9.000, nFreq); // Bodak
            MOB("nw_curst004", 6.000, nFreq); // Curst Monk
            MOB("nw_curst003", 5.000, nFreq); // Curst Ranger
            MOB("nw_curst002", 6.000, nFreq); // Curst Rogue
            MOB("nw_curst001", 5.000, nFreq); // Curst Warrior
            MOB("x2_demilich001", 24.000, nFreq); // Demilich
            MOB("nw_doomkght", 10.000, nFreq); // Doom Knight
            MOB("nw_doomkghtboss", 15.000, nFreq); // Doom Knight Commander
            MOB("x2_dracolich001", 43.000, nFreq); // Dracolich
            MOB("nw_lich001", 28.000, nFreq); // Lich
            MOB("nw_lich003", 17.000, nFreq); // Lich
            MOB("nw_lichboss", 21.000, nFreq); // Lich
            MOB("nw_mohrg", 12.000, nFreq); // Mohrg
            MOB("nw_revenant001", 7.000, nFreq); // Revenant
            MOB("nw_skeldevour", 13.000, nFreq); // Skeletal Devourer
            MOB("nw_vampire", 6.000, nFreq); // Vampire
            MOB("nw_vampire003", 16.000, nFreq); // Vampire Mage
            MOB("nw_vampire004", 13.000, nFreq); // Vampire Priest
            MOB("nw_vampire002", 13.000, nFreq); // Vampire Rogue
            MOB("nw_vampire001", 12.000, nFreq); // Vampire Warrior
            MOB("nw_wight", 4.000, nFreq); // Wight
            MOB("zep_batbattle", 4.000, nFreq); // Battle Bat
            MOB("zep_batbone", 4.000, nFreq); // Bone Bat
            MOB("zep_dklord_001", 20.000, nFreq); // Dark Lord
            MOB("zep_demi_lich", 20.000, nFreq); // Demi Lich
            MOB("zep_dracolich", 42.000, nFreq); // Dracolich
            MOB("zep_ghostpirate", 5.000, nFreq); // Ghost Pirate
            MOB("zep_ghostf_001", 7.000, nFreq); // Ghost, Female - Blue
            MOB("zep_ghostf_002", 7.000, nFreq); // Ghost, Female - Green
            MOB("zep_ghostf_003", 7.000, nFreq); // Ghost, Female - Red
            MOB("zep_ghostf_007", 7.000, nFreq); // Ghost, Female Black-Green
            MOB("zep_ghostf_008", 7.000, nFreq); // Ghost, Female Black-Blue
            MOB("zep_ghostf_009", 7.000, nFreq); // Ghost, Female Black-Red
            MOB("zep_ghostf_004", 7.000, nFreq); // Ghost, Female Gray-Blue
            MOB("zep_ghostf_005", 7.000, nFreq); // Ghost, Female Gray-Blue
            MOB("zep_ghostf_006", 7.000, nFreq); // Ghost, Female Gray-Blue
            MOB("zep_ghostf_010", 7.000, nFreq); // Ghost, Male - Blue
            MOB("zep_ghostf_011", 7.000, nFreq); // Ghost, Male - Green
            MOB("zep_ghostf_012", 7.000, nFreq); // Ghost, Male - Red
            MOB("zep_ghostf_016", 7.000, nFreq); // Ghost, Male Black-Green
            MOB("zep_ghostf_017", 7.000, nFreq); // Ghost, Male Black-Blue
            MOB("zep_ghostf_018", 7.000, nFreq); // Ghost, Male Black-Red
            MOB("zep_ghostf_013", 7.000, nFreq); // Ghost, Male Gray-Blue
            MOB("zep_ghostf_014", 7.000, nFreq); // Ghost, Male Gray-Blue
            MOB("zep_ghostf_015", 7.000, nFreq); // Ghost, Male Gray-Blue
            MOB("zep_flvampf_001", 14.000, nFreq); // Vampire Rogue, Flying
            MOB("zep_flvampm_001", 13.000, nFreq); // Vampire Warrior, Flying
            MOB("zep_wendigo", 8.000, nFreq); // Wendigo
            MOB("nw_vampire_shad", 3.000, nFreq); // Vampire Gaseous Form
            MOB("nw_shadow", 3.000, nFreq); // Shadow
            MOB("nw_shfiend", 7.000, nFreq); // Shadow Fiend
            MOB("zep_shade001", 4.000, nFreq); // Hooded Shade
            MOB("zep_shade", 2.000, nFreq); // Shade
            MOB("zep_vampireshad", 3.000, nFreq); // Vampiric Mist
            MOB("nw_skeleton", 0.500, nFreq); // Skeleton
            MOB("nw_skelchief", 7.000, nFreq); // Skeleton Chieftain
            MOB("nw_skelmage", 4.000, nFreq); // Skeleton Mage
            MOB("nw_skelpriest", 4.000, nFreq); // Skeleton Priest
            MOB("nw_skelwarr01", 6.000, nFreq); // Skeleton Warrior w/Sword
            MOB("nw_skelwarr02", 6.000, nFreq); // Skeleton Warrior w/Axe
            MOB("zep_skelredeyes", 5.000, nFreq); // Bone Medusa
            MOB("zep_skelflaming", 3.000, nFreq); // Flaming Dead
            MOB("zep_skelpurple", 3.000, nFreq); // Lifestealer
            MOB("zep_skelgreen", 3.000, nFreq); // Poisonous Dead
            MOB("zep_skelyellow", 3.000, nFreq); // Restless Dead
            MOB("zep_skeldoll2", 0.500, nFreq); // Skeletal Doll w/Crossbow
            MOB("zep_skeldolls", 0.500, nFreq); // Skeletal Doll w/Spear
            MOB("zep_skeldwarf", 1.000, nFreq); // Skeletal Dwarf w/Axe
            MOB("zep_skeldwarf2", 1.000, nFreq); // Skeletal Dwarf w/Crossbow
            MOB("zep_skelogre", 3.000, nFreq); // Skeletal Ogre
            MOB("zep_skelpir1", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skelpir2", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skelpir3", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skelpir4", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skelpir5", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skelpir6", 4.000, nFreq); // Skeleton Pirate
            MOB("zep_skeldyn_001", 6.000, nFreq); // Skeleton, Dynamic
            MOB("nw_allip", 3.000, nFreq); // Allip
            MOB("nw_spectre", 6.000, nFreq); // Spectre
            MOB("nw_wraith", 5.000, nFreq); // Wraith
            MOB("zep_visagegr", 7.000, nFreq); // Greater Visage
            MOB("zep_wraith1", 8.000, nFreq); // Hooded Wraith
            MOB("zep_wraith2", 8.000, nFreq); // Hooded Wraith
            MOB("zep_visage", 5.000, nFreq); // Visage
            MOB("nw_zombtyrant", 3.000, nFreq); // Tyrantfog Zombie
            MOB("nw_zombie01", 1.000, nFreq); // Zombie
            MOB("nw_zombie02", 1.000, nFreq); // Zombie Decayed
            MOB("nw_zombieboss", 8.000, nFreq); // Zombie Lord
            MOB("nw_zombwarr01", 4.000, nFreq); // Zombie Warrior Barechested
            MOB("nw_zombwarr02", 4.000, nFreq); // Zombie Warrior w/Armor
            MOB("zep_zombpir1", 4.000, nFreq); // Zombie Pirate
            MOB("zep_zombpir2", 4.000, nFreq); // Zombie Pirate
            MOB("zep_zombpir3", 4.000, nFreq); // Zombie Pirate
            MOB("zep_zombpir5", 4.000, nFreq); // Zombie Pirate
         }
      }
      else if (sCode == "b")
      {
         // PICK RANDOM BANDIT
         if (testODBC()) sRaceList += ",0,1,2,3,4,5,6";
         else
         {
            MOB("x2_duergar002", 4.000, nFreq, 1, 1); // Duergar Chief
            MOB("x2_duergar003", 8.000, nFreq, 1, 1); // Duergar Chief
            MOB("x2_duergar004", 10.000, nFreq, 1, 1); // Duergar Chief
            MOB("x2_duergar005", 13.000, nFreq, 1, 1); // Duergar Chief
            MOB("nw_duecler001", 1.000, nFreq); // Duergar Cleric
            MOB("nw_duecler005", 4.000, nFreq); // Duergar Cleric
            MOB("nw_duecler010", 8.000, nFreq); // Duergar Cleric
            MOB("nw_duecler015", 11.000, nFreq); // Duergar Cleric
            MOB("nw_duecler020", 15.000, nFreq); // Duergar Cleric
            MOB("nw_duemage001", 1.000, nFreq); // Duergar Mage
            MOB("nw_duemage005", 4.000, nFreq); // Duergar Mage
            MOB("nw_duemage010", 7.000, nFreq); // Duergar Mage w/Dagger
            MOB("nw_duemage015", 11.000, nFreq); // Duergar Mage w/Dagger
            MOB("nw_duemage020", 14.000, nFreq); // Duergar Mage w/Staff
            MOB("x2_mephduer007", 7.000, nFreq); // Duergar Mage w/Crossbow
            MOB("x2_mephduer008", 12.000, nFreq); // Duergar Mage w/Crossbow
            MOB("x2_mephduer009", 17.000, nFreq); // Duergar Mage w/Crossbow
            MOB("x2_mephduer010", 8.000, nFreq); // Duergar Priestess
            MOB("x2_mephduer011", 13.000, nFreq); // Duergar Priestess
            MOB("x2_mephduer012", 18.000, nFreq); // Duergar Priestess
            MOB("nw_duerogue001", 1.000, nFreq); // Duergar Rogue
            MOB("nw_duerogue005", 4.000, nFreq); // Duergar Rogue
            MOB("nw_duerogue010", 7.000, nFreq); // Duergar Rogue w/Crossbow
            MOB("nw_duerogue015", 10.000, nFreq); // Duergar Rogue w/Crossbow
            MOB("nw_duerogue020", 13.000, nFreq); // Duergar Rogue w/Crossbow
            MOB("x2_mephduer004", 7.000, nFreq); // Duergar Rogue w/Scimitars
            MOB("x2_mephduer005", 12.000, nFreq); // Duergar Rogue w/Scimitars
            MOB("x2_mephduer006", 17.000, nFreq); // Duergar Rogue w/Scimitars
            MOB("x2_duergar001", 0.250, nFreq); // Duergar Slaver [Commoner]
            MOB("nw_duefight001", 1.000, nFreq); // Duergar Warrior
            MOB("nw_duefight005", 4.000, nFreq); // Duergar Warrior
            MOB("nw_duefight010", 7.000, nFreq); // Duergar Warrior w/Axe
            MOB("nw_duefight015", 11.000, nFreq); // Duergar Warrior w/Hammers
            MOB("nw_duefight020", 14.000, nFreq); // Duergar Warrior w/Morningstar
            MOB("x2_mephduer001", 8.000, nFreq); // Duergar Warrior w/Axe+Shield
            MOB("x2_mephduer002", 12.000, nFreq); // Duergar Warrior w/Axe+Shield
            MOB("x2_mephduer003", 17.000, nFreq); // Duergar Warrior w/Axe+Shield
            MOB("nw_dwarfmerc001", 0.500, nFreq); // Dwarf Mercenary
            MOB("nw_dwarfmerc002", 2.000, nFreq); // Dwarf Mercenary
            MOB("nw_dwarfmerc003", 4.000, nFreq); // Dwarf Mercenary
            MOB("nw_dwarfmerc004", 7.000, nFreq); // Dwarf Mercenary
            MOB("nw_dwarfmerc005", 9.000, nFreq); // Dwarf Mercenary
            MOB("nw_dwarfmerc006", 13.000, nFreq); // Dwarf Mercenary
            MOB("nw_drowrogue001", 1.000, nFreq); // Drow Assassin [Drow]
            MOB("nw_drowrogue005", 3.000, nFreq); // Drow Assassin [Drow]
            MOB("nw_drowrogue010", 7.000, nFreq); // Drow Assassin [Drow]
            MOB("nw_drowrogue015", 10.000, nFreq); // Drow Assassin [Drow]
            MOB("nw_drowrogue020", 13.000, nFreq); // Drow Assassin [Drow]
            MOB("nw_drowmage001", 1.000, nFreq); // Drow Mage w/Dagger [Drow]
            MOB("nw_drowmage005", 4.000, nFreq); // Drow Mage w/Dagger [Drow]
            MOB("nw_drowmage010", 7.000, nFreq); // Drow Mage w/Dagger [Drow]
            MOB("nw_drowmage015", 11.000, nFreq); // Drow Mage w/Dagger [Drow]
            MOB("nw_drowmage020", 14.000, nFreq); // Drow Mage w/Staff [Drow]
            MOB("x2_mephdrow010", 7.000, nFreq); // Drow Mage w/Crossbow [Drow]
            MOB("x2_mephdrow011", 11.000, nFreq); // Drow Mage w/Crossbow [Drow]
            MOB("x2_mephdrow012", 14.000, nFreq); // Drow Mage w/Crossbow [Drow]
            MOB("nw_drowfight001", 1.000, nFreq); // Drow Militia [Drow]
            MOB("nw_drowfight005", 4.000, nFreq); // Drow Militia [Drow]
            MOB("nw_drowfight010", 8.000, nFreq); // Drow Militia [Drow]
            MOB("nw_drowfight015", 11.000, nFreq); // Drow Militia [Drow]
            MOB("nw_drowfight020", 15.000, nFreq); // Drow Militia [Drow]
            MOB("nw_drowcler001", 1.000, nFreq); // Drow Priestess w/Mace [Drow]
            MOB("nw_drowcler005", 4.000, nFreq); // Drow Priestess w/Mace [Drow]
            MOB("nw_drowcler010", 8.000, nFreq); // Drow Priestess w/Mace [Drow]
            MOB("nw_drowcler015", 11.000, nFreq); // Drow Priestess w/Club [Drow]
            MOB("nw_drowcler020", 15.000, nFreq); // Drow Priestess w/Mace [Drow]
            MOB("x2_mephdrow013", 8.000, nFreq); // Drow Priestess w/Axe [Drow]
            MOB("x2_mephdrow014", 13.000, nFreq); // Drow Priestess w/Axe [Drow]
            MOB("x2_mephdrow015", 18.000, nFreq); // Drow Priestess w/Axe [Drow]
            MOB("x2_mephdrow001", 7.000, nFreq); // Drow Rogue [Drow]
            MOB("x2_mephdrow002", 11.000, nFreq); // Drow Rogue [Drow]
            MOB("x2_mephdrow003", 18.000, nFreq); // Drow Rogue [Drow]
            MOB("x2_drow001", 0.500, nFreq); // Drow Slave [Commoner] [Drow]
            MOB("x2_mephdrow004", 8.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_mephdrow005", 13.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_mephdrow006", 20.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_mephdrow007", 8.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_mephdrow008", 13.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_mephdrow009", 20.000, nFreq); // Drow Warrior [Drow]
            MOB("x2_drow002", 4.000, nFreq); // Drow Wizard [Drow]
            MOB("x2_drow003", 7.000, nFreq); // Drow Wizard [Drow]
            MOB("x2_drow004", 11.000, nFreq); // Drow Wizard [Drow]
            MOB("x2_drow005", 15.000, nFreq); // Drow Wizard [Drow]
            MOB("nw_elfmerc001", 2.000, nFreq); // Elf Mercenary
            MOB("nw_elfmerc002", 4.000, nFreq); // Elf Mercenary
            MOB("nw_elfmerc003", 6.000, nFreq); // Elf Mercenary
            MOB("nw_elfmerc004", 9.000, nFreq); // Elf Mercenary
            MOB("nw_elfmerc005", 11.000, nFreq); // Elf Mercenary
            MOB("nw_elfmerc006", 14.000, nFreq); // Elf Mercenary
            MOB("nw_elfranger001", 0.500, nFreq); // Elf Ranger
            MOB("nw_elfranger005", 4.000, nFreq); // Elf Ranger
            MOB("nw_elfranger015", 11.000, nFreq); // Elf Ranger
            MOB("zep_blackrosef", 3.000, nFreq); // Female Blackrose Elf
            MOB("zep_blackrosem", 3.000, nFreq); // Male Blackrose Elf
            MOB("nw_halfling015", 10.000, nFreq); // Halfling
            MOB("nw_halfmerc001", 1.000, nFreq); // Halfling Mercenary
            MOB("nw_halfmerc002", 3.000, nFreq); // Halfling Mercenary
            MOB("nw_halfmerc003", 5.000, nFreq); // Halfling Mercenary
            MOB("nw_halfmerc004", 7.000, nFreq); // Halfling Mercenary
            MOB("nw_halfmerc005", 10.000, nFreq); // Halfling Mercenary
            MOB("nw_halfmerc006", 13.000, nFreq); // Halfling Mercenary
            MOB("nw_bandit006", 7.000, nFreq); // Half-Orc Bandit
            MOB("nw_bandit001", 0.500, nFreq); // Bandit
            MOB("nw_bandit002", 0.500, nFreq); // Bandit Archer
            MOB("nw_bandit007", 11.000, nFreq, 1, 1); // Bandit Chief
            MOB("nw_bandit004", 3.000, nFreq); // Bandit Cleric
            MOB("nw_bandit005", 4.000, nFreq); // Bandit Mage
            MOB("nw_bandit003", 1.000, nFreq); // Bandit Rogue
            MOB("nw_gypsy006", 11.000, nFreq, 1, 1); // Gypsy Chief
            MOB("nw_gypsy005", 8.000, nFreq); // Gypsy Healer
            MOB("nw_gypsy004", 4.000, nFreq); // Gypsy Mage
            MOB("nw_gypsy007", 10.000, nFreq); // Gypsy Mage
            MOB("nw_gypsy002", 0.500, nFreq); // Gypsy Rogue
            MOB("nw_gypsy001", 0.500, nFreq); // Gypsy Warrior
            MOB("nw_gypsy003", 4.000, nFreq); // Gypsy Warrior
            MOB("nw_gypfemale", 0.250, nFreq); // Gypsy Female
            MOB("nw_gypmale", 0.250, nFreq); // Gypsy Male
            MOB("nw_humanmerc001", 2.000, nFreq); // Human Mercenary
            MOB("nw_humanmerc002", 3.000, nFreq); // Human Mercenary
            MOB("nw_humanmerc003", 6.000, nFreq); // Human Mercenary
            MOB("nw_humanmerc004", 9.000, nFreq); // Human Mercenary
            MOB("nw_humanmerc005", 12.000, nFreq); // Human Mercenary
            MOB("nw_humanmerc006", 15.000, nFreq); // Human Mercenary
            MOB("zep_pygmy_001", 0.500, nFreq); // Pygmy Archer
            MOB("zep_pygmy_002", 4.000, nFreq); // Pygmy Champion
            MOB("zep_pygmy_003", 7.000, nFreq); // Pygmy Chief
            MOB("zep_pygmy_004", 0.500, nFreq); // Pygmy Warrior
            MOB("zep_tieflingf1", 7.000, nFreq); // Female Tiefling
            MOB("zep_feyri", 1.000, nFreq); // Fey'ri
            MOB("zep_tiefling3", 5.000, nFreq); // Male Tiefling
            MOB("zep_tieflingf2", 7.000, nFreq); // Noble Female Tiefling
            MOB("zep_tieflingm4", 5.000, nFreq); // Noble Male Tiefling
            MOB("zep_wemic1", 5.000, nFreq, 1, 10); // Female Wemic
            MOB("zep_wemicf2", 5.000, nFreq, 1, 10); // Female Wemic
            MOB("zep_wemic2", 5.000, nFreq, 1, 10); // Male Wemic
            MOB("zep_wemicm2", 5.000, nFreq, 1, 10); // Male Wemic
         }
      }

      if (bCustom &&
          (sCode == "0" ||
           StringToInt(GetSubString(sCreatureTable, nLoop, 1)) > 0
          )
         )
      {
         // PICK RANDOM CREATURE FROM CUSTOM TABLE
         //debug("custom table");
         sBuild = sBuild + GetSubString(sCreatureTable, nLoop, 1);
         //debugVarString("sBuild", sBuild);
      }
      else if (bCustom)
      {
         if (testODBC())
         {
            sSQLWhere +=
               " AND resref IN " +
                       "( SELECT resref " +
                           "FROM nwn_encounter$creatures " +
                          "WHERE encounter_id = " + sBuild +
                        ") ";
         }
         else
         {
            //debugVarInt("setting iVarNum", iVarNum);
            SetLocalInt(OBJECT_SELF, "re_iVarNum", iVarNum);
            SetLocalFloat(OBJECT_SELF, "re_fMinCR", fMinCR);
            SetLocalFloat(OBJECT_SELF, "re_fMaxCR", fMaxCR);
            //debug("executing re_custom" + sBuild);
            ExecuteScript("re_custom" + sBuild, OBJECT_SELF);
            iVarNum = GetLocalInt(OBJECT_SELF, "re_iVarNum");
            DeleteLocalInt(OBJECT_SELF, "re_iVarNum");
            DeleteLocalFloat(OBJECT_SELF, "re_fMinCR");
            DeleteLocalFloat(OBJECT_SELF, "re_fMaxCR");
            bCustom = FALSE;
            sBuild = "";
         }
      }

      if (sCode == "x")
      {
         //debug("x: bCustom = true");
         bCustom = TRUE;
      }

      if (bCommoner &&
          (sCode == "0" ||
           StringToInt(GetSubString(sCreatureTable, nLoop, 1)) > 0
          )
         )
      {
         // PICK RANDOM CREATURE FROM COMMONER TABLE (For the commoner spawner)
         //debug("commoner table");
         sBuild = sBuild + GetSubString(sCreatureTable, nLoop, 1);
         //debugVarString("sBuild", sBuild);
      }
      else if (bCommoner)
      {
         if (testODBC())
         {
            sSQLWhere +=
               " AND resref IN " +
                       "( SELECT resref " +
                           "FROM nwn_commoner$creatures " +
                          "WHERE commoner_id = " + sBuild +
                        ") ";
         }
         else
         {
            //debug("executing commoner script " + sBuild);
            ExecuteScript("re_commoner" + sBuild, OBJECT_SELF);
            iVarNum = GetLocalInt(OBJECT_SELF, "re_iVarNum");
            DeleteLocalInt(OBJECT_SELF, "re_iVarNum");
            bCommoner = FALSE;
            sBuild = "";
         }
      }

      if (sCode == "z")
      {
         //debug("z: bCommoner = true");
         bCommoner = TRUE;
      }
   }

   if (bCommoner)
   {
      sSQLWhere +=
         " AND faction_id IN (2,3,4) ";
   }
   else
   {
      sSQLWhere +=
         " AND faction_id = 1 " +
         " AND cr BETWEEN " + FloatToString(fMinCR) + " AND " +
              FloatToString(fMaxCR) + " ";
   }

   // SELECT THE RANDOM CREATURE
   string sCreature = "";
   if (testODBC())
   {
      string sSQL =
         "SELECT resref " +
           "FROM nwn_creatures " +
          "WHERE race_id IN (" + sRaceList + ") " +
            "AND " +
              "( module_name IS NULL " +
             "OR module_name IN ('Bioware','CEP','" + GetModuleName() + "') " +
              ") " + sSQLWhere +
          "ORDER BY rand() LIMIT 1 ";
      SQLExecDirect(sSQL);
      if (SQLFetch() == SQL_SUCCESS) sCreature = SQLGetData(1);
      if (sCreature == "")
      {
         logError("ERROR: BESIE encounter creature not chosen for " +
            objectToString(OBJECT_SELF) + " in " +
            GetName(GetArea(OBJECT_SELF)) + "; SQL=" + sSQL);
         return "";
      }
   }
   else
   {
      //debugVarInt("iVarNum", iVarNum);
      //debugVarInt("var iVarNum", GetLocalInt(OBJECT_SELF, "re_iVarNum"));
      if (! iVarNum)
      {
         logError("ERROR: BESIE encounter creature not chosen for " +
            objectToString(OBJECT_SELF) + " in " + GetName(GetArea(OBJECT_SELF)));
         return "";
      }
      int iRnd = Random(iVarNum);
      sCreature = GetLocalString(oModule, "re_sCreatureList" +
         IntToString(iRnd));
      //debugVarString("sCreature", sCreature);
      // Copy the Min and Max number of creatures from the corresponding
      // simulated "array" to the root variable in the module object.
      SetLocalInt(oModule, "re_iMinNumberOfCreatures",
         GetLocalInt(oModule, "re_iMinNumberOfCreatures" + IntToString(iRnd)));
      SetLocalInt(oModule, "re_iMaxNumberOfCreatures",
         GetLocalInt(oModule, "re_iMaxNumberOfCreatures" + IntToString(iRnd)));
   }
   // Reset the local module variables that store min and max number
   // of creatures so we don't use old numbers at a later time.
   for (nLoop = 1; nLoop <= iVarNum; nLoop++)
   {
      DeleteLocalInt(oModule, "re_iMinNumberOfCreatures" + IntToString(nLoop));
      DeleteLocalInt(oModule, "re_iMaxNumberOfCreatures" + IntToString(nLoop));
   }
   return sCreature;
}

// Returns TRUE if we should only do housecleaning, FALSE if encounters are wanted.
int besieInit(string sToolType)
{
   if (!GetLocalInt(OBJECT_SELF, "re_BESIE"))
   {
      SetLocalInt(OBJECT_SELF, "re_BESIE", TRUE);
      SetLocalString(OBJECT_SELF, "re_ToolType", sToolType);
   }
   string sVarName = "re_disable" + sToolType;
   if (GetLocalInt(GetModule(), sVarName) ||
       GetLocalInt(GetArea(OBJECT_SELF), sVarName) ||
       GetLocalInt(OBJECT_SELF, "re_disable"))
   {
      object oHouseCleaner = GetLocalObject(GetArea(OBJECT_SELF),
         "re_oHouseCleaner");
      if (!GetIsObjectValid(oHouseCleaner))
      {
         oHouseCleaner = OBJECT_SELF;
         SetLocalObject(GetArea(OBJECT_SELF), "re_oHouseCleaner", oHouseCleaner);
      }
      if (GetLocalObject(GetArea(OBJECT_SELF), "re_oHouseCleaner") ==
         OBJECT_SELF)
      {
         cleanHouse();
      }
      return TRUE;
   }
   return FALSE;
}

//void main() {} // testing/compiling purposes
