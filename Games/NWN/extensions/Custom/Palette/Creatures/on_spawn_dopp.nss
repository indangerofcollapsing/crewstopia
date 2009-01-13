#include "inc_doppelganger"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_spawn_dopp", OBJECT_SELF);
//   object oCopyMe = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE);
//   if (oCopyMe == OBJECT_INVALID) oCopyMe = GetFirstPC();
   //debugVarObject("oCopyMe", oCopyMe);
//   takeShapeOf(oCopyMe);
   ExecuteScript("x2_def_spawn", OBJECT_SELF);
}

