// Token of Sacrifice - Harm yourself to resurrect a friend.
#include "inc_sacritoken"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("dac_sacritoken", OBJECT_SELF);

   object oUser = GetItemActivator();
   //debugVarObject("oUser", oUser);
   object oTarget = GetItemActivatedTarget();
   //debugVarObject("oTarget", oTarget);

   if (oUser == OBJECT_INVALID || oTarget == OBJECT_INVALID)
   {
      logError("Invalid user or target in dac_sacritoken");
      logError("User: " + ObjectToString(oUser));
      logError("Target: " + ObjectToString(oTarget));
      return;
   }

   useTokenOfSacrifice(oTarget, OBJECT_SELF);
}
