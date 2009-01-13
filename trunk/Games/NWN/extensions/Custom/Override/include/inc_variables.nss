// Returns the variable value from the object, area, or module, whichever is
// found first.
int getVarInt(object obj, string sVarName);
float getVarFloat(object obj, string sVarName);
string getVarString(object obj, string sVarName);
object getVarObject(object obj, string sVarName);
location getVarLoc(object obj, string sVarName);
// Sets the default value if not set on the object, and return the value.
int getAndSetVarInt(object obj, string sVarName, int nDefault);
float getAndSetVarFloat(object obj, string sVarName, float fDefault);
string getAndSetVarString(object obj, string sVarName, string sDefault);
object getAndSetVarObject(object obj, string sVarName, object oDefault);
location getAndSetVarLoc(object obj, string sVarName, location lDefault);

// Integer variables which have never been set return as zero, so this is explicitly never.
const int NEVER = -1;
const int NOT_SET = 0;
// Zero is a valid 2DA value, but also used for "not set"; this is a standin
const int ZERO_FLAG = -99;

#include "inc_debug_dac"
#include "inc_travel"

int getVarInt(object obj, string sVarName)
{
   // If you want "never", you must set the value as -1, since 0 is the same
   // as "not set".
   int nReturn = GetLocalInt(obj, sVarName);
   if (nReturn == 0) nReturn = GetLocalInt(GetArea(obj), sVarName);
   if (nReturn == 0) nReturn = GetLocalInt(GetModule(), sVarName);

   return nReturn;
}

float getVarFloat(object obj, string sVarName)
{
   // If you want "never", you must set the value negative, since 0.0 is the same
   // as "not set".
   float fReturn = GetLocalFloat(obj, sVarName);
   if (fReturn == 0.0) fReturn = GetLocalFloat(GetArea(obj), sVarName);
   if (fReturn == 0.0) fReturn = GetLocalFloat(GetModule(), sVarName);

   return fReturn;
}

string getVarString(object obj, string sVarName)
{
   string sReturn = GetLocalString(obj, sVarName);
   if (sReturn == "") sReturn = GetLocalString(GetArea(obj), sVarName);
   if (sReturn == "") sReturn = GetLocalString(GetModule(), sVarName);

   return sReturn;
}

object getVarObject(object obj, string sVarName)
{
   object oReturn = GetLocalObject(obj, sVarName);
   if (oReturn == OBJECT_INVALID)
   {
      oReturn = GetLocalObject(GetArea(obj), sVarName);
   }
   if (oReturn == OBJECT_INVALID)
   {
      oReturn = GetLocalObject(GetModule(), sVarName);
   }

   return oReturn;
}

location getVarLoc(object obj, string sVarName)
{
   location lReturn = GetLocalLocation(obj, sVarName);
   if (GetAreaFromLocation(lReturn) == OBJECT_INVALID)
   {
      lReturn = GetLocalLocation(GetArea(obj), sVarName);
   }
   if (GetAreaFromLocation(lReturn) == OBJECT_INVALID)
   {
      lReturn = GetLocalLocation(GetModule(), sVarName);
   }

   return lReturn;
}

int getAndSetVarInt(object obj, string sVarName, int nDefault)
{
   int nValue = GetLocalInt(obj, sVarName);
   if (nValue == 0)
   {
      nValue = nDefault;
      SetLocalInt(obj, sVarName, nValue);
   }
   return nValue;
}

float getAndSetVarFloat(object obj, string sVarName, float fDefault)
{
   float fValue = GetLocalFloat(obj, sVarName);
   if (fValue == 0.0)
   {
      fValue = fDefault;
      SetLocalFloat(obj, sVarName, fValue);
   }
   return fValue;
}

string getAndSetVarString(object obj, string sVarName, string sDefault)
{
   string sValue = GetLocalString(obj, sVarName);
   if (sValue == "")
   {
      sValue = sDefault;
      SetLocalString(obj, sVarName, sValue);
   }
   return sValue;
}

object getAndSetVarObject(object obj, string sVarName, object oDefault)
{
   object oValue = GetLocalObject(obj, sVarName);
   if (oValue == OBJECT_INVALID)
   {
      oValue = oDefault;
      SetLocalObject(obj, sVarName, oValue);
   }
   return oValue;
}

location getAndSetVarLoc(object obj, string sVarName, location lDefault)
{
   location lValue = GetLocalLocation(obj, sVarName);
   if (! isLocationValid(lValue))
   {
      lValue = lDefault;
      SetLocalLocation(obj, sVarName, lValue);
   }
   return lValue;
}


//void main() {} // Testing/compiling purposes
