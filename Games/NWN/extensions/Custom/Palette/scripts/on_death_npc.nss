// On Death event for NPC's & monsters
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_npc", OBJECT_SELF);

   markKill(OBJECT_SELF, GetLastKiller());
}
