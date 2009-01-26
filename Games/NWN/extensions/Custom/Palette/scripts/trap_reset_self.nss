#include "inc_trap"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("trap_reset_self", OBJECT_SELF);

   // CEP trap reset
   ExecuteScript("trap_reset", OBJECT_SELF);

   randomTrap(OBJECT_SELF);
}
