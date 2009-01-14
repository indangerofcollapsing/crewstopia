// Does PC have any OHS henchmen hired?
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_ohs_hashench", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   int nNth = 1;
   object oHench = GetHenchman(oPC, nNth);
   while (oHench != OBJECT_INVALID)
   {
      //debugVarObject("oHench", oHench);
      if (GetStringLeft(GetTag(oHench), 8) == "OHS_HEN_") return TRUE;
      oHench = GetHenchman(oPC, ++nNth);
   }
   //debugMsg("returning FALSE");
   return FALSE;
}
