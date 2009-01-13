// just one campaign, to make things simple
const string CAMPAIGN = "Crewstopia";

int plotFlags(object oCreature, string sVarName, string sCampaignName = CAMPAIGN);
void setFlags(object oCreature, string sVarName, int nFlags, string sCampaignName = CAMPAIGN);
void clearFlags(object oCreature, string sVarName, int nFlags, string sCampaignName = CAMPAIGN);
string getPlotVarName(object oPC);
int dlgFlags(object oPC, object oNPC);
void setDlgFlags(object oPC, object oNPC, int nFlags);
void clearDlgFlags(object oPC, object oNPC, int nFlags);

// standard plot points
const int HAS_MET_PC = 1;
const int HAS_KILLED_PC = 2;
const int PC_HAS_KILLED = 4;
const int HAS_KILLED_PC_MULTIPLE_TIMES = 8;
const int PC_HAS_KILLED_MULTIPLE_TIMES = 16;
const int KNOWS_PC_NAME = 32;


#include "inc_nbde"
#include "inc_debug_dac"

int plotFlags(object oCreature, string sVarName, string sCampaignName = CAMPAIGN)
{
//   if (DEBUG) DoDebug("sVarName = " + sVarName);
//   if (DEBUG) DoDebug("sCampaignName = " + sCampaignName);
   int nFlags = NBDE_GetCampaignInt(sCampaignName, sVarName, oCreature);
//   if (DEBUG) DoDebug("nFlags = " + IntToString(nFlags));
   return nFlags;
}

void setFlags(object oCreature, string sVarName, int nFlags, string sCampaignName = CAMPAIGN)
{
//   if (DEBUG) DoDebug("Before setFlags, flags = " + IntToString(plotFlags(oCreature, sVarName, sCampaignName)));
//   if (DEBUG) DoDebug("Setting flags " + IntToString(nFlags));
   NBDE_SetCampaignInt(sCampaignName, sVarName,
      plotFlags(oCreature, sVarName, sCampaignName) | nFlags, oCreature);
//   if (DEBUG) DoDebug("After setFlags, flags = " + IntToString(plotFlags(oCreature, sVarName, sCampaignName)));
}

void clearFlags(object oCreature, string sVarName, int nFlags, string sCampaignName = CAMPAIGN)
{
//   if (DEBUG) DoDebug("Before clearFlags, flags = " + IntToString(plotFlags(oCreature, sVarName, sCampaignName)));
//   if (DEBUG) DoDebug("Clearing flags " + IntToString(nFlags));
   NBDE_SetCampaignInt(sCampaignName, sVarName,
      plotFlags(oCreature, sVarName, sCampaignName) ^ nFlags, oCreature);
//   if (DEBUG) DoDebug("After clearFlags, flags = " + IntToString(plotFlags(oCreature, sVarName, sCampaignName)));
}

// standard variable name for plot flags to be stored on creatures
string getPlotVarName(object oPC)
{
   return GetPCPublicCDKey(oPC) + GetName(oPC);
}

int dlgFlags(object oPC, object oNPC)
{
   return plotFlags(oNPC, getPlotVarName(oPC));
}

void setDlgFlags(object oPC, object oNPC, int nFlags)
{
   setFlags(oNPC, getPlotVarName(oPC), nFlags);
}

void clearDlgFlags(object oPC, object oNPC, int nFlags)
{
   clearFlags(oNPC, getPlotVarName(oPC), nFlags);
}

//void main() {} // testing/compiling purposes

