string getFaction(object obj = OBJECT_SELF);
object getFactionBanner(string sFactionName);
void guardMeAgainst(object oAttacker);

// Tag of the placeable which acts as the standard-bearer for each faction
const string TAG_FACTION_BANNER = "faction_banner";

// Faction Names
const string FACTION_COMMONER = "Commoner";
const string FACTION_HOSTILE = "Hostile";
const string FACTION_MERCHANT = "Merchant";
const string FACTION_DEFENDER = "Defender";
const string FACTION_ELVES = "Elves";
const string FACTION_DWARVES = "Dwarves";
const string FACTION_HALFLINGS = "Warrows";
const string FACTION_GNOMES = "Gnomes";
const string FACTION_HUMANOIDS = "Humanoids";
const string FACTION_DRAGON_GOOD = "Dragons, Good";
const string FACTION_DRAGON_EVIL = "Dragons, Evil";
const string FACTION_DROW = "Drow";
const string FACTION_ILLITHID = "Illithid";
const string FACTION_PREDATOR = "Predator";
const string FACTION_PREY = "Prey";
const string FACTION_TANARRI = "Tanar'ri";
const string FACTION_BAATEZU = "Baatezu";
const string FACTION_FEY = "Fey";

#include "inc_debug_dac"
#include "nw_o2_coninclude"

string getFaction(object obj = OBJECT_SELF)
{
   //debugVarObject("getFaction", obj);
   int nNth = 0;
   object oFactionBanner = GetObjectByTag(TAG_FACTION_BANNER, nNth);
   //debugVarObject("oFactionBanner", oFactionBanner);
   while (oFactionBanner != OBJECT_INVALID)
   {
      //debugVarObject("oFactionBanner", oFactionBanner);
      if (GetFactionEqual(obj, oFactionBanner)) return GetName(oFactionBanner);
      nNth++;
      oFactionBanner = GetObjectByTag(TAG_FACTION_BANNER, nNth);
   }
   return "Unknown";
}

object getFactionBanner(string sFactionName)
{
   //debug("getFactionBanner(" + sFactionName + ")");
   int nNth = 0;
   object oFactionBanner = GetObjectByTag(TAG_FACTION_BANNER, nNth);
   while (oFactionBanner != OBJECT_INVALID)
   {
      if (GetName(oFactionBanner) == sFactionName) return oFactionBanner;
      nNth++;
      oFactionBanner = GetObjectByTag(TAG_FACTION_BANNER, nNth);
   }
   logError("ERROR: No faction banner found for faction: " + sFactionName);
   return OBJECT_INVALID;
}

void setFaction(object oCreature, string sFactionName)
{
   //debug("setFaction(" + GetName(oCreature) + ", " + sFactionName + ")");
   object oFactionBanner = getFactionBanner(sFactionName);
   if (oFactionBanner == OBJECT_INVALID)
   {
      logError("ERROR: Unable to set faction for " + GetName(oCreature) +
         " because faction " + sFactionName + " is not found.");
      return;
   }

   ChangeFaction(oCreature, oFactionBanner);
}

void guardMeAgainst(object oAttacker)
{
   //debugVarObject("guardMeAgainst()", OBJECT_SELF);
   //debugVarObject("oAttacker", oAttacker);

   // If a guard is nearby, make sure he's guarding me.
   int nNth = 1;
   object oGuard = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF,
      nNth, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
   while (oGuard != OBJECT_INVALID &&
          GetArea(oGuard) == GetArea(OBJECT_SELF) &&
          GetIsEnemy(oAttacker, oGuard)
         )
   {
      string sResRef = GetStringLowerCase(GetResRef(oGuard));
      string sTag = GetStringLowerCase(GetTag(oGuard));
      if (FindSubString(sResRef + "~" + sTag, "guard") != -1)
      {
         //debugVarObject("changing faction to", oGuard);
         ChangeFaction(OBJECT_SELF, oGuard);
         oGuard = OBJECT_INVALID;
      }
      else
      {
         nNth++;
         oGuard = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, OBJECT_SELF,
            nNth, CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_NOT_PC);
      }
   }

//   SetIsTemporaryEnemy(oAttacker);
   ShoutDisturbed();
   SpeakString("GUARD_ME", TALKVOLUME_SILENT_SHOUT);
}

//void main() {} // testing/compiling purposes

