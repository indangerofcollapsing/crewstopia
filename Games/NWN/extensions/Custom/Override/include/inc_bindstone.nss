#include "inc_nbde"
#include "inc_debug_dac"
// variable name for PC bindpoint location
string VAR_BIND_LOC = "BIND_LOC";
// variable name for PC last rested location
string VAR_LAST_REST = "LAST_REST_LOC";
string TAG_RESPAWN_WAYPOINT = "RESPAWN_WAYPOINT";

location getBindLoc(object oPC);
void setBindLoc(object oPC, location loc);
void jumpToBindstone(object oPC);
location getLastRestLoc(object oPC);
void setLastRestLoc(object oPC, location loc);
void jumpToLastRest(object oPC);

location getBindLoc(object oPC)
{
   //debugVarObject("getBindLoc()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   location lBind = getPersistentLocation(oPC, VAR_BIND_LOC);
   //debugVarLoc("lBind", lBind);
   return lBind;
}

void setBindLoc(object oPC, location loc)
{
   //debugVarObject("setBindLoc()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   //debugVarLoc("loc", loc);
   setPersistentLocation(oPC, VAR_BIND_LOC, loc);
}

void jumpToBindstone(object oPC)
{
   location lPort = getBindLoc(oPC);
   if (GetAreaFromLocation(lPort) == OBJECT_INVALID)
   {
      FloatingTextStringOnCreature("No bind stone found.", oPC, FALSE);
      return;
   }
   effect ePort = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, ePort, oPC);
   AssignCommand(oPC, DelayCommand(2.0, JumpToLocation(lPort)));
}

location getLastRestLoc(object oPC)
{
   //debugVarObject("getLastRestLoc()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   return getPersistentLocation(oPC, VAR_LAST_REST);
}

void setLastRestLoc(object oPC, location loc)
{
   //debugVarObject("setLastRestLoc()", OBJECT_SELF);
   //debugVarObject("oPC", oPC);
   //debugVarLoc("loc", loc);
   if (GetAreaFromLocation(loc) == OBJECT_INVALID)
   {
      logError("ERROR: invalid location in setLastRestLoc() for " +
         objectToString(oPC) + ": " + LocationToString(loc));
      return;
   }
   setPersistentLocation(oPC, VAR_LAST_REST, loc);
}

void jumpToLastRest(object oPC)
{
   location lPort = getLastRestLoc(oPC);
   if (GetAreaFromLocation(lPort) == OBJECT_INVALID)
   {
      FloatingTextStringOnCreature("No last rest location found.", oPC, FALSE);
      return;
   }
   effect ePort = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
   ApplyEffectToObject(DURATION_TYPE_INSTANT, ePort, oPC);
   AssignCommand(oPC, DelayCommand(2.0, JumpToLocation(lPort)));
}

//void main() {} // testing/compiling purposes
