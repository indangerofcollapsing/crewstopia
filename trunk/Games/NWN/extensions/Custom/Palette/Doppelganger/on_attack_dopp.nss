#include "inc_doppelganger"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_attack_dopp", OBJECT_SELF);
   takeShapeOf(GetLastAttacker());
   ExecuteScript("nw_c2_default5", OBJECT_SELF);
}
