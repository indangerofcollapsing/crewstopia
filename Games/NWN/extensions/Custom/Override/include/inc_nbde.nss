/**
 * Extends the standard NBDE database functions
 */
#include "inc_debug_dac"
#include "inc_variables"
// standard NBDE
#include "nbde_inc"
// Avlis Persistence System (NWNX ODBC)
#include "aps_include"

string DEFAULT_DATABASE = GetModuleName();
const string VAR_NWNX_ODBC_ENABLED = "NWNX_ODBC_ENABLED";

// delete variables
void deletePersistentFloat(object oObject, string sVarName);
void deletePersistentInt(object oObject, string sVarName);
void deletePersistentLocation(object oObject, string sVarName);
void deletePersistentString(object oObject, string sVarName);
void deletePersistentVector(object oObject, string sVarName);
// database administration
void saveToDatabase();
void unloadDatabase();
// getters
float getPersistentFloat(object oObject, string sVarName);
int getPersistentInt(object oObject, string sVarName);
location getPersistentLocation(object oObject, string sVarName);
string getPersistentString(object oObject, string sVarName);
vector getPersistentVector(object oObject, string sVarName);
// setters
void setPersistentFloat(object oObject, string sVarNamem, float fVarValue);
void setPersistentInt(object oObject, string sVarName, int nVarValue);
void setPersistentLocation(object oObject, string sVarName, location lVarValue);
void setPersistentString(object oObject, string sVarName, string sVarValue);
void setPersistentVector(object oObject, string sVarName, vector vVarValue);
// Test the ODBC connection - put this in Module OnLoad event
int testODBC();

void deletePersistentFloat(object oObject, string sVarName)
{
   if (testODBC())
   {
      DeletePersistentVariable(oObject, sVarName);
   }
   else
   {
      NBDE_DeleteCampaignFloat(DEFAULT_DATABASE, sVarName, oObject);
   }
}
void deletePersistentInt(object oObject, string sVarName)
{
   if (testODBC())
   {
      DeletePersistentVariable(oObject, sVarName);
   }
   else
   {
      NBDE_DeleteCampaignInt(DEFAULT_DATABASE, sVarName, oObject);
   }
}
void deletePersistentLocation(object oObject, string sVarName)
{
   if (testODBC())
   {
      DeletePersistentVariable(oObject, sVarName);
   }
   else
   {
      NBDE_DeleteCampaignLocation(DEFAULT_DATABASE, sVarName, oObject);
   }
}
void deletePersistentString(object oObject, string sVarName)
{
   if (testODBC())
   {
      DeletePersistentVariable(oObject, sVarName);
   }
   else
   {
      NBDE_DeleteCampaignString(DEFAULT_DATABASE, sVarName, oObject);
   }
}
void deletePersistentVector(object oObject, string sVarName)
{
   if (testODBC())
   {
      DeletePersistentVariable(oObject, sVarName);
   }
   else
   {
      NBDE_DeleteCampaignVector(DEFAULT_DATABASE, sVarName, oObject);
   }
}

// database administration
void saveToDatabase()
{
   NBDE_FlushCampaignDatabase(DEFAULT_DATABASE);
}
void unloadDatabase()
{
   NBDE_UnloadCampaignDatabase(DEFAULT_DATABASE);
}

// getters
float getPersistentFloat(object oObject, string sVarName)
{
   if (testODBC())
   {
      return GetPersistentFloat(oObject, sVarName);
   }
   else
   {
      return NBDE_GetCampaignFloat(DEFAULT_DATABASE, sVarName, oObject);
   }
}
int getPersistentInt(object oObject, string sVarName)
{
   if (testODBC())
   {
      return GetPersistentInt(oObject, sVarName);
   }
   else
   {
      return NBDE_GetCampaignInt(DEFAULT_DATABASE, sVarName, oObject);
   }
}
location getPersistentLocation(object oObject, string sVarName)
{
   if (testODBC())
   {
      return GetPersistentLocation(oObject, sVarName);
   }
   else
   {
      return NBDE_GetCampaignLocation(DEFAULT_DATABASE, sVarName, oObject);
   }
}
string getPersistentString(object oObject, string sVarName)
{
   if (testODBC())
   {
      return GetPersistentString(oObject, sVarName);
   }
   else
   {
      return NBDE_GetCampaignString(DEFAULT_DATABASE, sVarName, oObject);
   }
}
vector getPersistentVector(object oObject, string sVarName)
{
   if (testODBC())
   {
      return GetPersistentVector(oObject, sVarName);
   }
   else
   {
      return NBDE_GetCampaignVector(DEFAULT_DATABASE, sVarName, oObject);
   }
}
// setters
void setPersistentFloat(object oObject, string sVarName, float fVarValue)
{
   if (testODBC())
   {
      SetPersistentFloat(oObject, sVarName, fVarValue);
   }
   else
   {
      NBDE_SetCampaignFloat(DEFAULT_DATABASE, sVarName, fVarValue, oObject);
   }
}
void setPersistentInt(object oObject, string sVarName, int nVarValue)
{
   if (testODBC())
   {
      SetPersistentInt(oObject, sVarName, nVarValue);
   }
   else
   {
      NBDE_SetCampaignInt(DEFAULT_DATABASE, sVarName, nVarValue, oObject);
   }
}
void setPersistentLocation(object oObject, string sVarName, location lVarValue)
{
   //debugVarObject("setPersistentLocation()", OBJECT_SELF);
   //debugVarObject("oObject", oObject);
   //debugVarString("sVarName", sVarName);
   //debugVarLoc("lVarValue", lVarValue);
   if (GetAreaFromLocation(lVarValue) == OBJECT_INVALID)
   {
      logError("ERROR: location " + LocationToString(lVarValue) +
         " not valid for " + GetName(oObject));
      return;
   }
   if (testODBC())
   {
      SetPersistentLocation(oObject, sVarName, lVarValue);
   }
   else
   {
      NBDE_SetCampaignLocation(DEFAULT_DATABASE, sVarName, lVarValue, oObject);
      saveToDatabase();
   }
}
void setPersistentString(object oObject, string sVarName, string sVarValue)
{
   if (testODBC())
   {
      SetPersistentString(oObject, sVarName, sVarValue);
   }
   else
   {
      NBDE_SetCampaignString(DEFAULT_DATABASE, sVarName, sVarValue, oObject);
   }
}
void setPersistentVector(object oObject, string sVarName, vector vVarValue)
{
   if (testODBC())
   {
      SetPersistentVector(oObject, sVarName, vVarValue);
   }
   else
   {
      NBDE_SetCampaignVector(DEFAULT_DATABASE, sVarName, vVarValue, oObject);
   }
}

// @TODO this appears to be bugged for non-NWNX use.
int testODBC()
{
   debugVarObject("testODBC()", OBJECT_SELF);
   int nEnabled = GetLocalInt(GetModule(), VAR_NWNX_ODBC_ENABLED);
   debugVarInt("nEnabled", nEnabled);
   switch(nEnabled)
   {
      case -1: return FALSE; break;
      case 1: return TRUE; break;
      case 0:
      default:
         SQLExecDirect("SELECT 'X'");
         int nFetchSuccess = SQLFetch();
         debugVarInt("nFetchSuccess", nFetchSuccess);
         nEnabled = (nFetchSuccess == SQL_SUCCESS);
         SetLocalInt(GetModule(), VAR_NWNX_ODBC_ENABLED, nEnabled ? 1 : -1);
         logError("ODBC connection " + (nEnabled ? "is" : "NOT") + " active.");
   }
   //debugVarInt("returning", nEnabled);
   return nEnabled;
}

//void main() {} // testing/compiling purposes
