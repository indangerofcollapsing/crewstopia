// On Spawn event for Xykon the lich
#include "nw_i0_generic"
#include "inc_debug_dac"
void main()
{
   SetSpawnInCondition(NW_FLAG_FAST_BUFF_ENEMY);
   SetSpawnInCondition(NW_FLAG_SPECIAL_CONVERSATION);
   SetSpawnInCondition(NW_FLAG_AMBIENT_ANIMATIONS);
   ExecuteScript("x2_def_spawn", OBJECT_SELF);
}