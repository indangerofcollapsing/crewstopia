#include "inc_ropebridge"
#include "inc_travel"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_used_ropebrdg", OBJECT_SELF);
   object oUser = GetLastUsedBy();
   //debugVarObject("oUser", oUser);

   if (GetIsInCombat(oUser))
   {
      useRopeBridge(oUser, OBJECT_SELF);
   }
   else
   {
      ActionStartConversation(oUser);
   }
}
