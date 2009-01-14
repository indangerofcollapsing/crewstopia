// On Death event for a Turreted Arbelest
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta3", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_ballista3w", GetLocation(OBJECT_SELF));
}

