// Template for On Player Death event for the module
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("_mod_on_death", OBJECT_SELF);

   ExecuteScript("nw_o0_death", OBJECT_SELF); // Default On Player Death event
   ExecuteScript("prc_ondeath", OBJECT_SELF);

   // GetLastKiller() only works when a PC is the killer
   markKilledBy(GetLastHostileActor(), GetLastPlayerDied());
}
