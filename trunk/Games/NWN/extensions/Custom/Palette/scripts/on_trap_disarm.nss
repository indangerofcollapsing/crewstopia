#include "inc_trap"
#include "inc_debug_dac"
void main()
{
   //debugMessage("on_trap_disarm");
   onTrapDisarm(OBJECT_SELF);
}
