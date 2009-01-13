void useAtlas(object oPC);
void addMap(object oPC, string sAreaTag);
object getAtlas(object oPC);
int hasMap(object oPC, string sAreaTag);

const string VAR_ATLAS_PIXIENAME = "ATLAS_PIXIENAME";
const string VAR_AREA_SHOWMAP = "SHOW_MAP";
const int SHOW_MAP_ALWAYS = 1;
const int SHOW_MAP_NEVER = -1;
const string VAR_MAP_AREA_TAG = "MAP_AREA_TAG";
const string VAR_AREA_MAP_POINTS = "MAP_POINTS_REQUIRED";
const string RESREF_ATLAS_MAP = "dac_atlasmap";

#include "inc_debug_dac"
#include "inc_nbde"

void useAtlas(object oPC)
{
   if (! GetIsPC(oPC)) return;

   object oArea = GetArea(oPC);
   if (hasMap(oPC, GetTag(oArea)))
   {
      ExploreAreaForPlayer(oArea, oPC);
   }
   else if (GetLocalInt(GetArea(oPC), VAR_AREA_SHOWMAP) == SHOW_MAP_ALWAYS)
   {
      ExploreAreaForPlayer(oArea, oPC);
   }
   else if (GetLocalInt(GetArea(oPC), VAR_AREA_SHOWMAP) == SHOW_MAP_NEVER)
   {
      ExploreAreaForPlayer(oArea, oPC, FALSE);
   }
   else
   {
      FloatingTextStringOnCreature("I don't have this map yet.", oPC, FALSE);
   }
}

void addMap(object oPC, string sAreaTag)
{
   //debugVarObject("addMap()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   //debugVarString("sAreaTag", sAreaTag);
   object oAtlas = getAtlas(oPC);
   string sAreaId = GetTag(oAtlas) + "~" + sAreaTag;
   if (getPersistentInt(oPC, sAreaId) == 0)
   {
      setPersistentInt(oPC, sAreaId, 1);
      SendMessageToPC(oPC, "You have thoroughly explored this area and have " +
        "added this map to your Atlas.");
      saveToDatabase();
   }
   //else {debugMsg("You already have this map in your Atlas.")};
}

object getAtlas(object oPC)
{
   object oAtlas = GetItemPossessedBy(oPC, "dac_atlas");
   if (oAtlas == OBJECT_INVALID)
   {
      oAtlas = CreateItemOnObject("dac_atlas", oPC);
   }
   return oAtlas;
}

int hasMap(object oPC, string sAreaTag)
{
   //debugVarObject("hasMap()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   //debugVarString("sAreaTag", sAreaTag);

   if (! GetIsPC(oPC)) return FALSE;

   object oAtlas = getAtlas(oPC);
   return getPersistentInt(oPC, GetTag(oAtlas) + "~" + sAreaTag);
}

//void main() {} // testing/compiling purposes
