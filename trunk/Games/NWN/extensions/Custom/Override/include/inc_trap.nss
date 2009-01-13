void randomTrap(object obj);
void randomTrapArea();
void onTrapDisarm(object obj);
struct trap getLocalTrap(object oObject, string sVarName);
void deleteLocalTrap(object oObject, string sVarName);
struct trap createRandomTrap(int nCR = -1);
string trapToString(struct trap tTrap);
object createPRGTTrapAtLocation(location lLoc, struct trap tTrap);
void createPRGTTrapOnObject(object oObjectToTrap, struct trap tTrap);

// Variable which determines what percentage of doors/placeables are trapped
const string VAR_TRAP_CHANCE = "TRAP_CHANCE";
// Variable containing an object's trap ID
const string VAR_TRAP_ID = "TrapSettings";

// Blatantly stolen from PrC's respawnable traps
struct trap
{
//DC to detect the trap
    int nDetectDC;
//DC to disarm the trap
//By PnP only rogues can disarm traps over DC 35?
    int nDisarmDC;
//this is the script that is fired when the trap is
//triggered
    string sTriggerScript;
//this is the script that is fired when the trap is
//disarmed
    string sDisarmScript;
//if the trap casts a spell when triggered
//these control the details
    int nSpellID;
    int nSpellLevel;
    int nSpellMetamagic;
    int nSpellDC;
//these are for normal dmaging type traps
    int nDamageType;
    int nRadius;
    int nDamageDice;
    int nDamageSize;
    int nDamageBonus;
//visual things
    int nTargetVFX;
    int nTrapVFX;
    int nBeamVFX;
    int nFakeSpell;
    int nFakeSpellLoc;
//saves for half
    int nAllowReflexSave;
    int nAllowFortSave;
    int nAllowWillSave;
    int nSaveDC;
//this is a mesure of CR of the trap
//can be used by XP scripts
    int nCR;
//delay before respawning once destroyed/disarmed
    int nRespawnSeconds;
//CR passed to CreateRandomTrap when respawning
//if not set, uses same trap as before
    int nRespawnRandomCR;
//this is the size of the trap on the ground
//if zero, 2.0 is used
    float fSize;
};

#include "inc_debug_dac"
#include "inc_fof"
#include "inc_heartbeat"
#include "inc_persistworld"
#include "inc_variables"
#include "inc_area"
#include "prc_misc_const"

void randomTrap(object obj)
{
   //debugVarObject("randomTrap()", OBJECT_SELF);
   //debugVarObject("obj", obj);
   // If a trap is undetectable, the object is plot-driven so leave it alone
   //if (! GetTrapDetectable(obj)) return;
   // If a trap is key-enabled, the object is plot-driven so leave it alone
   //if (GetTrapKeyTag(obj) != "") return;

   // Set unlock difficulty
   int nDC = GetTrapDisarmDC(obj);
   // This value is not set to zero by default, so it must have been on purpose
//   if (nDC == 0) return;

   int nTrapChance = getVarInt(obj, VAR_TRAP_CHANCE);
   //debugVarInt("nTrapChance", nTrapChance);
   if (d100() > nTrapChance) return;

   //debug("Trapping " + GetName(obj));
   struct trap tTrap = createRandomTrap();
   tTrap.nRespawnSeconds = FloatToInt(getRespawnDelay(obj) * DURATION_1_ROUND);
   //debug("tTrap = " + trapToString(tTrap));
   if (GetArea(obj) == OBJECT_INVALID)
   {
      // Likely it's an area itself, so create a location trap.
      createPRGTTrapAtLocation(getRandomLocation(OBJECT_SELF), tTrap);
   }
   else
   {
      // We are a placeable (or possibly a creature or PC, but unlikely).
      createPRGTTrapOnObject(obj, tTrap);
   }

/*
   // Randomly adjust up or down by 0 to 3
   nDC += Random(7) - 3;
   // Sanity check: value must be between 1 and 250
   nDC = (nDC < 1 ? 1 : nDC);
   nDC = (nDC > 250 ? 250 : nDC);
   // Choose a trap type
   int nTrapType = TRAP_BASE_TYPE_MINOR_SPIKE; // sanity check default value
   // @FIX: scale for all PCs in the area
   object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   int nLevel = GetHitDice(oPC);
   switch(Random(11))
   {
      case 0:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_ACID;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_ACID;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_ACID;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_ACID;
         break;
      case 1:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_ACID_SPLASH;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_ACID_SPLASH;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;
         break;
      case 2:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_ELECTRICAL;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_ELECTRICAL;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_ELECTRICAL;
         else if (nLevel < 21) nTrapType = TRAP_BASE_TYPE_DEADLY_ELECTRICAL;
         else nTrapType = TRAP_BASE_TYPE_EPIC_ELECTRICAL;
         break;
      case 3:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_FIRE;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_FIRE;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_FIRE;
         else if (nLevel < 21) nTrapType = TRAP_BASE_TYPE_DEADLY_FIRE;
         else nTrapType = TRAP_BASE_TYPE_EPIC_FIRE;
         break;
      case 4:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_FROST;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_FROST;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_FROST;
         else if (nLevel < 21) nTrapType = TRAP_BASE_TYPE_DEADLY_FROST;
         else nTrapType = TRAP_BASE_TYPE_EPIC_FROST;
         break;
      case 5:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_GAS;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_GAS;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_GAS;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_GAS;
         break;
      case 6:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_HOLY;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_HOLY;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_HOLY;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_HOLY;
         break;
      case 7:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_NEGATIVE;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_NEGATIVE;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_NEGATIVE;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_NEGATIVE;
         break;
      case 8:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_SONIC;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_SONIC;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_SONIC;
         else if (nLevel < 21) nTrapType = TRAP_BASE_TYPE_DEADLY_SONIC;
         else nTrapType = TRAP_BASE_TYPE_EPIC_SONIC;
         break;
      case 9:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_SPIKE;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_SPIKE;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_SPIKE;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_SPIKE;
         break;
      case 10:
         if (nLevel < 6) nTrapType = TRAP_BASE_TYPE_MINOR_TANGLE;
         else if (nLevel < 11) nTrapType = TRAP_BASE_TYPE_AVERAGE_TANGLE;
         else if (nLevel < 16) nTrapType = TRAP_BASE_TYPE_STRONG_TANGLE;
         else nTrapType = TRAP_BASE_TYPE_DEADLY_TANGLE;
         break;
   }
   // Finally, set the trap
   CreateTrapOnObject(nTrapType, obj, STANDARD_FACTION_HOSTILE, "on_trap_disarm");
   SetTrapRecoverable(obj, TRUE);
   SetTrapOneShot(obj, TRUE);
   SetTrapDetectable(obj, TRUE);
   SetTrapActive(obj, TRUE);
   SetTrapDisarmDC(obj, nDC);
   // It's easier to detect than to disarm
   SetTrapDetectDC(obj, nDC / 2);
*/
}

void randomTrapArea()
{
   //debugVarObject("randomTrapArea()", OBJECT_SELF);
   int nTrapChance = getVarInt(OBJECT_SELF, VAR_TRAP_CHANCE);
   //debugVarInt("nTrapChance", nTrapChance);
   if (nTrapChance == NEVER) return;

   object obj = GetFirstObjectInArea();
   while (obj != OBJECT_INVALID)
   {
      nTrapChance = getVarInt(obj, VAR_TRAP_CHANCE);
      //debugVarInt("Trap chance for " + GetName(obj), nTrapChance);
      int nObjType = GetObjectType(obj);
      switch(nObjType)
      {
         case OBJECT_TYPE_DOOR:
            //debugVarObject("processing door", obj);
            if (Random(100) < nTrapChance)
            {
               randomTrap(obj);
            }
            break;
         case OBJECT_TYPE_PLACEABLE:
            //debugVarObject("processing placeable", obj);
            if (Random(100) < nTrapChance)
            {
               randomTrap(obj);
            }
            break;
      }
      obj = GetNextObjectInArea();
   }

   // For every 10% of trap chance, 1 random floor trap.  Note that this
   // allows you to do nasty, evil, vicious, PC-killing things like setting
   // TRAP_CHANCE = 5000%.  Bwah-ha-ha-ha!
   object oArea = GetArea(OBJECT_SELF);
   int nAreaTraps = nTrapChance / 10;
   //debugVarInt("nAreaTraps", nAreaTraps);
   for (; nAreaTraps > 0; nAreaTraps--)
   {
      //debugVarObject("Creating floor trap in", oArea);
      createPRGTTrapAtLocation(getRandomLocation(oArea), createRandomTrap());
   }
}

void onTrapDisarm(object obj)
{
   //debugVarObject("onTrapDisarm()", OBJECT_SELF);
   //debugVarObject("obj", obj);
   struct trap tTrap = getLocalTrap(obj, VAR_TRAP_ID);
   //debugVarString("tTrap", trapToString(tTrap));
   int nDC = (tTrap.nDisarmDC == 0 ? GetTrapDisarmDC(obj) : tTrap.nDisarmDC);
   //debugVarInt("nDC", nDC);
   object oDisarmer = GetLastDisarmed();
   //debugVarObject("oDisarmer", oDisarmer);
   if (GetIsPC(oDisarmer))
   {
      GiveXPToCreature(oDisarmer, nDC);
   }

   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   if (fDelay > 0.0)
   {
      DelayCommand(fDelay, ExecuteScript("trap_reset_self", OBJECT_SELF));
   }
}

struct trap createRandomTrap(int nCR = -1)
{
   //debugVarObject("createRandomTrap()", OBJECT_SELF);
   //debugVarInt("nCR", nCR);

   if (nCR == -1)
   {
      object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
      if (oPC == OBJECT_INVALID) oPC = GetFirstPC();
      nCR = FloatToInt(getCR(oPC));
      nCR += Random(11) - 5;
      if (nCR < 1) nCR = 1;
      //debugVarInt("nCR", nCR);
   }
   struct trap tReturn;
   switch(Random(26))
   {
      case 0: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 1: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 2: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 3: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 4: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 5: tReturn.nDamageType = DAMAGE_TYPE_PIERCING; break;
      case 6: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 7: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 8: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 9: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 10: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 11: tReturn.nDamageType = DAMAGE_TYPE_BLUDGEONING; break;
      case 12: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 13: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 14: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 15: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 16: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 17: tReturn.nDamageType = DAMAGE_TYPE_SLASHING; break;
      case 18: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
      case 19: tReturn.nDamageType = DAMAGE_TYPE_FIRE; break;
      case 20: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
      case 21: tReturn.nDamageType = DAMAGE_TYPE_COLD; break;
      case 22: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
      case 23: tReturn.nDamageType = DAMAGE_TYPE_ELECTRICAL; break;
      case 24: tReturn.nDamageType = DAMAGE_TYPE_ACID; break;
      case 25: tReturn.nDamageType = DAMAGE_TYPE_SONIC; break;
   }
   tReturn.nRadius = 5 + (nCR / 2);
   tReturn.nDamageDice = 1 + (nCR / 2);
   tReturn.nDamageSize = 6;
   tReturn.nDamageBonus = 0;
   tReturn.nDetectDC = 15 + nCR;
   tReturn.nDisarmDC = 15 + nCR;
   tReturn.nCR = nCR;
   tReturn.nRespawnSeconds = 0;
   tReturn.nRespawnRandomCR = nCR;
   tReturn.sTriggerScript = "prgt_on_trigger";
   tReturn.sDisarmScript = "trap_on_disarm";
   tReturn.fSize = 2.0;

   switch(tReturn.nDamageType)
   {
      case DAMAGE_TYPE_BLUDGEONING:
         tReturn.nFakeSpellLoc = 773; // Boulder tossing
         tReturn.nRadius /= 2;
         tReturn.nDamageDice *= 2;
         tReturn.nAllowReflexSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_SLASHING:
         tReturn.nTrapVFX = VFX_FNF_SWINGING_BLADE;
         tReturn.nRadius /= 2;
         tReturn.nDamageSize *= 2;
         tReturn.nAllowReflexSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_PIERCING:
         tReturn.nTargetVFX = VFX_IMP_SPIKE_TRAP;
         tReturn.nRadius /= 4;
         tReturn.nDamageSize *= 2;
         tReturn.nDamageDice *= 2;
         tReturn.nAllowReflexSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_COLD:
         tReturn.nTrapVFX = VFX_FNF_ICESTORM;
         tReturn.nTargetVFX = VFX_IMP_FROST_S;
         tReturn.nRadius *= 2;
         tReturn.nDamageSize /= 2;
         tReturn.nDamageDice /= 2;
         tReturn.nAllowFortSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_FIRE:
         tReturn.nTrapVFX = VFX_FNF_FIREBALL;
         tReturn.nTargetVFX = VFX_IMP_FLAME_S;
         tReturn.nRadius *= 2;
         tReturn.nDamageSize /= 2;
         tReturn.nDamageDice /= 2;
         tReturn.nAllowReflexSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_ELECTRICAL:
         tReturn.nBeamVFX = VFX_BEAM_LIGHTNING;
         tReturn.nTargetVFX = VFX_IMP_LIGHTNING_S;
         tReturn.nRadius /= 4;
         tReturn.nDamageSize *= 2;
         tReturn.nDamageDice *= 2;
         tReturn.nAllowReflexSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_SONIC:
         tReturn.nTrapVFX = VFX_FNF_SOUND_BURST;
         tReturn.nTargetVFX = VFX_IMP_SONIC;
         tReturn.nRadius *= 2;
         tReturn.nDamageSize /= 2;
         tReturn.nDamageDice /= 2;
         tReturn.nAllowFortSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
      case DAMAGE_TYPE_ACID:
         tReturn.nTrapVFX = VFX_FNF_GAS_EXPLOSION_ACID;
         tReturn.nTargetVFX = VFX_IMP_ACID_S;
         tReturn.nRadius *= 2;
         tReturn.nDamageSize /= 2;
         tReturn.nDamageDice /= 2;
         tReturn.nAllowFortSave = TRUE;
         tReturn.nSaveDC = 10 + nCR;
         break;
   }

   //debug("tReturn = " + trapToString(tReturn));
   return tReturn;
}

struct trap getLocalTrap(object oObject, string sVarName)
{
   //debugVarObject("getLocalTrap()", OBJECT_SELF);
   //debugVarObject("oObject", oObject);
   //debugVarString("sVarName", sVarName);
    struct trap tReturn;
    tReturn.nDetectDC       = GetLocalInt(oObject, sVarName+".nDetectDC");
    tReturn.nDisarmDC       = GetLocalInt(oObject, sVarName+".nDisarmDC");
    tReturn.sTriggerScript  = GetLocalString(oObject, sVarName+".sTriggerScript");
    tReturn.sDisarmScript   = GetLocalString(oObject, sVarName+".sDisarmScript");
    tReturn.nSpellID        = GetLocalInt(oObject, sVarName+".nSpellID");
    tReturn.nSpellLevel     = GetLocalInt(oObject, sVarName+".nSpellLevel");
    tReturn.nSpellMetamagic = GetLocalInt(oObject, sVarName+".nSpellMetamagic");
    tReturn.nSpellDC        = GetLocalInt(oObject, sVarName+".nSpellDC");
    tReturn.nDamageType     = GetLocalInt(oObject, sVarName+".nDamageType");
    tReturn.nRadius         = GetLocalInt(oObject, sVarName+".nRadius");
    tReturn.nDamageDice     = GetLocalInt(oObject, sVarName+".nDamageDice");
    tReturn.nDamageSize     = GetLocalInt(oObject, sVarName+".nDamageSize");
    tReturn.nDamageBonus    = GetLocalInt(oObject, sVarName+".nDamageBonus");
    tReturn.nAllowReflexSave= GetLocalInt(oObject, sVarName+".nAllowReflexSave");
    tReturn.nAllowFortSave  = GetLocalInt(oObject, sVarName+".nAllowFortSave");
    tReturn.nAllowWillSave  = GetLocalInt(oObject, sVarName+".nAllowWillSave");
    tReturn.nSaveDC         = GetLocalInt(oObject, sVarName+".nSaveDC");
    tReturn.nTargetVFX      = GetLocalInt(oObject, sVarName+".nTargetVFX");
    tReturn.nTrapVFX        = GetLocalInt(oObject, sVarName+".nTrapVFX");
    tReturn.nFakeSpell      = GetLocalInt(oObject, sVarName+".nFakeSpell");
    tReturn.nFakeSpellLoc   = GetLocalInt(oObject, sVarName+".nFakeSpellLoc");
    tReturn.nBeamVFX        = GetLocalInt(oObject, sVarName+".nBeamVFX");
    tReturn.nCR             = GetLocalInt(oObject, sVarName+".nCR");
    tReturn.nRespawnSeconds = GetLocalInt(oObject, sVarName+".nRespawnSeconds");
    tReturn.nRespawnRandomCR= GetLocalInt(oObject, sVarName+".nRespawnRandomCR");
    tReturn.fSize           = GetLocalFloat(oObject, sVarName+".fSize");

   //debug("tReturn = " + trapToString(tReturn));
    return tReturn;
}

void setLocalTrap(object oObject, string sVarName, struct trap tTrap)
{
   //debug("setLocalTrap()", OBJECT_SELF);
   //debugVarObject("oObject", oObject);
   //debugVarString("sVarName", sVarName);
   //debug("tTrap = " + trapToString(tTrap));
    SetLocalInt(oObject, sVarName+".nDetectDC",             tTrap.nDetectDC);
    SetLocalInt(oObject, sVarName+".nDisarmDC",             tTrap.nDisarmDC);
    SetLocalString(oObject, sVarName+".sTriggerScript",     tTrap.sTriggerScript);
    SetLocalString(oObject, sVarName+".sDisarmScript",      tTrap.sDisarmScript);
    SetLocalInt(oObject, sVarName+".nSpellID",              tTrap.nSpellID);
    SetLocalInt(oObject, sVarName+".nSpellLevel",           tTrap.nSpellLevel);
    SetLocalInt(oObject, sVarName+".nSpellMetamagic",       tTrap.nSpellMetamagic);
    SetLocalInt(oObject, sVarName+".nSpellDC",              tTrap.nSpellDC);
    SetLocalInt(oObject, sVarName+".nDamageType",           tTrap.nDamageType);
    SetLocalInt(oObject, sVarName+".nRadius",               tTrap.nRadius);
    SetLocalInt(oObject, sVarName+".nDamageDice",           tTrap.nDamageDice);
    SetLocalInt(oObject, sVarName+".nDamageSize",           tTrap.nDamageSize);
    SetLocalInt(oObject, sVarName+".nDamageBonus",          tTrap.nDamageBonus);
    SetLocalInt(oObject, sVarName+".nAllowReflexSave",      tTrap.nAllowReflexSave);
    SetLocalInt(oObject, sVarName+".nAllowFortSave",        tTrap.nAllowFortSave);
    SetLocalInt(oObject, sVarName+".nAllowWillSave",        tTrap.nAllowWillSave);
    SetLocalInt(oObject, sVarName+".nSaveDC",               tTrap.nSaveDC);
    SetLocalInt(oObject, sVarName+".nTargetVFX",            tTrap.nTargetVFX);
    SetLocalInt(oObject, sVarName+".nTrapVFX",              tTrap.nTrapVFX);
    SetLocalInt(oObject, sVarName+".nFakeSpell",            tTrap.nFakeSpell);
    SetLocalInt(oObject, sVarName+".nFakeSpellLoc",         tTrap.nFakeSpellLoc);
    SetLocalInt(oObject, sVarName+".nBeamVFX",              tTrap.nBeamVFX);
    SetLocalInt(oObject, sVarName+".nCR",                   tTrap.nCR);
    SetLocalInt(oObject, sVarName+".nRespawnSeconds",       tTrap.nRespawnSeconds);
    SetLocalInt(oObject, sVarName+".nRespawnRandomCR",      tTrap.nRespawnRandomCR);
    SetLocalFloat(oObject, sVarName+".fSize",               tTrap.fSize);
}

void deleteLocalTrap(object oObject, string sVarName)
{
   //debugVarObject("deleteLocalTrap()", OBJECT_SELF);
   //debugVarObject("oObject", oObject);
   //debugVarString("sVarName", sVarName);
    DeleteLocalInt(oObject, sVarName+".nDetectDC");
    DeleteLocalInt(oObject, sVarName+".nDisarmDC");
    DeleteLocalString(oObject, sVarName+".sTriggerScript");
    DeleteLocalString(oObject, sVarName+".sDisarmScript");
    DeleteLocalInt(oObject, sVarName+".nSpellID");
    DeleteLocalInt(oObject, sVarName+".nSpellLevel");
    DeleteLocalInt(oObject, sVarName+".nSpellMetamagic");
    DeleteLocalInt(oObject, sVarName+".nSpellDC");
    DeleteLocalInt(oObject, sVarName+".nDamageType");
    DeleteLocalInt(oObject, sVarName+".nRadius");
    DeleteLocalInt(oObject, sVarName+".nDamageDice");
    DeleteLocalInt(oObject, sVarName+".nDamageSize");
    DeleteLocalInt(oObject, sVarName+".nDamageBonus");
    DeleteLocalInt(oObject, sVarName+".nAllowReflexSave");
    DeleteLocalInt(oObject, sVarName+".nAllowFortSave");
    DeleteLocalInt(oObject, sVarName+".nAllowWillSave");
    DeleteLocalInt(oObject, sVarName+".nSaveDC");
    DeleteLocalInt(oObject, sVarName+".nTargetVFX");
    DeleteLocalInt(oObject, sVarName+".nTrapVFX");
    DeleteLocalInt(oObject, sVarName+".nFakeSpell");
    DeleteLocalInt(oObject, sVarName+".nFakeSpellLoc");
    DeleteLocalInt(oObject, sVarName+".nBeamVFX");
    DeleteLocalInt(oObject, sVarName+".nCR");
    DeleteLocalInt(oObject, sVarName+".nRespawnSeconds");
    DeleteLocalInt(oObject, sVarName+".nRespawnRandomCR");
    DeleteLocalFloat(oObject, sVarName+".fSize");
}

string trapToString(struct trap tTrap)
{
    string s = "PRGT Trap >>>\n";
    s += "nDetectDC: "        + IntToString(tTrap.nDetectDC)        + "\n";
    s += "nDisarmDC: "        + IntToString(tTrap.nDisarmDC)        + "\n";
    s += "sTriggerScript: '"  + tTrap.sTriggerScript                + "'\n";
    s += "sDisarmScript: '"   + tTrap.sDisarmScript                 + "'\n";
    s += "nSpellID: "         + IntToString(tTrap.nSpellID)         + "\n";
    s += "nSpellLevel: "      + IntToString(tTrap.nSpellLevel)      + "\n";
    s += "nSpellMetamagic: "  + IntToString(tTrap.nSpellMetamagic)  + "\n";
    s += "nSpellDC: "         + IntToString(tTrap.nSpellDC)         + "\n";
    s += "nDamageType: "      + IntToString(tTrap.nDamageType)      + "\n";
    s += "nRadius: "          + IntToString(tTrap.nRadius)          + "\n";
    s += "nDamageDice: "      + IntToString(tTrap.nDamageDice)      + "\n";
    s += "nDamageSize: "      + IntToString(tTrap.nDamageSize)      + "\n";
    s += "nDamageBonus: "      + IntToString(tTrap.nDamageBonus)     + "\n";
    s += "nAllowReflexSave: " + IntToString(tTrap.nAllowReflexSave) + "\n";
    s += "nAllowFortSave: "   + IntToString(tTrap.nAllowFortSave)   + "\n";
    s += "nAllowWillSave: "   + IntToString(tTrap.nAllowWillSave)   + "\n";
    s += "nSaveDC: "          + IntToString(tTrap.nSaveDC)          + "\n";
    s += "nTargetVFX: "       + IntToString(tTrap.nTargetVFX)       + "\n";
    s += "nTrapVFX: "         + IntToString(tTrap.nTrapVFX)         + "\n";
    s += "nFakeSpell: "       + IntToString(tTrap.nFakeSpell)       + "\n";
    s += "nFakeSpellLoc: "    + IntToString(tTrap.nFakeSpellLoc)    + "\n";
    s += "nBeamVFX: "         + IntToString(tTrap.nBeamVFX)         + "\n";
    s += "nCR: "              + IntToString(tTrap.nCR)              + "\n";
    s += "nRespawnSeconds: "  + IntToString(tTrap.nRespawnSeconds)  + "\n";
    s += "nRespawnRandomCR: " + IntToString(tTrap.nRespawnRandomCR) + "\n";
    s += "fSize: "            + FloatToString(tTrap.fSize)          + "\n";

    return s;
}

object createPRGTTrapAtLocation(location lLoc, struct trap tTrap)
{
   //debugVarObject("createPRGTTrapAtLocation()", OBJECT_SELF);
   //debugVarLoc("lLoc", lLoc);
   //debugVarString("tTrap", trapToString(tTrap));

   object oTrap;
   oTrap = CreateTrapAtLocation(TRAP_BASE_TYPE_PRGT, lLoc, tTrap.fSize, "",
      STANDARD_FACTION_HOSTILE, tTrap.sDisarmScript, tTrap.sTriggerScript);

   setLocalTrap(oTrap, VAR_TRAP_ID, tTrap);
   SetTrapOneShot(oTrap, TRUE);
   SetTrapRecoverable(oTrap, TRUE);
   SetTrapActive(oTrap, TRUE);
   SetTrapDetectable(oTrap, TRUE);
   SetTrapDisarmable(oTrap, TRUE);
   SetTrapDisarmDC(oTrap, tTrap.nDisarmDC);

   return oTrap;
}

void createPRGTTrapOnObject(object oObjectToTrap, struct trap tTrap)
{
   //debugVarObject("createPRGTTrapOnObject()", OBJECT_SELF);
   //debugVarObject("oObjectToTrap", oObjectToTrap);
   //debugVarString("tTrap", trapToString(tTrap));

   CreateTrapOnObject(TRAP_BASE_TYPE_PRGT, oObjectToTrap, STANDARD_FACTION_HOSTILE,
      tTrap.sDisarmScript, tTrap.sTriggerScript);

   setLocalTrap(oObjectToTrap, VAR_TRAP_ID, tTrap);
   SetTrapOneShot(oObjectToTrap, TRUE);
   SetTrapRecoverable(oObjectToTrap, TRUE);
   SetTrapActive(oObjectToTrap, TRUE);
   SetTrapDetectable(oObjectToTrap, TRUE);
   SetTrapDisarmable(oObjectToTrap, TRUE);
   SetTrapDisarmDC(oObjectToTrap, tTrap.nDisarmDC);
}

//void main() {} // testing/compiling purposes

