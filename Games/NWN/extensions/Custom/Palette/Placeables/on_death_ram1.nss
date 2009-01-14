// On Death event for a Belier
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_ram1", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_battram1w", GetLocation(OBJECT_SELF));
}

