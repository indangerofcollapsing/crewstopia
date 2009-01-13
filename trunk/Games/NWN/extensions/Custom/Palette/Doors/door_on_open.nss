#include "inc_heartbeat"
#include "inc_trap"
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("door_on_open", OBJECT_SELF);
   int nDelay = getRespawnDelay(OBJECT_SELF) / 10;
   if (nDelay == 0) nDelay = 1;
   float fDelay = nDelay * DURATION_1_ROUND;
   //debugVarFloat("fDelay", fDelay);
   if (fDelay > 0.0)
   {
      DelayCommand(fDelay, ActionCloseDoor(OBJECT_SELF));
   }
}
