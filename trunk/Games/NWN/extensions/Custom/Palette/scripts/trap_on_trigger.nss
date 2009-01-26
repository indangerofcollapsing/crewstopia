#include "inc_debug_dac"
#include "inc_heartbeat"
#include "inc_persistworld"
void main()
{
   //debugVarObject("trap_on_trigger", OBJECT_SELF);

   // CEP trap triggered event
   ExecuteScript("trap_fire", OBJECT_SELF);

   object oSelf = OBJECT_SELF;
   if (oSelf == OBJECT_INVALID) return; // No point in continuing

   float fDelay = getRespawnDelay(oSelf) * DURATION_1_ROUND;
   if (fDelay > 0.0)
   {
      //debugVarFloat("Trap will reset in", fDelay);
      DelayCommand(fDelay, ExecuteScript("trap_reset_self", oSelf));
   }
}
