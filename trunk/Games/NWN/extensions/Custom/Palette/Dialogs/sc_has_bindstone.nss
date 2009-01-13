#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
int StartingConditional()
{
   //debugVarObject("sc_has_bindstone", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lBind = getBindLoc(oPC);
   //debugVarLoc("lBind", lBind);
   if (isLocationValid(lBind))
   {
      SetCustomToken(2112, GetName(GetAreaFromLocation(lBind)));
      return TRUE;
   }
   else
   {
      return FALSE;
   }
}
