// On Death event for an Arbelest
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_blsta4", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_ballista4w", GetLocation(OBJECT_SELF));
}

