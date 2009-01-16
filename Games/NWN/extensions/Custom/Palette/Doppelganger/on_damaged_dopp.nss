#include "inc_doppelganger"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_damaged_dopp", OBJECT_SELF);
   takeShapeOf(GetLastDamager());
   ExecuteScript("nw_c2_default6", OBJECT_SELF);
}
