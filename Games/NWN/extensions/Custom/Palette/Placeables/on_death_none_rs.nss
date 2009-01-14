// On Death event for respawnable placeable, no treasure
#include "inc_persistworld"
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_none_rs", OBJECT_SELF);
   respawnPlaceable();
}

