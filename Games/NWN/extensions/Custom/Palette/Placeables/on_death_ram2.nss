// On Death event for a Bore Ram
#include "inc_debug_dac"
void main()
{
   //debugVarObject("on_death_ram2", OBJECT_SELF);
   // Wrecked version
   CreateObject(OBJECT_TYPE_PLACEABLE, "dac_battram2w", GetLocation(OBJECT_SELF));
}

