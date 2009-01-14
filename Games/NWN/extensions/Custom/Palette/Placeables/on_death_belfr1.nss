// On Death event for a Belfry
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_belfr1", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_belfry1w", GetLocation(OBJECT_SELF));
}

