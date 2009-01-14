#include "inc_lock"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("lock_reset_self", OBJECT_SELF);
   SetLocked(OBJECT_SELF, TRUE);
}
