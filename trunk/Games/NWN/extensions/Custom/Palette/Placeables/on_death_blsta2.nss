// On Death event for a Bow Ballista
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta2", OBJECT_SELF);
   // Respawn ballista
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_ballista2w", GetLocation(OBJECT_SELF));
}

