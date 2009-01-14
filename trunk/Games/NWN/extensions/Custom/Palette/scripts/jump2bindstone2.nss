// Jumps to bindstone using a Rune of Recall
#include "inc_bindstone"
#include "inc_travel"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("jump2bindstone2", OBJECT_SELF);
   object oPC = GetPCSpeaker();
   location lBind = getBindLoc(oPC);
   //debugVarLoc("lBind", lBind);
   if (isLocationValid(lBind))
   {
      jumpToBindstone(oPC);
      object oRune = GetItemActivated();
      DestroyObject(oRune, 0.1f);
   }
   else
   {
      logError("No valid bind location for " + GetName(oPC) + ", lBind = " +
         LocationToString(lBind));
      SendMessageToPC(oPC, "I'm sorry, I cannot do that.  Please inform a DM.");
   }
}
