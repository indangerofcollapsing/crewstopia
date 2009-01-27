// On Player Rested event for the module
#include "inc_bindstone"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("mod_onrest", OBJECT_SELF);

   ExecuteScript("prc_rest", OBJECT_SELF); // PrC on-rest event
   ExecuteScript("x2_mod_def_rest", OBJECT_SELF); // standard on-rest event

   object oPC = GetLastPCRested();
   //debugVarObject("oPC", oPC);
   setLastRestLoc(oPC, GetLocation(oPC));
}

