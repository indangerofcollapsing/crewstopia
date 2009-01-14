// On Death event for a Ballista
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta1", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_ballista1w", GetLocation(OBJECT_SELF));
}

