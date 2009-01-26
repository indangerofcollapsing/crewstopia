#include "inc_trap"
#include "inc_heartbeat"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trap_on_disarm", OBJECT_SELF);
   //debugVarObject("disarmer", GetLastDisarmed()); '
   //debugVarInt("DC", GetTrapDisarmDC(OBJECT_SELF));

   // CEP disarm script
   ExecuteScript("trap_disarm", OBJECT_SELF);

   object oSelf = OBJECT_SELF;

   onTrapDisarm(OBJECT_SELF);

   if (oSelf == OBJECT_INVALID) return; // No point in continuing

   float fDelay = getRespawnDelay(OBJECT_SELF) * DURATION_1_ROUND;
   if (fDelay > 0.0f)
   {
      //debugVarFloat("Trap will reset in", fDelay);
      DelayCommand(fDelay, ExecuteScript("trap_reset_self", OBJECT_SELF));
   }
}
