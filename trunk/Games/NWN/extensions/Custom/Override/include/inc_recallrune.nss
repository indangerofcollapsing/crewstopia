void setRecallLoc(int nNth, location lRecall, object oPC);
location getRecallLoc(int nNth, object oPC = OBJECT_SELF);
int isRecallLocValid(int nNth, object oPC = OBJECT_SELF);
void createRecallRunePortal(location lLoc);
void useRecallRunePortal();
void deleteRecallLoc(int nNth, object oPC = OBJECT_SELF);

string VAR_RECALL_LOC = "RECALL_RUNE_LOCATION";
const string RESREF_RECALL_PORTAL = "dac_recallportal";
const string VAR_CURRENT_DLG_LOC = "RECALL_RUNE_LOC";
const string VAR_LAST_RECALL_RUNE_LOC = "LAST_RECALL_RUNE_LOC";
const string VAR_DISALLOW_RECALL_RUNES = "RECALL_RUNE_DISALLOW";

#include "inc_nbde"
#include "inc_travel"
#include "inc_debug_dac"
#include "x0_i0_position"

void setRecallLoc(int nNth, location lRecall, object oPC)
{
   //debugVarObject("setRecallLoc()", OBJECT_SELF);
   //debugVarLoc("lRecall", lRecall);
   //debugVarObject("oPC", oPC);
   setPersistentLocation(oPC, VAR_RECALL_LOC + IntToString(nNth), lRecall);

   SetPlotFlag(OBJECT_SELF, FALSE);
   DestroyObject(OBJECT_SELF, 0.1f);
}

location getRecallLoc(int nNth, object oPC = OBJECT_SELF)
{
   return getPersistentLocation(oPC, VAR_RECALL_LOC + IntToString(nNth));
}

int isRecallLocValid(int nNth, object oPC = OBJECT_SELF)
{
   return isLocationValid(getRecallLoc(nNth, oPC));
}

void createRecallRunePortal(location lLoc)
{
   //debugVarObject("createRecallRunePortal()", OBJECT_SELF);
   //debugVarLoc("lLoc", lLoc);
   if (! isLocationValid(lLoc))
   {
      logError("Invalid location in createRecallRunePortal(): " +
         LocationToString(lLoc));
      return;
   }

   object oPC = GetPCSpeaker();
   if (oPC == OBJECT_INVALID) oPC = GetItemActivator();
   if (oPC == OBJECT_INVALID)
   {
      oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC);
   }
   //debugVarObject("oPC", oPC);

   float fDir = GetFacing(oPC);
   object oPortal = CreateObject(OBJECT_TYPE_PLACEABLE, RESREF_RECALL_PORTAL,
      GenerateNewLocation(oPC, DISTANCE_SHORT, fDir, fDir), TRUE);
   if (oPortal == OBJECT_INVALID)
   {
      logError("Unable to create portal placeable in createRecallRunePortal().");
      return;
   }
   SetName(oPortal, "Portal to " + GetName(GetAreaFromLocation(lLoc)));
   SetLocalLocation(oPortal, VAR_RECALL_LOC, lLoc);

   setPersistentLocation(oPC, VAR_LAST_RECALL_RUNE_LOC, GetLocation(oPC));

   // @FIX Recall Rune portals seem not to be getting created, so for now
   //      just jump automagically to the location.  Research & fix.
   jumpTo(lLoc, oPC);

   object oRune = GetItemActivated();
   SetPlotFlag(oRune, FALSE);
   DestroyObject(oRune, 0.1f);
}

void useRecallRunePortal()
{
   object oPC = GetLastUsedBy();
   location lLoc = GetLocalLocation(OBJECT_SELF, VAR_RECALL_LOC);
   if (isLocationValid(lLoc))
   {
      jumpTo(lLoc, oPC);
   }
   else
   {
      SendMessageToPC(oPC, "Sorry, this portal leads to an invalid location: " +
         LocationToString(lLoc));
   }

   SetPlotFlag(OBJECT_SELF, FALSE);
   DestroyObject(OBJECT_SELF, 10.0f);
}

void deleteRecallLoc(int nNth, object oPC = OBJECT_SELF)
{
   deletePersistentLocation(oPC, VAR_RECALL_LOC + IntToString(nNth));
}

//void main() {} // Testing/compiling purposes

